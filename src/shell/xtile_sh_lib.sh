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

WAY=$(cd $(dirname $0); pwd)

if [ -f xtile_c_lib.o ] ; then
    cmd="$WAY/xtile_c_lib.o"
else
    exit 1
fi

###########################################################################################################################
############################################ GET_Functions ....   #########################################################
###########################################################################################################################

# |======================================================================|
# | XTile                                                             |
# |======================================================================|
# | Auteurs : A . RUPP                                                   |
# |======================================================================|
# | Nom : get_active_window                                              |
# | Description : retourne l'id de la fenêtre active                     |
# |======================================================================|

function get_active_window(){
    xprop -root _NET_ACTIVE_WINDOW | sed "s/.*# \(0x[0-9a-z]*\).*/\1/"
    return 0
}


# |======================================================================|
# | XTile                                                             |
# |======================================================================|
# | Auteurs : A . RUPP                                                   |
# |======================================================================|
# | Nom : 0xToDec                                                        |
# | Description : Convertisseur Hexadecimal -> Decimal                   |
# |======================================================================|

function oxToDec(){
    if [ $# -eq 0 ]; then
	return 1
    fi
    
    local num=$1
    if [ `echo "$num" | cut -c -2` = 0x ]; then
	num=`echo "$num" | cut -c 3- | tr [a-z] [A-Z]`
    fi
    echo `echo "ibase=16; $num" | bc`
}

# |======================================================================|
# | XTile                                                   06/2012   |
# |======================================================================|
# | Auteurs : A.RUPP                                                     |
# |======================================================================|
# | Nom : decTo0x                                                        |
# | Description : Convertisseur Decimal -> HexaDecimal                   |
# |======================================================================|

function decTo0x(){
    if [ $# -eq 0 ]; then
	return 1
    fi

    local num=`echo "obase=16; $1" | bc`

    local nbZero=`expr 9 - $(echo $num | wc -c)` # 9 car BC semble ne pas marcher (compte 1 caractere de trop chez moi)

    if [ $nbZero -ne 0 ] ; then
	for i in `seq $nbZero`; do
	    num=0$num
	done
    fi
    echo 0x$num
    return 0
}


# |======================================================================|
# | XTile                                                   06/2012   |
# |======================================================================|
# | Auteurs : A.RUPP                                                     |
# |======================================================================|
# | Nom :         get_border_for_screen                                  |
# |                                                                      |
# | Description : Retourne la dimension de la "bordure" décran demandée. |
# |               Les "bordures" sont le plus souvent les "tableaux de   |
# |               bord" et éléments ne devant être superposés par des    |
# |               fenêtres.                                              |
# |                                                                      |
# | Parametres :  1_ <top | bottom | left | right>                       |
# |                                                                      |
# | Exemple :     do_........sh right                                    |
# |======================================================================|    

function get_border_for_screen(){

    if [ $# -eq 0 ] ;then
	return 1
    fi


# Affichage de la marge demandée par l'utilisateur.

# _NET_WORKAREA, x, y, width, height
# _NET_DESKTOP_GEOMETRY width, height
# TODO
#Changer enlever virgule
    if echo "$DESKTOP_SESSION" | grep -i fluxbox >/dev/null 2>&1; then 

	local height=$(cat  "$(cat $HOME/.fluxbox/init | awk '/session.styleFile:/ {print $NF}')/theme.cfg" | awk '/toolbar.height:/ {print $NF}')
	local position=$(cat $HOME/.fluxbox/init | awk '/session.screen0.toolbar.placement:/ {print $NF}')
	
	if [ "$1" = top ] ; then
	    if [ -n "$(echo $position | awk '/^Top.*/ {print 1}')" ]; then
		echo $height
	    else
		echo 0
	    fi
	    return 0
	elif [ "$1" = bottom ] ; then
	    if [ -n "$(echo $position | awk '/^Bottom.*/ {print 1}')" ]; then
		echo $height
	    else
		echo 0
	    fi	
	    return 0
	elif [ "$1" = left ] ; then
	    if [ -n "$(echo $position | awk '/^Left.*/ {print 1}')" ]; then
		echo $height
	    else
		echo 0
	    fi 
	    return 0
	elif [ "$1" = right ] ; then
	    if [ -n "$(echo $position | awk '/^Right.*/ {print 1}')" ]; then
		echo $height
	    else
		echo 0
	    fi 
	    return 0
	else
	    return 1
	fi

    else 
	if [ "$1" = top ] ; then
	    xprop -root _NET_WORKAREA | sed "s/_NET_WORKAREA(CARDINAL) = \([0-9]*\), \([0-9]*\), \([0-9]*\), \([0-9]*\).*/\2/"
	    return 0
	elif [ "$1" = bottom ] ; then
	    $(( $(xprop -root _NET_DESKTOP_GEOMETRY | sed "s/_NET_DESKTOP_GEOMETRY(CARDINAL) = \([0-9]*\), \([0-9]*\)/\2/") - $(xprop -root _NET_WORKAREA | sed "s/_NET_WORKAREA(CARDINAL) = \([0-9]*\), \([0-9]*\), \([0-9]*\), \([0-9]*\),* .*/\2/") - $(xprop -root _NET_WORKAREA | sed "s/_NET_WORKAREA(CARDINAL) = \([0-9]*\), \([0-9]*\), \([0-9]*\), \([0-9]*\).*/\4/") ))
	    return 0
	elif [ "$1" = left ] ; then
	    xprop -root _NET_WORKAREA | sed "s/_NET_WORKAREA(CARDINAL) = \([0-9]*\), \([0-9]*\), \([0-9]*\), \([0-9]*\).*/\1/"
	    return 0
	elif [ "$1" = right ] ; then
	    $(( $(xprop -root _NET_DESKTOP_GEOMETRY | sed "s/_NET_DESKTOP_GEOMETRY(CARDINAL) = \([0-9]*\), \([0-9]*\)/\1/") - $(xprop -root _NET_WORKAREA | sed "s/_NET_WORKAREA(CARDINAL) = \([0-9]*\), \([0-9]*\), \([0-9]*\), \([0-9]*\).*/\1/") - $(xprop -root _NET_WORKAREA | sed "s/_NET_WORKAREA(CARDINAL) = \([0-9]*\), \([0-9]*\), \([0-9]*\), \([0-9]*\).*/\3/") ))
	    return 0
	else
	    return 1
	fi
    fi
}
     

# |======================================================================|
# | XTile                                                   06/2012   |
# |======================================================================|
# | Auteurs : A.RUPP                                                     |
# |======================================================================|
# | Nom :         get_border_for_window                                  |
# |                                                                      |
# | Description : Retourne la dimension de la "bordure" décran demandée. |
# |                                                                      |
# | Parametres :  1_ ID de la fenêtre                                    |
# |               2_ <top | bottom | left | right>                       |
# |                                                                      |
# | Exemple :     do_........sh 0x0342... right                          |
# |======================================================================|

function get_border_for_window(){

    if [ $# -lt 2 ] ; then 
	return 1
    fi
    local border
    if [ "$2" = left ] ; then
	border=$(xprop -id $1 _NET_FRAME_EXTENTS | sed -n "s/_NET_FRAME_EXTENTS(CARDINAL) = \(.*\), \(.*\), \(.*\), \(.*\)/\1/p")
	if [ -n $border ] ; then 
	    echo $border
	else
	    echo 0
	fi
    elif [ "$2" = right ] ; then
	border=$(xprop -id $1 _NET_FRAME_EXTENTS | sed -n "s/_NET_FRAME_EXTENTS(CARDINAL) = \(.*\), \(.*\), \(.*\), \(.*\)/\2/p")
	if [ -n $border ] ; then 
	    echo $border
	else
	    echo 0
	fi
	return 0
    elif [ "$2" = top ] ; then
	border=$(xprop -id $1 _NET_FRAME_EXTENTS | sed -n "s/_NET_FRAME_EXTENTS(CARDINAL) = \(.*\), \(.*\), \(.*\), \(.*\)/\3/p")
	if [ -n $border ] ; then 
	    echo $border
	else
	    echo 0
	fi
	return 0
    elif [ "$2" = bottom ] ; then
	border=$(xprop -id $1 _NET_FRAME_EXTENTS | sed -n "s/_NET_FRAME_EXTENTS(CARDINAL) = \(.*\), \(.*\), \(.*\), \(.*\)/\4/p")
	if [ -n $border ] ; then 
	    echo $border
	else
	    echo 0
	fi
	return 0
    fi 
    return 1
}             

# |======================================================================|
# | XTile                                                   06/2012   |
# |======================================================================|
# | Auteurs : A.RUPP                                                     |
# |======================================================================|
# | Nom :         get_dimension_for_screen                               |
# |                                                                      |
# | Description : Retourne la dimension demandée de l'écran (largeur ou  |
# |               hauteur).                                              |
# |                                                                      |
# | Parametres :  1_ <width | height>                                    |
# |                                                                      |
# | Exemple :     get_....sh width                                       |
# |======================================================================| 

function get_dimension_for_screen(){ 

# We can also use xprop -root _NET_DESKTOP_GEOMETRY
    if [ $# -eq 0 ] ;then
	return 1
    fi

    if [ "$1" = width ] ; then 
	xrandr | sed -n "s/.* current \(.*\) x \(.*\), .*/\1/p"
	return 0
    elif [ "$1" = height ] ; then
	xrandr | sed -n "s/.* current \(.*\) x \(.*\), .*/\2/p"
	return 0
    fi
}

# |======================================================================|
# | XTile                                                   06/2012   |
# |======================================================================|
# | Auteurs : A.RUPP                                                     |
# |======================================================================|
# | Nom :         get_dimension_for_window                               |
# |                                                                      |
# | Description : Retourne la dimension de la fenêtre demandée (hauteur  |
# |               ou largeur)                                            |
# |                                                                      |
# | Parametres :  1_ ID de la fenetre à redimensionner                   |
# |               2_ <width | height>                                    |
# |                                                                      |
# | Exemple :     do_.....sh 0x042010b3 width +10                        |
# |======================================================================| 

function get_dimension_for_window(){

    if [ $# -lt 2 ] ;then
	return 1
    fi

    if [ "$2" = width ] ; then
	xwininfo -id $1 | sed -n "s/Width: \(.*\)/\1/p" | sed "s/ //g" 2>/dev/null
	return 0
    elif [ "$2" = height ] ; then
	xwininfo -id $1 | sed -n "s/Height: \(.*\)/\1/p" | sed "s/ //g" 2>/dev/null
	return 0
    fi
}

# |======================================================================|
# | XTile                                                   06/2012   |
# |======================================================================|
# | Auteurs : A.RUPP                                                     |
# |======================================================================|
# | Nom :         get_list_of_windows.sh                                 |
# |                                                                      |
# | Description : Retourne la liste des id, de toutes les fenêtres X     |
# |               gérées par le gestionnaire de fenêtre.                 |
# |                                                                      |
# | Parametres :  /                                                      |
# |                                                                      |
# | Exemple : get.....sh                                                 |
# |======================================================================|  

function get_list_of_windows(){
#xprop -id 0x03a00006 _NET_WM_WINDOW_TYPE

    xprop -root _NET_CLIENT_LIST | sed "s/,//g" | sed -n "s/.*\#\(.*\)/\1/p"
    return 0
}

# |======================================================================|
# | XTile                                                   06/2012   |
# |======================================================================|
# | Auteurs : A.RUPP                                                     |
# |======================================================================|
# | Nom :         get_current_workspace.sh                               |
# |                                                                      |
# | Description : Retourne le numéro du workspace courrant               |
# |                                                                      |
# | Parametres :  /                                                      |
# |                                                                      |
# | Exemple : get.....sh                                                 |
# |======================================================================|  

function get_current_workspace(){
   xprop -root _NET_CURRENT_DESKTOP |  sed -n "s/.*\= \(.*\)/\1/p"
}

# |======================================================================|
# | XTile                                                   06/2012   |
# |======================================================================|
# | Auteurs : A.RUPP                                                     |
# |======================================================================|
# | Nom :         get_next_window_on_workspace                           |
# |                                                                      |
# | Description : Retourne l'ID de la prochaine fenetre présente         |
# |               dans l'espace de travail.                              |
# |                                                                      |
# | Parametres :  1_ ID de la fenêtre courante                           |
# |                                                                      |
# | Exemple :     do_........sh 0x321..                                  |
# |======================================================================|

function get_next_window_on_workspace(){

    if [ $# -eq 0 ]; then
	return 1
    fi

    local list=$(get_windows_on_workspace $(get_workspace_for_window $1))
    local nextWin=$(echo "$list $(echo $list | awk '{print $1}')")
    nextWin=$(echo $nextWin | sed "s/.*$1 \(0x[a-z0-9]*\).*/\1/" 2>/dev/null)

    if [ -z "$nextWin" ]; then
	echo $1
	return 1
    fi

    echo $nextWin
}                                                                                                                                                              
# |======================================================================|
# | XTile                                                   06/2012   |
# |======================================================================|
# | Auteurs : A.RUPP                                                     |
# |======================================================================|
# | Nom :         get_next_visible_window_on_workspace                   |
# |                                                                      |
# | Description : Retourne l'ID de la prochaine fenetre VISIBLE présente |
# |               dans l'espace de travail.                              |
# |                                                                      |
# | Parametres :  1_ ID de la fenêtre courante                           |
# |                                                                      |
# | Exemple :     do_........sh 0x45232                                  |
# |======================================================================|

function get_next_visible_window_on_workspace(){

    if [ $# -eq 0 ]; then
	return 1
    fi

    local list=$(get_visible_windows_on_workspace $(get_workspace_for_window $1))
    local nextWin=$(echo "$list $(echo $list | awk '{print $1}')")
    nextWin=$(echo $nextWin | sed "s/.*$1 \(0x[a-z0-9]*\).*/\1/" 2>/dev/null)

    if [ -z "$nextWin" ]; then
	echo $1
	return 0
    fi

    echo $nextWin
    return 0
}

# |======================================================================|
# | XTile                                                   06/2012      |
# |======================================================================|
# | Auteurs : A.RUPP                                                     |
# |======================================================================|
# | Nom :         get_last_window_on_workspace                           |
# |                                                                      |
# | Description : Retourne l'ID de la précédente fenetre présente        
# |               dans l'espace de travail.                              |
# |                                                                      |
# | Parametres :  1_ ID de la fenêtre courante                           |
# |                                                                      |
# | Exemple :     do_........sh 0x321..                                  |
# |======================================================================|

function get_last_window_on_workspace(){

    if [ $# -eq 0 ]; then
	return 1
    fi

    local list=$(get_windows_on_workspace $(get_workspace_for_window $1))
    local lastWin=$(echo "$(echo $list | awk '{print $NF}') $list")
    lastWin=$(echo $lastWin | sed "s/.*\(0x[a-z0-9]*\) $1.*/\1/" 2>/dev/null)

    if [ -z "$lastWin" ]; then
	echo $1
	return 1
    fi

    echo $lastWin
}            
          
# |======================================================================|
# | XTile                                                   06/2012      |
# |======================================================================|
# | Auteurs : A.RUPP                                                     |
# |======================================================================|
# | Nom :         get_last_visible_window_on_workspace                   |
# |                                                                      |
# | Description : Retourne l'ID de la précédente fenetre VISIBLE présente|
# |               dans l'espace de travail.                              |
# |                                                                      |
# | Parametres :  1_ ID de la fenêtre courante                           |
# |                                                                      |
# | Exemple :     do_........sh 0x432.....                               |
# |======================================================================|

function get_last_visible_window_on_workspace(){

    if [ $# -eq 0 ]; then
	return 1
    fi

    local list=$(get_visible_windows_on_workspace $(get_workspace_for_window $1))
    local lastWin=$(echo "$(echo $list | awk '{print $NF}') $list")
    lastWin=$(echo $lastWin | sed "s/.*\(0x[a-z0-9]*\) $1.*/\1/" 2>/dev/null)

    if [ -z "$lastWin" ]; then
	echo $1
	return 0
    fi

    echo $lastWin
    return 0
}

# |======================================================================|
# | XTile                                                   06/2012   |
# |======================================================================|
# | Auteurs : A.RUPP                                                     |
# |======================================================================|
# | Nom :         get_number_of_window_for_workspace                     |
# |                                                                      |
# | Description : Retourne le nombre de fenêtres NON RÉDUITES présentes  |
# |               dans l'espace de travail.                              |
# |                                                                      |
# | Parametres :  1_ ID d'un espace de travail                           |
# |                                                                      |
# |======================================================================|   

function get_number_of_window_for_workspace(){

    if [ $# -eq 0 ] || [ $1 -lt 0 ] || [ $1 -ge $(get_number_of_workspace) ] ; then 
	echo 0
	return 1
    fi 

    get_windows_on_workspace $1 | wc -w
}


# |======================================================================|
# | XTile                                                   06/2012      |
# |======================================================================|
# | Auteurs : A.RUPP                                                     |
# |======================================================================|
# | Nom :         get_number_of_visible_window_for_workspace             |
# |                                                                      |
# | Description : Retourne le nombre de fenêtres NON RÉDUITES présentes  |
# |               dans l'espace de travail.                              |
# |                                                                      |
# | Parametres :  1_ ID d'un espace de travail                           |
# |                                                                      |
# |======================================================================|   

function get_number_of_visible_window_for_workspace(){
    if [ $# -eq 0 ] || [ $1 -lt 0 ] || [ $1 -ge $(get_number_of_workspace) ] ; then 
	return 1
    fi 
    
    get_visible_windows_on_workspace $1 | wc -w
}


# |======================================================================|
# | XTile                                                   06/2012      |
# |======================================================================|
# | Auteurs : A.RUPP                                                     |
# |======================================================================|
# | Nom :         get_number_of_workspace                                |
# |                                                                      |
# | Description : Retourne le nombre d'espace de travail disponible.     |
# |                                                                      |
# | Parametres :  /                                                      |
# |======================================================================|  

function get_number_of_workspace(){
   xprop -root _NET_NUMBER_OF_DESKTOPS | cut -d " " -f3
}


# |======================================================================|
# | XTile                                                   06/2012   |
# |======================================================================|
# | Auteurs : A.RUPP                                                     |
# |======================================================================|
# | Nom :         get_position_for_windows                               |
# |                                                                      |
# | Description : Retourne la position de la fenêtre. Soit en ordonnés,  |
# |               soit en abscisses.                                     |
# |                                                                      |
# | Parametres :  1_ ID de la fenêtre                                    |
# |               2_ <x | y>                                             |
# |                                                                      |
# | Exemple : get.....sh 0x03e00004 x                                    |
# |======================================================================|                                                                                                                            
function get_position_for_windows(){
    if [ $#  -lt 2 ] ;then
	return 1
    fi

    if [ "$2" = x ] ; then
	xwininfo -id $1 | sed -n "s/  Absolute upper-left X:  \(.*\)/\1/p" 2>/dev/null
    elif [ "$2" = y ] ; then
	xwininfo -id $1 | sed -n "s/  Absolute upper-left Y:  \(.*\)/\1/p" 2>/dev/null
    fi
}                                                                                                               

# |======================================================================|
# | XTile                                                   06/2012   |
# |======================================================================|
# | Auteurs : A.RUPP                                                     |
# |======================================================================|
# | Nom :         get_real_dimension_for_window                          |
# |                                                                      |
# | Description : Retourne la dimension d'une fenêtre (AVEC les bordures)|
# |                                                                      |
# | Parametres :  1_ ID de la fenêtre                                    |
# |               2_ < width | height >                                  |
# |                                                                      |
# | Exemple : get_........sh 0x03e00004 width                            |
# |======================================================================|

function get_real_dimension_for_window(){
# real dimension : la dimension des fenêtres AVEC les bordures

    if [ $# -lt 2 ] ;then
	return 1
    fi

    if [ "$2" = width ] ; then 
	echo $(( $(get_dimension_for_window $1 width) + $(get_border_for_window $1 left) + $(get_border_for_window $1 right) ))
	return 0
    elif [ "$2" = height ] ; then
	echo $(( $(get_dimension_for_window $1 height) + $(get_border_for_window $1 top) + $(get_border_for_window $1 bottom) ))
	return 0
    fi
    return 1
}                                                                                                                                                             
# |======================================================================|
# | XTile                                                   06/2012   |
# |======================================================================|
# | Auteurs : A.RUPP                                                     |
# |======================================================================|
# | Nom :         get_real_position_for_window                          |
# |                                                                      |
# | Description : Retourne la position de la fenêtre. Soit en ordonnés,  |
# |               soit en abscisses.                                     |
# |               Le (0.0) se situant APRES les bordures et panels du    |
# |               bureau                                                 |
# |                                                                      |
# | Parametres :  1_ ID de la fenêtre                                    |
# |               2_ <x | y>                                             |
# |                                                                      |
# | Exemple : get.....sh 0x03e00004 x                                    |
# |======================================================================|

function get_real_position_for_window(){
    
    if [ $#  -lt 2 ] ;then
	return 1
    fi

    if [ "$2" = y ] ; then
	echo $(( $(get_position_for_windows $1 y) - $(get_border_for_window $1 top) ))
	return 0
    elif [ "$2" = x ] ; then
	echo $(( $(get_position_for_windows $1 x) - $(get_border_for_window $1 left) ))
	return 0
    fi
}
        

# |======================================================================|
# | XTile                                                   06/2012   |
# |======================================================================|
# | Auteurs : A.RUPP                                                     |
# |======================================================================|
# | Nom :         get_util_dimension_for_screen                          |
# |                                                                      |
# | Description : Retourne la dimension de l'écran, moins les tailles    |
# |               des bordures, et panels de l'écran.                    |
# |                                                                      |
# | Parametres :  1_ ID de la fenêtre                                    |
# |               2_ <width | height>                                    |
# |                                                                      |
# | Exemple : get.....sh 0x03e00004 width                                |
# |======================================================================|   

# LA dimension UTILE : celle sans les bordures, sans les panels ! (attention le sens est un peu différents que pour les fenetres)
# TODO : Attention, avec Fluxbox, le pannel n'est pas visible avec Xprop ... 

function get_util_dimension_for_screen(){   

    if [ $# -eq 0 ] ;then
	return 1
    fi

    if echo "$DESKTOP_SESSION" | grep -i fluxbox>/dev/null 2>&1 ; then
	if [ "$1" = width ] ; then     
	    echo $(( $(xprop -root _NET_WORKAREA | sed "s/.* = \([0-9]*\), \([0-9]*\), \([0-9]*\), \([0-9]*\).*/\3/") - $(get_border_for_screen left) - $(get_border_for_screen right) ))  
	elif [ "$1" = height ] ; then
	    echo $(( $(xprop -root _NET_WORKAREA | sed "s/.* = \([0-9]*\), \([0-9]*\), \([0-9]*\), \([0-9]*\).*/\4/") - $(get_border_for_screen top) - $(get_border_for_screen bottom) ))  
	fi
    else
	if [ "$1" = width ] ; then     
	    xprop -root _NET_WORKAREA | sed "s/.* = \([0-9]*\), \([0-9]*\), \([0-9]*\), \([0-9]*\).*/\3/"
	elif [ "$1" = height ] ; then
	    xprop -root _NET_WORKAREA | sed "s/.* = \([0-9]*\), \([0-9]*\), \([0-9]*\), \([0-9]*\).*/\4/"
	fi
    fi
}                                                                                                                                                             
# |======================================================================|
# | XTile                                                   06/2012   |
# |======================================================================|
# | Auteurs : A.RUPP                                                     |
# |======================================================================|
# | Nom :         get_visible_windows_on_workspace                       |
# |                                                                      |
# | Description :Retourne une liste de toutes les fenetres présentes     |
# |              dans l'espace de travail (non réduites)                 |
# |              Les noms des fenêtres sont séparés par un espace.       |
# |                                                                      |
# | Parametres :  1_ ID de l'espace de travail                           |
# |                                                                      |
# | Exemple : get.....sh 1                                               |
# |======================================================================|      

function get_visible_windows_on_workspace(){

    if [ $# -eq 0 ] || [ $1 -lt 0 ] || [ $1 -ge $(get_number_of_workspace) ] ; then 
	return 1
    fi 
	
    for win in $(get_list_of_windows); do
	if [ $(get_workspace_for_window $win) -eq $1 ] && [ "$(xprop -id $win | sed -n "s/_NET_WM_STATE(ATOM) = \(.*\)/\1/p")" != _NET_WM_STATE_HIDDEN ]; then
	    echo $win
	fi&
    done | sort | tr '\n' ' '
    wait
    return 0
}

# |======================================================================|
# | XTile                                                   06/2012   |
# |======================================================================|
# | Auteurs : A.RUPP                                                     |
# |======================================================================|
# | Nom :         get_windows_on_workspace                               |
# |                                                                      |
# | Description :Retourne une liste de toutes les fenetres présentes     |
# |              dans l'espace de travail                                |
# |              Les noms des fenêtres sont séparés par un espace.       |
# |                                                                      |
# | Parametres :  1_ ID de l'espace de travail                           |
# |                                                                      |
# | Exemple : get.....sh 1                                               |
# |======================================================================|      

function get_windows_on_workspace(){

    if [ $# -eq 0 ] || [ $1 -lt 0 ] || [ $1 -ge $(get_number_of_workspace) ] ; then 
	return 1
    fi 
	
    for win in $(get_list_of_windows); do
	if [ $(get_workspace_for_window $win) -eq $1 ] ; then
	    echo $win
	fi&
    done | sort | tr '\n' ' '
    wait
    return 0

}
                                                                                                                                 
# |======================================================================|
# | XTile                                                   06/2012   |
# |======================================================================|
# | Auteurs : A.RUPP                                                     |
# |======================================================================|
# | Nom :         get_windows_near_from                                  |
# |                                                                      |
# | Description : Retourne une liste de toutes les fenetres présentes    |
# |               à droite, gauche, bas ou haut de la fenetre actuelle.  |
# |               Les noms des fenêtres sont séparés par un espace.      |
# |                                                                      |
# | Parametres :  1_ ID de la fenêtre                                    |
# |               2_ <left | right | top | bottom>                       |
# |                                                                      |
# | Exemple : get.....sh 0x03e00004 right                                |
# |======================================================================|                     
 
function get_windows_near_from(){

    if [ $# -lt 2 ]; then
	return 1
    fi

    for i in $(get_windows_on_workspace $(get_workspace_for_window $1)); do
	if [ "$2" = left ] ;then 
	    if [ $(( $(get_real_position_for_window $i x) + $(get_real_dimension_for_window $i width) )) -lt $(( $(get_real_position_for_window $1 x) + 50 )) ] ; then
		echo $i
	    fi
	elif [ "$2" = onlyLeft ] ;then 
	    if [ $(( $(get_real_position_for_window $i x) + $(get_real_dimension_for_window $i width) )) -lt $(( $(get_real_position_for_window $1 x) + 50 )) ] && [ $(( $(get_real_position_for_window $i y) + $(get_real_dimension_for_window $i height) )) -ge $(( $(get_real_position_for_window $1 y) + 50 )) ] && [  $(( $(get_real_position_for_window $1 y) + $(get_real_dimension_for_window $1 height) )) -ge $(( $(get_real_position_for_window $i y) + 50 )) ]; then
		echo $i
	    fi
	elif [ "$2" = right ] ;then 
	    if [ $(( $(get_real_position_for_window $1 x) + $(get_real_dimension_for_window $1 width) )) -lt $(( $(get_real_position_for_window $i x) + 50 )) ] ; then

		echo $i
	    fi
	elif [ "$2" = onlyRight ] ;then 
	    if [ $(( $(get_real_position_for_window $1 x) + $(get_real_dimension_for_window $1 width) )) -lt $(( $(get_real_position_for_window $i x) + 50 )) ] && [ $(( $(get_real_position_for_window $i y) + $(get_real_dimension_for_window $i height) )) -ge $(( $(get_real_position_for_window $1 y) + 50 )) ] && [  $(( $(get_real_position_for_window $1 y) + $(get_real_dimension_for_window $1 height) )) -ge $(( $(get_real_position_for_window $i y) + 50 )) ]; then

		echo $i
	    fi
	elif [ "$2" = top ] ;then 
	    if [ $(( $(get_real_position_for_window $i y) + $(get_real_dimension_for_window $i height) )) -lt $(( $(get_real_position_for_window $1 y) + 50 )) ] ; then

		echo $i
	    fi
	elif [ "$2" = onlyTop ] ;then 
	    if [ $(( $(get_real_position_for_window $i y) + $(get_real_dimension_for_window $i height) )) -lt $(( $(get_real_position_for_window $1 y) + 50 )) ] && [ $((  $(get_real_position_for_window $i x) + $(get_real_dimension_for_window $i width) )) -ge $(( $(get_real_position_for_window $1 x) + 50 )) ] && [  $(( $(get_real_position_for_window $1 x) + $(get_real_dimension_for_window $1 width) )) -ge $(( $(get_real_position_for_window $i x) + 50 )) ]; then

		echo $i
	    fi
	elif [ "$2" = bottom ] ;then 
	    if [ $(( $(get_real_position_for_window $1 y) + $(get_real_dimension_for_window $1 height) )) -lt $(( $(get_real_position_for_window $i y) + 50 )) ] ; then

		echo $i
	    fi
	elif [ "$2" = onlyBottom ] ;then 
	    if [ $(( $(get_real_position_for_window $1 y) + $(get_real_dimension_for_window $1 height) )) -lt $(( $(get_real_position_for_window $i y) + 50 )) ] && [ $(( $(get_real_position_for_window $i x) + $(get_real_dimension_for_window $i width) )) -ge $(( $(get_real_position_for_window $1 x) + 50 )) ] && [ $(( $(get_real_position_for_window $1 x) + $(get_real_dimension_for_window $1 width) )) -ge $(( $(get_real_position_for_window $i x) + 50 )) ]; then
		echo $i
	    fi 
	fi &
    done | sort | tr '\n' ' '
    wait
    return 0

}


# |======================================================================|
# | XTile                                                   06/2012   |
# |======================================================================|
# | Auteurs : A.RUPP                                                     |
# |======================================================================|
# | Nom :         get_workspace_for_window                               |
# |                                                                      |
# | Description : Retourne l'espace de travail dans lequel se trouve la  |
# |               fenêtre.                                               |
# |                                                                      |
# | Parametres :  1_ ID de la fenêtre                                    |
# |                                                                      |
# | Exemple : get.....sh 0x03e00004                                      |
# |======================================================================|  

function get_workspace_for_window(){

    if [ $# -eq 0 ] ; then 
	return 1
    fi

    local workspace=$(xprop -id $1 _NET_WM_DESKTOP | awk '{print $NF}' 2>/dev/null)

    if  xprop -id $1 _NET_WM_STATE 2>/dev/null | sed -n "s/_NET_WM_STATE(ATOM) =\(.*\)/\1/p" 2>/dev/null | grep STICKY >/dev/null || ! xprop -id $1 _NET_WM_WINDOW_TYPE | grep _NET_WM_WINDOW_TYPE_NORMAL >/dev/null ; then 
	echo -1
	return 0
    fi  # Sert à éliminer les applications n'affichant pas de fenêtre (ex : conky, le panel ..)
#
#    if [ $workspace -eq 0 ]; then
#	workspace=$(( ($(xprop -id $1 _NET_DESKTOP_VIEWPORT | sed -n "s/_NET_DESKTOP_VIEWPORT(CARDINAL) = \([0-9]*\), \([0-9]*\)/\1/p") / $(get_dimens#ion_for_screen width) ) + ( ( $(xprop -root _NET_DESKTOP_GEOMETRY | sed -n "s/_NET_DESKTOP_GEOMETRY(CARDINAL) = \([0-9]*\), \([0-9]*\)/\1/p") / $(get#_dimension_for_screen width) ) * ($(xprop -root _NET_DESKTOP_VIEWPORT | sed -n "s/_NET_DESKTOP_VIEWPORT(CARDINAL) = \([0-9]*\), \([0-9]*\)/\2/p") / $#(get_dimension_for_screen height) ) ) ))
#    fi

    if [ -z $workspace ]; then 
	echo 0
	return 0
    fi

    echo $workspace
    return 0
}


###########################################################################################################################
############################################ DO_Functions .....   #########################################################
###########################################################################################################################

# |======================================================================|
# | XTile                                                   06/2012   |
# |======================================================================|
# | Auteurs : A.RUPP                                                     |
# |======================================================================|
# | Nom :         do_move_in_real_space                                  |
# |                                                                      |
# | Description : Déplace la fenetre, dans la largeur OU la hauteur,     |
# |               vers la droite, la gauche, le haut ou le bas.          |
# |               La position 0.0 se situe en haut de l'écran, APRES les |
# |               tableaux de bords (pannels).                           |
# |                                                                      |
# | Parametres :  1_ ID de la fenetre à déplacer                         |
# |               2_ <x | y>                                             |
# |               3_ <int> (eg : 10)                                     |
# |                                                                      |
# | Exemple :     do_.....sh 0x042010b3 x 10                             |
# |======================================================================|  

function do_move_in_real_space(){

    if [ $# -lt 3 ]; then
	exit 1
    fi

    if [ "$2" = x ] ; then
	$cmd move $1 $(($3 + $(get_border_for_screen left))) $(get_real_position_for_window $1 y)
	exit 0
    elif  [ "$2" = y ] ; then
	$cmd move $1 $(get_real_position_for_window $1 x) $(( $3 + $(get_border_for_screen top)))
	exit 0   
    elif [ $# -eq 4 ] && [ "$2" = both ] ; then
	$cmd move $1 $(($3 + $(get_border_for_screen left))) $(( $4 + $(get_border_for_screen top)))
    fi

    exit 1
}

# |======================================================================|
# | XTile                                                   06/2012   |
# |======================================================================|
# | Auteurs : A.RUPP                                                     |
# |======================================================================|
# | Nom :         do_relative_resize                                     |
# |                                                                      |
# | Description : Redimensionne la fenetre, en largeur OU en hauteur,    |
# |                                                                      |
# | Parametres :  1_ ID de la fenetre à redimensionner                   |
# |               2_ <width | height>                                    |
# |               4_ <+/-><int> (eg : +10)                               |
# |                                                                      |
# | Exemple :     do_......sh 0x042010b3 width +10                       |
# |======================================================================| 

function do_relative_resize(){
    if [ $# -lt 3 ]; then
	exit 1
    fi

    if [ "$2" = width ] ; then
	if [ `echo "$3" | cut -c1 2>/dev/null` = + ]; then
	    $cmd resize $1 $(( $(get_dimension_for_window $1 width) + $(echo $3 | cut -c 2-) )) $(get_dimension_for_window $1 height )
	    exit 0
	elif [ `echo "$3" | cut -c1 2>/dev/null` = - ]; then
	    $cmd resize $1 $(( $(get_dimension_for_window $1 width) - $(echo $3 | cut -c 2-) )) $(get_dimension_for_window $1 height)
	    exit 0
	fi
    elif  [ "$2" = height ] ; then
	if [ `echo "$3" | cut -c1 2>/dev/null` = + ]; then
	    $cmd resize $1 $(get_dimension_for_window $1 width) $(( $(get_dimension_for_window $1 height) + $(echo $3 | cut -c 2-) ))
	    exit 0
	elif [ `echo "$3" | cut -c1 2>/dev/null` = - ]; then
	    $cmd resize $1 $(get_dimension_for_window $1 width) $(( $(get_dimension_for_window $1 height) - $(echo $3 | cut -c 2-) ))
	    exit 0
	fi
    elif [ $# -eq 4 ] && [ "$2" = both ] ; then
	if [ `echo "$3" | cut -c1 2>/dev/null` = + ] && [ `echo "$4" | cut -c1 2>/dev/null` = + ]; then
	    $cmd resize $1 $(( $(get_dimension_for_window $1 width) + $(echo $3 | cut -c 2-) )) $(( $(get_dimension_for_window $1 height) + $(echo $4 | cut -c 2-) ))
	    exit 0
	elif [ `echo "$3" | cut -c1 2>/dev/null` = - ] && [ `echo "$4" | cut -c1 2>/dev/null` = - ]; then
	    $cmd resize $1 $(( $(get_dimension_for_window $1 width) - $(echo $3 | cut -c 2-) )) $(( $(get_dimension_for_window $1 height) - $(echo $4 | cut -c 2-) ))
	    exit 0
	elif [ `echo "$3" | cut -c1 2>/dev/null` = - ] && [ `echo "$4" | cut -c1 2>/dev/null` = + ]; then
	    $cmd resize $1 $(( $(get_dimension_for_window $1 width) - $(echo $3 | cut -c 2-) )) $(( $(get_dimension_for_window $1 height) + $(echo $4 | cut -c 2-) ))
	    exit 0
	elif [ `echo "$3" | cut -c1 2>/dev/null` = + ] && [ `echo "$4" | cut -c1 2>/dev/null` = - ]; then
	    $cmd resize $1 $(( $(get_dimension_for_window $1 width) + $(echo $3 | cut -c 2-) )) $(( $(get_dimension_for_window $1 height) - $(echo $4 | cut -c 2-) ))
	    exit 0
	fi
    fi

    exit 1
}


# |======================================================================|
# | XTile                                                   06/2012   |
# |======================================================================|
# | Auteurs : A.RUPP                                                     |
# |======================================================================|
# | Nom :         do_resize_with_real_dimension                          |
# |                                                                      |
# | Description : Redimensionne la fenetre, en largeur OU en hauteur.    |
# |               La valeur indiquée en paramètre représente             |
# |               la dimension de la fenetre AVEC les bordures           |
# |                                                                      |
# | Parametres :  1_ ID de la fenetre à redimensionner                   |
# |               2_ <width | height>                                    |
# |               4_ <int> (eg : 10)                                     |
# |                                                                      |
# | Exemple :     do_.....sh 0x042010b3 width 10                        |
# |======================================================================| 

function do_resize_with_real_dimension(){

    if [ $# -lt 3 ] ;then
	exit 1
    fi

    if [ "$2" = width ] ; then
	$cmd resize $1 $(( $3 - $(get_border_for_window $1 left) - $(get_border_for_window $1 right) )) $(get_dimension_for_window $1 height)
	exit 0
    elif [ "$2" = height ] ; then
	$cmd resize $1 $(get_dimension_for_window $1 width) $(( $3 - $(get_border_for_window $1 top) - $(get_border_for_window $1 bottom) ))
	exit 0
    elif [ $# -eq 4 ] && [ "$2" = both ] ; then
	$cmd resize $1 $(( $3 - $(get_border_for_window $1 left) - $(get_border_for_window $1 right) )) $(( $4 - $(get_border_for_window $1 top) - $(get_border_for_window $1 bottom) ))
	exit 0
    fi

}

# |======================================================================|
# | XTile                                                   06/2012   |
# |======================================================================|
# | Auteurs : A.RUPP                                                     |
# |======================================================================|
# | Nom :         do_move_and_resize                                     |
# |                                                                      |
# | Description : Redimensionne et déplace la fenetre                    |
# |               La position 0.0 se situe en haut de l'écran, APRES les |
# |               tableaux de bords (pannels).                           |
# |               La valeur indiquée en paramètre représente             |
# |               la dimension de la fenetre AVEC les bordures (pour     |
# |               width et height)                                       |
# |                                                                      |
# | Parametres :  1_ ID de la fenetre à redimensionner                   |
# |               2_ x                                                   |
# |               3_ y                                                   |
# |               4_ width                                               |
# |               5_ height                                              |
# |                                                                      |
# | Exemple :     do_.....sh 0x042010b3 10 10 1000 500                   |
# |======================================================================| 


function do_move_and_resize(){

    if [ $# -lt 5 ] ;then
        exit 1
    fi
    
    $cmd moveResize $1 $(($2 + $(get_border_for_screen left))) $(( $3 + $(get_border_for_screen top))) $(( $4 - $(get_border_for_window $1 left) - $(get_border_for_window $1 right) )) $(( $5 - $(get_border_for_window $1 top) - $(get_border_for_window $1 bottom) ))
    exit 0

}