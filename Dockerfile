FROM debian:8.2
MAINTAINER Candid Dauth <cdauth@cdauth.eu> 

RUN apt-get update && apt-get install -y \
		mpd \
		python \
		subversion
        
RUN LC_ALL=C.UTF-8 svn checkout http://client175.googlecode.com/svn/trunk/ /opt/client175

RUN mkdir /music /run/mpd \
	&& chown mpd:audio /run/mpd \
	&& useradd -d /opt/client175 -r -s/bin/false client175 \
	&& chown -R client175:client175 /opt/client175

COPY mpd.conf /etc/mpd.conf
COPY site.conf /opt/client175/site.conf
COPY start.sh /usr/local/bin/start.sh

RUN apt-get --purge autoremove -y subversion

EXPOSE 8080 6600

VOLUME [ "/music" ]
        
CMD [ "/bin/bash", "/usr/local/bin/start.sh" ]