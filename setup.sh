echo Setting up

# configure directories
mkdir \
    work \
        work/web \
        work/web/apps \
        work/web/sites \
        work/web/sites/default \
        work/web/themes \
        work/web/www \
        work/web/www/static \
    work/source \
    work/source/libs \
    work/lib \
    work/jobs \
    work/log \
    work/data \
    work/setup

# put libraries on the python path
echo /work/lib > dsi.pth
mv dsi.pth /usr/local/lib/python2.7/dist-packages

# install datazoomer library
git clone https://github.com/dsilabs/datazoomer.git /work/source/libs/datazoomer
pip install -r /work/source/libs/datazoomer/requirements.txt
ln -s /work/source/libs/datazoomer/zoom /work/lib

# setup the default theme
ln -s /work/source/libs/datazoomer/themes/default /work/web/themes

# setup apache
cd /etc/apache2/sites-enabled
rm -f 000-default*
ln -s /work/source/libs/datazoomer/setup/apache/zoom zoom.conf
sed -i'' 's/Listen 80/ServerName localhost\n\nlisten 80/' /etc/apache2/ports.conf

apt-get install vim

# setup datazoomer config files
echo -e "[sites]\\npath=/work/web/sites" > /work/dz.conf
echo -e "[sites]\\npath=/work/web/sites" > /work/web/dz.conf
cat <<'EOF' >> /work/web/sites/default/site.ini
[site]
name=Zoom
slogan=Ridiculously Rapid Application Development
owner_name=Company Name
owner_email=owner@yoursite.com
owner_url=http://www.yourcompanysite.com
admin_email=admin@yoursite.com
register_email=register@yoursite.com
bug_email=support@yoursite.com

[users]
default=guest
administrator_group=administrators
developer_group=developers

[sessions]
use_cookies=1 
destroy=1     

[apps]
index=content
home=home
login=login
path=/work/web/apps

[data]

[theme]
name=default
url=/work/web/themes

[system]

[log]

[error]

[database]
engine=mysql
dbname=zoomdata
dbhost=localhost
dbuser=zoomuser
dbpass=zoompass

[mail]
delivery=immediate
smtp_host=
smtp_port=587
smtp_user=
smtp_passwd=
logo=http://www.yoursite.com/mail-logo.png
from_addr=alerts@yoursite.com
EOF

# setup the www server folder
ln -s /work/source/libs/datazoomer/setup/www/static/dz /work/web/www/static
ln -s /work/source/libs/datazoomer/setup/www/index.py /work/web/www
chmod +x /work/source/libs/datazoomer/setup/www/index.py

# copy apps
cp -r /work/source/libs/datazoomer/apps /work/web/apps

# create initial database
service mysql start
echo "create database zoomdata" | mysql -u root -proot
mysql -u root -proot zoomdata < /work/source/libs/datazoomer/setup/database/setup_mysql.sql
mysql -u root -proot -e "create user zoomuser identified by 'zoompass'"
mysql -u root -proot -e "grant all on zoomdata.* to zoomuser@'%'"
