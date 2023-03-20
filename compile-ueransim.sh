#!/bin/bash

echo "Clone UERANSIM in $pwd"
cd ~
git clone -b v3.2.6 https://github.com/aligungr/UERANSIM.git && cd UERANSIM

echo "Install dependencies"
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y install make g++ libsctp-dev
sudo apt-get -y install git python3 python3-pip
sudo pip3 install cmake

echo "Compile UERANSIM in $pwd"
make
cd ~



