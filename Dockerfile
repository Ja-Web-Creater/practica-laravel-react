# Usamos la versión oficial de PHP 8.4 con Apache
FROM php:8.4-apache

# Instalar dependencias del sistema y extensiones de PHP necesarias (incluyendo PostgreSQL para Supabase)
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

# Instalar NodeJS y NPM versión 20 para compilar React
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Definir el directorio de trabajo y copiar los archivos del proyecto
WORKDIR /var/www/html
COPY . .

# Reconfigurar Apache para que la raíz pública apunte a la carpeta /public de Laravel
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Instalar las dependencias de Laravel y compilar los componentes de React con Vite
RUN composer install --no-dev --optimize-autoloader
RUN npm install && npm run build

# Configurar los permisos correctos para el almacenamiento de Laravel
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

EXPOSE 80

CMD ["apache2-foreground"]
