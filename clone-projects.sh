#!/bin/bash

echo "Clone projects in $pwd"

cd ~
git clone https://TOKEN:x-oauth-basic@github.com/towoards5gs/fiveg-trafficmeter.git && \
  git clone https://TOKEN:x-oauth-basic@github.com/towoards5gs/t5gs-helm.git && \
  git clone https://TOKEN:x-oauth-basic@github.com/raoufkh/5gc-observer-perf-evaluation.git && \
  git clone https://TOKEN:x-oauth-basic@github.com/raoufkh/ml-observability-5g.git





