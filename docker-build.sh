#!/bin/bash

# added --network host because 
# on Linux archive.ubuntu.com wasn't 
# resolving because it can't use 127.0.0.1 as DNS server from HOST
docker build --network host -t tgn/tgn-wms:v16 .

