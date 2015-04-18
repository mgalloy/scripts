#!/usr/bin/env python

import ConfigParser
import datetime
import json
import requests


API_BASE     = 'https://api.moves-app.com/api/1.1'
DAILY_FORMAT = '%s/user/summary/daily?from=%s&to=%s&access_token=%s'


def format_date(d):
    '''Format as date MM-DD.
    '''
    return "%s-%s" % (d[4:6], d[6:8])


def main():
    config = ConfigParser.ConfigParser()
    config.read('/Users/mgalloy/.movesapp')

    access_token    = config.get('auth', 'access_token')
    output_location = config.get('output', 'location')

    datapoints = []
    result = {'graph': {'datasequences': [{ 'datapoints': datapoints,
                                            'title': 'Steps' }],
                        'total': False,
                        'type': 'bar',
                        'refreshEveryNSeconds': 3600,
                        'title': 'Steps'}
              }
    to_date = datetime.date.today()
    from_date = to_date - datetime.timedelta(30)

    url = DAILY_FORMAT % (API_BASE, str(from_date), str(to_date), access_token)

    r = requests.get(url)

    if r.status_code == 200:
        data = json.loads(r.text)

        for summary in data:
            for activity in summary['summary']:
                if activity['activity'] == 'walking':
                    datapoints.append({'value': activity['steps'],
                                       'title': format_date(summary['date'])})

        f = open(output_location, 'w')
        json.dump(result, f)
        f.close()
    else:
        print 'Invalid response from moves-app.com: %d' % r.status_code


if __name__ == "__main__":
    main()
