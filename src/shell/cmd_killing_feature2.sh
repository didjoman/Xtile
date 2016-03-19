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
# | Nom :         killing feature                                        |
# |                                                                      |
# | Description : Cherche un treminal sur l'espace de travail courant,   |
# |               Si il y en a un, le focus, sinon, en ouvre un.         |
# |                                                                      |
# | Parametres :  1_ ID de l'espace de travail                           |
# |                                                                      |
# | Exemple :     killing_feature.sh 3                                   |
# |======================================================================| 

WAY=$(cd $(dirname $0); pwd)

[ -f $WAY/xtile_sh_lib.sh ] && . $WAY/xtile_sh_lib.sh || ( echo missing file $WAY/xtile_sh_lib.sh; exit 1 )
if [ -f xtile_c_lib.o ] ; then
    cmd="$WAY/xtile_c_lib.o"
else
    exit 1
fi


if [ $# -eq 0 ] || [ $1 -lt 0 ] || [ $1 -ge $(get_number_of_workspace) ] ; then
    exit 1
fi

# Si la fenêtre courante est un terminal, on la minimise :
if if xprop -id $(get_active_window) | grep "WM_WINDOW_ROLE(STRING)" | grep -i "terminal">/dev/null 2>&1 ; then
    $cmd minimize $(get_active_window)
    exit 0
fi

# Sinon on affiche le terminal présent dans l'espace de travail, ou on se déplace dans le premier espace de travail qui en a un, ou à défaut, on en ouvre un nouveau.

terminalInOtherWorkSpace=

for winId in $(get_list_of_windows); do

    if xprop -id $winId | grep "WM_WINDOW_ROLE(STRING)" | grep terminal >/dev/null 2>&1 ; then
	if [ `get_workspace_for_window $winId` -eq "$1" ] ; then
	    $cmd mapRaise $winId &
	    $cmd focus $winId &
            exit 0
        else
            terminalInOtherWorkSpace=$winId
        fi
    fi

done

# Si il n'y a pas de terminal dans l'espace de travail courrant, mais qu'il y en a un dans un autre espace, on bouge vers l'espace, et ouvre le term.
if [ ! -z terminalInOtherWorkSpace ] ; then
    $cmd mapRaise $winId &
    $cmd focus $winId &
    #xdotool set_desktop $(get_workspace_for_window $terminalInOtherWorkSpace)
    
    exit 0
fi

# si aucun terminal trouvé on en ouvre un : 
if ls /usr/bin | grep xfce4-terminal ; then
    xfce4-terminal # ligne à changer en fonction du gestionnaire de fenêtre
else
    $(ls /usr/bin | grep terminal | head -1)
fi
exit 0
