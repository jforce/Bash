#! /bin/bash
#
# Wii Cover Downloader bash script
# written by spookykid buyapentiumjerk@gmail.com
#

# Edit these values to match your preferences
# -------------------------------------------

COVER_LANGUAGE=('PT' 'ES' 'EN' 'US' 'FR' 'DE' 'JA')
BASE_DIRECTORY="./"
NORMAL_COVER_DIRECTORY=$BASE_DIRECTORY"images/"
DISK_COVER_DIRECTORY=$NORMAL_COVER_DIRECTORY"disk/"
COVER_KIND="cover3D" #cover; coverfull; coverfullHQ; disc; disccustom; cover3D

# DO NOT EDIT AFTER HERE
# ----------------------

VERSION="20100722"
WHITE='\E[1;29m'
DARK='\E[1;30m'
RED='\E[1;31m'
GREEN='\E[1;32m'
YELLOW='\E[1;33m'
BLUE='\E[1;34m'
MAGENTA='\E[1;35m'
CYAN='\E[1;36m'
NC='\e[0m'
GAME_LIST_FILE="GAME_LIST.TXT"
COUNTER_PROCESSED=0
COUNTER_DOWNLOADED_COVERS=0
COUNTER_NO_NEED_COVERS=0
ELEMENTS=${#COVER_LANGUAGE[@]}

echo
echo -e "${YELLOW}>>>${NC} ${WHITE}Wii Cover Downloader, version $VERSION${NC}"
echo -e "${DARK}    A simple cover donwloader for the webless Wii${NC}"
echo
echo -ne "   ${YELLOW}*${NC} Downloading titles database file... ${NC}"
if `wget -q -c -nd -P "$BASE_DIRECTORY" --output-document=TITLES_DB.TXT "http://wiitdb.com/titles.txt?LANG=EN"`
then
    echo -e "${GREEN}DONE${NC}"
else
    echo -e "${RED}ERROR: Couldn't download titles database file${NC}"
    echo
    exit 0
fi
echo -ne "   ${YELLOW}*${NC} Creating titles list file... "
echo -ne ${RED}
if `ls /media/C4E5-C0A8/wbfs | awk '{print $NF'} | sed 's/\[//' | sed 's/\]//' > $GAME_LIST_FILE`
then
    echo -e "${GREEN}DONE${NC}"
else
    echo
    exit 0
fi
echo -ne ${NC}
COUNTER_TOTAL_GAMES=`wc -l "$GAME_LIST_FILE"`
echo
echo -e "${BLUE}  /// [ INFORMATION ] ///${NC}"
echo
echo -e "  ${RED}Title(s) to process:${NC} $COUNTER_TOTAL_GAMES"
echo -ne "  ${RED}Language(s) order: ${NC}"
for ((z=0;z<$ELEMENTS;z++)); do
echo -ne "[`expr $z + 1`]-${COVER_LANGUAGE[z]} "
done
echo
echo
echo -e "${BLUE}  /// [ PROCESS OUTPUT ] ///${NC}"
echo
while read LINE; do
    COUNTER_PROCESSED=`expr $COUNTER_PROCESSED + 1`
    GAME_ID=$LINE
    echo -e "${YELLOW}  *${NC}${WHITE} PROCESSING ${NC}${CYAN}($COUNTER_PROCESSED out of $COUNTER_TOTAL_GAMES)${NC}${WHITE} - ID/NAME: ${NC}${BLUE}`cat TITLES_DB.TXT | grep $GAME_ID`${NC}"
    if [ -f $NORMAL_COVER_DIRECTORY$GAME_ID.png ]
    then
        echo -e "    ${MAGENTA}WARNING:${NC} Found a local cover file [ $GAME_ID.png ], skipping"
        COUNTER_NO_NEED_COVERS=`expr $COUNTER_NO_NEED_COVERS + 1`
    else
        echo -e "    ${YELLOW}WARNING:${NC} Local cover file not found, searching for online file"
        for ((i=0;i<$ELEMENTS;i++)); do
        if [ -f $NORMAL_COVER_DIRECTORY$GAME_ID.png ]
        then
            echo -ne
        else
            echo -ne "    ${YELLOW}>${NC} Searching language: ${WHITE}${COVER_LANGUAGE[i]}${NC}... "
           if `wget -q -c -nd -P "$NORMAL_COVER_DIRECTORY" http://wiitdb.com/wiitdb/artwork/$COVER_KIND/${COVER_LANGUAGE[i]}/$GAME_ID.png`
            then
                echo -e "${GREEN}Found${NC}"
                COUNTER_DOWNLOADED_COVERS=`expr $COUNTER_DOWNLOADED_COVERS + 1`
            else
                echo -e "${RED}Not found${NC}"
            fi
        fi
        done
    fi
    echo
    done < $GAME_LIST_FILE
echo -e "${BLUE}  /// [ POST PROCESSING ] ///${NC}"
echo
echo -ne "  ${YELLOW}*${NC} Removing files... "
if [ -f $GAME_LIST_FILE ]
then
    rm $GAME_LIST_FILE
fi
if [ -f TITLES_DB.TXT ]
then
    rm TITLES_DB.TXT
fi
echo -e "${GREEN}DONE${NC}"
echo
echo -e "${BLUE}  /// [ TOTALS ] ///${NC}"
echo
echo -e "  ${RED}Titles with covers:${NC} ${WHITE}`expr $COUNTER_NO_NEED_COVERS + $COUNTER_DOWNLOADED_COVERS`${NC}"
echo -e "  ${RED}Downloaded covers:${NC} ${WHITE}$COUNTER_DOWNLOADED_COVERS${NC}"
echo -e "  ${RED}Covers missing:${NC} ${WHITE}`expr $COUNTER_TOTAL_GAMES - $COUNTER_NO_NEED_COVERS - $COUNTER_DOWNLOADED_COVERS`${NC}"
echo

exit 0
