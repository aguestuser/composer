#! /usr/bin/env bash

# remember where we are!
pushd `pwd`
cd ../../

# run `indake-receiver`
babel-node crisisbox-intake-receiver/app.js &
  # run `intake-form`
  cd crisisbox-intake-form
  node scripts/start.js
