
# create database
service mysql start
echo "create database zoomdata" | mysql -u root -proot
mysql -u root -proot zoomdata < /work/source/libs/datazoomer/setup/database/setup_mysql.sql
mysql -u root -proot -e "create user zoomuser identified by 'zoompass'"
mysql -u root -proot -e "grant all on zoomdata.* to zoomuser@'%'"

# start apache
/usr/sbin/apache2ctl -D FOREGROUND
