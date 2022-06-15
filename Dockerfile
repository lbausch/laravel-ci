FROM debian:bullseye

LABEL org.opencontainers.image.authors="info@lorenzbausch.de"

ARG DEBIAN_FRONTEND=noninteractive

# Do not install recommended or suggested packages
RUN echo 'APT::Get::Install-Recommends "false";' >> /etc/apt/apt.conf \
    && echo 'APT::Get::Install-Suggests "false";' >> /etc/apt/apt.conf

# Create user 'laravel'
RUN adduser --disabled-password --gecos '' laravel

# Install basic packages
RUN apt-get update \
    && apt-get install -y \
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

# Support Laravel Dusk
RUN apt-get update \
    && apt-get -y install libxpm4 libxrender1 libgtk2.0-0 libnss3 libgconf-2-4 \
    && apt-get -y install chromium \
    && apt-get -y install xvfb gtk2-engines-pixbuf \
    && apt-get -y install xfonts-cyrillic xfonts-100dpi xfonts-75dpi xfonts-base xfonts-scalable \
    && apt-get -y install imagemagick x11-apps \
    && chromium --version

# Add key and repository
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg \
    && echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list

# Install PHP
RUN apt-get update \
    && apt-get install -y \
    php-redis \
    php8.1-bcmath \
    php8.1-cli \
    php8.1-curl \
    php8.1-dom \
    php8.1-fpm \
    php8.1-gd \
    php8.1-imap \
    php8.1-intl \
    php8.1-ldap \
    php8.1-mbstring \
    php8.1-mysql \
    php8.1-soap \
    php8.1-sqlite \
    php8.1-tidy \
    php8.1-xdebug \
    php8.1-zip \
    && php -m \
    && php -v

# Install Node.js
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get install -y nodejs \
    && npm install --global npm@8 \
    && node --version \
    && npm -v

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer
RUN composer self-update && composer --version
