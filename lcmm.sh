#!/bin/bash
plug=$RANDOM
config="/opt/lcmm/config"
pluginTmp="/tmp/lcmmPlugin_$plug"
addTmp="/tmp/lcmmAdd_$plug"
ls $config > /dev/null
if [[ $? -ne 0 ]] ; then
    echo "making new config"
    echo "gameDir=~/.local/share/Steam/steamapps/common/Lethal Company/" > $config
fi

gameDir=$(grep -oP '^gameDir=\K.*' $config | head -n1 )

if [[ $gameDir == "" ]] ; then
    echo "gameDir=~/.local/share/Steam/steamapps/common/Lethal Company/" > $config
    gameDir=$(grep -oP '^gameDir=\K.*' $config | head -n1 )
fi

processRefresh(){
    cat $addTmp | awk -F '|' '{ print "gameDir="$2 }' > $config

    lineCount=$(wc -l $pluginTmp | awk '{print $1}')
    i=1
    while [[ $i -le $lineCount ]] ; do
        bool=$(head -n$i $pluginTmp | tail -n1 | awk -F '|' '{print $1}')
        fileName="$(head -n$i $pluginTmp | tail -n1 | awk -F '|' '{print $2}').dll"
        if [[ $bool == "FALSE" ]]; then
            rm -f "$gameDir/BepInEx/plugins/$fileName"
        fi
        i=$(($i+1))
    done

    rm $addTmp
    rm $pluginTmp
}

    (
        yad --print-all --list --checklist --plug=$plug --tabnum=1\
        --column "Installed" --column "Plugins" $(ls "$gameDir/BepInEx/plugins" | sed 's/\.dll\b/ /g' | sed 's/\S\+/TRUE &/g') \
        >$pluginTmp
    )&\
    # Install
    (
        yad  --form --plug=$plug --tabnum=2\
        --field="<b>Mod Loader Options</b>":LBL ""\
        --field="Game DIR" "$gameDir" \
        --field="Update Mod Loader":FBTN "bash -c '/opt/lcmm/installBepInEx.sh && yad --center --title="" --text=\"BepInEx Installed!\" --button=Ok || yad --center --title="" --text=\"Could Not install BepInEx\" --button=Ok'" \
        --field="<b>Install Mods</b>":LBL ""\
        --field="Mod Link" "" \
        --field="Install Mod":FBTN "bash -c '/opt/lcmm/installMod.sh %5 && yad --center --title="" --text=\"Mod Installed Successfully!\" --button=Ok || yad --center --title="" --text=\"Mod Install Failed\" --button=Ok'" \
        --field="Browse for mods on thunderstore.io":LINK "https://thunderstore.io/c/lethal-company/" \
        >$addTmp
    )&\

    #draw UI
    (
        yad --always-print-result --no-escape --notebook --window-icon=color-management --center --key=$plug --height=700 --width=500 --title="Lethal Company Mod Manager"\
        --tab="Installed"\
        --tab="Add"\
        --button="Open File":2\
        --button="Refresh":3\
        --button="Save":0\
    )
    exitCode=$?

if [[ $exitCode -ne 252 ]] ; then
    processRefresh
    if [[ $exitCode -eq 2 ]] ; then
        xdg-open "$gameDir/BepInEx/"
        $0$@
    elif [[ $exitCode -eq 3 ]] ; then
        $0$@
    fi
fi
