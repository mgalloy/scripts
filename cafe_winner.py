#!/usr/bin/env python

import smtplib
from email.mime.text import MIMEText

from bs4 import BeautifulSoup
import requests


URL = 'https://staff.ucar.edu/for-staff/daily/menu'


def has_cg(tag):
    return tag.get_text()[:4] == 'CG -'


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


def send_winner(winner, address):
    msg = MIMEText(winner)
    msg['Subject'] = 'This week\'s cafeteria winner'
    msg['From'] = 'mgalloy@ucar.edu'
    msg['To'] = address
    s = smtplib.SMTP('localhost')
    s.send_message(msg)
    s.quit()


if __name__ == "__main__":
    try:
        winner = 'Cafeteria winner: %s' % get_winner(URL)
    except:
       winner = 'Problem retreiving cafeteria winner'
    send_winner(winner, 'mgalloy@ucar.edu')

