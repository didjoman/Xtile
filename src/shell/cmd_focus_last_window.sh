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
# | Xtile                                                   06/2012      |
# |======================================================================|
# | Auteurs : A.RUPP                                                     |
# |======================================================================|
# | Nom :         focus_last_window.sh                                   |
# |                                                                      |
# | Description : Place le focus sur la précédente fenêtre de l'espace de| 
# |               travail                                                |
# |                                                                      |
# | Parametres :  1_ ID de la fenetre actuelle (optionnel)               |
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
    lastWindow=$(get_last_window_on_workspace $(get_active_window))
    $cmd focus $lastWindow &
    $cmd raise $lastWindow &
    exit 0
else
    lastWindow=$(get_last_window_on_workspace $1)
    $cmd focus $lastWindow &
    $cmd raise $lastWindow &   
fi

exit 0
