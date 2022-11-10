#!/usr/bin/env bash
# Donot run this on local,
# this is supposed to be run inside docker

ODOO_BASE_DIR="/opt/bitnami/odoo"
EXTRA_ADDONS_DIR="$ODOO_BASE_DIR/extraaddons"

apt-get update
apt-get install -y build-essential autoconf libtool
source $ODOO_BASE_DIR/venv/bin/activate
for dir in $EXTRA_ADDONS_DIR/*/; do
    if [[ -f ${dir}requirements.txt ]]; then
        pip3 install -r $dir/requirements.txt
    fi
done
deactivate
apt-get purge -y build-essential autoconf libtool
apt-get autoremove -y
apt-get clean
rm -rf /var/lib/apt/lists /var/cache/apt/archives
