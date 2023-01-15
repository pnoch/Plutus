#!/usr/bin/env bash

docker build -t plutus . && \
docker create --name plutus-miner --cpuset-cpus="43-127" -v /home/chiamaster/plutus-data:/data/ plutus:latest