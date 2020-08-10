# docker build -t bbjreg.svicloud.com/tools/eolinker_os:v4.3 . --no-cache
# docker build -t bbjreg.svicloud.com/tools/eolinker_os:v4.3

FROM bbjreg.svicloud.com/tools/svi-jdk8
MAINTAINER Sean <xiaohui@beebeejump.com>

ENV LANG        en_US.UTF8
ENV LC_ALL      en_US.UTF8
ENV OS_VERSION  20200420

#RUN sed -i "/#baseurl=http:\/\/download.fedoraproject.org\/pub\/epel\/6\/\$basearch/d" /etc/yum.repos.d/epel.repo
#RUN sed -i "/mirrorlist=https:\/\/mirrors.fedoraproject.org\/metalink?repo=epel-6&arch=\$basearch/d" /etc/yum.repos.d/epel.repo

#RUN sed -i "/\[epel\]/a\baseurl=http:\/\/download.fedoraproject.org\/pub\/epel\/6\/\$basearch" /etc/yum.repos.d/epel.repo

# install yum repo
RUN rpm --rebuilddb && \
    yum -y  update  
    
# install tools
RUN rpm --rebuilddb && \
    yum -y  install jq vim  ifconfig  curl nc ping  wget  net-tools iproute traceroute && \
    yum -y  install netstat man telnet strace  htop top  gdb bind-utils make m4 && \
    yum -y  install free  lsof  tar which file du md5sum git python-pip gd gd2 gd-devel gd2-devel

RUN rpm --rebuilddb && \
    yum -y  install stat  less  tcpdump   gcc  iostat  route  rsync pstree  nmon libffi-devel && \
    yum -y  install ifstat ngrep iperf  ipcs ltrace dos2unix psmisc sar expect mysql MySQL-python && \
    yum -y  install openssh-server openssh-clients supervisor openssl crontabs

#RUN yum install java -y

WORKDIR /opt
RUN mkdir eolinker_os
WORKDIR /opt/eolinker_os

ADD eolinker_os .
RUN yes|cp /opt/eolinker_os/start_eolinker.sh /bin/start_eolinker
RUN chmod a+x /bin/start_eolinker

ENTRYPOINT ["tini", "--"]

CMD ["start_eolinker"]