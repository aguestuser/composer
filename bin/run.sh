#! /usr/bin/env bash

# remember where we are!
cd ../../

# run `indake-receiver`
babel-node intake-receiver/app.js &
  # run `intake-form`
  cd intake-form
  node scripts/start.js
