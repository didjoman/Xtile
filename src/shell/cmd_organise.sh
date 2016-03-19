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
# | Nom :         Organise                                               |
# |                                                                      |
# | Description : Organise les fenetres de l'espace de travail actuel,   |
# |               selon deux colonnes verticales                         |
# |                                                                      |
# | Parametres :  1_ ID de l'espace de travail                           |
# |                                                                      |
# | Exemple :     do_.........sh 0 square                                |
# |======================================================================| 

WAY=$(cd $(dirname $0); pwd)
[ -f $WAY/xtile_sh_lib.sh ] && . $WAY/xtile_sh_lib.sh || ( echo missing file $WAY/xtile_sh_lib.sh; exit 1 )

if [ $# -lt 2 ] || [ $1 -lt 0 ] || [ $1 -ge $(get_number_of_workspace) ] ; then
    exit 1
fi


windows=$(get_visible_windows_on_workspace $1)
nbWindows=$(get_number_of_visible_window_for_workspace $1)
if [ $nbWindows -gt 0 ]; then
    if [ "$2" = square ] ; then

	nbCol=$(echo "sqrt($nbWindows)" | bc)
	nbLine=$(( $nbWindows / $nbCol ))
	activeWin=$(get_active_window)
	windows=$(echo $windows | sed -n "s/\(.*\)$activeWin\(.*\)/$activeWin \1\2/p" | sed "s/  / /")

	
	if [ $nbCol -lt 2 ] && [ $nbWindows -gt 1 ]; then
	    nbCol=2
	    nbLine=$(( $nbWindows / $nbCol ))
	fi

	col=0
	line=0
	winInd=1
	posX=0
	posY=0
	for i in 1 2 3 4 ;do
	    (
		for win in $windows; do    
		    
		    $(do_move_and_resize $win $posX $posY $(( $(get_util_dimension_for_screen width) / $nbCol)) $(( $(get_util_dimension_for_screen height) / $nbLine)) )&		    

		    line=$(($line + 1))
		    if [ $line -eq $nbLine ]; then

			line=0
			col=$(( $col + 1 ))
			posX=$(( $(get_util_dimension_for_screen width) / $nbCol * $col ))
			if [ $col -eq $(( $nbCol - 1)) ] ; then
			    nbLine=$(($nbLine + ($nbWindows % $nbCol) ))
			fi
		    fi
		    winInd=$(($winInd + 1))
		    posY=$(( $(get_util_dimension_for_screen height) / $nbLine * $line ))
		    
		    done)&
	    wait
	done
	
    elif [ "$2" = specialSquare ] ; then

	activeWin=$(get_active_window)

	windows=$(echo $windows | sed "s/$activeWin//"| sed "s/  / /g")
	nbWindows=$(($nbWindows - 1))
	
	if [ $nbWindows -gt 0 ]; then
	    nbCol=$(echo "sqrt($nbWindows)" | bc)
	    nbLine=$(( $nbWindows / $nbCol ))

	    if [ $nbCol -lt 2 ] && [ $nbWindows -gt 1 ]; then
		nbCol=2
		nbLine=$(( $nbWindows / $nbCol ))
	    fi

	    col=0
	    line=0
	    winInd=1
	    posX=0
	    posY=0
		(for i in 1 2 3 4;do
		    (for win in $windows; do    
			
			$(do_move_and_resize $win $posX $posY $(( $(get_util_dimension_for_screen width) / $nbCol)) $(( $(get_util_dimension_for_screen height) / $nbLine)) )&
			
			
			line=$(($line + 1))
			if [ $line -eq $nbLine ]; then
			    
			    line=0
			    col=$(( $col + 1 ))
			    posX=$(( $(get_util_dimension_for_screen width) / $nbCol * $col ))
			    if [ $col -eq $(( $nbCol - 1)) ] ; then
				nbLine=$(($nbLine + ($nbWindows % $nbCol) ))
			    fi
			fi
			winInd=$(($winInd + 1))
			posY=$(( $(get_util_dimension_for_screen height) / $nbLine * $line ))
			
			done)&
		    wait
	    done )&
	fi
	for i in 1 2 3; do
	    $(do_move_and_resize $activeWin $(( $(get_util_dimension_for_screen width ) / 8 ))  $(( $(get_util_dimension_for_screen height) / 8 )) $(( $(get_util_dimension_for_screen width) * 3 / 4 )) $(( $(get_util_dimension_for_screen height) * 3 / 4 ))  )&
	done

    elif [ "$2" = horizontal ] ; then
	activeWin=$(get_active_window)
	windows=$(echo $windows | sed -n "s/\(.*\)$activeWin\(.*\)/$activeWin \1\2/p" | sed "s/  / /")
	for ind in 1 2 3 4; do
	    (
		winNum=0
		for i in $windows; do
		    (
			posX=$(( $(get_util_dimension_for_screen width) / $nbWindows * $winNum))
			$(do_move_and_resize $i $posX 0 $(( $(get_util_dimension_for_screen width) / $nbWindows )) $(get_util_dimension_for_screen height))&		wait
		    )&
		    winNum=$(( $winNum + 1 ))
		    
		    
		done
		wait
	    )& 
	    wait
	done
	    
    elif [ "$2" = vertical ] ; then
	activeWin=$(get_active_window)
	windows=$(echo $windows | sed -n "s/\(.*\)$activeWin\(.*\)/$activeWin \1\2/p" | sed "s/  / /")
	for ind in 1 2; do
	    (
		winNum=0
		for i in $windows; do
		    (
			posY=$(( $(get_util_dimension_for_screen height) / $nbWindows * $winNum))
			$(do_move_and_resize $i 0 $posY $(get_util_dimension_for_screen width) $(( $(get_util_dimension_for_screen height) / $nbWindows )) )&			wait
		    )&
		    winNum=$(( $winNum + 1 ))

		done
		wait
	    ) &
	    wait
	done

    elif [ "$2" = spec1 ] ; then

	activeWin=$(get_active_window)

	windows=$(echo $windows | sed "s/$activeWin//"| sed "s/  / /g")
	nbWindows=$(($nbWindows - 1))

	for i in 1 2;do
	    $(do_move_and_resize $activeWin 0 0 $(( $(get_util_dimension_for_screen width) / 2 )) $(get_util_dimension_for_screen height) ) &
	done&

	if [ $nbWindows -gt 0 ]; then
	    line=0
	    posX=$(($(get_util_dimension_for_screen width) / 2))
	    posY=0
	    for i in 1 2 3 4;do
		(
		    for win in $windows; do    
			$(do_move_and_resize $win $posX $posY $(( $(get_util_dimension_for_screen width) / 2)) $(( $(get_util_dimension_for_screen height) / $nbWindows)) )&
		
			line=$(($line + 1))
			posY=$(( $(get_util_dimension_for_screen height) / $nbWindows * $line ))	
			
			done)&
		wait
	    done
	fi

	
    elif [ "$2" = spec2 ] ; then
    
	activeWin=$(get_active_window)

	windows=$(echo $windows | sed "s/$activeWin//"| sed "s/  / /g")
	nbWindows=$(($nbWindows - 1))

	for i in 1 2;do
	    $(do_move_and_resize $activeWin 0 0 $(get_util_dimension_for_screen width) $(( $(get_util_dimension_for_screen height) / 2)) )&
	done&
	    
	if [ $nbWindows -gt 0 ]; then
	    col=0
	    posX=0
	    posY=$(($(get_util_dimension_for_screen height) / 2))
	    for i in 1 2 3 4 5;do
		(
		    for win in $windows; do    
                           $(do_move_and_resize $win $posX $posY  $(( $(get_util_dimension_for_screen width) / $nbWindows)) $(( $(get_util_dimension_for_screen height) / 2)))&
			
			col=$(($col + 1))
			posX=$(( $(get_util_dimension_for_screen width) / $nbWindows * $col ))	
			done
		) &
		wait
	    done
	fi
	
	
	
    fi
fi
