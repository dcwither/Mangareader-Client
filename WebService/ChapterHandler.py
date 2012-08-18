__author__ = 'Devin'

import webapp2
import json
import urllib
import JsonDump
from datetime import datetime, timedelta

import BeautifulSoup

class ChapterHandler(webapp2.RequestHandler):
    def get(self, *args):
        self.response.headers['Content-Type'] = 'application/json; charset=UTF-8'
        url_str = "http://www.mangareader.net" + self.request.path

        saved, age = JsonDump.get_page(url_str)
        if saved:
            self.response.out.write(saved.content)
            return

        mangareader = urllib.urlopen(url_str)
        HTML = mangareader.read()
        soup = BeautifulSoup.BeautifulSoup(HTML)
        pages = []
        menu = soup.find(attrs={"id":"pageMenu"})
        error = ""
        for option in menu.contents:
            try:
                url_str =  "http://www.mangareader.net" + option['value']
                page = urllib.urlopen(url_str)
                page_html = page.read()
                page_soup = BeautifulSoup.BeautifulSoup(page_html)
                img = page_soup.find(attrs={"id":"img"})['src']
                dict = {"index":int(option.string), "image_url":img}
                pages.append(dict)
            except TypeError:
                error = "TypeError"


        chapter = {"page_count":pages, "pages":pages}

        json_text = json.dumps(pages)
        saved = JsonDump.JsonDump(url = url_str, content = json_text)
        JsonDump.age_set(url_str, saved)

        self.response.out.write(saved.content)