#
# jenkins.sh - builds vagrant file
#
set -e

export VAGRANT_TAG=$(git log --pretty=format:%H -1 | cut -c1-7)
echo "Using tag: ${VAGRANT_TAG}"
cd $WORKSPACE
# vagrant has a serious problem. This is the workaround: https://github.com/dotless-de/vagrant-vbguest/issues/351
#export FIRST_RUN='true'
#vagrant up --no-provision
#vagrant ssh -c 'sudo apt-get -y update'
#vagrant ssh -c 'DEBIAN_FRONTEND=noninteractive sudo DEBIAN_FRONTEND=noninteractiv apt-get -y upgrade'
#vagrant ssh -c 'sudo apt-get install -y build-essential linux-headers-amd64 linux-image-amd64'
#vagrant halt
#export FIRST_RUN='false'
vagrant up
vagrant package --output motesque_dev_git${VAGRANT_TAG}.box
