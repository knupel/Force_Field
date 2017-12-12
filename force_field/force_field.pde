
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
boolean use_leapmotion = true;

boolean fullScreen_is = false;
boolean change_size_window_is = false;

PGraphics pg ;


int type_field;

int which_cam = 0 ; // 0 is the camera fullsize / max frameRate by default if there is camera plug is the external cam is catch


// Using this variable to decide whether to draw all the stuff
void settings() {
  if(fullScreen_is) {
    fullScreen(P2D) ;   
  } else {
    size(640,480,P2D);
  }
  set_cell_grid_ff(10);

  type_field = r.FLUID;

//   type_field = r.GRAVITY; /* you can also use HOLE constant */
//type_field = r.MAGNETIC;
 // type_field = r.PERLIN;
// type_field = r.CHAOS;
}








/**
SETUP

*/
void setup() {
  background(0);
  noCursor();
  // warp_instruction();

  if(use_leapmotion) leap_setup();

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
  interface_setup(Vec2(0), Vec2(200,height));
}


/**
DRAW

*/
void draw() {
  // cursor(CROSS);
  if(use_leapmotion) leap_update();

  /*
  update force field
  */
  /* 
  condition to update force field
  */
  boolean run_is = true;
  boolean inside_gui = inside(get_pos_interface(), get_size_interface(), Vec2(mouseX,mouseY));
  if(inside_gui) run_is = false ;
  if(interface_is() && inside_gui) run_is = false ;
  if(!interface_is()) run_is = true ;
  if(use_leapmotion) run_is = true ;
  if(pause_is) run_is = false ;


  if(run_is) { 
    if(use_leapmotion) {
      force_field_spot_condition_leapmotion();
      force_field_spot_coord_leapmotion();
    } else {
      force_field_spot_condition();
      force_field_spot_coord();
    }

    if(get_type_ff() == r.FLUID) {
      //
    } else if(get_type_ff() == r.MAGNETIC) {
      force_field_spot_diam();
      force_field_spot_tesla();
    } else if(get_type_ff() == r.GRAVITY) {
      force_field_spot_diam();
      force_field_spot_mass();
    }   
    update_ff(); 
  }

  /*
  warp
  */
  warp_init(type_field, get_size_cell_ff(), which_cam, change_size_window_is);
  // println(ff_is());


  num_spot_ff(4); 
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
  interface_display(Vec2(0), Vec2(200,height));
    if(!ff_is()) {
    println("new force field grid");
    init_ff(get_type_ff(),get_size_cell_ff(),g);
  }

}
/**
END DRAW
*/




Vec2 [] pos_finger ;
void force_field_spot_coord_leapmotion() {
  // init var
  if(pos_finger == null && get_spot_num_ff() > 0) {
    pos_finger = new Vec2[get_spot_num_ff()];
    for(int i = 0 ; i < pos_finger.length ; i++) {
      pos_finger[i] = Vec2(width/2,height/2);
    }
  }

  if(finger.is() && pos_finger != null) {
    for(int i = 0 ; i < finger.get_num() && i < get_spot_num_ff() ; i++) {
      if(finger.visible()[i]) {
        float x = finger.get_pos()[i].x;
        float y = finger.get_pos()[i].y;
        y = map(y,0,1,1,0);
        pos_finger[i] = Vec2(x,y);
        pos_finger[i].mult(width,height);
      }
    }
    update_spot_ff_coord(pos_finger);
  }
}


void force_field_spot_condition_leapmotion() {
  if(get_spot_num_ff() > 0) {
    boolean [] bool = new boolean[get_spot_num_ff()];
    for(int i = 0 ; i < bool.length ; i++) {
      bool[i] = false ;
    }
    // if(mousePressed && mouseButton == LEFT) bool_1 = true ;
    // if(mousePressed && mouseButton == RIGHT) bool_2 = true ;
    if(finger.is()) {
      for(int i = 0 ; i < finger.get_num() && i < get_spot_num_ff() ; i++) {
        if(finger.visible()[i]) bool[i] = true ; else bool[i] = false ;
      }
    }
    update_spot_ff_is(bool);
  }
}

void force_field_spot_coord() {
  Vec2 pos_1 = Vec2(mouseX,mouseY);
  Vec2 pos_2 = Vec2(width -mouseX, height -mouseY);
  Vec2 pos_3 = Vec2(mouseX, height -mouseY);
  Vec2 pos_4 = Vec2(width -mouseX, mouseY);
  update_spot_ff_coord(pos_1,pos_2,pos_3,pos_4);
}

void force_field_spot_condition() {
  if(get_spot_num_ff() > 0) {
    boolean [] bool = new boolean[get_spot_num_ff()];
    for(int i = 0 ; i < bool.length ; i++) {
      bool[i] = false ;
    }
    // if(mousePressed && mouseButton == LEFT) bool_1 = true ;
    // if(mousePressed && mouseButton == RIGHT) bool_2 = true ;
    if(mousePressed) {
      for(int i = 0 ; i < bool.length ; i++) {
        bool[i] = true ;
      }
    }
    update_spot_ff_is(bool);
  }
}


void force_field_spot_diam() {
  int size = get_resultion_ff()/2 ;
  int rad_1 = size;
  int rad_2 = size;
  int rad_3 = size;
  int rad_4 = size;
  update_spot_ff_diam(rad_1,rad_2,rad_3,rad_4);
}

void force_field_spot_tesla() {
  int tesla = 10 ;
  int tsl_1 = tesla;
  int tsl_2 = -tesla;
  int tsl_3 = tesla;
  int tsl_4 = -tesla;
  update_spot_ff_tesla(tsl_1,tsl_2,tsl_3,tsl_4);
}

void force_field_spot_mass() {
  int m_1 = 30;
  int m_2 = 100;
  int m_3 = 30;
  int m_4 = 10;
  update_spot_ff_mass(m_1,m_2,m_3,m_4);
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


















