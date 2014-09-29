import datetime
import json
import requests


api_base = 'https://api.moves-app.com/api/1.1'
access_token = 'replace-with-token-value'

daily_format = '%s/user/summary/daily?from=%s&to=%s&access_token=%s'

output_location = '/Users/mgalloy/data/movesapp.json'


def format_date(d):
  return "%s-%s" % (d[4:6], d[6:8])

def main():
  datapoints = []
  result = { 'graph': {
               'datasequences': [{ 'datapoints': datapoints, 'title': 'Steps' }],
               'total': False,
               'type': 'bar',
               'refreshEveryNSeconds': 3600,
               'title': 'Steps' }
            }
  to_date = datetime.date.today()
  from_date = to_date - datetime.timedelta(30)

  url = daily_format % (api_base, str(from_date), str(to_date), access_token)

  r = requests.get(url)
  if r.status_code == 200:
    data = json.loads(r.text)

    for summary in data:
      for activity in summary['summary']:
        if activity['activity'] == 'walking':
          datapoints.append({ 'value': activity['steps'],
                              'title': format_date(summary['date']) })

    f = open(output_location, 'w')
    json.dump(result, f)
    f.close()
  else:
    print 'Invalid response from moves-app.com: %d' % r.status_code


if __name__ == "__main__":
  main()




