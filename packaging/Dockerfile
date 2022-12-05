FROM bitnami/odoo:15.0.20220810-debian-11-r9

ENV LIMIT_TIME_REAL=150
ENV SERVER_WIDE_MODULES=web

ADD tmpdir /opt/bitnami/odoo/extraaddons
ADD docker-build.sh /opt/bitnami/odoo/extraaddons/
ADD post-init-openg2p.sh /

RUN /opt/bitnami/odoo/extraaddons/docker-build.sh
