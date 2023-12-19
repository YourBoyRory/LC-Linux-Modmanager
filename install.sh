#!/bin/bash

sudo mkdir /opt/lcmm/
sudo cp ./installBepInEx.sh /opt/lcmm/installBepInEx.sh
sudo cp ./installMod.sh /opt/lcmm/installMod.sh
sudo cp ./lcmm.sh /usr/local/bin/lcmm
sudo chmod 777 /opt/lcmm/
sudo chmod 755 /opt/lcmm/installBepInEx.sh
sudo chmod 755 /opt/lcmm/installMod.sh
sudo chmod 755 /usr/local/bin/lcmm
