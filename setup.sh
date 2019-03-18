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
cp /work/source/libs/datazoomer/sites/default/site.ini /work/web/sites/default/site.ini
mkdir /work/web/sites/localhost
cat <<EOT | tee "/work/web/sites/localhost/site.ini"
[database]
engine=mysql
dbname=zoomdata
dbhost=localhost
dbuser=zoomuser
dbpass=zoompass
EOT

# setup the www server folder
ln -s /work/source/libs/datazoomer/setup/www/static/dz /work/web/www/static
ln -s /work/source/libs/datazoomer/setup/www/index.py /work/web/www
chmod +x /work/source/libs/datazoomer/setup/www/index.py

