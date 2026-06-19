# === ETAPA 1: Compilar el Frontend (React) ===
FROM node:20 AS frontend-builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# === ETAPA 2: Servidor de Producción (PHP + Apache) ===
FROM php:8.4-apache

# Instalar dependencias de Linux y extensiones de PHP (PostgreSQL para Supabase)
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    libpq-dev \
    zip \
    unzip \
    git \
    curl \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd zip pdo pdo_pgsql \
    && a2enmod rewrite

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Definir directorio de trabajo
WORKDIR /var/www/html
COPY . .

# Copiar la carpeta compilada de React desde la Etapa 1
COPY --from=frontend-builder /app/public/build ./public/build

# Reconfigurar Apache para apuntar a la carpeta pública de Laravel
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Instalar dependencias de Laravel sin scripts pesados
RUN composer install --no-dev --optimize-autoloader --no-scripts

# Permisos correctos para Laravel
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

EXPOSE 80

CMD ["apache2-foreground"]
