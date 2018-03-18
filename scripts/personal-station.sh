#!/bin/bash

set -x -e

# pull down my exercism repo
mkdir -p ~/workspace/exercism
cd $_
git clone https://github.com/maorleger/exercism .
