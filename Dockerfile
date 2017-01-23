FROM ubuntu:trusty
MAINTAINER Tiago Farias <sarcer@gmail.com>

# Install base packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -yq install \
        curl \
        apache2 \
        libapache2-mod-php5 \
        php5-mysql \
        php5-mcrypt \
        php5-gd \
        php5-curl \
        php-pear \
        php-apc && \
	apt-get update && \
	apt-get install nano && \
    rm -rf /var/lib/apt/lists/* && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN /usr/sbin/php5enmod mcrypt
RUN export TERM=xterm
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf && \
    sed -i "s/variables_order.*/variables_order = \"EGPCS\"/g" /etc/php5/apache2/php.ini
RUN sed -i 's/display_errors = Off/display_errors = On/' /etc/php5/apache2/php.ini
RUN sed -i 's/short_open_tag = Off/short_open_tag = On/' /etc/php5/apache2/php.ini

ENV ALLOW_OVERRIDE **False**

# Add image configuration and scripts
ADD run.sh /run.sh
RUN chmod 755 /*.sh

EXPOSE 80
WORKDIR /var/www/html
CMD ["/run.sh"]
