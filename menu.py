#!/usr/bin/env python

from bs4 import BeautifulSoup
import requests


URL = 'http://www2.ucar.edu/for-staff/daily/menu'


def has_class(tag):
    return tag.has_attr('class') and 'views-field-field-date-required' in tag['class']

def has_cg(tag):
    return tag.get_text()[:3] == 'CG:'

def get_menu_page(url):
    r = requests.get(url)
    return r.text


def get_menu(url):
    html_doc = get_menu_page(url)
    soup = BeautifulSoup(html_doc, 'lxml')
    dates = soup.find_all(has_class)
    today = dates[0]
    today_string = ''.join(today.stripped_strings)
    underscores = len(today_string) * '-'
    breakfast = today.next_sibling.next_sibling
    breakfast_string = '\n  '.join(breakfast.stripped_strings)

    lunch = breakfast.next_sibling.next_sibling
    lunch_string = ''
    indent = False
    sstrings = list(lunch.stripped_strings)

    for s in sstrings[0:-1]:
        if s.endswith(':'):
            if indent:
                lunch_string += s + '\n' + 4 * ' '
            else:
                lunch_string += s + '\n' + 2 * ' '
            indent = True
        else:
            lunch_string += s + '\n' + 2 * ' '

    lunch_string += sstrings[-1]

    cg = soup.find_all(has_cg)
    cg_winner = cg[0].get_text()
    cg_winner = ' '.join(cg_winner.split())

    return [today_string, underscores, cg_winner, '', breakfast_string, lunch_string]


if __name__ == "__main__":
    print '\n'.join(get_menu(URL))


