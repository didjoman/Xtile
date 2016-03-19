// gcc -Wall twm.c -o twm.o -lX11 

/*-----------------------------------------------------------------------

XTILE version 1.0
-------------------

This file is part of the code XTILE.

Copyright (C) 2012, Alexandre RUPP

contact: alexrupp@free.fr

The code XTILE is free software; you can redistribute it
and/or modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2 of
the License, or (at your option) any later version.

XTILE is distributed in the hope that it will be
useful, but WITHOUT ANY WARRANTY; without even the implied warranty
of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.


You should have received a copy of the GNU General Public License
along with XTILE; if not, write to the
Free Software Foundation, Inc.,
51 Franklin St, Fifth Floor,
Boston, MA  02110-1301  USA

-----------------------------------------------------------------------*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <X11/Xlib.h>

void fail();
Window get_window(char**);
void do_move(Window, int, int);
void do_resize(Window, int, int);
void do_move_and_resize(Window, int, int , unsigned int, unsigned int);
void do_map_and_raise(Window);
void do_map(Window);
void do_raise(Window);
void do_destroy(Window);
void do_focus(Window);
void do_minimize(Window);
int set_desktop(long);
int set_desktop_for_window(Window, long);
int set_viewport(int,int);
