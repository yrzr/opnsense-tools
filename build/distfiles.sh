#!/bin/sh

# Copyright (c) 2015 Franco Fichtner <franco@opnsense.org>
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.

set -e

. ./common.sh && $(${SCRUB_ARGS})

PORT_LIST=$(cat ${CONFIGDIR}/ports.conf)

git_checkout ${PORTSDIR} HEAD

MAKE_CONF="${CONFIGDIR}/make.conf"
if [ -f ${MAKE_CONF} ]; then
	cp ${MAKE_CONF} ${STAGEDIR}/etc/make.conf
fi

echo "ports-mgmt/pkg ${PORT_LIST}" | while read PORT_ORIGIN PORT_BROKEN; do
	if [ "$(echo ${PORT_ORIGIN} | colrm 2)" = "#" ]; then
		continue
	fi

	echo -n ">>> Fetching ${PORT_ORIGIN}... "

	make -C ${PORTSDIR}/${PORT_ORIGIN} fetch
done