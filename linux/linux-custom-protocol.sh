#!/bin/bash
# ----------------------------------------------------------------
#   Octarine-Phaneron | Custom Protocol
#   Script to create a custom scheme and its handler 
#   to open local files 
# ----------------------------------------------------------------

VERSION=0.1.0
SUBJECT=custom-protocol-script
USAGE="Usage: \"bash customProtocol.sh\" or \"./customProtocol.sh\" \n -h : help \n -v : version"

# --- Options processing -----------------------------------------
quitMsg="Press any key to quit ..."

while getopts ":i:vh" optname
  do
    case "$optname" in
      "v")
        echo -e "Version $VERSION"
        read -p "${quitMsg}"
        exit 0;
        ;;
      "h")
        echo -e $USAGE
        read -p "${quitMsg}"
        exit 0;
        ;;
      "?")
        echo -e "Unknown option $OPTARG"
        read -p "${quitMsg}"
        exit 0;
        ;;
      *)
        echo -e "Unknown error while processing options"
        read -p "${quitMsg}"
        exit 0;
        ;;
    esac
  done

shift $(($OPTIND - 1))

param1=$1
param2=$2

# --- Body ------------------------------------------------------

c1="\e[96;1m"
c2="\e[33m"
c3="\e[97m"
c4="\e[0m"

linuxLogo="${c1}          odddd            ${c4}#######################################################
${c1}      oddxkkkxxdoo         ${c4}##     .oPYo.                 o                      ##
${c1}      ddcoddxxxdoool       ${c4}##     8    8                 8                      ##
${c1}      xdclodod  olol       ${c4}##     8      o    o .oPYo.  o8P .oPYo. ooYoYo.      ##
${c1}      xoc  xdd  olol       ${c4}##     8      8    8 Yb..     8  8    8 8' 8  8      ##
${c1}      xdc  ${c2}k00${c1}Okdlol       ${c4}##     8    8 8    8   'Yb.   8  8    8 8  8  8      ##
${c1}      xxd${c2}kOKKKOkd${c1}ldd       ${c4}##     \`YooP\` \`YooP\` \`YooP\`   8  \`YooP\` 8  8  8      ##
${c1}      xdco${c2}xOkdlo${c1}dldd       ${c4}##     :.....::.....::.....:::..::.....:..:..:..     ##
${c1}      ddc:cl${c2}lll${c1}oooodo      ${c4}##     :::::::::::::::::::::::::::::::::::::::::     ##
${c1}    odxxdd${c3}xkO000kx${c1}ooxdo    ${c4}##  .oPYo.                o                       8  ##
${c1}   oxdd${c3}x0NMMMMMMWW0od${c1}kkxo  ${c4}##  8    8                8                       8  ## 
${c1}  oooxd${c3}0WMMMMMMMMMW0o${c1}dxkx  ${c4}## o8YooP' oPYo. .oPYo.  o8P .oPYo. .oPYo. .oPYo. 8  ## 
${c1} docldkXW${c3}MMMMMMMWWN${c1}Odolco  ${c4}##  8      8  \`' 8    8   8  8    8 8    ' 8    8 8  ##
${c1} xx${c2}dx${c1}kxxOKN${c3}WMMWN${c1}0xdoxo::c  ${c4}##  8      8     8    8   8  8    8 8    . 8    8 8  ##
${c2} xOkkO${c1}0oo${c3}odOW${c2}WW${c1}XkdodOxc:l  ${c4}##  8      8     \`YooP\`   8  \`YooP\` \`YooP\` \`YooP\` 8  ##
${c2} dkkkxkkk${c3}OKX${c2}NNNX0Oxx${c1}xc:cd  ${c4}## :..:::::..:::::.....:::..::.....::.....::.....:.. ##
${c2}  odxxdx${c3}xllod${c2}ddooxx${c1}dc:ldo  ${c4}## ::::::::::::::::::::::::::::::::::::::::::::::::: ##
${c2}    lodd${c1}dolccc${c2}ccox${c1}xoloo    ${c4}#######################################################
${c1}                           
==================================================================================
${c4} "

echo -e "$linuxLogo"

echo -e " This should be the path to your home folder : $HOME \n If it is not, launch the file as the user that needs to have the protocol installed.\n"

mkdir -p $HOME/bin
cat > $HOME/bin/file-opener <<EOF
#!/bin/bash
FILE=\$1
FILE=\${FILE#*:}
xdg-open "\$FILE"
EOF
read -p " Custom protocol name : " protocolName
chmod u+x $HOME/bin/file-opener
mkdir -p $HOME/.local/share/applications/
cat > $HOME/.local/share/applications/${protocolName}-file-opener.desktop <<EOF
[Desktop Entry]
Name=file-opener
Comment=local URI scheme:
Exec=$HOME/bin/file-opener %u
Terminal=0
Type=Application
X-MultipleArgs=True
MimeType=x-scheme-handler/${protocolName}
Encoding=UTF-8
Categories=Application;
EOF

update-desktop-database $HOME/.local/share/applications/
xdg-mime default ${protocolName}-file-opener.desktop x-scheme-handler/${protocolName}
# By default added in : ~/.config/mimeapps.list

echo -e "\n=====================================  DONE  ====================================="
