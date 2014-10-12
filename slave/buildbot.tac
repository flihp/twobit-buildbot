
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

buildmaster_host = 'builder.twobit.us'
port = 9989
slavename = 'longhaul'
passwd = ""
keepalive = 600
usepty = 0
umask = 0002
maxdelay = 300

# environment variables for commands from master
os.environ['SLAVE_SETUP_CORE'] = '/var/lib/buildbot/slaves/bin/core-image-minimal_setup.sh'
os.environ["SLAVE_SETUP_MEASURED"] = "/var/lib/buildbot/slaves/bin/meta-measured_setup.sh"
os.environ ['SLAVE_SETUP_OPENXT'] = '/var/lib/buildbot/slaves/bin/openxt_setup.sh'
os.environ["SLAVE_SETUP_SELINUX"] = "/var/lib/buildbot/slaves/bin/meta-selinux_setup.sh"

s = BuildSlave(buildmaster_host, port, slavename, passwd, basedir,
               keepalive, usepty, umask=umask, maxdelay=maxdelay)
s.setServiceParent(application)
