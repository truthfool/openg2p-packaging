ARG BASE_VERSION="15.0.20220810-debian-11-r9"
FROM bitnami/odoo:$BASE_VERSION

ENV LIMIT_TIME_REAL=150
ENV SERVER_WIDE_MODULES=web

ADD tmpdir /opt/bitnami/odoo/extraaddons
ADD docker-build.sh /opt/bitnami/odoo/extraaddons/
ADD post-init-openg2p.sh /

RUN /opt/bitnami/odoo/extraaddons/docker-build.sh
RUN TO_REPLACE=$(grep "libodoo.sh" /opt/bitnami/scripts/odoo/run.sh); \
    sed -i "s#$TO_REPLACE#$TO_REPLACE\n/post-init-openg2p.sh#g" /opt/bitnami/scripts/odoo/run.sh
