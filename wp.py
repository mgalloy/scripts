#!/usr/bin/env python

import argparse
import json
import os
import requests


BLOG_ID = '1075177'
APIKEY = '2d23bddda208'
BASE_URL = 'http://stats.wordpress.com/csv.php'
URL = '{base_url}?api_key={apikey}&blog_id={blog_id}&table=views&days={days}&limit=-1&format=json'
FILENAME = 'sitestats.json'


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Get web stats')
    parser.add_argument('--data_dir', help='data directory')
    parser.add_argument('--days', help='number of days', default=30)
    args = parser.parse_args()

    url = URL.format(base_url=BASE_URL,
                     apikey=APIKEY,
                     blog_id=BLOG_ID,
                     days=args.days + 1)
    r = requests.get(url)
    data = r.json()
    data = [{'title' : d['date'], 'value' : d['views']} for d in data]
    output = {'graph':
                {'title': 'michaelgalloy.com',
                 'type': 'bar',
                 'datasequences': [{'title': 'Traffic',
                                    'color': 'yellow',
                                    'datapoints': data}]}}
    with open(os.path.join(args.data_dir, FILENAME), 'w') as f:
        f.write(json.dumps(output))
