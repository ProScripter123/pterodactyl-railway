FROM ubuntu:22.04

# Set timezone
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y tzdata
RUN ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime && dpkg-reconfigure --frontend noninteractive tzdata

# Install dependencies
RUN apt update && apt install -y nginx mariadb-server mariadb-client php php-cli php-mysql php-gd php-mbstring php-xml php-bcmath php-curl php-zip php-tokenizer unzip curl git composer

# Setup working dir
WORKDIR /var/www

# Clone panel
RUN rm -rf /var/www/* && git clone https://github.com/pterodactyl/panel.git .
RUN cp .env.example .env && composer install --no-dev --optimize-autoloader

# Setup environment
RUN php artisan key:generate

# Expose web
EXPOSE 8080

# Start script
CMD ["/bin/bash", "/start.sh"]
