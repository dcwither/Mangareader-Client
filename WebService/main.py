#!/usr/bin/env python
#
# Copyright 2007 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
import webapp2
import json
import urllib
from datetime import datetime, timedelta


import BeautifulSoup
import SeriesHandler
import ChapterHandler
import JsonDump
class MainHandler(webapp2.RequestHandler):

    def get(self):
        self.response.headers['Content-Type'] = 'application/json; charset=UTF-8'

        url_str = "http://www.mangareader.net"
        saved, age = JsonDump.get_page(url_str)
        if saved:
            age = (datetime.utcnow().date() - saved.last_modified).total_seconds()

        if saved and age < 60 * 60:
            self.response.out.write(saved.content)
            return

        mangareader = urllib.urlopen(url_str)
        HTML = mangareader.read()
        soup = BeautifulSoup.BeautifulSoup(HTML)
        array = []
        for popular in soup.findAll(attrs={"class":"popularitemcaption"}):

            path = str(popular['href'])
            name = str(popular.string)
            dict = {"name":name, "path":path}
            array.append(dict)
            if len(array) == 5:
                break

        json_text = json.dumps(array)
        if not saved:
            saved = JsonDump.JsonDump(url = url_str, content = json_text)
        else:
            saved.content = json_text

        JsonDump.age_set(url_str, saved)
        self.response.out.write(json_text)

class AllSeriesHandler(webapp2.RequestHandler):
    def get(self):
        JsonDump.flush()
        self.response.headers['Content-Type'] = 'application/json; charset=UTF-8'
        url_str = "http://www.mangareader.net/alphabetical"
        saved, age = JsonDump.get_page(url_str)
        if saved:
            age = (datetime.utcnow().date() - saved.last_modified).total_seconds()

        if saved and age < 60 * 60:
            self.response.out.write(saved.content)
            return

        mangareader = urllib.urlopen(url_str)
        HTML = mangareader.read()
        soup = BeautifulSoup.BeautifulSoup(HTML)
        array = []
        for letter in soup.findAll("ul",attrs={"class":"series_alpha"}):
            for series in letter.contents:
                try:
                    path = str(series.a['href'])
                    name = str(series.a.string)
                    dict = {"name":name, "path":path}
                    array.append(dict)
                except KeyError:
                    continue
                except AttributeError:
                    continue

        json_text = json.dumps(array)
        saved = JsonDump.JsonDump(url=url_str, content=json_text)
        if not saved:
            saved = JsonDump.JsonDump(url = url_str, content = json_text)
        else:
            saved.content = json_text

        JsonDump.age_set(url_str, saved)
        self.response.out.write(json_text)

app = webapp2.WSGIApplication([('/', MainHandler),
                               ('/all', AllSeriesHandler),
                               ('/([a-zA-Z0-9_-]+)/([0-9]+)', ChapterHandler.ChapterHandler),
                               ('/([0-9_-]+)/' + '([a-zA-Z0-9_-]+/)' + '([a-zA-Z0-9_-]+(?:/)?)' + '(?:.html)?', ChapterHandler.ChapterHandler),
                               ('/([0-9]+)?(?:/)?' + '(?:[a-zA-Z0-9_-]+/?)' + '(?:.html)?', SeriesHandler.SeriesHandler)],
                              debug=True)
