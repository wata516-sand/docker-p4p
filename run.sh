#!/bin/bash
set -e

if [ ! -f /etc/perforce/p4dctl.conf.d/$SERVER_NAME.conf ]; then

    # Configure a server if not yet.
    /opt/perforce/sbin/configure-perforce-server.sh -n \
                                                    -p $P4PORT \
                                                    -u $P4USER \
                                                    -P $P4PASSWD \
                                                    $SERVER_NAME
else
    # Start the server if yet.
    p4dctl start $SERVER_NAME
fi

exec ls -1v --color=never /opt/perforce/servers/$SERVER_NAME/logs/log | xargs tail -f
