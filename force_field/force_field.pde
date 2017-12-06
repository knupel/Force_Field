
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
  size(640,480,P2D);
  // fullScreen(1) ;
  init_rope();

  size_cell = 10;
type_field = r.FLUID;
  // type_field = r.GRAVITY; /* you can also use HOLE constant */
// type_field = r.MAGNETIC;
 // type_field = r.PERLIN;
// type_field = r.CHAOS;
}






/**
SETUP

*/
void setup() {
  background(0);
  // noCursor();
  // warp_instruction();
  interface_setup();

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
  // num_spot_force_field(2); 

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
  // println("library", warp.library_size());
  cursor(CROSS);
  /*
  interface
  */
  if(!pause_is && !interface_is()) {
    force_field_spot_condition();
    force_field_spot_coord();
    
    update_force_field(); 
  }

  /*
  warp
  */
  warp_init(type_field, size_cell);
  warp_init_spot(4);
  // video_draw();
  warp_draw(tempo_display, rgba_channel);
   
   /**
   INFO
   */
  info(display_field, display_grid, display_pole);

  /**
  RESET
  */

  if(force_field != null) force_field.reverse_is(false);
  // reset_force_field();

  interface_value();
}
/**
END DRAW
*/


void force_field_spot_coord() {
  Vec2 pos_1 = Vec2(mouseX,mouseY);
  Vec2 pos_2 = Vec2(width -mouseX, height -mouseY);
  Vec2 pos_3 = Vec2(mouseX, height -mouseY);
  Vec2 pos_4 = Vec2(width -mouseX, mouseY);
  update_force_field_spot_coord(pos_1,pos_2,pos_3,pos_4);
}


void force_field_spot_condition() {
  boolean bool_1 = false ;
  boolean bool_2 = false ;
  boolean bool_3 = false ;
  boolean bool_4 = false ;
  boolean bool_5 = false ;
  // if(mousePressed && mouseButton == LEFT) bool_1 = true ;
  // if(mousePressed && mouseButton == RIGHT) bool_2 = true ;
  if(mousePressed) {
    bool_1 = true ;
    bool_2 = true ;
    bool_3 = true ;
    bool_4 = true ;
  }
  update_force_field_spot_is(bool_1, bool_2, bool_3, bool_4);
}


void force_field_spot_radius() {
  int rad_1 = 30;
  int rad_2 = 30;
  int rad_3 = 30;
  int rad_4 = 30;
  update_force_field_spot_radius(rad_1,rad_2,rad_3,rad_4);
}

void force_field_spot_tesla() {
  int tsl_1 = 30;
  int tsl_2 = -30;
  int tsl_3 = 30;
  int tsl_4 = -30;
  update_force_field_spot_tesla(tsl_1,tsl_2,tsl_3,tsl_4);
}

void force_field_spot_mass() {
  int m_1 = 30;
  int m_2 = 30;
  int m_3 = 30;
  int m_4 = 30;
  update_force_field_spot_mass(m_1,m_2,m_3,m_4);
}






















/**
KEYPRESSED

*/


void keyPressed() {
  println("keyPressed", frameCount);
  if(key == 'a') {
    // @see if(key == 'n')
    warp_add_media_folder();
    play_video(false);
  }

  if(key == 'b') manage_border();

  if(key == 'c') hide_interface();

  if(key == 'f') display_field();

  if(key == 'g') display_grid();

  if(key == 'h') display_pole();

  if(key == 'i') display_info();

  if(key == 'n') {
    // @see if(key == 'a')
    warp_change_media_folder();
    play_video(false);
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

  if(key == 'v') play_video_switch();

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


















