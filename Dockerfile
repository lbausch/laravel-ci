# syntax=docker/dockerfile:1

ARG DEBIAN_VERSION=trixie

FROM debian:${DEBIAN_VERSION}-slim

LABEL org.opencontainers.image.authors="info@lorenzbausch.de"

# Abort on any error, including failures inside pipes, and print every command
SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]

ARG DEBIAN_VERSION

ARG DEBIAN_FRONTEND=noninteractive

# Do not install recommended or suggested packages
COPY <<EOF /etc/apt/apt.conf
APT::Install-Recommends "false";
APT::Install-Suggests "false";
EOF

# Create user 'laravel'
RUN useradd -m -s /bin/bash -c '' laravel && passwd -d laravel

# Install basic packages
RUN <<EOF
apt-get update
apt-get install -y \
    apt-transport-https \
    build-essential \
    ca-certificates \
    curl \
    git \
    gnupg \
    less \
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
rm -rf /var/lib/apt/lists/*
EOF

# Support Laravel Dusk
RUN <<EOF
apt-get update
apt-get -y install libxpm4 libxrender1 libnss3
apt-get -y install chromium
apt-get -y install xvfb xauth
apt-get -y install fonts-liberation xfonts-100dpi xfonts-75dpi xfonts-base xfonts-scalable
apt-get -y install imagemagick ghostscript
rm -rf /var/lib/apt/lists/*
chromium --version
EOF

ARG NODE_MAJOR=24

COPY <<EOF /etc/apt/sources.list.d/nodesource.list
deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_${NODE_MAJOR}.x nodistro main
EOF

# Install Node.js and Yarn
RUN <<EOF
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
apt-get update
apt-get install -y nodejs
npm install --global npm@10 yarn
node --version
npm -v
yarn --version
rm -rf /var/lib/apt/lists/* /root/.npm /tmp/*
EOF

# Add key and repository
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg

COPY <<EOF /etc/apt/sources.list.d/php.list
deb https://packages.sury.org/php/ ${DEBIAN_VERSION} main
EOF

ARG PHP_VERSION=8.5

# Install PHP
RUN <<EOF
apt-get update
apt-get install -y \
    php${PHP_VERSION}-bcmath \
    php${PHP_VERSION}-cli \
    php${PHP_VERSION}-curl \
    php${PHP_VERSION}-dom \
    php${PHP_VERSION}-fpm \
    php${PHP_VERSION}-gd \
    php${PHP_VERSION}-gmp \
    php${PHP_VERSION}-imagick \
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
    php${PHP_VERSION}-zip
update-alternatives --set php /usr/bin/php${PHP_VERSION}
rm -rf /var/lib/apt/lists/*
php -m
php -v
EOF

# Install Composer (the installer picks the newest release supporting PHP_VERSION, i.e. 2.2 LTS for PHP < 7.2.5)
RUN <<EOF
signature=$(curl -fsSL https://composer.github.io/installer.sig)
curl -fsSL https://getcomposer.org/installer -o /tmp/composer-setup.php
echo "${signature}  /tmp/composer-setup.php" | sha384sum -c -
php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer
rm /tmp/composer-setup.php
composer --version
EOF
