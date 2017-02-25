#! /usr/bin/env bash

# remember where we are!
cd ../../

# run `intake-receiver`
babel-node intake-receiver/app.js &
  # run `intake-form`
  cd intake-form
  node scripts/start.js
