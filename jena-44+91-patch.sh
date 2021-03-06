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

WORKING_PATH=/tmp/JENA-44-91

ARQ_SVN_REPOSITORY="http://svn.apache.org/repos/asf/incubator/jena/Jena2/ARQ/trunk/"
TDB_SVN_REPOSITORY="http://svn.apache.org/repos/asf/incubator/jena/Experimental/TxTDB/trunk/"
ARQ_PATH="arq"
TDB_PATH="txtdb"
PATCH_ARQ_POM_FILE=pom-arq.patch
PATCH_TDB_POM_FILE=pom-tx-tdb.patch

PATCH_NAME="JENA_44_91"
PATCH_ARQ_FILE_NAME="JENA-44_ARQ_r1156212.patch"
PATCH_ARQ_URL_PATH="https://issues.apache.org/jira/secure/attachment/12490098/$PATCH_ARQ_FILE_NAME"
PATCH_TDB_FILE_NAME=""
PATCH_TDB_URL_PATH=""

