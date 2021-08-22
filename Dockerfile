FROM debian:bullseye

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

# Support Laravel Dusk
RUN apt-get update && \
    apt-get -y install libxpm4 libxrender1 libgtk2.0-0 libnss3 libgconf-2-4 && \
    apt-get -y install chromium && \
    apt-get -y install xvfb gtk2-engines-pixbuf && \
    apt-get -y install xfonts-cyrillic xfonts-100dpi xfonts-75dpi xfonts-base xfonts-scalable && \
    apt-get -y install imagemagick x11-apps

# Add key and repository
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg && \
    echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list

# Install PHP
RUN apt-get update && apt-get install -y php8.0-fpm php8.0-bcmath php8.0-cli php8.0-curl php8.0-mysql php8.0-mbstring php8.0-dom php8.0-xdebug php8.0-tidy php8.0-gd php8.0-zip php8.0-imap php8.0-soap php8.0-sqlite php-redis && \
    php -m && \
    php -v

# Install Node.js
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && apt-get install -y nodejs && \
    npm install --global npm@7 && \
    node --version && \
    npm -v

# Install Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php && \
    mv composer.phar /usr/local/bin/composer && \
    php -r "unlink('composer-setup.php');" && \
    composer --version
