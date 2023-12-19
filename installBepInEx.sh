#!/bin/bash
config="./config"
gameDir=$(grep -oP '^gameDir=\K.*' $config | head -n1 )
rand=${RANDOM}

curl -s https://api.github.com/repos/BepInEx/BepInEx/releases/latest \
| grep "browser_download_url.*x64" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -O "/tmp/BepInExCache_$rand.zip" -i -
unzip -o "/tmp/BepInExCache_$rand.zip" -d "$gameDir"
if [[ $? -eq 0 ]] ; then
    echo -e "\033[32mBepInEx Installed!\033[0m"
    echo " "
    echo -e "\033[31mIMPORTANT: Add '\033[0;33mWINEDLLOVERRIDES=\"winhttp.dll=n,b\" %command%\033[0;31m' to your games launch options\033[0m"
    echo " "
    exitCode=0
else
    echo -e "\033[31mCould Not install BepInEx\033[0m"
    exitCode=1
fi
rm -f "/tmp/BepInExCache_$rand.zip"
exit $exitCode
