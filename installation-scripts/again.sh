#!/bin/bash
#set -e
##################################################################################################################
# Author	:	Erik Dubois
# Website	:	https://www.erikdubois.online
# Website	:	https://www.arcolinux.info
# Website	:	https://www.arcolinux.com
# Website	:	https://www.arcolinuxd.com
# Website	:	https://www.arcolinuxb.com
# Website	:	https://www.arcolinuxiso.com
# Website	:	https://www.arcolinuxforum.com
# Website	:	https://www.alci.online
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################
echo
echo "################################################################## "
tput setaf 2
echo "Phase 1 : "
echo "- Setting General parameters"
tput sgr0
echo "################################################################## "
echo

	
	# setting of the general parameters
	archisoRequiredVersion="archiso 72-1"
	buildFolder=$HOME"/XFCE-build"
	outFolder=$HOME"/XFCE-iso"
	archisoVersion=$(sudo pacman -Q archiso)

	echo "################################################################## "
	#echo "Building the desktop                   : "$desktop
	#echo "Building version                       : "$arcolinuxVersion
	#echo "Iso label                              : "$isoLabel
	echo "Do you have the right archiso version? : "$archisoVersion
	echo "What is the required archiso version?  : "$archisoRequiredVersion
	echo "Build folder                           : "$buildFolder
	echo "Out folder                             : "$outFolder
	echo "################################################################## "

	if [ "$archisoVersion" == "$archisoRequiredVersion" ]; then
		tput setaf 2
		echo "##################################################################"
		echo "Archiso has the correct version. Continuing ..."
		echo "##################################################################"
		tput sgr0
	else
	tput setaf 1
	echo "###################################################################################################"
	echo "You need to install the correct version of Archiso"
	echo "Use 'sudo downgrade archiso' to do that"
	echo "or update your system"
	echo "If a new archiso package comes in and you want to test if you can still build"
	echo "the iso then change the version in line 37."
	echo "###################################################################################################"
	tput sgr0
	fi

echo
echo "################################################################## "
tput setaf 2
echo "Phase 2 :"
echo "- Checking if archiso is installed"
echo "- Saving current archiso version to archiso.md"
echo "- Making mkarchiso verbose"
tput sgr0
echo "################################################################## "
echo

	package="archiso"

	#----------------------------------------------------------------------------------

	#checking if application is already installed or else install with aur helpers
	if pacman -Qi $package &> /dev/null; then

			echo "Archiso is already installed"

	else

		#checking which helper is installed
		if pacman -Qi yay &> /dev/null; then

			echo "################################################################"
			echo "######### Installing with yay"
			echo "################################################################"
			yay -S --noconfirm $package

		elif pacman -Qi trizen &> /dev/null; then

			echo "################################################################"
			echo "######### Installing with trizen"
			echo "################################################################"
			trizen -S --noconfirm --needed --noedit $package

		fi

		# Just checking if installation was successful
		if pacman -Qi $package &> /dev/null; then

			echo "################################################################"
			echo "#########  "$package" has been installed"
			echo "################################################################"

		else

			echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
			echo "!!!!!!!!!  "$package" has NOT been installed"
			echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
			exit 1
		fi

	fi

	echo
	echo "Saving current archiso version to archiso.md"
	sudo sed -i "s/\(^archiso-version=\).*/\1$archisoVersion/" ../archiso.md
	echo
	echo "Making mkarchiso verbose"
	sudo sed -i 's/quiet="y"/quiet="n"/g' /usr/bin/mkarchiso

echo
echo "################################################################## "
tput setaf 2
echo "Phase 3 :"
echo "- Deleting the build folder if one exists"
echo "- Copying the Archiso folder to build folder"
tput sgr0
echo "################################################################## "
echo

	echo "Deleting the build folder if one exists - takes some time"
	[ -d $buildFolder ] && sudo rm -rf $buildFolder
	echo
	echo "Copying the Archiso folder to build work"
	echo
	mkdir $buildFolder
	cp -r ../archiso $buildFolder/archiso

# echo
# echo "################################################################## "
# tput setaf 2
# echo "Phase 4 :"
# echo "- Deleting any files in /etc/skel"
# echo "- Getting the last version of bashrc in /etc/skel"
# echo "- Removing the old packages.x86_64 file from build folder"
# echo "- Copying the new packages.x86_64 file to the build folder"
# echo "- Changing group for polkit folder"
# tput sgr0
# echo "################################################################## "
# echo

#	echo "Deleting any files in /etc/skel"
#	rm -rf $buildFolder/archiso/airootfs/etc/skel/.* 2> /dev/null
#	echo

#	echo "Getting the last version of bashrc in /etc/skel"
#	echo
#	wget https://raw.githubusercontent.com/arcolinux/arcolinux-root/master/etc/skel/.bashrc-latest -O $buildFolder/archiso/airootfs/etc/skel/.bashrc

#	echo "Removing the old packages.x86_64 file from build folder"
#	rm $buildFolder/archiso/packages.x86_64
#	echo
#	echo "Copying the new packages.x86_64 file to the build folder"
#	cp -f ../archiso/packages.x86_64 $buildFolder/archiso/packages.x86_64
#	echo
#	echo "Changing group for polkit folder"
#	sudo chgrp polkitd $buildFolder/archiso/airootfs/etc/polkit-1/rules.d
#	#is not working so fixing this during calamares installation

# echo
# echo "################################################################## "
# tput setaf 2
# echo "Phase 5 : "
# echo "- Changing all references"
# echo "- Adding time to /etc/dev-rel"
# tput sgr0
# echo "################################################################## "
# echo
#
# 	#Setting variables
#
# 	#profiledef.sh
# 	oldname1='iso_name=arcolinux'
# 	newname1='iso_name=arcolinux'
#
# 	oldname2='iso_label="arcolinux'
# 	newname2='iso_label="arcolinux'
#
# 	oldname3='ArcoLinux'
# 	newname3='ArcoLinux'
#
# 	#hostname
# 	oldname4='ArcoLinux'
# 	newname4='ArcoLinux'
#
# 	#lightdm.conf user-session
# 	oldname5='user-session=xfce'
# 	newname5='user-session='$lightdmDesktop
#
# 	#lightdm.conf autologin-session
# 	oldname6='#autologin-session='
# 	newname6='autologin-session='$lightdmDesktop
#
# 	echo "Changing all references"
# 	echo
# 	sed -i 's/'$oldname1'/'$newname1'/g' $buildFolder/archiso/profiledef.sh
# 	sed -i 's/'$oldname2'/'$newname2'/g' $buildFolder/archiso/profiledef.sh
# 	sed -i 's/'$oldname3'/'$newname3'/g' $buildFolder/archiso/airootfs/etc/dev-rel
# 	sed -i 's/'$oldname4'/'$newname4'/g' $buildFolder/archiso/airootfs/etc/hostname
# 	sed -i 's/'$oldname5'/'$newname5'/g' $buildFolder/archiso/airootfs/etc/lightdm/lightdm.conf
# 	sed -i 's/'$oldname6'/'$newname6'/g' $buildFolder/archiso/airootfs/etc/lightdm/lightdm.conf
#
# 	echo "Adding time to /etc/dev-rel"
# 	date_build=$(date -d now)
# 	echo "Iso build on : "$date_build
# 	sudo sed -i "s/\(^ISO_BUILD=\).*/\1$date_build/" $buildFolder/archiso/airootfs/etc/dev-rel


#echo
#echo "################################################################## "
#tput setaf 2
#echo "Phase 6 :"
#echo "- Cleaning the cache from /var/cache/pacman/pkg/"
#tput sgr0
#echo "################################################################## "
#echo

	#echo "Cleaning the cache from /var/cache/pacman/pkg/"
	#yes | sudo pacman -Scc

echo
echo "################################################################## "
tput setaf 2
echo "Phase 7 :"
echo "- Building the iso - this can take a while - be patient"
tput sgr0
echo "################################################################## "
echo

	[ -d $outFolder ] || mkdir $outFolder
	cd $buildFolder/archiso/
	sudo mkarchiso -v -w $buildFolder -o $outFolder $buildFolder/archiso/



# echo
# echo "###################################################################"
# tput setaf 2
# echo "Phase 8 :"
# echo "- Creating checksums"
# echo "- Copying pgklist"
# tput sgr0
# echo "###################################################################"
# echo
#
# 	cd $outFolder
#
# 	echo "Creating checksums for : "$isoLabel
# 	echo "##################################################################"
# 	echo
# 	echo "Building sha1sum"
# 	echo "########################"
# 	sha1sum $isoLabel | tee $isoLabel.sha1
# 	echo "Building sha256sum"
# 	echo "########################"
# 	sha256sum $isoLabel | tee $isoLabel.sha256
# 	echo "Building md5sum"
# 	echo "########################"
# 	md5sum $isoLabel | tee $isoLabel.md5
# 	echo
 	echo "Moving pkglist.x86_64.txt"
 	echo "########################"
	rename=$(date +%Y-%m-%d)
 	cp $buildFolder/iso/arch/pkglist.x86_64.txt  $outFolder/archlinux-$rename-pkglist.txt



echo
echo "##################################################################"
tput setaf 2
echo "DONE"
echo "- Check your out folder :"$outFolder
tput sgr0
echo "################################################################## "
echo
echo
echo "##################################################################"
tput setaf 2
echo "Phase 9 :"
echo "- Making sure we start with a clean slate next time"
tput sgr0
echo "################################################################## "
echo

	echo "Deleting the build folder if one exists - takes some time"
	[ -d $buildFolder ] && sudo rm -rf $buildFolder
