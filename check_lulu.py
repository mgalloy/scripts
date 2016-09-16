#!/usr/bin/env python

import requests
from requests.auth import HTTPDigestAuth


BASE_URL = 'https://www.lulu.com/account/revenue-download?payeeId={payee}&includeZeroRevenueSales=true&startDate={start_date}&endDate={end_date}'

PAYEE = '12205176'
#HEADERS = {'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36'}


#https://www.lulu.com/account/revenue-download?payeeId=12205176&includeZeroRevenueSales=true&startDate=8/18/16&endDate=9/16/16

def main():
  start_date = '8/18/16'
  end_date = '9/16/16'
  vars = {'payee' : PAYEE, 'start_date' : start_date, 'end_date': end_date}

  url = BASE_URL.format(**vars)
  #r = requests.get(url, headers=HEADERS, auth=HTTPBasicAuth('mgalloy@gmail.com', 'mike9146'))
  r = requests.get(url, auth=HTTPDigestAuth(username, password))
  if r.ok:
    print r.text
  else:
    print r.text
    print 'problem retrieving data'

if __name__ == '__main__':
  main()