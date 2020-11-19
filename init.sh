#!/bin/bash

# get service name from args
if [ -z ${1+x} ]; then echo "service name is not set.\n sh init.sh <serviceName>\n"; exit 1; else echo "using service name '$1'"; fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"

echo "replacing <serviceName> with $1..."
find $DIR/build -type f -name '*.sh' -print0 | xargs -0 sed -i '' "s/<serviceName>/$1/g"
find $DIR/config -type f -name '*.env' -print0 | xargs -0 sed -i '' "s/<serviceName>/$1/g"
find $DIR/src/main -type f -name '*.go' -print0 | xargs -0  sed -i '' "s/<serviceName>/$1/g"
find $DIR/src/server/serviceName -type f -name '*.go' -print0 | xargs -0  sed -i '' "s/<serviceName>/$1/g"
find $DIR/src/serviceName -type f -name '*.go' -print0 | xargs -0  sed -i '' "s/<serviceName>/$1/g"
echo "Updating default project files"
find $DIR/templateVSCode -type f -name '*.json' -print0 | xargs -0  sed -i '' "s/<serviceName>/$1/g"
find $DIR/templateVSCode -type f -name '*.json' -print0 | xargs -0  sed -i '' "s|<projectPath>|$DIR|g"
find $DIR/templateGoLand -type f -name '*.xml' -print0 | xargs -0  sed -i '' "s/<serviceName>/$1/g"

# module file is named the same as the project
mv $DIR/templateGoLand/SERVICE_NAME.iml $DIR/templateGoLand/${PWD##*/}.iml
echo "Default projects moved to hidden folders"
mv $DIR/templateVSCode $DIR/.vscode
mv $DIR/templateGoLand $DIR/.idea

echo "moving serviceName directories..."
mv $DIR/src/server/serviceName $DIR/src/server/$1
mv $DIR/src/serviceName $DIR/src/$1

echo "\nFinished.  Don't forget to remove this script update the README.md and run govendor.\n"
