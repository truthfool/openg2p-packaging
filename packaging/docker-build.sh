#!/usr/bin/env bash
# Donot run this on local,
# this is supposed to be run inside docker

ODOO_BASE_DIR="/opt/bitnami/odoo"
EXTRA_ADDONS_DIR="$ODOO_BASE_DIR/extraaddons"

source $ODOO_BASE_DIR/venv/bin/activate
for dir in $EXTRA_ADDONS_DIR/*/; do
    if [[ -f ${dir}requirements.txt ]]; then
        pip3 install -r $dir/requirements.txt
    fi
done
deactivate