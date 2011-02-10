#!/bin/bash

##
# Copyright © 2011 Talis Systems Ltd.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
##

ROOT_PATH=`pwd`
WORKING_PATH=/tmp

PATCH_NAME=JENA_44
PATCH_FILE_NAME=JENA-44-0.patch
PATCH_URL_PATH=https://issues.apache.org/jira/secure/attachment/12470682/$PATCH_FILE_NAME

PATCH_ARQ_POM_FILE=pom-arq.patch
PATCH_TDB_POM_FILE=pom-tdb.patch

## if [ ! -d "/tmp/arq" ] ; then
##     mkdir /tmp/arq
## fi
## 
## if [ ! -d "/tmp/tdb" ] ; then
##     mkdir /tmp/tdb
## fi

svn_revert() {
    if [ -f "pom.xml.orig" ] ; then 
        rm pom.xml.orig 
    fi
    if [ -f "pom.xml.rej" ] ; then 
        rm pom.xml.rej 
    fi
    svn revert -R *
    svn st |grep ^\?| awk '{print $2}'|xargs rm -rf
}

cd $WORKING_PATH

svn co https://jena.svn.sourceforge.net/svnroot/jena/ARQ/trunk/ arq
svn co https://jena.svn.sourceforge.net/svnroot/jena/TDB/trunk/ tdb

cd $WORKING_PATH/arq
svn_revert
cp $ROOT_PATH/pom-arq.patch $WORKING_PATH/arq/
patch -p0 < pom-arq.patch
if [ ! -f "$PATCH_FILE_NAME" ] ; then
    wget $PATCH_URL_PATH
fi
patch -p0 < $PATCH_FILE_NAME
sed -i "s/@@PATCH_NAME@@/$PATCH_NAME/g" pom.xml
mvn clean install

cd $WORKING_PATH/tdb
svn_revert
cp $ROOT_PATH/pom-tdb.patch $WORKING_PATH/tdb/
sed -i "s/@@PATCH_NAME@@/$PATCH_NAME/g" pom-tdb.patch
patch -p0 < pom-tdb.patch
mvn clean install

echo "Do you want to proceed publishing SNAPSHOTs? [y|n]"
read ANSWER
if [ $ANSWER = "y" ] ; then
    cd $WORKING_PATH/arq
    mvn deploy
    cd $WORKING_PATH/tdb
    mvn deploy
else
    echo "No, problem. I understand."
fi

