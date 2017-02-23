#! /usr/bin/env bash

# remember where we are!
pushd `pwd`
cd ../../
baseDir=`pwd`

# install `intake-form`
git clone git@github.com:aguestuser/crisisbox-intake-form.git
cd crisisbox-intake-form
npm install

# install `intake-receiver`
cd ${baseDir}
git clone git@github.com:aguestuser/crisisbox-intake-receiver.git
cd crisisbox-intake-receiver
npm install

popd
