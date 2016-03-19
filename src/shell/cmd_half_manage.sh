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
# | Nom :         resize_half                                            |
# |                                                                      |
# | Description : Redimensionne et place la fenetre dans une demi partie |
# |               de l'écran (moitié haute, basse, de droite, de gauche) |
# |               ou en plein écran.                                     |
# |                                                                      |
# | Parametres :  1_ ID de la fenetre à redimensionner                   |
# |               2_ <top | bottom | left | right | full>                |
# |                                                                      |
# | Exemple :     cmd_.........sh 0x042010b3 top                         |
# |======================================================================|

WAY=$(cd $(dirname $0); pwd)

[ -f $WAY/xtile_sh_lib.sh ] && . $WAY/xtile_sh_lib.sh || ( echo missing file $WAY/xtile_sh_lib.sh; exit 1 )

# librairies     

#way="$HOME/bin/twm_powa_tools"
#getBorder="$way/get_border_for_screen.sh"
#getPosition="$way/get_real_position_for_window.sh"
#getDimension="$way/get_util_dimension_for_screen.sh"
#move="$way/do_move_in_real_space.sh"
#resize="$way/do_resize_with_real_dimension.sh"

if [ $# -lt 2 ]; then
    exit 1
fi

if [ "$2" = top ] ; then
    $(do_move_and_resize $1 0 0 $(get_util_dimension_for_screen width) $(( $(get_util_dimension_for_screen height) / 2)))&
    sleep 0.01
    $(do_move_and_resize $1 0 0 $(get_util_dimension_for_screen width) $(( $(get_util_dimension_for_screen height) / 2)))&
    exit 0
elif  [ "$2" = bottom ] ; then
    $(do_move_and_resize $1 0 $(( $(get_util_dimension_for_screen height) / 2)) $(get_util_dimension_for_screen width) $(( $(get_util_dimension_for_screen height) / 2)) )&
    sleep 0.01
    $(do_move_and_resize $1 0 $(( $(get_util_dimension_for_screen height) / 2)) $(get_util_dimension_for_screen width) $(( $(get_util_dimension_for_screen height) / 2)) )&
    exit 0
elif  [ "$2" = left ] ; then
    $(do_move_and_resize $1 0 0 $(( $(get_util_dimension_for_screen width) / 2)) $(get_util_dimension_for_screen height) )&
    sleep 0.03
    $(do_move_and_resize $1 0 0 $(( $(get_util_dimension_for_screen width) / 2)) $(get_util_dimension_for_screen height) )&
    exit 0
elif  [ "$2" = right ] ; then
    $(do_move_and_resize $1 $(( $(get_util_dimension_for_screen width) / 2 )) 0 $(( $(get_util_dimension_for_screen width) / 2)) $(get_util_dimension_for_screen height) )&
    sleep 0.03
    $(do_move_and_resize $1 $(( $(get_util_dimension_for_screen width) / 2 )) 0 $(( $(get_util_dimension_for_screen width) / 2)) $(get_util_dimension_for_screen height) )&
    exit 0
elif  [ "$2" = full ] ; then
    $(do_move_and_resize $1 0 0 $(get_util_dimension_for_screen width) $(get_util_dimension_for_screen height))&
    sleep 0.01
    $(do_move_and_resize $1 0 0 $(get_util_dimension_for_screen width) $(get_util_dimension_for_screen height))&
    exit 0
fi

exit 1

