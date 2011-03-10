#!/bin/bash

for dname in bin include lib; do
  if [ ! -d "$(dirname $0)/$dname" ]; then
    mkdir "$(dirname $0)/$dname"
  fi
done


autoreconf -fvi


