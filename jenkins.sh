#
# jenkins.sh - builds vagrant file
#
set -e

export gitcommithash=`git describe --always`
vagrant up
vagrant package --output motesque_dev_git${gitcommithash}.box
