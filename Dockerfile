# Run `make run` to get things started

# our image is centos default image with systemd
FROM centos/systemd

# who's your boss?
MAINTAINER "Tamas Foldi" <tfoldi@starschema.net>

# this is the version what we're building
ENV TABLEAU_VERSION="2020.2.3" \
    LANG=en_US.UTF-8

ARG INSTALL_DIR=/opt

# make systemd dbus visible 
VOLUME /sys/fs/cgroup /run /tmp /var/opt/tableau

COPY config/lscpu /bin

#COPY tableau-server-2019-1-18.x86_64.rpm ${INSTALL_DIR}

# Install core bits and their deps:w
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    yum install -y iproute curl sudo vim && \
    adduser tsm && \
    (echo tsm:tsm | chpasswd) && \
    (echo 'tsm ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/tsm) && \
    mkdir -p  /run/systemd/system /opt/tableau/docker_build && \
 #   curl -O -sSL https://downloads.tableau.com/esdalt/2019.1.18/tableau-server-2019-1-18.x86_64.rpm \
 #   yum install -y tableau-server-2019-1-18.x86_64.rpm \
    yum install -y yum-plugin-versionlock  \ 
             "https://downloads.tableau.com/esdalt/2020.2.3/tableau-server-2020-2-3.x86_64.rpm" \
           #  "https://downloads.tableau.com/esdalt/2019.1.1/tableau-server-2019-1-1.x86_64.rpm" \
             "https://downloads.tableau.com/drivers/linux/yum/tableau-driver/tableau-postgresql-odbc-9.5.3-1.x86_64.rpm"  && \
    rm -rf /var/tmp/yum-* 


COPY config/* /opt/tableau/docker_build/

RUN mkdir -p /etc/systemd/system/ && \
    cp /opt/tableau/docker_build/tableau_server_install.service /etc/systemd/system/ && \
    systemctl enable tableau_server_install 

# Expose TSM and Gateway ports
EXPOSE 80 8850

CMD /sbin/init
