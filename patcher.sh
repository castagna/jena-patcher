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

source jena-44+91-patch.sh

svn_revert() {
    echo "Reverting SVN repository..."
    if [ -f "pom.xml.orig" ] ; then 
        rm pom.xml.orig 
    fi
    if [ -f "pom.xml.rej" ] ; then 
        rm pom.xml.rej 
    fi
    svn revert -R *
    svn st |grep ^\?| awk '{print $2}'|xargs rm -rf
    echo "done."
    svn status
}


if [ ! -d "$WORKING_PATH" ] ; then
    mkdir -p $WORKING_PATH 
fi
cd $WORKING_PATH

echo "Checking out ARQ and TDB..."
svn co $ARQ_SVN_REPOSITORY $ARQ_PATH
svn co $TDB_SVN_REPOSITORY $TDB_PATH
echo "done."


##
## Patching ARQ code and pom.xml file and compiling
##

cd $WORKING_PATH/$ARQ_PATH
svn_revert

echo "Patching ARQ pom.xml file..."
cp $ROOT_PATH/$PATCH_ARQ_POM_FILE $WORKING_PATH/$ARQ_PATH/
sed -i "s/@@PATCH_NAME@@/$PATCH_NAME/g" $PATCH_ARQ_POM_FILE
patch -p0 < $PATCH_ARQ_POM_FILE
## sed -i "s/@@PATCH_NAME@@/$PATCH_NAME/g" pom.xml
echo "done."

if [[ -n $PATCH_ARQ_FILE_NAME ]] ; then
    echo "Patching ARQ code..."
    if [ ! -f "$PATCH_ARQ_FILE_NAME" ] ; then
        wget $PATCH_ARQ_URL_PATH
    fi
    # cat $PATCH_ARQ_FILE_NAME
    patch -p0 < $PATCH_ARQ_FILE_NAME
    echo "done."
fi

mvn clean install


##
## Patching TDB code and pom.xml file and compiling
##

cd $WORKING_PATH/$TDB_PATH
svn_revert

echo "Patching TDB pom.xml file..."
cp $ROOT_PATH/$PATCH_TDB_POM_FILE $WORKING_PATH/$TDB_PATH/
sed -i "s/@@PATCH_NAME@@/$PATCH_NAME/g" $PATCH_TDB_POM_FILE
patch -p0 < $PATCH_TDB_POM_FILE
## sed -i "s/@@PATCH_NAME@@/$PATCH_NAME/g" pom.xml
echo "done."

if [[ -n $PATCH_TDB_FILE_NAME ]] ; then
    echo "Patching TDB code..."
    if [ ! -f "$PATCH_TDB_FILE_NAME" ] ; then
        wget $PATCH_TDB_URL_PATH
    fi
    # cat $PATCH_TDB_FILE_NAME
    patch -p0 < $PATCH_TDB_FILE_NAME
    echo "done."
fi

mvn clean install



echo "Do you want to proceed publishing SNAPSHOTs? [y|n]"
read ANSWER
if [ $ANSWER = "y" ] ; then
    cd $WORKING_PATH/$ARQ_PATH
    mvn deploy
    cd $WORKING_PATH/$TDB_PATH
    mvn deploy
else
    echo "No, problem. I understand."
fi

