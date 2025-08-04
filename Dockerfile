FROM alpine:3.22.1

ENV PHPVER 8.2
ENV PHPVER_ALPINE 82

RUN apk update
RUN apk add supervisor nginx mariadb-client wget git unzip curl
RUN apk add php$PHPVER_ALPINE php$PHPVER_ALPINE-cli php$PHPVER_ALPINE-fpm php$PHPVER_ALPINE-mbstring php$PHPVER_ALPINE-xml php$PHPVER_ALPINE-curl php$PHPVER_ALPINE-gd php$PHPVER_ALPINE-mysql php-redis php$PHPVER_ALPINE-readline php$PHPVER_ALPINE-zip php$PHPVER_ALPINE-gd

# Prepare nginx
RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf
RUN ln -sf /dev/stdout /var/log/nginx/access.log && ln -sf /dev/stderr /var/log/nginx/error.log
COPY docker/nginx.conf /etc/nginx/sites-enabled/default
RUN sed -i "s/php{{phpver}}/php$PHPVER/" /etc/nginx/sites-enabled/default

# Copy PHP config
COPY docker/php.ini /etc/php/$PHPVER/fpm/conf.d/cloudlog.ini

ADD https://github.com/wavelog/wavelog/archive/master.zip /usr/src/master.zip

# Build site
COPY docker/build.sh /build.sh
RUN chmod +x /build.sh
RUN /build.sh

# Disable development environment - needed for CloudLog 2
RUN sed -i s/define\(\'ENVIRONMENT\',\ \'development\'\)\;/define\(\'ENVIRONMENT\',\ \'production\'\)\;/ /var/www/index.php

# Copy supervisor configs
COPY docker/supervisor/*.conf /etc/supervisor/conf.d/
# Make sure php run dir exists
RUN mkdir /run/php

# Copy crontab config
RUN crond -f
COPY docker/cron-cloudlog /etc/cron.d/cloudlog
# Make sure permissions are correct, else it doesn't run.
RUN chmod 644 /etc/cron.d/cloudlog
RUN crontab /etc/cron.d/cloudlog
RUN /usr/sbin/cron -f


# Add start script
COPY docker/start*.sh /
RUN chmod +x /start*.sh

# Cleanup packages
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/cache/apt/archives/* /build.sh

# Define default command.
CMD /start.sh

# Expose ports.
EXPOSE 80

