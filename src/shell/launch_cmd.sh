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
# | Nom :         launch_cmd                                             |
# |                                                                      |
# | Description : Lance les différentes commandes de xtile, en y ajoutant|
# |               l'ID de la fenetre courrante ou de l'espace de      .  |
# |               travail courrant.                                      |
# |                                                                      |
# | Exemple :     xtile_c_lib.c move 0x42010b3 10 10                     |
# |======================================================================|

WAY=$(cd $(dirname $0); pwd)

[ -f $WAY/xtile_sh_lib.sh ] && . $WAY/xtile_sh_lib.sh || ( echo missing file $WAY/xtile_sh_lib.sh; exit 1 )
if [ -f xtile_c_lib.o ] ; then
    cmd="$WAY/xtile_c_lib.o"
else
    exit 1
fi


if [ $# -lt 1 ]; then
    exit 1
fi


if [ $1 = cmd_organise ] || [ $1 = cmd_killing_feature ]; then
    progToCall="$WAY/${1}.sh $(get_current_workspace)"
else    
    progToCall="$WAY/${1}.sh $(get_active_window)"
fi

shift

for param in $*; do
    progToCall="$progToCall $param"
done

`$progToCall`
