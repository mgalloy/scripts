#!/usr/bin/env python

from bs4 import BeautifulSoup
from googlevoice import Voice
from googlevoice.util import input
import requests


URL = 'http://www2.ucar.edu/for-staff/daily/menu'


def has_cg(tag):
    return tag.get_text()[:3] == 'CG:'


def get_menu_page(url):
    r = requests.get(url)
    return r.text


def get_winner(url):
    html_doc = get_menu_page(url)
    soup = BeautifulSoup(html_doc, 'lxml')

    cg = soup.find_all(has_cg)
    cg_winner = cg[0].get_text()
    cg_winner = ' '.join(cg_winner.split())

    return cg_winner


def send_winner(winner):
    voice = Voice()
    voice.login()
    voice.send_sms('3033246746', winner)
    voice.logout()


if __name__ == "__main__":
    try:
       winner = 'Cafeteria winner: %s' % get_winner(URL)
    except:
       winner = 'Problem retreiving cafeteria winner'
    send_winner(winner)

