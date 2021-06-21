
# install general packages
sudo apt-get update  && sudo apt-get install -y \
    autotools-dev \
    build-essential \
    cmake-curses-gui \
    curl \
    debhelper \
    devscripts \
    dfu-util \
    erlang \
    exfat-fuse \
    ffmpeg \
    gfortran \
    ghostscript \
    gir1.2-gtk-3.0 \
    git \
    htop \
    jq \
    libatlas-base-dev \
    libbz2-dev  \
    libcairo-dev \
    libdbus-glib-1-dev \
    libffi-dev \
    libgdbm-dev  \
    libgirepository1.0-dev \
    libhdf5-dev  \
    libicu-dev \
    libicu63 \
    libjpeg-dev \
    liblapack-dev \
    libncursesw5-dev \
    libnspr4-dev \
    libsnappy-dev \
    libsqlite3-dev \
    libssl-dev \
    lsb-release \
    net-tools \
    netcat \
    nfs-common \
    ntfs-3g \
    ntp \
    openssl \
    pandoc \
    pkg-config \
    pkg-kde-tools \
    tk-dev \
    usbutils \
    vim \
    wget \
    zip \
    zlib1g-dev


# virtual serial com port. Make sure vagrant user has permissions
sudo modprobe -a ftdi_sio
sudo modprobe -a usbserial
sudo gpasswd --add vagrant dialout

set -e

PYTHON_VERSION=3.8.2
cd /
sudo wget -nv https://nyc3-download-01.motesque.com/packages/Python-$PYTHON_VERSION.linux-amd64.tar.gz \
    && sudo tar -zxf Python-$PYTHON_VERSION.linux-amd64.tar.gz  --strip-components=1 \
    && sudo rm Python-$PYTHON_VERSION.linux-amd64.tar.gz \
    && sudo ldconfig

source /home/vagrant/.bashrc

# compile libmozjs185 for couchdb.
cd  /tmp \
    && git clone https://github.com/apache/couchdb-pkg.git \
    && cd couchdb-pkg \
    && make -j4 couch-js-debs PLATFORM=$(lsb_release -cs) > make-couch-js-debs.log 2> make-couch-js-debs-error.log

# compile CouchDB 2.x
cd /tmp/ \
  && sudo apt-get install -y --allow-downgrades -f /tmp/couchdb-pkg/js/couch-libmozjs185-1.0_1.8.5-1.0.0*.deb \
  && sudo apt-get install -y --allow-downgrades -f /tmp/couchdb-pkg/js/couch-libmozjs185-dev_1.8.5-1.0.0*.deb \
  && wget https://archive.apache.org/dist/couchdb/source/2.3.0/apache-couchdb-2.3.0.tar.gz \
  && tar -zxvf apache-couchdb-2.3.0.tar.gz \
  && cd apache-couchdb-2.3.0 \
  && ./configure --disable-docs \
  && make release -j4 \
  && sudo cp -r /tmp/apache-couchdb-2.3.0/rel/couchdb /usr/local/lib

# compile wiring library
mkdir -p ~/tmp && cd ~/tmp \
    && sudo wget -nv https://download.motesque.com/wiringPi-96344ff.tar.gz \
    && sudo tar xfz wiringPi-96344ff.tar.gz \
    && cd wiringPi-96344ff \
    && sudo ./build

#sudo apt-get remove -y 'python3.*'

#install all python 3 packages needed in production
sudo pip3 install   --no-deps \
                    --trusted-host pypi-buster.motesque.com \
                    --index-url http://pypi-buster.motesque.com:8181 \
                    --extra-index-url https://pypi.org/simple \
                    --find-links . -r /vagrant_shared/requirements.txt

# install python packages for local development.
sudo pip3 install \
        jupyter  \
        jupyter_contrib_nbextensions

sudo jupyter contrib nbextension install --user

#install nodejs 12
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt-get install -y nodejs

#install protocol buffer generator for python
mkdir -p ~/tmp && cd ~/tmp \
    && sudo wget -nv https://github.com/google/protobuf/releases/download/v3.7.0/protobuf-python-3.7.0.tar.gz \
    && sudo tar -xzf protobuf-python-3.7.0.tar.gz \
    && cd protobuf-3.7.0 \
    && sudo  ./configure  \
    && sudo make -j4 \
    && sudo make install \
    && sudo ldconfig

# run checks
pip3 check

#cleanup
sudo apt-get clean
sudo rm -rf ~/tmp
