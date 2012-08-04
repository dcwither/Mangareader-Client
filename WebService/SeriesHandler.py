__author__ = 'Devin'

import webapp2
import json
import urllib

import BeautifulSoup


class SeriesHandler(webapp2.RequestHandler):

    def get(self, *args):
        self.response.headers['Content-Type'] = 'application/json; charset=UTF-8'
        url_str = "http://www.mangareader.net" + self.request.path
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
            link = anchor['href']
            dict = {"name":name, "link":link}
            array.append(dict)

        json_text = json.dumps(array)
        self.response.out.write(json_text)