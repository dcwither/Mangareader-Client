__author__ = 'Devin'

import webapp2
import json
import urllib
import JsonDump
import BeautifulSoup
from datetime import datetime, timedelta


class SeriesHandler(webapp2.RequestHandler):

    def get(self, *args):
        self.response.headers['Content-Type'] = 'application/json; charset=UTF-8'
        url_str = "http://www.mangareader.net" + self.request.path

        saved, age = JsonDump.get_page(url_str)
        if saved:
            age = (datetime.utcnow().date() - saved.last_modified).total_seconds()

        if saved and age < 60*60:
            self.response.out.write(saved.content)
            return

        mangareader = urllib.urlopen(url_str)
        HTML = mangareader.read()
        soup = BeautifulSoup.BeautifulSoup(HTML)
        array = []
        for chicodiv in soup.findAll(attrs={"class":"chico_manga"}):
            tableId = chicodiv.parent.parent.parent.parent['id']
            if tableId != "chapterlist":
                continue

            anchor = chicodiv.parent.a
            name = str(anchor.string)
            path = anchor['href']
            dict = {"name":name, "path":path}
            array.append(dict)

        json_text = json.dumps(array)
        if not saved:
            saved = JsonDump.JsonDump(url = url_str, content = json_text)
        else:
            saved.content = json_text

        JsonDump.age_set(url_str, saved)
        self.response.out.write(json_text)