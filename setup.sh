echo Setting up

# setup work directory
cd /work
mkdir \
    web \
        web/apps \
        web/sites \
        web/sites/default \
        web/themes \
        web/www \
        web/www/static \
    lib \
    libs \
    jobs \
    log \
    data

# set the python path to point the lib folder which is
# where we install datazoomer related python scripts
echo /work/lib > dsi.pth
mv dsi.pth /usr/local/lib/python2.7/dist-packages

# get a copy of datazoomer from github
cd /work/libs
git clone https://github.com/dsilabs/datazoomer.git
cd /work/lib
ln -s /work/libs/datazoomer/zoom

# setup the default theme
cd /work/web/themes
ln -s /work/libs/datazoomer/themes/default

# setup apache
cd /etc/apache2/sites-enabled
rm -f 000-default*
ln -s /work/libs/datazoomer/setup/apache/zoom zoom.conf
sed -i'' 's/Listen 80/ServerName localhost\n\nlisten 80/' /etc/apache2/ports.conf

# setup datazoomer config files
echo -e "[sites]\\npath=/work/web/sites" > /work/dz.conf
echo -e "[sites]\\npath=/work/web/sites" > /work/web/dz.conf
cp /work/libs/datazoomer/sites/default/site.ini /work/web/sites/default/site.ini
sed -i'' 's|^path=/work/source/libs/datazoomer/apps|path=/work/libs/datazoomer/apps|' /work/web/sites/default/site.ini

# setup the www server folder
cd /work/web/www/static
ln -s /work/libs/datazoomer/setup/www/static/dz
cd ..
ln -s /work/libs/datazoomer/setup/www/index.py
chmod +x /work/libs/datazoomer/setup/www/index.py

