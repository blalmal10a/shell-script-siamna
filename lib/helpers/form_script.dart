import 'package:get/get.dart';

final app_name = 'filament'.obs;
final mariadb_password = 'watoke'.obs;
final git_url = 'https://github.com/filamentphp/demo.git'.obs;
final git_token = ''.obs;
final php_extensions = 'intl mbstring gd dom xml curl zip mysq'.obs;
final domain_name = '000-default'.obs;
// String get resultantScript => '''

// ''';

String get autoInstallScript => """
cat << 'EOF' > auto-install.sh
#!/bin/bash

# Specify your MariaDB username and password

# Specify your project name, GitHub URL, and GitHub password
PROJECTNAME="$app_name"
GITHUB_URL="$git_url"
GIT_TOKEN="$git_token"

# Specify your PHP extensions list
PHP_EXTENSIONS_LIST="$php_extensions"

DOMAIN_NAME="$domain_name"


# Update the package repository
apt-get update -y

# Install Apache2 and MariaDB
apt-get install -y apache2 mariadb-server

# Create a new MariaDB user with the specified username and password
mysql -e "CREATE USER '$app_name'@'localhost' IDENTIFIED BY '$mariadb_password';"
mysql -e "GRANT ALL PRIVILEGES ON *.* TO '$app_name'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"

# Install PHP 8.2 and the specified PHP extensions
apt-get install -y software-properties-common
add-apt-repository -y ppa:ondrej/php
apt-get update -y
apt-get install -y php8.2

for ext in \${PHP_EXTENSIONS_LIST//,/ }
do
  apt-get install -y php8.2-"\$ext"
done

# Install Composer globally
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

# Clone the GitHub repository into /var/www/\$PROJECTNAME
if [ -z "\${GIT_TOKEN}" ]; then
  git clone https://\${GITHUB_URL} /var/www/\$PROJECTNAME
else
  git clone https://"\${GIT_TOKEN}"@\${GITHUB_URL} /var/www/\$PROJECTNAME
fi


# Navigate to the project directory and execute composer install and php artisan key:generate, storage:link
cd /var/www/\$PROJECTNAME && \\
composer install --no-interaction && \\
cp .env.example .env && \\
sed -i "s/DB_USERNAME=root/DB_USERNAME=$app_name/g" .env && \\
sed -i "s/DB_PASSWORD=/DB_PASSWORD=$mariadb_password/g" .env && \\
sed -i "s/DB_CONNECTION=\\`.*\\`/DB_CONNECTION=mysql/g" .env && \\
php artisan key:generate && \\
php artisan storage:link
php artisan migrate:fresh --seed


# Update the Apache configuration to point to the Laravel public directory and enable URL rewriting
echo "<VirtualHost *:80>
DocumentRoot /var/www/\$PROJECTNAME/public
<Directory /var/www/\$PROJECTNAME/public>
Options Indexes FollowSymLinks MultiViews
AllowOverride All
Order allow,deny
Allow from all
</Directory>
ErrorLog \${APACHE_LOG_DIR}/error.log
CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>" > /etc/apache2/sites-available/\$DOMAIN_NAME.conf

a2ensite \$DOMAIN_NAME.conf

a2enmod rewrite

# Restart Apache to apply the changes
systemctl restart apache2

EOF
""";

// void showToast(String msg) {
//   Fluttertoast.showToast(
//     msg: msg,
//     toastLength: Toast.LENGTH_SHORT,
//     gravity: ToastGravity.CENTER,
//     timeInSecForIosWeb: 1,
//     backgroundColor: Colors.green,
//     textColor: Colors.white,
//     fontSize: 16.0,
//   );
// }
