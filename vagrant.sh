#!/usr/bin/env bash

# I´m using this two guides:
# Building OSRM: https://github.com/Project-OSRM/osrm-backend/wiki/Building-OSRM
# Building on Ubuntu: https://github.com/Project-OSRM/osrm-backend/wiki/Building-on-Ubuntu

# First off, let's install the required software
apt-get update
apt-get install build-essential git cmake pkg-config libprotoc-dev libprotobuf8 \
protobuf-compiler libprotobuf-dev libosmpbf-dev libpng12-dev \
libbz2-dev libstxxl-dev libstxxl-doc libstxxl1 libxml2-dev \
libzip-dev libboost-all-dev lua5.1 liblua5.1-0-dev libluabind-dev libluajit-5.1-dev libtbb-dev