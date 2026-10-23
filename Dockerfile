ARG DEBIAN_VERSION=trixie

FROM debian:${DEBIAN_VERSION}-slim

LABEL org.opencontainers.image.authors="info@lorenzbausch.de"

ARG DEBIAN_FRONTEND=noninteractive

# Do not install recommended or suggested packages
RUN echo 'APT::Install-Recommends "false";' >> /etc/apt/apt.conf \
    && echo 'APT::Install-Suggests "false";' >> /etc/apt/apt.conf

# Create user 'laravel'
RUN useradd -m -s /bin/bash -c '' laravel && passwd -d laravel

# Install basic packages
RUN apt-get update \
    && apt-get install -y \
    apt-transport-https \
    build-essential \
    ca-certificates \
    curl \
    git \
    gnupg \
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
RUN if [ "$(lsb_release -sc)" = "bookworm" ]; then gtk2="libgtk2.0-0 libgconf-2-4"; else gtk2="libgtk2.0-0t64"; fi \
    && apt-get update \
    && apt-get -y install libxpm4 libxrender1 $gtk2 libnss3 \
    && apt-get -y install chromium \
    && apt-get -y install xvfb gtk2-engines-pixbuf \
    && apt-get -y install xfonts-100dpi xfonts-75dpi xfonts-base xfonts-scalable \
    && apt-get -y install imagemagick x11-apps \
    && chromium --version

ARG NODE_MAJOR=24

# Install Node.js and Yarn
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list \
    && apt-get update && apt-get install -y nodejs \
    && npm install --global npm@10 yarn \
    && node --version \
    && npm -v \
    && yarn --version

# Add key and repository
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg \
    && echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list

ARG PHP_VERSION=8.5

# Install PHP
RUN apt-get update \
    && apt-get install -y \
    php${PHP_VERSION}-bcmath \
    php${PHP_VERSION}-cli \
    php${PHP_VERSION}-curl \
    php${PHP_VERSION}-dom \
    php${PHP_VERSION}-fpm \
    php${PHP_VERSION}-gd \
    php${PHP_VERSION}-gmp \
    php${PHP_VERSION}-imap \
    php${PHP_VERSION}-intl \
    php${PHP_VERSION}-ldap \
    php${PHP_VERSION}-mbstring \
    php${PHP_VERSION}-mysql \
    php${PHP_VERSION}-redis \
    php${PHP_VERSION}-soap \
    php${PHP_VERSION}-sqlite \
    php${PHP_VERSION}-tidy \
    php${PHP_VERSION}-xdebug \
    php${PHP_VERSION}-zip \
    && update-alternatives --set php /usr/bin/php${PHP_VERSION} \
    && php -m \
    && php -v

# Install Composer (the installer picks the newest release supporting PHP_VERSION, i.e. 2.2 LTS for PHP < 7.2.5)
RUN curl -fsSL https://getcomposer.org/installer -o /tmp/composer-setup.php \
    && echo "$(curl -fsSL https://composer.github.io/installer.sig)  /tmp/composer-setup.php" | sha384sum -c - \
    && php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && rm /tmp/composer-setup.php \
    && composer --version
