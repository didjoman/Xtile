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
# | XTile                                                   06/2012   |
# |======================================================================|
# | Auteurs : A.RUPP                                                     |
# |======================================================================|
# | Nom :         do_clever_relative_resize                              |
# |                                                                      |
# | Description : Redimensionne la fenetre, en largeur OU en hauteur,    |
# |               soit par la droite, la gauche, le haut ou le bas.      |
# |                                                                      |
# | Parametres :  1_ ID de la fenetre à redimensionner                   |
# |               2_ <width | height>                                    |
# |               3_ <top | bottom | left | right>                       |
# |               4_ <+/-><int> (eg : +10)                               |
# |                                                                      |
# | Exemple :     do_cl...dow.sh 0x042010b3 width right +10              |
# |               do_cl...dow.sh 0x042010b3 both +10 -20                 |                                                       |
# |======================================================================|     

# ATTENTION: : LES CMD_move et resize sont effectuées en double, en parallèle afin d'améliorer les résultats.                                              


WAY=$(cd $(dirname $0); pwd)

[ -f $WAY/xtile_sh_lib.sh ] && . $WAY/xtile_sh_lib.sh || ( echo missing file $WAY/xtile_sh_lib.sh; exit 1 )
if [ -f xtile_c_lib.o ] ; then
    cmd="$WAY/xtile_c_lib.o"
else
    exit 1
fi

# librairies                                                                                                                                                              
#way="$HOME/bin/twm_powa_tools"
#getDimension="$way/get_dimension_for_window.sh"
#getRealDimension="$way/get_real_dimension_for_window.sh"
#getPosition="$way/get_real_position_for_window.sh"
#getScreenDimension="$way/get_util_dimension_for_screen.sh"
cmd_relative_move="$WAY/cmd_relative_move.sh"

if [ $# -lt 4 ]; then
    exit 1
fi

sizeToAdd=$(echo $4 | cut -c 2-)
sizeToMove=$(echo $4 | cut -c 2-)

if [ "$2" = width ] ; then
    if [ `echo "$4" | cut -c1 2>/dev/null` = + ]; then
	if [ "$3" = left ] ; then # si on veut redimentionner par la gauche il est nécessaire de déplacer la fenetre vers la droite.
	    if [ $(( $(get_util_dimension_for_screen width) - $(get_real_position_for_window $1 x) - $(get_dimension_for_window $1 width) )) -lt $sizeToMove ] ; then
		sizeToMove=$(( $(get_util_dimension_for_screen width) - $(get_real_position_for_window $1 x) - $(get_dimension_for_window $1 width) ))
	    fi
	    if [ $sizeToMove -lt 0 ] ; then
		sizeToMove=$(( -$sizeToMove )) # correctif de bug
	    fi
	    $($cmd_relative_move $1 x -$sizeToMove) &	    $($cmd_relative_move $1 x -$sizeToMove) &
	fi
	$($cmd resize $1 $(( $(get_real_dimension_for_window $1 width) + $sizeToAdd )) $(get_dimension_for_window $1 height))&	    $($cmd resize $1 $(( $(get_real_dimension_for_window $1 width) + $sizeToAdd )) $(get_dimension_for_window $1 height))&
	exit 0
    elif [ `echo "$4" | cut -c1 2>/dev/null` = - ]; then
	$($cmd resize $1 $(( $(get_real_dimension_for_window $1 width) - $sizeToAdd )) $(get_dimension_for_window $1 height)) & 	$($cmd resize $1 $(( $(get_real_dimension_for_window $1 width) - $sizeToAdd )) $(get_dimension_for_window $1 height)) & 
	if [ "$3" = left ] ; then
	    $($cmd_relative_move $1 x +$sizeToAdd) &	    $($cmd_relative_move $1 x +$sizeToAdd) &
	fi
	exit 0
    fi
elif  [ "$2" = height ] ; then
    if [ `echo "$4" | cut -c1 2>/dev/null` = + ]; then
	if [ "$3" = top ] ; then # on augmente la fenetre par le bas, donc on doit la pousser vers le haut pour donner l'impression que la position n'a pas bougé par rapport au bas. Attention, si on augmente et que la fenetre dépasse de l'écran elle est automatiquement déplacée vers le haut (d'où le second if), car on doit décompter la margin qui est fait automatiquement. 
	    if [ $(( $(get_util_dimension_for_screen height) - $(get_real_position_for_window $1 y) - $(get_dimension_for_window $1 height) )) -lt $sizeToMove ] ; then
		sizeToMove=$(( $(get_util_dimension_for_screen height) - $(get_real_position_for_window $1 y) - $(get_dimension_for_window $1 height) ))
	    fi

	    if [ $sizeToMove -lt 0 ] ; then
		sizeToMove=$(( -$sizeToMove )) # correctif de bug
	    fi
	    
	    $($cmd_relative_move $1 y -$sizeToMove) & 	    $($cmd_relative_move $1 y -$sizeToMove) & 
	fi
	$($cmd resize $1 $(get_real_dimension_for_window $1 width) $(( $(get_dimension_for_window $1 height) + $sizeToAdd)) )
	exit 0
    elif [ `echo "$4" | cut -c1 2>/dev/null` = - ]; then
	$($cmd resize $1 $(get_real_dimension_for_window $1 width) $(( $(get_dimension_for_window $1 height) - $sizeToAdd)) ) &	$($cmd resize $1 $(get_real_dimension_for_window $1 width) $(( $(get_dimension_for_window $1 height) - $sizeToAdd)) ) &
	if [ "$3" = top ] ; then 
	    $($cmd_relative_move $1 y +$sizeToAdd) & 	    $($cmd_relative_move $1 y +$sizeToAdd) & 
	fi
	exit 0	
    fi
elif [ "$2" = both ] ; then
    if [ `echo "$3" | cut -c1 2>/dev/null` = + ] && [ `echo "$4" | cut -c1 2>/dev/null` = + ]; then
	$($cmd resize $1 $(( $(get_real_dimension_for_window $1 width) + $3 )) $(( $(get_dimension_for_window $1 height) + $4)) ) & 	$($cmd resize $1 $(( $(get_real_dimension_for_window $1 width) + $3 )) $(( $(get_dimension_for_window $1 height) + $4)) ) & 
	exit 0
    elif [ `echo "$4" | cut -c1 2>/dev/null` = - ] && [ `echo "$4" | cut -c1 2>/dev/null` = - ]; then
	$($cmd resize $1 $(( $(get_real_dimension_for_window $1 width) - $3 )) $(( $(get_dimension_for_window $1 height) - $4)) ) & 	$($cmd resize $1 $(( $(get_real_dimension_for_window $1 width) - $3 )) $(( $(get_dimension_for_window $1 height) - $4)) ) & 
	exit 0
    elif [ `echo "$3" | cut -c1 2>/dev/null` = + ] && [ `echo "$4" | cut -c1 2>/dev/null` = - ]; then
	$($cmd resize $1 $(( $(get_real_dimension_for_window $1 width) + $3 )) $(( $(get_dimension_for_window $1 height) - $4)) ) & 	$($cmd resize $1 $(( $(get_real_dimension_for_window $1 width) + $3 )) $(( $(get_dimension_for_window $1 height) - $4)) ) & 
	exit 0
    elif [ `echo "$4" | cut -c1 2>/dev/null` = - ] && [ `echo "$4" | cut -c1 2>/dev/null` = + ]; then
	$($cmd resize $1 $(( $(get_real_dimension_for_window $1 width) - $3 )) $(( $(get_dimension_for_window $1 height) + $4)) ) & 	$($cmd resize $1 $(( $(get_real_dimension_for_window $1 width) - $3 )) $(( $(get_dimension_for_window $1 height) + $4)) ) & 
	exit 0	
    fi
fi
    
    exit 1
