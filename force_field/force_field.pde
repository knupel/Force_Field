
/**
FORCE FIELD
2017-2018
by Stan le Punk
http://stanlepunk.xyz/
v 0.1.0
*/
/**
Force Field is a deep refactoring Flow field from The Nature of Code by Daniel Shiffman
http://natureofcode.com

Flow Field Following / Force Field / Vector field 
the link below is not up to date
Via Reynolds: http://www.red3d.com/cwr/steer/FlowFollow.html

Stable fluids from Jos Stam's work on the Navier-Stokes equation
*/
boolean pause_is ;
boolean use_leapmotion = false;

boolean fullScreen_is = false;
boolean change_size_window_is = false;
boolean fullfit_image_is = true;

boolean display_bg = false;
boolean display_result_warp = false;
boolean display_result_vehicle = false;

boolean hide_menu_bar = false;




PGraphics pg;

int type_field;

int which_cam = 0 ; // 0 is the camera fullsize / max frameRate by default if there is camera plug is the external cam is catch
boolean inside_gui;

// Using this variable to decide whether to draw all the stuff
void settings() {
  if(fullScreen_is) {
    // fullScreen(P2D,1);
    fullScreen(P2D);      
  } else {
    size(1200,750,P2D);
    //size(1600,870,P2D); // 2eme écran macbook
    // size(1900,1200,P2D); // 2 recopie écran macbook
  }
  set_cell_grid_ff(10);
  // type_field = r.FLUID;
  //  type_field = r.GRAVITY; /* you can also use HOLE constant */
  type_field = r.MAGNETIC;
  //type_field = r.PERLIN;
  // type_field = r.CHAOS;
 // type_field = IMAGE;

  if(hide_menu_bar) PApplet.hideMenuBar();
}








/**
SETUP

*/
void setup() {
  info_system();
  background(0);
  // noCursor();

  if(use_leapmotion) leap_setup();

  /**
  force field setting
  Choice which vector you want use
  */

  /**
  vehicle
  */
  set_vehicle(1000);



  /**
  warp force field
  */
  warp_setup();
  
  set_info(false);
  interface_setup(Vec2(0), Vec2(250,height));
  warp_instruction(); 
}





/**
DRAW

*/
void draw() {
  println("vehicle",display_vehicle_is());
  println("warp",display_warp_is());
  println("background",display_bg_is());
  println("alpha bg",get_alpha_bg());
  println("alpha warp",get_alpha_warp());
  println("alpha vehicle",get_alpha_vehicle());

  if(hide_menu_bar) PApplet.hideMenuBar();
  // cursor(CROSS);
  if(use_leapmotion) leap_update();

  if(interface_is()) {
    inside_gui = inside(get_pos_interface(), get_size_interface(), Vec2(mouseX,mouseY));
  } else {
    inside_gui = false;
  }

  boolean run_is = true;
  if(pause_is) run_is = false ;


  /**
  SPOT
  update spot coord
  */
  if(run_is) {
    if(use_leapmotion) {
      force_field_spot_condition_leapmotion();
      force_field_spot_coord_leapmotion();
    } else {
      force_field_spot_condition(true);
      if(!inside_gui){
        force_field_spot_coord(iVec2(mouseX,mouseY),mousePressed);
      } else {
        force_field_spot_coord(iVec2(mouseX,mouseY),false);
      }
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










  /**
  WARP
  warp management
  */
  warp_init(type_field, get_size_cell_ff(), which_cam, change_size_window_is, fullfit_image_is);
  num_spot_ff(get_num_spot_gui()); 
  /*
  warp result
  */

  /**
  VEHICLE
  */
  init_vehicle(get_ff());
  


  /** 
  DISPLAY RESULT
  */

  if(display_bg_is()) {
    if(get_alpha_bg() > 0 ) background_rope(0,get_alpha_bg());
  }
  // if(display_is()) {
    // tint(g.colorModeX,g.colorModeY,g.colorModeZ,get_alpha_bg());
  if(display_warp_is()) {
    // tint(g.colorModeX,g.colorModeY,g.colorModeZ,get_alpha_bg());
    tint(g.colorModeX,g.colorModeY,g.colorModeZ,get_alpha_warp());
    warp_draw(get_tempo_refresh_gui(), get_rgba_channel_mapped_gui(), get_warp_power_gui());
  }
  if(display_vehicle_is()) {
    update_vehicle(get_ff());
    show_vehicle();
  } 
/*
  if(display_warp_is() || display_vehicle_is()) {
    tint(g.colorModeX,g.colorModeY,g.colorModeZ,get_alpha_bg());
  }
  */
//  } 


  

   
  
   
  





  /**
   INFO
   */
  info(display_field, display_grid, display_pole);

  if(force_field != null) force_field.reverse_flow(false);




  /**
  GUI
  interface gui
  */
  get_controller_gui();
  update_gui_value(false);
  interface_display(use_leapmotion, force_field);

  if(!ff_is()) {
    println("new force field grid, with cell size:", get_size_cell_ff());
    init_ff(get_type_ff(),get_size_cell_ff(),g);
  }
  
  if(get_type_ff() == IMAGE) {
    if(!sort_channel_is()) {
      force_field_init_is = false ;
      build_ff(force_field.get_type(), get_resultion_ff(), warp.get_image(), get_sorting_channel_ff_2D());
      update_ff();
    }
  }

  cursor_manager(interface_is());

  diaporama(240);

  if(media_add_is()) {
    reset_key();
    media_ready_to_add();
  }
}

































