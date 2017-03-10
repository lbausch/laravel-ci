FROM debian:jessie

LABEL maintainer "Lorenz Bausch <info@lorenzbausch.de>"

ARG DEBIAN_FRONTEND=noninteractive

# Create user "laravel"
RUN adduser --disabled-password --gecos "" laravel

# Install basic packages
RUN apt-get update && apt-get install -y apt-transport-https lsb-release ca-certificates wget curl build-essential git unzip supervisor mysql-client openssh-client vim

# Add key and repository
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg && \
    echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list

# Install PHP
RUN apt-get update && apt-get install -y php7.1-fpm php7.1-cli php7.1-curl php7.1-mysql php7.1-mcrypt php7.1-mbstring php7.1-dom php7.1-xdebug php7.1-tidy php7.1-gd && \
    php -m

# Install Node.js
RUN curl -sL https://deb.nodesource.com/setup_7.x | bash - && apt-get install -y nodejs && \
    nodejs --version

# Install Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y yarn && \
    yarn --version

# Install Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php && \
    mv composer.phar /usr/local/bin/composer && \
    php -r "unlink('composer-setup.php');" && \
    composer --version

# Support Laravel Dusk
# https://github.com/laravel/dusk/issues/71#issuecomment-276208621
RUN cd /root && wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    dpkg -i google-chrome-stable_current_amd64.deb ; apt-get update && apt-get install -f -y && \
    apt-get install -y xvfb
