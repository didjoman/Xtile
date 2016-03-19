//Gcc -Wall xtile_events.c -o xtile_events.o -lX11


// So that to see keysyms : /usr/include/X11/keysymdef.h
// You can also use Xev on Linux so that to test the events (and having key-codes and key syms

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
# | Nom :         xtile_events                                           |
# |                                                                      |
# | Description : programme qui "observe" les touches tapées par l'utili-|
# |               sateur et lance les raccourcis claviers.               |
# |                                                                      |
# | Exemple :     xtile_events.c                                         |
# |======================================================================|
*/

#include "xtile_events.h"

int main(int argc, char* argv[]){
  (void) argc;
  (void) argv;

  char cwd[1024];
  char callFunction[2048];
  getcwd(cwd, sizeof(cwd));

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

  // Gestion des évènements

    XEvent ev;

    KeyCode SUPER= XKeysymToKeycode(display, XStringToKeysym("Super_L"));
    KeyCode ALT_L = XKeysymToKeycode(display, XStringToKeysym("Alt_L"));

    KeyCode Z_KEY = XKeysymToKeycode(display, XStringToKeysym("z"));
    KeyCode S_KEY = XKeysymToKeycode(display, XStringToKeysym("s"));
    KeyCode Q_KEY = XKeysymToKeycode(display, XStringToKeysym("q"));
    KeyCode D_KEY = XKeysymToKeycode(display, XStringToKeysym("d"));
    KeyCode F_KEY = XKeysymToKeycode(display, XStringToKeysym("f"));
    KeyCode T_KEY = XKeysymToKeycode(display, XStringToKeysym("t"));
    KeyCode M_KEY = XKeysymToKeycode(display, XStringToKeysym("m"));
    KeyCode C_KEY = XKeysymToKeycode(display, XStringToKeysym("c"));
    KeyCode B_KEY = XKeysymToKeycode(display, XStringToKeysym("b"));
    KeyCode N_KEY = XKeysymToKeycode(display, XStringToKeysym("n"));
    // TAB

    KeyCode RIGHT = XKeysymToKeycode(display, XStringToKeysym("Right"));
    KeyCode DOWN = XKeysymToKeycode(display, XStringToKeysym("Down"));
    KeyCode LEFT = XKeysymToKeycode(display, XStringToKeysym("Left"));
    KeyCode UP = XKeysymToKeycode(display, XStringToKeysym("Up"));

    KeyCode KEY_1 = XKeysymToKeycode(display, XStringToKeysym("ampersand"));
    KeyCode KEY_2 = XKeysymToKeycode(display, XStringToKeysym("eacute"));
    KeyCode KEY_3 = XKeysymToKeycode(display, XStringToKeysym("quotedbl"));
    KeyCode KEY_4 = XKeysymToKeycode(display, XStringToKeysym("apostrophe"));
    KeyCode KEY_5 = XKeysymToKeycode(display, XStringToKeysym("parenleft"));
    KeyCode KEY_6 = XKeysymToKeycode(display, XStringToKeysym("minus"));

    /* grab our key combo -- we use AnyModifier because of caps lock/num lock
     * complexity.  just grab every F1 press.
     */
    XGrabKey(display, ALT_L, KeyPressMask | KeyReleaseMask, DefaultRootWindow(display), 1, GrabModeSync, GrabModeSync);
    XGrabKey(display, SUPER, AnyModifier, DefaultRootWindow(display), 1, GrabModeSync, GrabModeSync);
 
    // AnyModifier KeyPressMask | KeyReleaseMask
    int alt_pressed=0;
    int super_pressed=0;

    for(;;){
        XNextEvent(display, &ev);

	if(ev.type == KeyPress){
	  // We change the state of boolean variables to know if ALT or SUPER are pressed.

	  if(ev.xkey.keycode == ALT_L){
	    alt_pressed=1;
	    fprintf(stdout, "ALT_L pressed\n");
	    swallow_keystroke(display, &ev);
	  }
	  else if(ev.xkey.keycode == SUPER){ 
	    super_pressed=1;
	    fprintf(stdout, "SUPER pressed\n");
	    swallow_keystroke(display, &ev);
	  }

	  // Here are the SUPER + ALT_L + letter keybindings
	  else if(alt_pressed == 1 && super_pressed == 1){
	    if(ev.xkey.keycode == S_KEY){
	      fprintf(stdout, "got SUPER + ALT_L + S : Relative Resize (Special): Height +40px \n");
	      sprintf(callFunction,"%s/launch_cmd.sh cmd_relative_resize_all height +40", cwd);
	      system(callFunction);
	      swallow_keystroke(display, &ev);
	    }
	    else if (ev.xkey.keycode == Q_KEY){
	      fprintf(stdout, "got SUPER + ALT_L + Q : Relative Resize (Special): Width -40px\n");
	      sprintf(callFunction,"%s/launch_cmd.sh cmd_relative_resize_all width -40", cwd);
	      system(callFunction);
	      swallow_keystroke(display, &ev);
	    }
	         
	    else if (ev.xkey.keycode == D_KEY){
	      fprintf(stdout, "got SUPER + ALT_L + D : Relative Resize (Special): Width +40px\n");
	      sprintf(callFunction,"%s/launch_cmd.sh cmd_relative_resize_all width +40", cwd);
	      system(callFunction);
	      swallow_keystroke(display, &ev);
	    }
	         
	    else if (ev.xkey.keycode == Z_KEY){
	      fprintf(stdout, "got SUPER + ALT_L + Z : Relative Resize (Special): Height -40px\n");
	      sprintf(callFunction,"%s/launch_cmd.sh cmd_relative_resize_all height -40", cwd);
	      system(callFunction);
	      swallow_keystroke(display, &ev);
	    }
      	    else if (ev.xkey.keycode == UP){
	      fprintf(stdout, "got SUPER +  ALT_L + UP : Relative Resize : Height -70px\n");
	      sprintf(callFunction,"%s/launch_cmd.sh cmd_relative_resize height bottom -70", cwd);
              system(callFunction);
	      swallow_keystroke(display, &ev);
	    }
	         
	    else if (ev.xkey.keycode == DOWN){
	      fprintf(stdout, "got SUPER +  ALT_L + DOWN : Relative Resize : Height +70px\n");
	      sprintf(callFunction,"%s/launch_cmd.sh cmd_relative_resize height bottom +70", cwd);
              system(callFunction);
	      swallow_keystroke(display, &ev);
	    }
	         
	    else if (ev.xkey.keycode == LEFT){
	      fprintf(stdout, "got SUPER + ALT_L + LEFT : Relative Resize : Width -70px\n");
	      sprintf(callFunction,"%s/launch_cmd.sh cmd_relative_resize width right -70", cwd);
              system(callFunction);
	      swallow_keystroke(display, &ev);
	    }
	    else if (ev.xkey.keycode == RIGHT){
	      fprintf(stdout, "got SUPER + ALT_L + LEFT : Relative Resize : Width +70px\n");
	      sprintf(callFunction,"%s/launch_cmd.sh cmd_relative_resize width right +70", cwd);
              system(callFunction);
	      swallow_keystroke(display, &ev);
	    }
	    /*	    else{
	      fprintf(stdout, "got (something else)+F1, passing through\n");
	      passthru_keystroke(display, &ev);
	    }
	    */

	  }
	  
	
	
	  // Here are the SUPER + letter keybindings
	  else if(super_pressed == 1){
	    if(ev.xkey.keycode == S_KEY){
	      fprintf(stdout, "got SUPER + S : tile half and move on the bottom\n");
	      sprintf(callFunction,"%s/launch_cmd.sh cmd_half_manage bottom", cwd);
              system(callFunction);
	      swallow_keystroke(display, &ev);
	    }
	    else if (ev.xkey.keycode == Q_KEY){
	      fprintf(stdout, "got SUPER + Q : tile half and move on the left\n");
	      sprintf(callFunction,"%s/launch_cmd.sh cmd_half_manage left", cwd);
              system(callFunction);
	      swallow_keystroke(display, &ev);
	    }
	         
	    else if (ev.xkey.keycode == D_KEY){
	      fprintf(stdout, "got SUPER + D : tile half and move on the right\n");
	      sprintf(callFunction,"%s/launch_cmd.sh cmd_half_manage right", cwd);
              system(callFunction);
	      swallow_keystroke(display, &ev);
	    }
	         
	    else if (ev.xkey.keycode == Z_KEY){
	      fprintf(stdout, "got SUPER + Z : tile half and move on the top\n");
	      sprintf(callFunction,"%s/launch_cmd.sh cmd_half_manage top", cwd);
              system(callFunction);
	      swallow_keystroke(display, &ev);
	    }
	    else if (ev.xkey.keycode == F_KEY){
	      fprintf(stdout, "got SUPER + F : full screen\n");
	      sprintf(callFunction,"%s/launch_cmd.sh cmd_half_manage full", cwd);
              system(callFunction);
	      swallow_keystroke(display, &ev);
	    }
      	    else if (ev.xkey.keycode == UP){
	      fprintf(stdout, "got SUPER + UP : relative move : y -70px \n");
	      sprintf(callFunction,"%s/launch_cmd.sh cmd_relative_move y -70", cwd);
              system(callFunction);
	      swallow_keystroke(display, &ev);
	    }
	         
	    else if (ev.xkey.keycode == DOWN){
	      fprintf(stdout, "got SUPER + DOWN : relative move : y +70px\n");
	      sprintf(callFunction,"%s/launch_cmd.sh cmd_relative_move y +70", cwd);
              system(callFunction);
	      swallow_keystroke(display, &ev);
	    }
	         
	    else if (ev.xkey.keycode == LEFT){
	      fprintf(stdout, "got SUPER + LEFT : relative move : x -70px\n");
	      sprintf(callFunction,"%s/launch_cmd.sh cmd_relative_move x -70", cwd);
              system(callFunction);
	      swallow_keystroke(display, &ev);
	    }
	    else if (ev.xkey.keycode == RIGHT){
	      fprintf(stdout, "got SUPER + LEFT : relative move : x +70px\n");
	      sprintf(callFunction,"%s/launch_cmd.sh cmd_relative_move x +70", cwd);
              system(callFunction);
	      swallow_keystroke(display, &ev);
	    }
	    /*	    else if (ev.xkey.keycode == O_KEY){
	      fprintf(stdout, "got SUPER + O\n");
	      sprintf(callFunction,"%s/launch_cmd.sh cmd_relative_move x +70", cwd);
              system(callFunction);
	      swallow_keystroke(display, &ev);
	      }*/
	    else if (ev.xkey.keycode == T_KEY){
	      fprintf(stdout, "got SUPER + T : killing feature (open terminal, or move to terminal, or focus terminal) \n");
	      sprintf(callFunction,"%s/launch_cmd.sh cmd_killing_feature", cwd);
              system(callFunction);
	      swallow_keystroke(display, &ev);
	    }
	    else if (ev.xkey.keycode == KEY_1){
	      fprintf(stdout, "got SUPER + & : tiling in square\n");
	      sprintf(callFunction,"%s/launch_cmd.sh cmd_organise square", cwd);
              system(callFunction);
	      swallow_keystroke(display, &ev);
	    }
	    else if (ev.xkey.keycode == KEY_2){
	      fprintf(stdout, "got SUPER + é : tiling in square with main window in first\n");
	      sprintf(callFunction,"%s/launch_cmd.sh cmd_organise specialSquare", cwd);
              system(callFunction);
	      swallow_keystroke(display, &ev);
	    }
	    else if (ev.xkey.keycode == KEY_3){
	      fprintf(stdout, "got SUPER + \" : tiling in horizontal\n");
	      sprintf(callFunction,"%s/launch_cmd.sh cmd_organise horizontal", cwd);
              system(callFunction);
	      swallow_keystroke(display, &ev);
	    }
	    else if (ev.xkey.keycode == KEY_4){
	      fprintf(stdout, "got SUPER + ' : tiling in vertical\n");
	      sprintf(callFunction,"%s/launch_cmd.sh cmd_organise vertical", cwd);
              system(callFunction);
	      swallow_keystroke(display, &ev);
	    }
	    else if (ev.xkey.keycode == KEY_5){
	      fprintf(stdout, "got SUPER + ( : tiling with main window on left\n");
	      sprintf(callFunction,"%s/launch_cmd.sh cmd_organise spec1", cwd);
              system(callFunction);
	      swallow_keystroke(display, &ev);
	    }
	    else if (ev.xkey.keycode == KEY_6){
	      fprintf(stdout, "got SUPER + - : tiling with main window on top\n");
	      sprintf(callFunction,"%s/launch_cmd.sh cmd_organise spec2", cwd);
              system(callFunction);
	      swallow_keystroke(display, &ev);
	    }
	    else if (ev.xkey.keycode == M_KEY){
	      fprintf(stdout, "got SUPER + M : minimize current window\n");
	      sprintf(callFunction,"%s/launch_cmd.sh cmd_minimize", cwd);
              system(callFunction);
	      swallow_keystroke(display, &ev);
	    }
	    else if (ev.xkey.keycode == C_KEY){
	      fprintf(stdout, "got SUPER + C : close current window\n");
	      sprintf(callFunction,"%s/launch_cmd.sh cmd_close_window", cwd);
              system(callFunction);
	      swallow_keystroke(display, &ev);
	    }
	    else if (ev.xkey.keycode == N_KEY){
	      fprintf(stdout, "got SUPER + N : focus next visible window\n");
	      sprintf(callFunction,"%s/launch_cmd.sh cmd_focus_next_visible_window", cwd);
              system(callFunction);
	      swallow_keystroke(display, &ev);
	    }
	    else if (ev.xkey.keycode == B_KEY){
	      fprintf(stdout, "got SUPER + B : focus last visible window (B:before)\n");
	      sprintf(callFunction,"%s/launch_cmd.sh cmd_focus_last_visible_window", cwd);
              system(callFunction);
	      swallow_keystroke(display, &ev);
	    }

	    /*
	    else{
	      fprintf(stdout, "got (something else)+F1, passing through\n");
	      passthru_keystroke(display, &ev);
	    }
	    */
	  }
	  // If any other key are pressed : 
	  /*
	  else{
	    fprintf(stdout, "got (something else)+F1, passing through\n");
	    passthru_keystroke(display, &ev);
	  }
	  */

	}
	else if(ev.type == KeyRelease){
	  if(ev.xkey.keycode == ALT_L){
	    alt_pressed=0;
	    fprintf(stdout, "ALT_L released\n");
	  }
	  else if(ev.xkey.keycode == SUPER){
	    super_pressed=0;
	    fprintf(stdout, "SUPER released\n");
	  }
	}
	/*
	else{
	  fprintf(stdout, "got (something else)+F1, passing through\n");
	  passthru_keystroke(display, &ev);
	}
	*/
    }
    XUngrabKey(display, SUPER, AnyModifier, DefaultRootWindow(display));
    XUngrabKey(display, ALT_L, AnyModifier, DefaultRootWindow(display));
    XCloseDisplay(display);
    return EXIT_SUCCESS;
	
}


void swallow_keystroke(Display * dpy, XEvent * ev)
{
  XAllowEvents(dpy, AsyncKeyboard, ev->xkey.time);
  /* burp */
}

void passthru_keystroke(Display * dpy, XEvent * ev)
{
  /* pass it through to the app, as if we never intercepted it */
  XAllowEvents(dpy, ReplayKeyboard, ev->xkey.time);
  XFlush(dpy); /* don't forget! */
}

