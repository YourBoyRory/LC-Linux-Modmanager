#!/bin/bash
config="./config"
gameDir=$(grep -oP '^gameDir=\K.*' $config | head -n1 )
modToInstall="$@"
rand=${RANDOM}

mkdir "/opt/Steam/steamapps/common/Lethal Company/BepInEx/plugins"
wget "$modToInstall" -O "/tmp/thunderstoreCache_$rand.zip"
unzip -o "/tmp/thunderstoreCache_$rand.zip" -d "/tmp/thunderstoreCache_$rand"
if [[ $? -eq 0 ]] ; then
    #Install
    find "/tmp/thunderstoreCache_$rand" -iname "*.dll" -exec cp {} "$gameDir/BepInEx/plugins" \;
    echo -e "\033[32mMod Installed Successfully!\033[0m"
    exitCode=0
else
    echo -e "\033[31mMod Install Failed\033[0m"
    exitCode=1
fi
rm -rf "/tmp/thunderstoreCache_$rand.zip" "/tmp/thunderstoreCache_$rand"
exit $exitCode

