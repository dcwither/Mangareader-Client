__author__ = 'Devin'

from google.appengine.ext import db

def json_key(name = 'default'):
    return db.Key.from_path('json', name)

class JsonDump(db.Model):
    content = db.TextProperty(required=True)
    url = db.StringProperty(required=True)

