#!/usr/bin/env

# 0 Provider
# 1 Provider Country
# 2 SKU
# 3 Developer
# 4 Title
# 5 Version
# 6 Product Type Identifier
# 7 Units
# 8 Developer Proceed
# 9 Begin Date
# 10 End Date
# 11 Customer Currency
# 12 Country Code
# 13 Currency of Proceeds
# 14 Apple Identifier
# 15 Customer Price
# 16 Promo Code
# 17 Parent Identifier
# 18 Subscription
# 19 Period
# 20 Category
# 21 CMB
# 22 Device
# 23 Supported Platforms
# 24 Proceeds Reason
# 25 Preserved Pricing
# 26 Client
# 27 Order Type
        
import configparser
import datetime
import gzip
import os
import time

import jwt
import requests


BASE_URL = "https://api.appstoreconnect.apple.com/v1"

# time that token will be valid for (can't be for more than 20 mins)
VALID_TIME = 20 * 60   # seconds
N_WEEKS = 10

def main():
    config = configparser.ConfigParser()
    config.read(os.path.expanduser('~/.appstore'))
    user = config.sections()[0]
    key_id = config.get(user, 'key_id')
    header = {"alg": "ES256", "kid": key_id, "typ": "JWT"}

    now = time.time()
    expiration = int(now + VALID_TIME)
    issuer_id = config.get(user, 'issuer_id')
    payload = {"iss": issuer_id, "exp": expiration, "aud": "appstoreconnect-v1"}
    private_key_filename = f"AuthKey_{key_id}.p8"
    with open(private_key_filename, "r") as f:
        lines = f.readlines()

    key = ''.join(lines)
    signature = jwt.encode(payload, key, algorithm="ES256", headers=header)
    signature = str(signature, "utf-8")
    vendor_number = config.get(user, 'vendor_number')

    url = f"{BASE_URL}/salesReports"
    header = {"Authorization": f"Bearer {signature}"}
    parameters = {"filter[frequency]": "WEEKLY",
                  "filter[reportType]": "SALES",
                  "filter[reportSubType]": "SUMMARY",
                  "filter[vendorNumber]": f"{vendor_number}",
                  "filter[reportDate]": "2019-06-02"}

    today = datetime.date.today()
    days_ago = (today.weekday() - 6) % 7
    last_sunday = today - datetime.timedelta(days=days_ago)
    for i in range(N_WEEKS):
        parameters['filter[reportDate]'] = last_sunday.strftime('%Y-%m-%d')
        response = requests.get(url, params=parameters, headers=header)
        #print(f"curl -v -H 'Authorization: Bearer {signature}' \"{url}\"")
        print(f"status code: {response.status_code}")
        if response.status_code == 200:
            data = str(gzip.decompress(response.content), "utf-8")
            # first row is header
            # title is column 4, units is column 7, developer proceeds is column 8
            lines = data.split("\n")
            for i, line in enumerate(lines):
                if i == 0: continue
                if len(line) == 0: continue

                tokens = line.split("\t")
                if float(tokens[8]) == 0.0: continue
                print(f"Report: {last_sunday}, Product: {tokens[4]}, Units: {tokens[7]}")
        else:
            print(response.content)
        last_sunday = last_sunday - datetime.timedelta(days=7)


if __name__ == '__main__':
    main()
