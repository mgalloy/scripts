#!/usr/bin/env python

import datetime
import json
import os

import speedtest


DATA_FILE = "/Users/mgalloy/data/speed.json"


if __name__ == "__main__":
  # get upload/download speeds
  servers = []
  s = speedtest.Speedtest()
  all_servers = s.get_servers(servers)
  best_server = s.get_best_server()
  download_speed = s.download() / 1000 / 1000   # Mbs
  upload_speed = 100 * s.upload() / 1000 / 1000   # Mbs

  today = datetime.date.today()
  download_pt = {"value": download_speed, "title": "%s" % today}
  upload_pt = {"value": upload_speed, "title": "%s" % today}

  if os.path.isfile(DATA_FILE):
    with open(DATA_FILE, "r") as f:
      result = json.load(f)

    result["graph"]["datasequences"][0]["datapoints"].append(upload_pt)
    result["graph"]["datasequences"][1]["datapoints"].append(download_pt)
  else:
    result = {"graph": {"datasequences": [{ "datapoints": [upload_pt],
                                            "title": "Upload @ 3 am" },
                                          { "datapoints": [download_pt],
                                            "title": "Download @ 3 am" }],
                        "total": False,
                        "type": "line",
                        "refreshEveryNSeconds": 3600,
                        "title": "Internet speed",
                        "yAxis": {"minValue": 0, "maxValue": 200, "units": {"suffix": "Mbs"}}
                      }
              }

  # update json file
  with open(DATA_FILE, "w") as f:
    json.dump(result, f)
