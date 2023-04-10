#!/bin/bash
set -eo pipefail

if [ "$#" -ne 3 ]; then
  echo "Usage: $0 <build number> <build name> <npm publish token>"
  exit 1
fi

BUILD_NUMBER=$1
BUILD_NAME=$2
NPM_PUBLISH_TOKEN=$3

. ~/.nvm/nvm.sh
nvm install 12.18.3
nvm use 12.18.3

yarn install

if [[ $BUILD_NAME != "master" ]] && [[ ! $BUILD_NAME =~ ^[0-9]+\.[0-9]([0-9])?(\.[0-9]+)?$ ]]; then
	echo "Not a mainline(master or x.y or x.y.z or x.yy.z) branch, skipping publish"
	exit 0;	
fi

if [ "$NPM_PUBLISH_TOKEN" != "nopublish" ]; then
	sed  -i.old "s|//registry.npmjs.org/:_authToken=.*|//registry.npmjs.org/:_authToken=${NPM_PUBLISH_TOKEN}|g" .npmrc
	npm publish ./index.json
else
	echo "Skipping publish"
fi
