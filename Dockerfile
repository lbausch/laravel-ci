FROM debian:bookworm

LABEL maintainer "Lorenz Bausch <info@lorenzbausch.de>"

ARG DEBIAN_FRONTEND=noninteractive

# Create user "laravel"
RUN adduser --disabled-password --gecos "" laravel

# Install basic packages
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    build-essential \
    ca-certificates \
    curl \
    git \
    libgtk-3-0 \
    lsb-release \
    default-mysql-client \
    openssh-client \
    poppler-utils \
    rsync \
    supervisor \
    unzip \
    wget \
    vim

# Add key and repository
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg && \
    echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list

# Install PHP
RUN apt-get update && apt-get install -y php7.4-fpm php7.4-bcmath php7.4-cli php7.4-curl php7.4-gmp php7.4-intl php7.4-ldap php7.4-mysql php7.4-mbstring php7.4-dom php7.4-xdebug php7.4-tidy php7.4-gd php7.4-zip php7.4-imap php7.4-soap php7.4-sqlite && \
    php -m && \
    php -v

# Install Node.js
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && npm install --global npm@8 \
    && node --version \
    && npm -v

# Install Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y yarn && \
    yarn --version

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer
RUN composer self-update && composer --version

# Support Laravel Dusk
RUN apt-get update \
    && apt-get -y install libxpm4 libxrender1 libgtk2.0-0 libnss3 libgconf-2-4 \
    && apt-get -y install chromium \
    && apt-get -y install xvfb gtk2-engines-pixbuf \
    && apt-get -y install xfonts-100dpi xfonts-75dpi xfonts-base xfonts-scalable \
    && apt-get -y install imagemagick x11-apps \
    && chromium --version
