#!/Users/mgalloy/anaconda/bin/python

import datetime
from dateutil import tz
import itertools
import os
import re
import tempfile
import urllib2

import jenkinsapi
from jenkinsapi.jenkins import Jenkins
from jenkinsapi.artifact import Artifact
from jenkinsapi.custom_exceptions import (
    NoBuildData,
    NotConfiguredSCM,
    NotFound,
    NotInQueue,
    NotSupportSCM,
    WillNotBuild,
    UnknownQueueItem,
)


def check_test_result(url_format, base_url, project, builtOn):
  url = url_format % (base_url, project, builtOn)
  u = urllib2.urlopen(url)
  try:
    content = u.read()
  except urllib2.HTTPError:
    return None
  finally:
    u.close()

  results = re.findall('^Test (Passed|Failed)\.', content, flags=re.MULTILINE)
  status = []
  for r in results:
    status.append('success' if r == 'Passed' else 'failure')
  return status


projects = ['GPULIB-1.6.2-gpulib', 'gpuliball', 'mpidl-build', 'taskdlall']
display_names = ['GPULib 1.6.2', 'GPULib', 'mpiDL', 'TaskDL']
test_result_url = ['%s/job/%s/qarnodes=%s/ws/builds-v/gpulib/gpu-nolicense/Testing/Temporary/LastTest.log',
                   '%s/job/%s/qarnodes=%s/ws/builds-v/gpulib/gpu-nolicense/Testing/Temporary/LastTest.log',
                   '',
                   '']

base_url = 'http://jenkins.txcorp.com:8300'
jenkins_server = Jenkins(base_url)

now = datetime.datetime.now().strftime("%m/%d/%y %I:%M %p")
local_tz = tz.tzlocal()

tmp_file, tmp_filename = tempfile.mkstemp(suffix='.html', text=True)
os.close(tmp_file)

tmp_file = open(tmp_filename, mode='w')

tmp_file.write('<table id="projects">\n')
for p, name, tresult in itertools.izip(projects, display_names, test_result_url):
  tmp_file.write('  <tr>\n')
  project = jenkins_server[p]
  last_build = project.get_last_build()
  ts = last_build.get_timestamp().astimezone(local_tz).strftime("%m/%d/%y %I:%M %p")
  status = last_build.get_status()
  status = 'running' if (status == None) else status

  # try:
  #   lfb_num = project.get_last_failed_buildnumber()
  #   lfb = project.get_build(lfb_num)
  #   lfb_ts = lfb.get_timestamp()
  #   lfb_age = "%s days ago" % (datetime.date.today() - lfb_ts.date()).days
  # except NoBuildData:
  #   lfb_age = 'none'

  # artifacts = []
  # for afinfo in last_build._data['runs'][0]['artifacts']:
  #   url = "%s/artifact/%s" % (last_build.baseurl, afinfo["relativePath"])
  #   af = Artifact(afinfo["fileName"], url, last_build)
  #   artifacts.append(af)
  # artifacts_dict = dict((af.filename, af) for af in artifacts)
  # print artifacts_dict['mkgpulib-summary.txt'].get_data()

  tmp_file.write('    <td class="projectName" style="width: 190px;">%s</td>\n' % name)
  tmp_file.write('    <td class="projectIcon noresize" style="width: 64px;">\n')
  tmp_file.write('      <img src="jenkins_images/%s@2x.png" style="float: left; margin-right: 2px;"/>\n' % status.lower())
  for r in last_build._data['runs']:
    rstatus = 'running' if (r['result'] == None) else r['result']
    tmp_file.write('      <img src="jenkins_images/test-%s@2x.png" style="float: left; margin-right: 2px;"/>\n' % rstatus.lower())
  tmp_file.write('    </td>\n')
  tmp_file.write('    <td class="projectName" style="width: 250px;">%s</td>\n' % ts)

  tmp_file.write('    <td class="projectIcon noresize" style="width: 258px;">\n')

  for r in xrange(len(last_build._data['runs'])):
    if len(tresult) != 0:
      builtOn = last_build._data['runs'][r]['builtOn']
      test_status = check_test_result(tresult, base_url, p, builtOn)
      for t in test_status:
        tmp_file.write('      <img src="jenkins_images/test-%s@2x.png" style="float: left; margin-right: 2px;"/>\n' % t)

      tmp_file.write('      <img src="jenkins_images/test-%s@2x.png" style="float: left; margin-right: 4px;"/>\n' % 'space')

  tmp_file.write('    </td>\n')

  tmp_file.write('  </tr>\n')

tmp_file.write('</table>\n')
tmp_file.close()

cmd = 'scp -i ~mgalloy/.ssh/id_dsa2 %s nucleus:~mgalloy/public_html/statusboard/jenkins.html' % tmp_filename
os.system(cmd)

with open('/Users/mgalloy/data/jenkins_statusboard.py.log', 'a') as logfile:
  logfile.write('Updating Jenkins results at %s\n' % now)
