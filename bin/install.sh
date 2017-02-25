#! /usr/bin/env bash

# remember where we are!
pushd `pwd`
cd ../../
baseDir=`pwd`

# install `intake-form`
git clone git@github.com:crisisbox/intake-form.git
cd intake-form
./install.sh

# install `intake-receiver`
cd ${baseDir}
git clone git@github.com:crisisbox/intake-receiver.git
cd intake-receiver
./install.sh

popd
