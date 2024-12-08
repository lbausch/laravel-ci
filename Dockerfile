FROM debian:bookworm

LABEL org.opencontainers.image.authors="info@lorenzbausch.de"

ARG DEBIAN_FRONTEND=noninteractive

ARG NODE_MAJOR=22

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
    && apt-get -y install xfonts-100dpi xfonts-75dpi xfonts-base xfonts-scalable \
    && apt-get -y install imagemagick x11-apps \
    && chromium --version

# Add key and repository
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg \
    && echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list

# Install PHP
RUN apt-get update \
    && apt-get install -y \
    php-redis \
    php8.4-bcmath \
    php8.4-cli \
    php8.4-curl \
    php8.4-dom \
    php8.4-fpm \
    php8.4-gd \
    php8.4-imap \
    php8.4-intl \
    php8.4-ldap \
    php8.4-mbstring \
    php8.4-mysql \
    php8.4-soap \
    php8.4-sqlite \
    php8.4-tidy \
    php8.4-xdebug \
    php8.4-zip \
    && update-alternatives --set php /usr/bin/php8.4 \
    && php -m \
    && php -v

# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list \
    && apt-get update && apt-get install -y nodejs \
    && npm install --global npm@10 \
    && node --version \
    && npm -v

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer
RUN composer self-update && composer --version
