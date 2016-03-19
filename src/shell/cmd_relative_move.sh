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
# | Nom :         do_relative_move                                       |
# |                                                                      |
# | Description : Déplace la fenetre, en largeur OU en hauteur,          |
# |               vers la droite, la gauche, le haut ou le bas.          |
# |               Le déplacement est relatif à la position actuelle de   |
# |               la fenêtre.                                            |
# |                                                                      |
# | Parametres :  1_ ID de la fenetre à déplacer                         |
# |               2_ <x | y>                                             |
# |               3_ <+/-><int> (eg : +10)                               |
# |                                                                      |
# | Exemple :     do_......sh 0x042010b3 x +10                           |
# |======================================================================| 

WAY=$(cd $(dirname $0); pwd)

[ -f $WAY/xtile_sh_lib.sh ] && . $WAY/xtile_sh_lib.sh || ( echo missing file $WAY/xtile_sh_lib.sh; exit 1 )
if [ -f xtile_c_lib.o ] ; then
    cmd="$WAY/xtile_c_lib.o"
else
    exit 1
fi

# librairies                                                                                                                                                          
#way="$HOME/bin/twm_powa_tools"
#getPosition="$way/get_real_position_for_window.sh"


if [ $# -lt 3 ]; then
    exit 1
fi

if [ "$2" = x ] ; then
    if [ `echo "$3" | cut -c1 2>/dev/null` = + ]; then
	$cmd move $1 $(( $(get_real_position_for_window  $1 x) + $(echo $3 | cut -c 2-) )) $(get_real_position_for_window  $1 y)
	exit 0
    elif [ `echo "$3" | cut -c1 2>/dev/null` = - ]; then
	$cmd move $1 $(( $(get_real_position_for_window  $1 x) - $(echo $3 | cut -c 2-) )) $(get_real_position_for_window  $1 y)
	exit 0
    fi
elif  [ "$2" = y ] ; then
    if [ `echo "$3" | cut -c1 2>/dev/null` = + ]; then
	$cmd move $1 $(get_real_position_for_window  $1 x) $(( $(get_real_position_for_window  $1 y) + $(echo $3 | cut -c 2-) ))
	exit 0
    elif [ `echo "$3" | cut -c1 2>/dev/null` = - ]; then
	$cmd move $1 $(get_real_position_for_window  $1 x) $(( $(get_real_position_for_window  $1 y) - $(echo $3 | cut -c 2-) ))
	exit 0	
    fi
elif  [ $# = 4 ] && [ "$2" = both ] ; then
    if [ `echo "$3" | cut -c1 2>/dev/null` = + ] && [ `echo "$4" | cut -c1 2>/dev/null` = + ]; then
	$cmd move $1 $(( $(get_real_position_for_window  $1 x) + $(echo $3 | cut -c 2-) )) $(( $(get_real_position_for_window  $1 y) + $(echo $4 | cut -c 2-) ))
	exit 0
    elif [ `echo "$3" | cut -c1 2>/dev/null` = - ] && [ `echo "$4" | cut -c1 2>/dev/null` = - ]; then
	$cmd move $1 $(( $(get_real_position_for_window  $1 x) - $(echo $3 | cut -c 2-) )) $(( $(get_real_position_for_window  $1 y) - $(echo $4 | cut -c 2-) ))
	exit 0	
    elif [ `echo "$3" | cut -c1 2>/dev/null` = + ] && [ `echo "$4" | cut -c1 2>/dev/null` = - ]; then
	$cmd move $1 $(( $(get_real_position_for_window  $1 x) + $(echo $3 | cut -c 2-) )) $(( $(get_real_position_for_window  $1 y) - $(echo $4 | cut -c 2-) ))
	exit 0
    elif [ `echo "$3" | cut -c1 2>/dev/null` = - ] && [ `echo "$4" | cut -c1 2>/dev/null` = + ]; then
	$cmd move $1 $(( $(get_real_position_for_window  $1 x) - $(echo $3 | cut -c 2-) )) $(( $(get_real_position_for_window  $1 y) + $(echo $4 | cut -c 2-) ))
	exit 0	
    fi
fi

exit 1
