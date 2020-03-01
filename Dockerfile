FROM centos:8.1.1911
ENV container docker

RUN dnf install -y epel-release
# RUN dnf install -y https://rpms.remirepo.net/enterprise/remi-release-8.rpm
# RUN dnf install -y http://rpms.remirepo.net/enterprise/8/remi/x86_64/php-fedora-autoloader-1.0.0-5.el8.remi.noarch.rpm
# RUN dnf install -y dnf-plugins-core
# RUN dnf config-manager --set-enabled remi
# RUN dnf module allow php:remi-7.two
RUN dnf -y install dnf-plugins-core
RUN dnf config-manager --set-enabled PowerTools
RUN dnf -y install \
    gcc \
    make \
    httpd \
    mysql \
    php \
    php-devel \
    php-mbstring \
    php-mysqlnd \
    php-json \
    php-fpm \
    php-gd \
    php-pear \
    ImageMagick \
    ImageMagick-devel \
    sendmail \
    libmcrypt-devel \
    xinetd
    # phpMyAdmin
RUN printf "\n" | pecl install imagick mcrypt

# Remove xinetd services
RUN /bin/rm -f /etc/xinetd.d/*

# App setup
RUN mkdir /base
RUN mkdir /base/application
RUN mkdir /base/public_html

COPY ./assets/httpd.conf /etc/httpd/conf/
COPY ./assets/php.conf   /etc/httpd/conf.d/
COPY ./assets/phpMyAdmin.conf   /etc/httpd/conf.d/
COPY ./assets/php.ini    /etc/
COPY ./assets/index.php  /base/public_html/
COPY ./assets/smtp       /etc/xinetd.d/smtp
COPY ./assets/phpMyAdmin/config.inc.php /etc/phpMyAdmin/

EXPOSE 80

CMD exec httpd -DFOREGROUND "$@"
