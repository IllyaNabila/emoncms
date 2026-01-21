# Repository: https://github.com/IllyaNabila/emoncms
# Dockerfile for containerizing EmonCMS (PHP + Apache)
# Notes:
# - This image serves the EmonCMS web app on port 5000 to match the assignment's sample `docker run -p 5000:5000 ...`

FROM php:8.2-apache

# Set working directory
WORKDIR /var/www/html

# Install system dependencies and PHP extensions commonly required by EmonCMS
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    unzip \
    zip \
    libzip-dev \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) mysqli pdo_mysql zip gd \
    && a2enmod rewrite headers \
    && rm -rf /var/lib/apt/lists/*

COPY . /var/www/html

RUN sed -i 's/Listen 80/Listen 5000/' /etc/apache2/ports.conf \
 && sed -i 's/<VirtualHost \*:80>/<VirtualHost \*:5000>/' /etc/apache2/sites-available/000-default.conf \
 && sed -i 's/:80/:5000/' /etc/apache2/sites-available/000-default.conf

RUN chown -R www-data:www-data /var/www/html

EXPOSE 5000

CMD ["apache2-foreground"]
