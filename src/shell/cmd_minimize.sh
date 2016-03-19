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
# | Nom :         do_minimize                                            |
# |                                                                      |
# | Description : Minimise la fenetre si elle est affichée, ou restaure  |
# |               la fenetre si elle est déja minimisée.                 |
# |                                                                      |
# | Parametres :  1_ ID de la fenetre à minimiser                        |
# |                                                                      |
# | Exemple :     do_.....sh 0x042010b3                                  |
# |======================================================================|  

WAY=$(cd $(dirname $0); pwd)
[ -f $WAY/xtile_sh_lib.sh ] && . $WAY/xtile_sh_lib.sh || ( echo missing file $WAY/xtile_sh_lib.sh; exit 1 )

if [ -f xtile_c_lib.o ] ; then
    cmd="$WAY/xtile_c_lib.o"
else
    exit 1
fi

if [ $# -eq 0 ]; then
    $cmd minimize $(get_active_window) &
    exit 0
fi

if  [ "$(xprop -id $1 | sed -n "s/_NET_WM_STATE(ATOM) = \(.*\)/\1/p")" != _NET_WM_STATE_HIDDEN ] ;then
    $cmd minimize $1 &
else
    $cmd map $1 & 
    $cmd focus $1 &
fi

exit 0
