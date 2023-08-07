#!/bin/bash

echo 'Run yarn install'

EB_APP_STAGING_DIR=$(sudo /opt/elasticbeanstalk/bin/get-config platformconfig -k AppStagingDir)
cd $EB_APP_STAGING_DIR
yarn install --production