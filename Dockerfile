FROM php:7.4-apache

RUN apt-get update && apt-get install -y zlib1g-dev libpng-dev g++ git libicu-dev zip libzip-dev zip libpq-dev gnupg \
    && docker-php-ext-install zip intl opcache pdo  gd sockets bcmath \
    && pecl install apcu \
    && docker-php-ext-configure zip \
    && docker-php-ext-enable apcu

# apt-get and system utilities
RUN apt-get update && apt-get install -y \
	curl apt-transport-https debconf-utils \
    && rm -rf /var/lib/apt/lists/*

# adding custom MS repository
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list

# install SQL Server drivers and tools
RUN apt-get update && ACCEPT_EULA=Y apt-get install -y msodbcsql18 mssql-tools18 unixodbc-dev
RUN echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> ~/.bashrc
RUN /bin/bash -c "source ~/.bashrc"

RUN apt-get update && pecl install sqlsrv pdo_sqlsrv \
    && docker-php-ext-enable apcu sqlsrv pdo_sqlsrv