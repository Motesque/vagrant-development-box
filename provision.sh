
# install general packages
sudo apt-get update && sudo apt-get install -y \
 usbutils curl  dfu-util \
 libncursesw5-dev libgdbm-dev zlib1g-dev libsqlite3-dev tk-dev libssl-dev openssl liblapack-dev gfortran libatlas-base-dev \
 libbz2-dev libffi-dev libjpeg-dev wget vim \
 htop netcat pandoc jq net-tools ntp ffmpeg \
 libdbus-glib-1-dev  ghostscript git nfs-common curl libhdf5-dev zlib1g-dev \
 libcairo-dev libgirepository1.0-dev pkg-config swig cmake-curses-gui gir1.2-gtk-3.0



# virtual serial com port. Make sure vagrant user has permissions
sudo modprobe -a ftdi_sio
sudo modprobe -a usbserial
sudo gpasswd --add vagrant dialout

# compile python3
mkdir -p ~/tmp && cd ~/tmp \
    && wget https://www.python.org/ftp/python/3.6.8/Python-3.6.8.tgz \
    && tar -zxvf Python-3.6.8.tgz \
    && cd Python-3.6.8 \
    && sudo ./configure --enable-shared \
    && sudo make -j4 \
    && sudo make install

# compile couchdb
sudo apt-get --no-install-recommends -y install \
    build-essential  pkg-config erlang \
    libicu-dev libmozjs185-dev libcurl4-openssl-dev

mkdir -p ~/tmp && cd ~/tmp \
    && wget http://mirrors.ibiblio.org/apache/couchdb/source/2.3.0/apache-couchdb-2.3.0.tar.gz \
    && tar -zxvf apache-couchdb-2.3.0.tar.gz \
    && cd apache-couchdb-2.3.0 \
    && ./configure --disable-docs \
    && make release -j4 \
    && sudo cp -r ~/tmp/apache-couchdb-2.3.0/rel/couchdb /usr/local/lib/couchdb

# compile wiring library
mkdir -p ~/tmp && cd ~/tmp \
    && sudo wget https://download.motesque.com/wiringPi-96344ff.tar.gz \
    && sudo tar xfz wiringPi-96344ff.tar.gz \
    && cd wiringPi-96344ff \
    && sudo ./build

#install all python 3 packages
sudo pip3 install  --trusted-host pypi.motesque.com --index-url http://pypi.motesque.com:8181 --extra-index-url https://pypi.org/simple --find-links . -r /vagrant_shared/requirements_py3.txt
sudo pip3 install jupyter==1.0.0
sudo pip3 install jupyter_contrib_nbextensions
sudo jupyter contrib nbextension install --user

#install nodejs 8
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs

#install protocol buffer generator for python
mkdir -p ~/tmp && cd ~/tmp \
    && sudo wget https://github.com/google/protobuf/releases/download/v3.7.0/protobuf-python-3.7.0.tar.gz \
    && sudo tar -xvzf protobuf-python-3.7.0.tar.gz \
    && cd protobuf-3.7.0 \
    && sudo  ./configure  \
    && sudo make -j4 \
    && sudo make install \
    && sudo ldconfig

# Install eigen3 (Chrono dependency)
mkdir -p /tmp && cd /tmp \
    && sudo wget http://bitbucket.org/eigen/eigen/get/3.3.7.tar.gz \
    && sudo tar -xvzf 3.3.7.tar.gz \



#-------------------------------------------------
# Install chrono
#-------------------------------------------------
mkdir /home/vagrant/chrono-build
cd /home/vagrant
git clone https://github.com/projectchrono/chrono.git
cd /home/vagrant/chrono
# git checkout f8f0edd40b5e4f0c2235da40a50f7c91ed45c153
# git checkout 466e7b64b74f4c69b2e03216a805b0f782a7020e
git checkout 88fb81d100d66acf2e1874eb71b975b5ce3455c7
cd /home/vagrant/chrono-build
cmake -DCMAKE_BUILD_TYPE=Release -DENABLE_MODULE_PYTHON=ON -DENABLE_MODULE_POSTPROCESS=ON \
 -DPYTHON_EXECUTABLE:FILEPATH=/usr/local/bin/python3 -DPYTHON_LIBRARY=/usr/local/lib/libpython3.so ../chrono \
 -DUSE_BULLET_DOUBLE=ON -DEIGEN3_INCLUDE_DIR:PATH=/tmp/eigen-eigen-323c052e1731 -DEIGEN3_DIR:PATH=/tmp/eigen-eigen-323c052e1731
make -j4
sudo make install
sed  -i '1 i export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/lib' /home/vagrant/.bashrc
#sed  -i ‘1 i export PYTHONPATH=${PYTHONPATH}:/usr/local/share/chrono/python’ /home/vagrant/.bashrc
sudo ln -s /usr/local/share/chrono/python/pychrono/ /usr/local/lib/python3.6/site-packages/pychrono

source /home/vagrant/.bashrc


#cleanup
sudo apt-get clean
sudo rm -rf ~/tmp
