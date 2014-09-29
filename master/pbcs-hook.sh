#!/bin/sh

# Wrapper script to call git_buildbot.py hook script._
# Supply your connection credentials here.

GIT_BUILDBOT=/usr/share/buildbot/contrib/git_buildbot.py
MASTER="localhost:9989"
USER_NAME="pbchange"
AUTH=""
PROJECT="SOME-PROJECT"
LOGFILE="/tmp/${PROJECT}_git.log"

if [ ! -x ${GIT_BUILDBOT} ]; then
    echo "No git_buildbot.py script." 1>&2
    exit 1
fi
if [ -z "${MASTER}" ]; then
    echo "Connection string not set." 1>&2
    exit 2
fi
if [ -z "${USER_NAME}" ]; then
    echo "Username not set." 1>&2
    exit 3
fi
if [ -z "${AUTH}" ]; then
    echo "Password not set." 1>&2
    exit 4
fi
if [ -z "${PROJECT}" ]; then
    echo "Project not set." 1>&2
    exit 5
fi

${GIT_BUILDBOT} --master="${MASTER}" --username="${USER_NAME}" --auth="${AUTH}" --project="${PROJECT}" --logfile="${LOGFILE}"

