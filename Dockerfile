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
RUN apt-get update && apt-get install -y php7.1-fpm php7.1-bcmath php7.1-cli php7.1-curl php7.1-mysql php7.1-mcrypt php7.1-mbstring php7.1-dom php7.1-xdebug php7.1-tidy php7.1-gd php7.1-zip && \
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
RUN apt-get update && \
    apt-get -y install libxpm4 libxrender1 libgtk2.0-0 libnss3 libgconf-2-4 && \
    apt-get -y install chromium && \
    apt-get -y install xvfb gtk2-engines-pixbuf && \
    apt-get -y install xfonts-cyrillic xfonts-100dpi xfonts-75dpi xfonts-base xfonts-scalable && \
    apt-get -y install imagemagick x11-apps
