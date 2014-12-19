#!/usr/bin/env sh

######

cd ${HOME}

###### for OSX ######

is_osx=`expr "${TRAVIS_OS_NAME}" : "osx"`;

# echo "is_osx = ${is_osx}"

if
  expr ${is_osx} > 0
then
#
# brew install gcc47
  wget -q https://distfiles.macports.org/MacPorts/MacPorts-2.3.3.tar.gz
  tar zvxf MacPorts-2.3.3.tar.gz
  cd MacPorts-2.3.3
  ./configure && make && sudo make install
  export PATH=${PATH}:/opt/local/bin:/opt/local/sbin
  sudo port -v selfupdate
  sudo port install gcc47
  sudo port select --list gcc
  sudo port select --set gcc mp-gcc47
#
  brew install gmp
  brew install bdw-gc
# brew install gtk+3
  brew install libev
  brew install jansson
#
fi

###### for LINUX ######

is_linux=`expr "${TRAVIS_OS_NAME}" : "linux"`;

# echo "is_linux = ${is_linux}"

if
  expr ${is_linux} > 0
then
#
  sudo apt-get -qq -y update
  sudo apt-get -qq -y install libgc-dev
  sudo apt-get -qq -y install libgmp3-dev
# For contrib/GTK/
  sudo apt-get -qq -y install libgtk-3-dev
# For contrib/libev/
  sudo apt-get -qq -y install libev-dev
# For contrib/jansson/
  sudo apt-get -qq -y install libjansson-dev
#
fi

######

exit 0

###### end of [installpkg.sh] ######