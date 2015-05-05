#!/usr/bin/env python

import csv
import os

with open("/Users/mgalloy/Desktop/modernidl/Sheet 1-Table 3.csv", 'rb') as sales_file:
  sales_reader = csv.reader(sales_file)

  with open("/Users/mgalloy/Desktop/sales.csv", "wb") as sales_output:
    sales_writer = csv.writer(sales_output, delimiter=",")
    for row in sales_reader:
      sales_writer.writerow([row[0], row[3], row[4]])

os.system("scp ~/Desktop/sales.csv idldev.com:~/idldev.com")
