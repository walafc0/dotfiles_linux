#!/bin/bash

if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi

export SCRIPTS_DIR=~/.scripts
export PATH=$SCRIPTS_DIR:$PATH
