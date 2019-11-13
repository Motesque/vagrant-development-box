
# install general packages
sudo apt-get update  && sudo apt-get install -y \
    build-essential \
    cmake-curses-gui \
    curl \
    dfu-util \
    ffmpeg \
    gfortran \
    ghostscript \
    git \
    gir1.2-gtk-3.0 \
    htop \
    jq \
    libncursesw5-dev   \
    libatlas-base-dev \
    libbz2-dev  \
    libcairo-dev \
    libdbus-glib-1-dev \
    libffi-dev \
    libgdbm-dev  \
    libgirepository1.0-dev \
    libhdf5-dev  \
    libjpeg-dev \
    liblapack-dev \
    libsqlite3-dev \
    libsnappy-dev \
    libssl-dev \
    netcat \
    net-tools \
    nfs-common \
    ntp \
    openssl \
    pandoc \
    pkg-config \
    tk-dev \
    usbutils \
    vim \
    wget \
    zlib1g-dev


# virtual serial com port. Make sure vagrant user has permissions
sudo modprobe -a ftdi_sio
sudo modprobe -a usbserial
sudo gpasswd --add vagrant dialout


set -e
sudo apt-get remove -y 'python3.*'
PYTHON_VERSION=3.6.8
cd /
sudo wget -nv https://nyc3-download-01.motesque.com/packages/Python-$PYTHON_VERSION.linux-amd64.tar.gz \
    && sudo tar -zxf Python-$PYTHON_VERSION.linux-amd64.tar.gz  --strip-components=1 \
    && sudo rm Python-$PYTHON_VERSION.linux-amd64.tar.gz \
    && sudo ldconfig

source /home/vagrant/.bashrc

# compile couchdb
sudo apt-get --no-install-recommends -y install \
    erlang \
    libicu-dev \
    libmozjs185-dev \
    libcurl4-openssl-dev

mkdir -p ~/tmp && cd ~/tmp \
    && wget -nv http://mirrors.ibiblio.org/apache/couchdb/source/2.3.0/apache-couchdb-2.3.0.tar.gz \
    && tar -zxvf apache-couchdb-2.3.0.tar.gz \
    && cd apache-couchdb-2.3.0 \
    && ./configure --disable-docs \
    && make release -j4 \
    && sudo cp -r ~/tmp/apache-couchdb-2.3.0/rel/couchdb /usr/local/lib/couchdb

# compile wiring library
mkdir -p ~/tmp && cd ~/tmp \
    && sudo wget -nv https://download.motesque.com/wiringPi-96344ff.tar.gz \
    && sudo tar xfz wiringPi-96344ff.tar.gz \
    && cd wiringPi-96344ff \
    && sudo ./build

#install all python 3 packages needed in production
sudo pip3 install  --trusted-host pypi.motesque.com \
                    --index-url http://pypi.motesque.com:8181 \
                    --extra-index-url https://pypi.org/simple \
                    --no-deps --find-links . -r /vagrant_shared/requirements.txt

# install python packages for local development.
sudo pip3 install \
        jupyter  \
        jupyter_contrib_nbextensions

sudo jupyter contrib nbextension install --user

#install nodejs 8
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
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
