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

import BeautifulSoup
import SeriesHandler
import ChapterHandler
import JsonDump
class MainHandler(webapp2.RequestHandler):

    def get(self):
        self.response.headers['Content-Type'] = 'application/json; charset=UTF-8'
        mangareader = urllib.urlopen("http://www.mangareader.net")

        saved = JsonDump.JsonDump.all().filter("url = ", "http://www.mangareader.net").get()
        if saved:
            self.response.out.write(saved.content)
            return
        HTML = mangareader.read()
        soup = BeautifulSoup.BeautifulSoup(HTML)
        array = []
        for chapter in soup.findAll(attrs={"class":"chapter"}):

            link = str(chapter['href'])
            name = str(chapter.contents[0].string)
            dict = {"name":name, "link":link}
            array.append(dict)

        json_text = json.dumps(array)
        saved = JsonDump.JsonDump(url="http://www.mangareader.net", content=json_text)
        saved.put()
        self.response.out.write(json_text)

app = webapp2.WSGIApplication([('/', MainHandler),
                               ('/([a-zA-Z0-9_-]+)/([0-9]+)', ChapterHandler.ChapterHandler),
                               ('/([0-9_-]+)/' + '([a-zA-Z0-9_-]+/)' + '([a-zA-Z0-9_-]+(?:/)?)' + '(?:.html)?', ChapterHandler.ChapterHandler),
                               ('/([0-9]+)?(?:/)?' + '(?:[a-zA-Z0-9_-]+/?)' + '(?:.html)?', SeriesHandler.SeriesHandler)],
                              debug=True)
