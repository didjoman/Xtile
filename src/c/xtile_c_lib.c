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
along with the XTILE; if not, write to the
Free Software Foundation, Inc.,
51 Franklin St, Fifth Floor,
Boston, MA  02110-1301  USA

-----------------------------------------------------------------------*/

/*
# |======================================================================|
# | XTile                                                   06/2012      |
# |======================================================================|
# | Auteurs : A.RUPP                                                     |
# |======================================================================|
# | Nom :         xtil_c_lib                                             |
# |                                                                      |
# | Description : Contient les fonctions de bases permettant de "maper", |
# |               avoir le focus, redimensionner, déplacer une fenetre.  |
# |               Cette librairie permet d'utiliser en bash des fonctions|
# |               de la xlib.                                            |
# |                                                                      |
# | Exemple :     xtile_c_lib.c move 0x42010b3 10 10                     |
# |======================================================================|
*/

#include "xtile_c_lib.h"

GC gc; // Contexte graphique
Display* display;
int screen;
Window root;

int main(int argc, char* argv[]){
 
  char* action;
  Window window;
  int arg[5]={0};

  // Connexion à un serveur X
  display = XOpenDisplay(NULL);
  if(!display){
    printf("Can not open display.\n");
    exit(EXIT_FAILURE);
  }

  // Récupère la valeur par default des différentes variables.
  screen = DefaultScreen(display);
  gc = DefaultGC (display, screen);
  root = RootWindow (display, screen);
  // Détermine l'action à effectuer :
  // On vérifie que le 2er argument (autre que nom fichier) est un id de fenetre :

  if(argc>2 && ((!strncmp(argv[2],"0x",2) && strtoll(argv[2],NULL,16)) || strtoll(argv[2],NULL,10)) ){  

      action = argv[1];
      window = get_window(argv); 
      
      // Si 5 arguments, c'est soit un move, soit un resize:
      if (argc==3){ // 1 seul argument (ex: 0x32422 )
	if(!strcmp(action,"mapRaise"))
	  do_map_and_raise(window);
	else if(!strcmp(action,"map"))
	  do_map(window);
	else if(!strcmp(action,"raise"))
	  do_raise(window);
	else if(!strcmp(action,"destroy"))
	  do_destroy(window);
	else if(!strcmp(action,"focus"))
	  do_focus(window);
	else if(!strcmp(action,"minimize"))
	  do_minimize(window);
	else if(!strcmp(action,"set_desktop"))
	  set_desktop((int)strtoll(argv[2],NULL,10));
	else
	  fail();
      }
      else if(argc==4){ // 2 arguments (ex : 0x4242535 1 )
	if(!strcmp(action,"set_desktop_for_window")){
	  set_desktop(strtoll(argv[3],NULL,10));
	  set_desktop_for_window(window,strtoll(argv[3],NULL,10));
	}
	else if(!strcmp(action,"set_viewport"))
	  set_viewport((int)strtoll(argv[2],NULL,10),(int)strtoll(argv[3],NULL,10));
	else
	  fail();
      }
      else if(argc==5){ 

	arg[0]=(int)strtoll(argv[3],NULL,10);
	arg[1]=(int)strtoll(argv[4],NULL,10);
	if(!strcmp(action,"move"))
	  do_move(window, arg[0], arg[1]); 
	else if(!strcmp(action,"resize"))
	  do_resize(window,arg[0],arg[1]); 
	else
	  fail();
      }
      else if(argc==7){

	arg[0]=(int)strtoll(argv[3],NULL,10);
	arg[1]=(int)strtoll(argv[4],NULL,10);
	arg[2]=(int)strtoll(argv[5],NULL,10);
	arg[3]=(int)strtoll(argv[6],NULL,10);

	if(!strcmp(action,"moveResize"))
	  do_move_and_resize(window, arg[0], arg[1], arg[2], arg[3]); 
	else
	  fail();
      }
      else
	fail();
  }
  else
    fail();
  
  
  XCloseDisplay(display);
  return EXIT_SUCCESS;
  
}


void fail(){
  printf("invalids arguments.\n");
  XCloseDisplay(display);
  exit(EXIT_FAILURE);  
}

  
Window get_window(char* argv[]){
  if(!strncmp(argv[2],"0x",2))
    return (Window)strtoll(argv[2],NULL,16);
  
  return (Window)strtoll(argv[2],NULL,10);
}

void do_move(Window window, int posx, int posy){
  XMoveWindow(display, window, posx, posy);
}

void do_resize(Window window, int width, int height){
  XResizeWindow(display, window, width, height);
}

void do_move_and_resize(Window window, int x, int y, unsigned int width, unsigned int height){
  XMoveResizeWindow(display, window, x, y, width, height);
} 

void do_map_and_raise(Window window){
  XMapRaised(display, window);
}

void do_map(Window window){
  XMapWindow(display, window);
}

void do_raise(Window window){
  XMapWindow(display, window);
}

void do_destroy(Window window){
  XDestroyWindow(display, window);
}

void do_focus(Window window){
  XSetInputFocus(display, window, RevertToNone, CurrentTime);
}

void do_minimize(Window window){
  XIconifyWindow(display, window, screen);
}

int set_desktop(long desktop) {

  XEvent ev;
  Window root;
  int ret = 0;
  root = RootWindow (display, screen);

  memset(&ev, 0, sizeof(ev));
  ev.type = ClientMessage;
  ev.xclient.display = display;
  ev.xclient.window = root;
  ev.xclient.message_type = XInternAtom(display, "_NET_CURRENT_DESKTOP", False);
  ev.xclient.format = 32;
  ev.xclient.data.l[0] = desktop;
  ev.xclient.data.l[1] = CurrentTime;

  ret = XSendEvent(display, root, False, SubstructureNotifyMask | SubstructureRedirectMask, &ev);

  return ret;
}

int set_desktop_for_window(Window window, long desktop) {

  XEvent ev;
  int ret = 0;
  XWindowAttributes attributes;
  
  XGetWindowAttributes(display, window, &attributes);

  memset(&ev, 0, sizeof(ev));
  ev.type = ClientMessage;
  ev.xclient.display = display;
  ev.xclient.window = window;
  ev.xclient.message_type = XInternAtom(display, "_NET_WM_DESKTOP", False);
  ev.xclient.format = 32;
  ev.xclient.data.l[0] = desktop;
  ev.xclient.data.l[1] = 2; /* indicate we are messaging from a pager */

  ret = XSendEvent(display, attributes.screen->root, False, SubstructureNotifyMask | SubstructureRedirectMask, &ev);

  return ret;
}

int set_viewport(int x, int y) {
  XEvent ev;
  int ret;

  memset(&ev, 0, sizeof(ev));
  ev.type = ClientMessage;
  ev.xclient.display = display;
  ev.xclient.window = root;
  ev.xclient.message_type = XInternAtom(display, "_NET_DESKTOP_VIEWPORT", False);
  ev.xclient.format = 32;
  ev.xclient.data.l[0] = x;
  ev.xclient.data.l[1] = y;

  ret = XSendEvent(display, root, False, SubstructureNotifyMask | SubstructureRedirectMask, &ev);

  return ret;
}
