
import os

from twisted.application import service
from buildslave.bot import BuildSlave

basedir = r'/var/lib/buildbot/slaves'
rotateLength = 10000000
maxRotatedFiles = 10

# if this is a relocatable tac file, get the directory containing the TAC
if basedir == '.':
    import os.path
    basedir = os.path.abspath(os.path.dirname(__file__))

# note: this line is matched against to check that this is a buildslave
# directory; do not edit it.
application = service.Application('buildslave')

try:
  from twisted.python.logfile import LogFile
  from twisted.python.log import ILogObserver, FileLogObserver
  logfile = LogFile.fromFullPath(os.path.join(basedir, "twistd.log"), rotateLength=rotateLength,
                                 maxRotatedFiles=maxRotatedFiles)
  application.setComponent(ILogObserver, FileLogObserver(logfile).emit)
except ImportError:
  # probably not yet twisted 8.2.0 and beyond, can't set log yet
  pass

# connection data for build master
from ConfigParser import ConfigParser

with open('slave.cfg') as fp:
    slave_cfg = ConfigParser()
    slave_cfg.readfp(fp)

    buildmaster_host = slave_cfg.get('connect', 'buildmaster_host')
    port = int(slave_cfg.get('connect', 'port'))
    slavename = slave_cfg.get('connect', 'slavename')
    passwd = slave_cfg.get('connect', 'passwd')
    keepalive = int(slave_cfg.get('connect', 'keepalive'))
    maxdelay = int(slave_cfg.get('connect', 'maxdelay'))

    usepty = int(slave_cfg.get('local', 'usepty'))
    umask = int(slave_cfg.get('local', 'umask'))

# environment variables for commands from master
os.environ['SLAVE_SETUP_CORE'] = '/var/lib/buildbot/slaves/bin/core-image-minimal_setup.sh'
os.environ["SLAVE_SETUP_MEASURED"] = "/var/lib/buildbot/slaves/bin/meta-measured_setup.sh"
os.environ ['SLAVE_SETUP_OPENXT'] = '/var/lib/buildbot/slaves/bin/openxt_setup.sh'
os.environ["SLAVE_SETUP_SELINUX"] = "/var/lib/buildbot/slaves/bin/meta-selinux_setup.sh"

s = BuildSlave(buildmaster_host, port, slavename, passwd, basedir,
               keepalive, usepty, umask=umask, maxdelay=maxdelay)
s.setServiceParent(application)

