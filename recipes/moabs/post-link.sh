#!/bin/bash

env >> "$PREFIX/.messages.txt"
which wget sha256sum shasum >> "$PREFIX/.messages.txt"

f=$PREFIX/bin/lut_fet.dat
url='https://ndownloader.figshare.com/files/16527371?private_link=44c546b05dd9fa0aee3d'
sha256=2f9099e79d6a23764b51220362634acd7412a025464001717ae58acca24a8eb3

echo Start: wget -q -O "$f" "$url" >> "$PREFIX/.messages.txt"
wget -q -O "$f" "$url"
echo Success: wget -q -O "$f" "$url" >> "$PREFIX/.messages.txt"

if [ -f "$f" ]
then
	sha256sum "$f" >> "$PREFIX/.messages.txt"
fi

SUCCESS=0
if [[ $(uname -s) == "Linux" ]]; then
	sha256sum "$f" >> "$PREFIX/.messages.txt"
	sha256sum --quiet -c <<< "$sha256  $f"
	if (($?==0))
	then
		SUCCESS=1
	fi
else if [[ $(uname -s) == "Darwin" ]]; then
	shasum -a 256 "$f" >> "$PREFIX/.messages.txt"
	if [[ $(shasum -a 256 "$f" | awk '{ print $1 }') == "$sha256" ]]; then
		SUCCESS=1
	fi
fi

if [[ $SUCCESS != 1 ]]; then
	echo "ERROR: post-link.sh was unable to download $f with the sha256 $sha256 from $url." >> "$PREFIX/.messages.txt"
	exit -1
fi


# function cmd {
# local f=$PREFIX/bin/$1
# local url=$2
# local sha256=$3
# 
# echo "$PREFIX" >> "$PREFIX/.messages.txt"
# echo wget -q -O "$f" "$url" >> "$PREFIX/.messages.txt"
# # wget -q -O "$f" "$url"
# if [ -f "$f" ]
# then
# 	SUCCESS=0
# 	if [[ $(uname -s) == "Linux" ]]; then
# 		which sha256sum >> "$PREFIX/.messages.txt"
# 		sha256sum "$f" >> "$PREFIX/.messages.txt"
# 		sha256sum --quiet -c <<< "$sha256  $f"
# 		if (($?==0))
# 		then
# 			SUCCESS=1
# 		fi
# 	else if [[ $(uname -s) == "Darwin" ]]; then
# 		which shasum >> "$PREFIX/.messages.txt"
# 		shasum -a 256 "$f" >> "$PREFIX/.messages.txt"
# 		if [[ $(shasum -a 256 $f | awk '{ print $1 }') == "$sha256" ]]; then
# 			SUCCESS=1
# 		fi
# 	fi
# 
# 	if [[ $SUCCESS != 1 ]]; then
# 		echo "ERROR: post-link.sh was unable to download $f with the sha256 $sha256 from $url." >> "$PREFIX/.messages.txt"
# 		exit -1
# 	fi
# fi
# }
# 
# cmd lut_fet.dat 'https://ndownloader.figshare.com/files/16527371?private_link=44c546b05dd9fa0aee3d' 2f9099e79d6a23764b51220362634acd7412a025464001717ae58acca24a8eb3
# cmd lut_pdiffCI.dat 'https://ndownloader.figshare.com/files/16527389?private_link=44c546b05dd9fa0aee3d' 98cd92911c9a73267129cb010b1186db7cd248267b58614cc836f78db331902f
# cmd lut_pdiffInRegion.dat 'https://ndownloader.figshare.com/files/16527443?private_link=44c546b05dd9fa0aee3d' 6410f059842c11dc62e9452f36f6869edda25d44afc2bd51f9b495c4c3c128e4
# 
