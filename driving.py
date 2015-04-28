#!/usr/bin/env python

import argparse
from collections import defaultdict
import csv
import datetime
import sys

ingest_date_format = '%B %d, %Y at %I:%M%p'
output_date_format = '%Y-%W'


def output(weeks, out):
    out.write('"Mileage","Subaru"\n')
    for d in sorted(weeks):
        out.write('{0}, {1}\n'.format(d, weeks[d]))

    out.write('"Colors","Red"\n')
    # out.write('"Totals"\n')

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Summarize trips to weekly miles')
    parser.add_argument('input', help='CSV trip filename')
    parser.add_argument('-o', '--output', help='filename for weekly mileage CSV output')
    args = parser.parse_args()

    weeks = defaultdict(float)
    with open(args.input, 'rt') as csv_file:
        csv_reader = csv.reader(csv_file)
        for row in csv_reader:
            if len(row) < 11: continue
            trip_start = row[0]
            trip_mileage = row[10]
            dt = datetime.datetime.strptime(trip_start, ingest_date_format)
            day = dt.strftime(output_date_format)
            weeks[day] += float(trip_mileage)

    if args.output is None:
        output(weeks, sys.stdout)
    else:
        with open(args.output, 'wt') as out:
            output(weeks, out)
