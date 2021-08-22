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
RUN apt-get update && apt-get install -y php5.6-fpm php5.6-bcmath php5.6-cli php5.6-curl php5.6-mysql php5.6-mbstring php5.6-dom php5.6-xdebug php5.6-tidy php5.6-gd php5.6-zip php5.6-imap php5.6-soap php5.6-sqlite php-redis && \
    php -m && \
    php -v

# Install Node.js
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && apt-get install -y nodejs && \
    npm install -g npm@7 && \
    node --version && \
    npm -v

# Install Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php && \
    mv composer.phar /usr/local/bin/composer && \
    php -r "unlink('composer-setup.php');" && \
    composer --version
