FROM ubuntu

# ONDREJ PHP AND NGINX

RUN apt-get update --fix-missing && \
    apt-get install -y software-properties-common && \
    rm -rf /var/lib/apt/lists/*

RUN add-apt-repository -y ppa:ondrej/php
RUN add-apt-repository -y ppa:ondrej/nginx

## for apt to be noninteractive
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

RUN apt-get -y install php8.0-fpm php8.0-common php8.0-curl php8.0-intl php8.0-gd php8.0-dev php8.0-mbstring php8.0-mysql php8.0-opcache php8.0-xml php8.0-zip
RUN apt-get -y install nginx
RUN apt-get -y install mysql-client

# dev tools
RUN apt -y install git
RUN apt -y install zip
RUN apt-get -y install groff


# # COMPOSER
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && php composer-setup.php && rm composer-setup.php && mv composer.phar /usr/local/bin/composer && chmod a+x /usr/local/bin/composer
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_PROCESS_TIMEOUT 2000  
RUN composer self-update --1

# # drush 10.6.1
RUN git clone https://github.com/drush-ops/drush.git /usr/local/src/drush
WORKDIR /usr/local/src/drush
RUN git checkout 10.6.1
RUN composer update
RUN ln -s /usr/local/src/drush/drush /usr/bin/drush

# # drupal console
WORKDIR /home
RUN curl https://drupalconsole.com/installer -L -o drupal.phar
RUN mv drupal.phar /usr/local/bin/drupal
RUN chmod +x /usr/local/bin/drupal

# MySQL
RUN apt-get install -y mysql-server mysql-client

# PHP CONFIG
ADD ./docker-configs/php/php.ini /etc/php/8.0/fpm/
ADD ./docker-configs/php/www.conf /etc/php/8.0/fpm/pool.d/

# NGINX CONFIG
ADD ./docker-configs/nginx/ /etc/nginx

# Init

# RUN chown mysql.mysql /var/lib/mysql

# Setup

WORKDIR /var/www/html

EXPOSE 80 443

# EXPOSE 8080

# EXPOSE 9000

CMD ["/var/www/docker-configs/init/docker-cmd.sh"]