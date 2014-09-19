#!/bin/sh

DL_DIR=/mnt/openembedded/downloads
SLAVE_ROOT=/var/lib/buildbot/slaves
OPENXT_BUILD=${1:-${SLAVE_ROOT}/openxt/build}
OPENXT_CONF_SRC=${OPENXT_BUILD}/example-config
OPENXT_CONF_DST=${OPENXT_BUILD}/.config
OPENXT_CERTDIR=${SLAVE_ROOT}/openxt_certs
REPO_PROD_CACERT="${OPENXT_CERTDIR}/prod-cacert.pem"
REPO_DEV_CACERT="${OPENXT_CERTDIR}/dev-cacert.pem"
REPO_DEV_SIGNING_CERT="${OPENXT_CERTDIR}/dev-cacert.pem"
REPO_DEV_SIGNING_KEY="${OPENXT_CERTDIR}/dev-cakey.pem"

# values we'll be setting in local.conf
DL_DIR="/mnt/openembedded/downloads/"
GIT_MIRROR="file:///var/lib/git/openxt"

if [ ! -f ${CORE_CONF_SRC} ]; then
    echo "Missing example config file for OpenXT. Halting."
    exit 1
fi

EQUALITY_REGEX='\?=\|\+=\|=\+\|='
# set variables in config
cat "${OPENXT_CONF_SRC}" | sed \
    -e "s&^\([[:space:]]*OPENXT_GIT_MIRROR[[:space:]]*\)\(${EQUALITY_REGEX}\).*$&\1\2\"${GIT_MIRROR}\"&" \
    -e "s&^\([[:space:]]*REPO_PROD_CACERT[[:space:]]*\)\(${EQUALITY_REGEX}\).*$&\1\2\"${REPO_PROD_CACERT}\"&" \
    -e "s&^\([[:space:]]*REPO_DEV_CACERT[[:space:]]*\)\(${EQUALITY_REGEX}\).*$&\1\2\"${REPO_DEV_CACERT}\"&" \
    -e "s&^\([[:space:]]*REPO_DEV_SIGNING_CERT[[:space:]]*\)\(${EQUALITY_REGEX}\)&\1\2\"${REPO_DEV_SIGNING_CERT}\"&" \
    -e "s&^\([[:space:]]*REPO_DEV_SIGNING_KEY[[:space:]]*\)\(${EQUALITY_REGEX}\)&\1\2\"${REPO_DEV_SIGNING_KEY}\"&" \
    > ${OPENXT_CONF_DST}
if [ $? -ne 0 ]; then
    exit $?
fi

echo "OE_BUILD_CACHE_DL=\"${DL_DIR}\"" >> ${OPENXT_CONF_DST}
if [ $? -ne 0 ]; then
    exit $?
fi
