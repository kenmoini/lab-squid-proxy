#!/bin/bash

source /etc/sysconfig/squid

SSL_DB_PATH="${SSL_DB_PATH:-"/etc/squid/certs"}"
SSL_DB_SIZE="${SSL_DB_SIZE:-"64MB"}"

/usr/libexec/squid/cache_swap.sh

if [ ! -z "${SSL_DB_PATH}" ]; then
    if [ ! -d "${SSL_DB_PATH}" ]; then
        mkdir -p ${SSL_DB_PATH}
    fi
    /usr/lib64/squid/security_file_certgen -c -s ${SSL_DB_PATH}/ssl_db -M ${SSL_DB_SIZE}
fi

/usr/sbin/squid -k parse -f ${SQUID_CONF}

/usr/sbin/squid -d1 --foreground $SQUID_OPTS -f ${SQUID_CONF}
