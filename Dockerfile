FROM nathankw/centos6_essentials
LABEL maintainer "Nathaniel Watson nathankw@stanford.edu"
#comes with python/2.7.5, but I'll install 2.7.14 and make that the default.

#PURPOSE: Installs many core packages on top of the centos:centos6 base image, along with the following programming languages - 
# 1) JRE v8u144
# 2) R v3.2.3
# 3) Python 2.7.14
# 4) Perl v5.10.1 (as part of the "Developoment Tools" yum package). This doesn't come with cpan, cpanm, or cpanp. I was unable to install
#    cpanm using the instruction at http://search.cpan.org/~miyagawa/App-cpanminus-1.7043/lib/App/cpanminus.pm to run 
#		 "curl -L https://cpanmin.us | perl - --sudo App::cpanminus". It will be best to redo the Perl install from source. 

#'yum clean all' so this error doesn't pop up when trying to install Java: Rpmdb checksum is invalid: dCDPT(pkg checksums)
RUN yum clean all
#INSTALL JRE v1.8.0_91.
# Download rpm for JRE v1.8.0_91.
# When downloading the JRE via the browser, Oracle now requires acceptance of terms. 
# https://ivan-site.com/2012/05/download-oracle-java-jre-jdk-using-a-script found a way to do this with wget, which I use here as well.
RUN cd /srv/src && \
	wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u144-b01/090f390dda5b47b9b721c7dfaa008135/jre-8u144-linux-x64.rpm \
	&& yum install -y /srv/src/jre-8u144-linux-x64.rpm

#INSTALL R v3.2.3.
# As stated in https://cran.r-project.org/bin/linux/redhat/README: 
# The Fedora RPMs for R have been ported to RHEL by the project Extra Packages for Enterprise Linux (EPEL)
RUN rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm && yum install -y R
RUN Rscript -e "install.packages('argparse',repos='http://cran.us.r-project.org',dependencies=T)"

#INSTALL Python 2.7.14 along with scipy and numpy packages. (creates python symlink in /usr/local/bin/python)
RUN curl -O https://www.python.org/ftp/python/2.7.14/Python-2.7.14.tgz \
	&& tar -zxf Python-2.7.14.tgz \
	&& rm Python-2.7.14.tgz \
	&& cd Python-2.7.14 \
	&& ./configure \
	&& make \
	&& make install \
	&& curl -O https://bootstrap.pypa.io/get-pip.py \
	&& python get-pip.py \
	&& pip install numpy \
	&& pip install scipy
