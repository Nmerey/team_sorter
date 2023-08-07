echo 'Add database.yml'

EB_APP_STAGING_DIR=$(sudo /opt/elasticbeanstalk/bin/get-config platformconfig -k AppStagingDir)
cd $EB_APP_STAGING_DIR
sudo cp ./config/database.yml.eb ./config/database.yml