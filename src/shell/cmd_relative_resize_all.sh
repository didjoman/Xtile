#!/bin/bash                                                                                                                                                          


# ========================================================================= #
#
# XTILE version 1.0
#
# This file is part of the code XTILE.
#
# Copyright (C) 2012, Alexandre RUPP
#
# contact: alexrupp@free.fr
#
# The code XTILE is free software; you can redistribute it
# and/or modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2 of
# the License, or (at your option) any later version.

# XTILE is distributed in the hope that it will be
# useful, but WITHOUT ANY WARRANTY; without even the implied warranty
# of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.


# You should have received a copy of the GNU General Public License
# along with XTILE; if not, write to the
# Free Software Foundation, Inc.,
# 51 Franklin St, Fifth Floor,
# Boston, MA  02110-1301  USA

# ========================================================================= #

# |======================================================================|
# | XTile                                                   06/2012      |
# |======================================================================|
# | Auteurs : A.RUPP                                                     |
# |======================================================================|
# | Nom :         do_clever_relative_resize_for_near_windows             |
# |                                                                      |
# | Description : Redimensionne la fenetre, en largeur OU en hauteur,    |
# |               soit par la droite, la gauche, le haut ou le bas.      |
# |               Et redimensionne les fenetres environnantes.           |
# |                                                                      |
# | Parametres :  1_ ID de la fenetre à redimensionner                   |
# |               2_ <width | height>                                    |
# |               3_ <+/-><int> (eg : +10)                               |
# |                                                                      |
# | Exemple :     do_cl...dow.sh 0x042010b3 width +10                    |
# |======================================================================|   


WAY=$(cd $(dirname $0); pwd)
[ -f $WAY/xtile_sh_lib.sh ] && . $WAY/xtile_sh_lib.sh || ( echo missing file $WAY/xtile_sh_lib.sh; exit 1 )

# librairies                                                                                                                                                              
#way="$HOME/bin/twm_powa_tools"
#getDimension="$way/get_real_dimension_for_window.sh"
#getPosition="$way/get_real_position_for_window.sh"
#getScreenDimension="$way/get_util_dimension_for_screen.sh"
#getNear="$way/get_windows_near_from.sh"

resize="$WAY/cmd_relative_resize.sh"


if [ $# -lt 3 ]; then
    exit 1
fi

resizeMainWindow(){
    $($resize $1 $2 $3 $4) # On resize notre fenetre    
}

modifyOnRight(){
# BUG !!!
    for i in $(get_windows_near_from $1 right); do	
	$($resize $i width left $2) &
	$($resize $i width left $2) &
    done
}

modifyOnLeft(){
    for i in $(get_windows_near_from $1 left); do
	$($resize $i width right $2) &	$($resize $i width right $2) &
    done
}

modifyOnTop(){
    for i in $(get_windows_near_from $1 top); do
	$($resize $i height bottom $2) & $($resize $i height bottom $2) &
    done
}

modifyOnBottom(){
    for i in $(get_windows_near_from $1 bottom); do
	$($resize $i height top $2) &	$($resize $i height top $2) &
    done
}

modifyOnRightOnly(){
    for i in $(get_windows_near_from $1 onlyRight); do
	$($resize $i $2 $3 $4) & 	$($resize $i $2 $3 $4) & 
    done
}

modifyOnLeftOnly(){
    for i in $(get_windows_near_from $1 onlyLeft); do
	$($resize $i $2 $3 $4) &		$($resize $i $2 $3 $4) &	
    done
}

modifyOnTopOnly(){
    for i in $(get_windows_near_from $1 onlyTop); do
	$($resize $i $2 $3 $4) &	$($resize $i $2 $3 $4) &
    done
}

modifyOnBottomOnly(){
    for i in $(get_windows_near_from $1 onlyBottom); do
	$($resize $i $2 $3 $4) &	$($resize $i $2 $3 $4) &
    done
}



size1=$(echo $3 | cut -c 2-)
size2=0

if [ "$2" = width ] ; then

    if [ `echo "$3" | cut -c1 2>/dev/null` = + ]; then
	# cas où la fenetre est proche d'une bordure, elle va être "poussée" vers le coté opposé, il faut donc modifier les autres fenetres des 2 cotés.
        if [ `expr $(get_util_dimension_for_screen width) - $(get_real_position_for_window $1 x) - $(get_real_dimension_for_window $1 width)` -lt $size1 ] ; then
	    size2=`expr $size1 - $(( $(get_util_dimension_for_screen width) - $(get_real_position_for_window $1 x) - $(get_real_dimension_for_window $1 width) ))`
	    size1=$(( $size1 - $size2 ))
        fi
	modifyOnRight $1 -$size1 &   
	if [ $size2 -ne 0 ]; then
	    modifyOnLeft $1 -$size2 &
	fi
	resizeMainWindow $1 $2 right $3 &

	modifyOnTopOnly $1 $2 right $3 &
	modifyOnBottomOnly $1 $2 right $3 &
	exit 0

    elif [ `echo "$3" | cut -c1 2>/dev/null` = - ]; then
	# [---|-] Condition pour savoir si l'on redimensionne par la gauche ou la droite. On évalue les espaces à gauche et droite de la fenetre.
        if [ `expr $(get_util_dimension_for_screen width) - $(get_real_position_for_window $1 x) - $(get_real_dimension_for_window $1 width)` -lt  $(get_real_position_for_window $1 x) ] ; then
	    modifyOnLeft $1 +$size1 &
	    modifyOnTopOnly $1 $2 left $3 &
	    modifyOnBottomOnly $1 $2 left $3 &
 	    resizeMainWindow $1 $2 left $3 &
	    exit 0
	else

	    modifyOnRight $1 +$size1 &
	    modifyOnTopOnly $1 $2 right $3 &

	    modifyOnBottomOnly $1 $2 right $3 &
	    resizeMainWindow $1 $2 right $3 &
	    # ici
	    exit 0
        fi
    fi
elif  [ "$2" = height ] ; then

    if [ `echo "$3" | cut -c1 2>/dev/null` = + ]; then
	# cas où la fenetre est proche d'une bordure, elle va être "poussée" vers le coté opposé, il faut donc modifier les autres fenetres des 2 cotés.
        if [ `expr $(get_util_dimension_for_screen height) - $(get_real_position_for_window $1 y) - $(get_real_dimension_for_window $1 height)` -lt $size1 ] ; then
	    size2=`expr $size1 - $(( $(get_util_dimension_for_screen height) - $(get_real_position_for_window $1 y) - $(get_real_dimension_for_window $1 height) ))`
	    size1=$(( $size1 - $size2 ))
        fi
	modifyOnBottom $1 -$size1 &
	if [ $size2 -ne 0 ]; then
	    modifyOnTop $1 -$size2 &
	fi

	modifyOnLeftOnly $1 $2 bottom $3 &
	modifyOnRightOnly $1 $2 bottom $3 &
	resizeMainWindow $1 $2 bottom $3 &
	exit 0 

    elif [ `echo "$3" | cut -c1 2>/dev/null` = - ]; then

        if [ `expr $(get_util_dimension_for_screen height) - $(get_real_position_for_window $1 y) - $(get_real_dimension_for_window $1 height)` -lt  $(get_real_position_for_window $1 y) ] ; then
	    modifyOnTop $1 +$size1 &
	    modifyOnLeftOnly $1 $2 top $3 &
	    modifyOnRightOnly $1 $2 top $3 &
	    resizeMainWindow $1 $2 top $3 &
	    exit 0
	else
	    modifyOnBottom $1 +$size1	   & 
	    modifyOnLeftOnly $1 $2 bottom $3 &
	    modifyOnRightOnly $1 $2 bottom $3 &
	    resizeMainWindow $1 $2 bottom $3 &
	    exit 0
        fi
    fi
fi

exit 1
