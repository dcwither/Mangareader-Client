__author__ = 'Devin'

from google.appengine.ext import db
from datetime import datetime, timedelta
from google.appengine.api import memcache

def json_key(name = 'default'):
    return db.Key.from_path('json', name)

class JsonDump(db.Model):
    content = db.TextProperty(required=True)
    url = db.StringProperty(required=True)
    last_modified = db.DateProperty(auto_now=True)

def age_set(key, val):
    current_time = datetime.utcnow()
    memcache.set(key, (val, current_time))

def age_get(key):
    cached = memcache.get(key)

    if cached:
        val, save_date = cached
        age = (datetime.utcnow() - save_date).total_seconds()
    else:
        val, age = None, 0

    return val, age

def flush():
    memcache.flush_all()

def add_page(page):
    page.put()
    get_pages(page.url, True)
    return str(page.url)

def get_page(key, updated = False):
    page, age = age_get(key)

    if page is None or updated:
        page = JsonDump.all().filter("url = ", key).get()
        age_set(key, page)

    return page, age
