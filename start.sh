
# create database
service mysql start
echo "create database zoomdata" | mysql -u root
mysql -u root zoomdata < /work/libs/datazoomer/setup/database/setup_mysql.sql

# start apache
/usr/sbin/apache2ctl -D FOREGROUND
