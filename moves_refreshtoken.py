#!/usr/bin/env python

# Refresh Moves API access token. Prints new access token and other
# information to stdout.


import ConfigParser
import json
import requests


if __name__ == '__main__':
    api_base = 'https://api.moves-app.com/oauth/v1/access_token'

    config = ConfigParser.ConfigParser()
    config.read('/Users/mgalloy/.movesapp')

    client_id     = config.get('auth', 'client_id')
    client_secret = config.get('auth', 'client_secret')
    refresh_token = config.get('auth', 'refresh_token')

    params = {'grant_type':    'refresh_token',
              'refresh_token': refresh_token,
              'client_id':     client_id,
              'client_secret': client_secret}

    p = '&'.join({'%s=%s' % (k, params[k]) for k in params})
    url = '%s?%s' % (api_base, p)

    r = requests.post(url)
    print json.loads(r.content)
