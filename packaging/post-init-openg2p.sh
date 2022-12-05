#!/usr/bin/env bash

ODOO_CONF_PATH="/opt/bitnami/odoo/conf/odoo.conf"
ODOO_ADDONS_PATH="/opt/bitnami/odoo/addons"
EXTRA_ADDONS_PATH="/opt/bitnami/odoo/extraaddons"

for dir in $EXTRA_ADDONS_PATH/*/; do
  ODOO_ADDONS_PATH="$ODOO_ADDONS_PATH,${dir%/}"
done

TO_REPLACE=$(grep -i addons_path $ODOO_CONF_PATH)
sed -i "s#$TO_REPLACE#addons_path = $ODOO_ADDONS_PATH#g" $ODOO_CONF_PATH

TO_REPLACE=$(grep -i limit_time_real $ODOO_CONF_PATH)
sed -i "s/$TO_REPLACE/limit_time_real = $LIMIT_TIME_REAL/g" $ODOO_CONF_PATH

if [ -n "$OPENG2P_SMTP_PORT" ] ; then
  TO_REPLACE=$(grep -i smtp_port $ODOO_CONF_PATH)
  sed -i "s/$TO_REPLACE/smtp_port = $OPENG2P_SMTP_PORT/g" $ODOO_CONF_PATH
fi

if [ -n "$OPENG2P_SMTP_HOST" ] ; then
  TO_REPLACE=$(grep -i smtp_server $ODOO_CONF_PATH)
  sed -i "s/$TO_REPLACE/smtp_server = $OPENG2P_SMTP_HOST/g" $ODOO_CONF_PATH
fi

TO_REPLACE=$(grep -i list_db $ODOO_CONF_PATH)
sed -i "s/$TO_REPLACE/list_db = $LIST_DB/g" $ODOO_CONF_PATH

echo "; Custom options" >> $ODOO_CONF_PATH
echo "server_wide_modules = $SERVER_WIDE_MODULES" >> $ODOO_CONF_PATH
