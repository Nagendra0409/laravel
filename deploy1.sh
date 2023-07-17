# #!/bin/bash

# INSTANCE_TYPE="t2.micro"
# KEY_NAME="laravel.pem"
# SECURITY_GROUP_NAME="launch-wizard-8"
# AMI_ID="ami-053b0d53c279acc90"
# REPOSITORY_URL="https://github.com/nagaladinnemahesh/laravel.git"
# MYSQL_PASSWORD="mahesh123"

# # Install AWS CLI
# sudo apt update
# sudo apt install -y awscli

# # Configure AWS CLI
# aws configure


# # Create EC2 instance
# aws ec2 run-instances --image-id $AMI_ID --instance-type $INSTANCE_TYPE --key-name $KEY_NAME --security-groups $SECURITY_GROUP_NAME --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=Laravel-Instance}]"

# # Retrieve public IP address of EC2 instance
# PUBLIC_IP=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=Laravel-Instance" --query "Reservations[0].Instances[0].PublicIpAddress" --output text)

# # SSH into EC2 instance and execute deployment commands
# ssh -i C:\pemfiles\laravel.pem ubuntu@3.110.92.193 << EOF
#     # Install necessary packages
#     sudo apt update
#     sudo apt install -y nginx php php-fpm php-mbstring php-xml php-zip php-mysql mysql-server composer

#     # Configure MySQL
#     sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'mahesh123';"

#     # Install Laravel project dependencies
#     cd /var/www/html
#     sudo git clone https://github.com/nagaladinnemahesh/laravel.git laravel
#     cd laravel
#     sudo composer install --optimize-autoloader --no-dev

#     # Configure Nginx for Laravel
#     sudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/default.bak
#     sudo sed -i 's@/var/www/html@/var/www/html/laravel/public@g' /etc/nginx/sites-available/default

#     # Set appropriate permissions
#     sudo chown -R www-data:www-data /var/www/html/laravel
#     sudo chmod -R 755 /var/www/html/laravel/storage
#     sudo chmod -R 755 /var/www/html/laravel/bootstrap/cache

#     # Restart services
#     sudo systemctl restart nginx
#     sudo systemctl restart php7.4-fpm

#     # Generate application key
#     sudo php /var/www/html/laravel/artisan key:generate

#     echo "Laravel application deployed successfully."
# EOF




#!/bin/bash

# Update the system packages
sudo apt update

# Install Nginx
sudo apt install -y nginx

# Install PHP and required extensions
sudo apt install -y php php-fpm php-mbstring php-xml php-zip php-mysql

# Install Composer
sudo apt install -y composer

# Clone your Laravel project
sudo git clone https://github.com/nagaladinnemahesh/laravel.git /var/www/html/laravel

# Navigate into the project directory
cd /var/www/html/laravel

# Install project dependencies using Composer
sudo composer install --optimize-autoloader --no-dev

# Create a new Nginx server block configuration file
sudo tee /etc/nginx/sites-available/laravel > /dev/null <<EOF
server {
    listen 80;
    listen [::]:80;
    server_name 3.110.92.193;

    root /var/www/html/laravel/public;
    index index.php;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
    }
}
EOF

# Enable the Nginx server block
sudo ln -s /etc/nginx/sites-available/laravel /etc/nginx/sites-enabled/

# Set ownership and permissions
sudo chown -R www-data:www-data /var/www/html/laravel
sudo chmod -R 755 /var/www/html/laravel/storage
sudo chmod -R 755 /var/www/html/laravel/bootstrap/cache

# Test Nginx configuration and restart Nginx
sudo nginx -t && sudo service nginx restart

# Generate the application key
sudo php /var/www/html/laravel/artisan key:generate

# Configure the .env file with necessary settings
sudo cp /var/www/html/laravel/.env.example /var/www/html/laravel/.env

# Restart PHP-FPM service
sudo service php8.1-fpm restart

# Provide instructions to the user
echo "Deployment completed. Access your Laravel application using the domain or server IP."
