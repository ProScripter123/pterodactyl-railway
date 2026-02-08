FROM ubuntu:22.04

# Set timezone
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y tzdata
RUN ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime && dpkg-reconfigure --frontend noninteractive tzdata

# Install dependencies
RUN apt update && apt install -y software-properties-common \
    && add-apt-repository ppa:ondrej/php \
    && apt update \
    && apt install -y nginx mariadb-server mariadb-client sqlite3 \
       php8.3 php8.3-cli php8.3-common php8.3-mysql php8.3-gd php8.3-mbstring \
       php8.3-xml php8.3-bcmath php8.3-curl php8.3-zip php8.3-tokenizer \
       unzip curl git composer

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
