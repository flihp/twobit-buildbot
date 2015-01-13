#!/bin/sh

DL_DIR=/mnt/openembedded/downloads
SLAVE_ROOT=/var/lib/buildbot/slaves
OPENXT_BUILD=${SLAVE_ROOT}/openxt/build
OPENXT_CONF_SRC=${OPENXT_BUILD}/example-config
OPENXT_CONF_DST=${OPENXT_BUILD}/.config
OPENXT_CERTDIR=${SLAVE_ROOT}/openxt_certs
REPO_PROD_CACERT="${OPENXT_CERTDIR}/prod-cacert.pem"
REPO_DEV_CACERT="${OPENXT_CERTDIR}/dev-cacert.pem"
REPO_DEV_SIGNING_CERT="${OPENXT_CERTDIR}/dev-cacert.pem"
REPO_DEV_SIGNING_KEY="${OPENXT_CERTDIR}/dev-cakey.pem"
CORES_TWICE=$(($(nproc)*2))
OPENXT_NAME_SITE="${1:-autobuilder}"
OPENXT_BUILD_TYPE="${2:-dev}"
# positional arguments are bad, use getopt
OPENXT_BUILD_ID="${3:-noid}"
OPENXT_BRANCH="${4:-master}"
# Setting the above build variables triggers the tagging logic in the
# do_build.sh script. Basically it assumes there's a tag in the git repos
# taht matches some mash-up of these 4 variables. Fall back to master by
# setting the following variable.
ALLOW_SWITCH_BRANCH_FAIL='true'

# values we'll be setting in local.conf
DL_DIR="/mnt/openembedded/downloads/"
OPENXT_GIT_MIRROR="/var/lib/git/openxt"
OE_GIT_MIRROR="file:///var/lib/git"
OPENXT_GIT_PROTOCOL="file"

if [ ! -f ${CORE_CONF_SRC} ]; then
    echo "Missing example config file for OpenXT. Halting."
    exit 1
fi

EQUALITY_REGEX='\?=\|\+=\|=\+\|='
# set variables in config
cat "${OPENXT_CONF_SRC}" | sed \
    -e "s&^\([[:space:]]*OPENXT_GIT_MIRROR[[:space:]]*\)\(${EQUALITY_REGEX}\).*$&\1\2\"${OPENXT_GIT_MIRROR}\"&" \
    -e "s&^\([[:space:]]*OPENXT_GIT_PROTOCOL[[:space:]]*\)\(${EQUALITY_REGEX}\).*$&\1\2\"${OPENXT_GIT_PROTOCOL}\"&" \
    -e "s&^\([[:space:]]*OE_GIT_MIRROR[[:space:]]*\)\(${EQUALITY_REGEX}\).*$&\1\2\"${OE_GIT_MIRROR}\"&" \
    -e "s&^\([[:space:]]*REPO_PROD_CACERT[[:space:]]*\)\(${EQUALITY_REGEX}\).*$&\1\2\"${REPO_PROD_CACERT}\"&" \
    -e "s&^\([[:space:]]*REPO_DEV_CACERT[[:space:]]*\)\(${EQUALITY_REGEX}\).*$&\1\2\"${REPO_DEV_CACERT}\"&" \
    -e "s&^\([[:space:]]*REPO_DEV_SIGNING_CERT[[:space:]]*\)\(${EQUALITY_REGEX}\)&\1\2\"${REPO_DEV_SIGNING_CERT}\"&" \
    -e "s&^\([[:space:]]*REPO_DEV_SIGNING_KEY[[:space:]]*\)\(${EQUALITY_REGEX}\)&\1\2\"${REPO_DEV_SIGNING_KEY}\"&" \
    -e "s&^\([[:space:]]*NAME_SITE[[:space:]]*\)\(${EQUALITY_REGEX}\).*$&\1\2\"${OPENXT_NAME_SITE}\"&" \
    -e "s&^\([[:space:]]*BUILD_TYPE[[:space:]]*\)\(${EQUALITY_REGEX}\).*$&\1\2\"${OPENXT_BUILD_TYPE}\"&" \
    -e "s&^\([[:space:]]*BRANCH[[:space:]]*\)\(${EQUALITY_REGEX}\).*$&\1\2\"${OPENXT_BRANCH}\"&" \
    > ${OPENXT_CONF_DST}
if [ $? -ne 0 ]; then
    exit $?
fi

echo "OE_BUILD_CACHE_DL=\"${DL_DIR}\"" >> ${OPENXT_CONF_DST}
if [ $? -ne 0 ]; then
    exit $?
fi
echo "ID=\"${OPENXT_BUILD_ID}\"" >> ${OPENXT_CONF_DST}
if [ $? -ne 0 ]; then
    exit $?
fi
echo "OE_BB_THREADS=\"${CORES_TWICE}\"" >> ${OPENXT_CONF_DST}

if [ ! -z "${ALLOW_SWITCH_BRANCH_FAIL}" ]; then
    echo "ALLOW_SWITCH_BRANCH_FAIL=\"${ALLOW_SWITCH_BRANCH_FAIL}\"" >> ${OPENXT_CONF_DST}
    if [ $? -ne 0 ]; then
        exit $?
    fi
fi

