
## 
## ORACLE Express Based General Dev Image
##

# Pre-requirements
RUN mkdir -p /run/lock/subsys

RUN yum install -y libaio 
RUN yum clean all
RUN yum update -y

# Install Oracle XE
ADD lib/oracle-xe-11.2.0-1.0.x86_64.rpm /tmp/oracle-xe-11.2.0-1.0.x86_64.rpm

RUN yum localinstall -y /tmp/oracle-xe-11.2.0-1.0.x86_64.rpm
RUN rm -rf /tmp/img/oracle-xe-11.2.0-1.0.x86_64.rpm

ADD lib/init.ora lib/initXETemp.ora lib/response/xe.rsp /u01/app/oracle/product/11.2.0/xe/config/scripts/

RUN chown oracle:dba /u01/app/oracle/product/11.2.0/xe/config/scripts/*.ora \
                     /u01/app/oracle/product/11.2.0/xe/config/scripts/xe.rsp
RUN chmod 755        /u01/app/oracle/product/11.2.0/xe/config/scripts/*.ora \
                     /u01/app/oracle/product/11.2.0/xe/config/scripts/xe.rsp
ENV ORACLE_HOME /u01/app/oracle/product/11.2.0/xe
ENV ORACLE_SID  XE
ENV PATH        $ORACLE_HOME/bin:$PATH

RUN /etc/init.d/oracle-xe configure responseFile=/u01/app/oracle/product/11.2.0/xe/config/scripts/xe.rsp

# Run script
ADD lib/start.sh /
RUN chmod +x  start.sh


ADD lib/jdk-8u73-linux-x64.rpm  /tmp/jdk-8u73-linux-x64.rpm
RUN yum localinstall -y  /tmp/jdk-8u73-linux-x64.rpm

ADD lib/scala-2.11.8.rpm /tmp/scala-2.11.8.rpm
RUN yum localinstall -y /tmp/scala-2.11.8.rpm

RUN curl https://bintray.com/sbt/rpm/rpm | tee /etc/yum.repos.d/bintray-sbt-rpm.repo
RUN yum install sbt -y

RUN yum install epel-release -y
RUN yum clean all
RUN yum update -y

RUN yum install nodejs -y

RUN yum install npm -y

RUN yum install ruby -y
RUN yum install gcc g++ make automake autoconf curl-devel openssl-devel zlib-devel httpd-devel apr-devel apr-util-devel sqlite-devel -y -t
RUN yum install rubygems -y

RUN npm install -g grunt-cli
RUN npm install grunt --save-dev

RUN yum install yum-utils bzip2 bzip2-devel wget curl tar -y -t
RUN yum groupinstall "Development Tools" -y -t

RUN npm install bower -g
RUN npm install gulp -g

RUN yum install cmake -y

RUN yum install zlib-devel -y
RUN yum install bzip2-devel -y
RUN yum install openssl-devel -y
RUN yum install ncurses-devel -y
RUN yum install sqlite-devel -y
RUN yum install golang

RUN yum install -y centos-release-SCL
RUN yum install -y python27

RUN yum install mysql -y

RUN yum clean all
RUN yum update -y

RUN yum -y install python-pip

RUN yum install git -y

RUN yum install golang -y

RUN pip install --upgrade setuptools
RUN pip install --upgrade pip

RUN pip install supervisor

RUN yum clean all
RUN yum update -y

COPY supervisord.conf /etc/supervisord.conf
EXPOSE 9000
EXPOSE 8080
EXPOSE 80

#RUN java -version
RUN wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
RUN yum install apache-maven -y
RUN yum clean all
RUN yum update -y
RUN mvn -version
RUN java -version

USER root
WORKDIR /
ADD lib/sudoers /
RUN chown -R root:root sudoers
#RUN groupadd dev
#RUN useradd -g devusr  devusr
RUN yum update -y
RUN yum install sudo -y
RUN yum update -y
RUN cp sudoers /etc/sudoers


RUN mkdir -p /var/oracle
RUN chown oracle:dba /var/oracle
USER oracle
##RUN git clone mydbproject
#WORKDIR /path-to-mydb-proj
##ENV ORACLE_SID=XE
#RUN ./install_xe_docker.sh init

#CMD git pull devproj
#CMD ./install_xe_docker.sh apply-hotfix alter_21700001
#CMD mysql --user=devusr --password='devpwd' --host=127.0.0.1 < /path/test.sql
#CMD /start.sh
#CMD ["/usr/bin/supervisord"]
















