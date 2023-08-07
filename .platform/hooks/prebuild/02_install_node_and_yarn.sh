#!/bin/bash

echo 'Install nodejs and yarn'

# Install nodejs
sudo curl --silent --location https://rpm.nodesource.com/setup_14.x | sudo bash -
sudo yum -y install nodejs

# Install yarn
sudo wget https://dl.yarnpkg.com/rpm/yarn.repo -O /etc/yum.repos.d/yarn.repo
sudo yum -y install yarn