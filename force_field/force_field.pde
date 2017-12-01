
/**
FORCE FIELD
by Stan le Punk
http://stanlepunk.xyz/
v 0.0.4
*/
/**
Force Field is a refactoring Flow field from The Nature of Code by Daniel Shiffman
http://natureofcode.com

Flow Field Following / Force Field / Vector field 
the link below is not up to date
Via Reynolds: http://www.red3d.com/cwr/steer/FlowFollow.html

Stable fluids from Jos Stam's work on the Navier-Stokes equation
*/
boolean pause_is ;

PGraphics pg ;

int size_cell ;
int type_field;



// Using this variable to decide whether to draw all the stuff
void settings() {
  size(400,400,P2D);
  // fullScreen(1) ;
  init_rope();

  size_cell = 10;
 // type_field = r.FLUID;
  // type_field = r.GRAVITY; /* you can also use HOLE constant */
  type_field = r.MAGNETIC;
  // type_field = r.PERLIN;
// type_field = r.CHAOS;
}



/**

PROBLEM TO GO FROM MOVIE TO PICTURE, when the we try to load a new pics

PROBLEM TO GO FROM MOVIE TO PICTURE, when the we try to load a new pics

PROBLEM TO GO FROM MOVIE TO PICTURE, when the we try to load a new pics

PROBLEM TO GO FROM MOVIE TO PICTURE, when the we try to load a new pics

PROBLEM TO GO FROM MOVIE TO PICTURE, when the we try to load a new pics

PROBLEM TO GO FROM MOVIE TO PICTURE, when the we try to load a new pics

PROBLEM TO GO FROM MOVIE TO PICTURE, when the we try to load a new pics

PROBLEM TO GO FROM MOVIE TO PICTURE, when the we try to load a new pics

PROBLEM TO GO FROM MOVIE TO PICTURE, when the we try to load a new pics

PROBLEM TO GO FROM MOVIE TO PICTURE, when the we try to load a new pics

PROBLEM TO GO FROM MOVIE TO PICTURE, when the we try to load a new pics

PROBLEM TO GO FROM MOVIE TO PICTURE, when the we try to load a new pics

*/












/**
SETUP

*/
void setup() {
  background(0);
  // noCursor();
  // warp_instruction();

  /**
  force field setting
  Choice which vector you want use
  */



  /**
  warp force field
  */
  warp_setup();

  /**
  classic build
  */
  // build_force_field(type_field,size_cell);

  /**
  vehicle example
  */
  
  /*
  int num_vehicle = 1000;
  build_vehicle(num_vehicle);
  */
  set_info(false);
}


/**
DRAW

*/
void draw() {
  warp_init(type_field, size_cell) ;
  
  // background_rope(0,10);
  //  println(frameRate);
  //  if(mousePressed) cursor(CROSS); else noCursor();
  if(!pause_is) update_force_field(); 
  cursor(CROSS);

 //  if(mouseY >= width) println(mouseY, width); else println(mouseY);

  warp_draw();
   
   /**
   INFO
   */
  info(display_field, display_grid, display_pole);

  /**
  RESET
  */

  if(force_field != null) force_field.reverse_is(false);
  // reset_force_field();
}
/**
END DRAW
*/

























/**
KEYPRESSED

*/


void keyPressed() {
  if(key == 'a') {
    warp_add_media();
  }

  if(key == 'b') manage_border();

  if(key == 'f') display_field();

  if(key == 'g') display_grid();

  if(key == 'h') display_pole();

  if(key == 'i') display_info();

  if(key == 'n') {
    warp_change_media();
  }

  if(key == 'p') {
    println("export jpg");
    saveFrame();   
  }

  if(key == 'r') {
    reset_vehicle();
    warp.reset(); 
    force_field.refresh();  
  }

  if(key == 'w') {
    if(shader_filter_is) shader_filter_is = false ; else shader_filter_is = true ;
  }

  if(key == 'z') {
    force_field.reset();
  }

  if(key == ' ') {
    if(pause_is) pause_is = false ; else pause_is = true ;
  }
  

  // navigation in the media movie or picture
  if(keyCode == UP) { 
    which_img++;
    /*
    we don't use 0 to the first element of the array because this one is use for G / surface
    see void warp_init(int type_field, int size_cell) 
    */
    if(which_img >= warp.library_size()) which_img = 1 ;
    if(movie_warp_list != null) {
      which_movie++;
      if(which_movie >= movie_warp_list.size()) which_movie = 0 ;
    }
    
  }

  if(keyCode == DOWN) { 
    which_img--; 
    /*
    we don't use 0 to the first element of the array because this one is use for G / surface
    see void warp_init(int type_field, int size_cell) 
    */
    if(which_img < 1) which_img = warp.library_size() -1 ;
    if(movie_warp_list != null) {
      which_movie--;
      if(which_movie < 0) which_movie = movie_warp_list.size() -1 ;
    }       
  }
}


















