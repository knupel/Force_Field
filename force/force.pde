 
/**
FORCE
2017-2018
by Stan le Punk
http://stanlepunk.xyz/
Processing 3.3.7
*/
/**
Inspiration

Force Field is a deep refactoring Flow field from The Nature of Code by Daniel Shiffman
http://natureofcode.com

Flow Field Following / Force Field / Vector field 
the link below is not up to date
Via Reynolds: http://www.red3d.com/cwr/steer/FlowFollow.html

Stable fluids from Jos Stam's work on the Navier-Stokes equation
*/
String force_version = "0.3.9";

boolean use_video_cam = false;
int which_cam = 0 ; // 0 is the camera fullsize / max frameRate by default if there is camera plug is the external cam is catch

boolean use_leapmotion = false;

boolean pause_is = false;

boolean external_gui_is = true;
boolean interface_is = true;
boolean hide_menu_bar = true;
boolean inside_gui = false;

int time_count_ff;

int type_field;
int pattern_field;

int num_mask = 4;

PGraphics pg;


/**
SALENGRISTE
*/
boolean full_screen_is = false;
iVec2 size = iVec2(900,500); // Yougtimer CFPTS
iVec2 pos_window = iVec2(0,0); // Yougtimer CFPTS




void settings() {
  String renderer = P3D ;
  if(full_screen_is) {
    fullScreen(renderer,2);
    //fullScreen(P2D);      
  } else {
    size(size.x,size.y,renderer); // taille pour VP Lovetimers
  }
  set_cell_grid_ff(10);
  
  // r.FLUID / r.GRAVITY / r.MAGNATIC 
  type_field = r.STATIC;

  // r.BLANK / r.CHAOS / IMAGE / r.EQUATION
  pattern_field = r.PERLIN;

  if(hide_menu_bar) PApplet.hideMenuBar();
}








/**
SETUP
*/
void setup() {
  info_system();
  println("display connected:",get_display_num());
  if(get_display_num() > 1) {
    // size.set(width,height);
    // set_window_on_other_display(size,0);
    //set_window_on_other_display(iVec2(1920,0),size);
  }

  background(0);

  if(use_leapmotion) leap_setup();

  String s = sketchPath(1);
  // YOUNGTIMER
  /*
  String [] path = new String[1];
  path[0] = (s+"/import/corbeau.svg");
  */
  // ALGORAVE
  String [] path = new String[3];

  path[0] = (s+"/import/algorave_typo.svg");
  path[1] = (s+"/import/algorave_picto.svg");
  path[2] = (s+"/import/algorave_logo.svg");



  set_spot_shape(path);
  set_vehicle_shape(path);

  set_vehicle(get_num_vehicle());

  warp_setup();
  set_info(false); 
  
  set_interface(Vec2(0), Vec2(250,height));
  if(external_gui_is) {
    osc_setup();
  }
  gui_setup(); 
 
  mode_ff();
}





/**
DRAW
*/
boolean init_force;
void draw() {
  if(init_force) {
    if(use_leapmotion) leap_update();
    if(hide_menu_bar) PApplet.hideMenuBar();
    force();
  } else {
    // that's a bullshit organisation, it's just for a specific show
    // iVec2 offset_display = iVec2(get_display_size(target_display).x, get_display_size(target_display).y);
    int target_display = 0 ;
    iVec2 offset_display = iVec2(0, -get_display_size(target_display).y);
    //iVec2 offset_display = iVec2(0, -get_display_size(target_display).y);

    if(get_display_num() > 1) {
      // other
      set_window_on_other_display(pos_window,size,offset_display,CENTER);
    } else {
      // main
      set_window_on_main_display(pos_window,size,CENTER);
    }

    // end of n'importe quoi  
    init_force = true;
  }
}















/**
SUPER DRAW
*/
void force() {
  if(!pause_is || show_must_go_on_is()) time_count_ff++;
  
  if(interface_is() && !external_gui_is) {
    inside_gui = inside(get_pos_interface(), get_size_interface(), Vec2(mouseX,mouseY));
  } else {
    inside_gui = false;
  }

  boolean run_spot_is = true;
  if(pause_is && !mousePressed) {
    run_spot_is = false;  
  } 
  



  // spot coord
  if(run_spot_is || show_must_go_on_is()) {
    num_spot_ff(get_num_spot_gui(),get_range_spot_gui()); 
    if(use_leapmotion) {
      force_field_spot_condition_leapmotion();
      force_field_spot_coord_leapmotion();
    } else {
      force_field_spot_condition(true);
      if(!inside_gui){
        force_field_spot_coord(iVec2(mouseX,mouseY),mousePressed,pause_is);
      } else if(show_must_go_on_is()){
        force_field_spot_coord(iVec2(mouseX,mouseY),false,pause_is);
      } else if(inside_gui && show_must_go_on_is()) {
        force_field_spot_coord(iVec2(mouseX,mouseY),false,show_must_go_on_is());
      } else {
        force_field_spot_coord(iVec2(mouseX,mouseY),false,show_must_go_on_is());
      }
    }
  }

  // spot param
  if(run_spot_is) {
    if(get_type_ff() == r.FLUID) {
      //
    } else if(get_type_ff() == r.MAGNETIC) {
      force_field_spot_diam();
      force_field_spot_tesla();
    } else if(get_type_ff() == r.GRAVITY) {
      force_field_spot_diam();
      force_field_spot_mass();
    } 
    if(!inside_gui || show_must_go_on_is()) {
      update_ff(); 
    } 
  }



  // warp
  warp_init(get_type_ff(), get_pattern_ff(), get_size_cell_ff(), which_cam, change_size_window_is, fullfit_image_is);
  
  // vehicle
  init_vehicle(get_ff());
  


  /** 
  DISPLAY
  */
  // BACKGROUND
  if(display_background_is()) {
    if(get_alpha_background() > 0 ) background_rope(0,get_alpha_background());
  }

  // WARP
  if(display_warp_is()) {
    tint(g.colorModeX,g.colorModeY,g.colorModeZ,get_alpha_warp());
    if(show_must_go_on_is()) {
      warp_draw(get_tempo_refresh_gui(), get_rgba_warp_mapped_gui(), get_power_cycling_gui(), true);
    } else if(!show_must_go_on_is() && pause_is) {
      warp_draw(get_tempo_refresh_gui(), get_rgba_warp_mapped_gui(), get_power_cycling_gui(), false);
    } else {
      warp_draw(get_tempo_refresh_gui(), get_rgba_warp_mapped_gui(), get_power_cycling_gui(), false);
    }
  }

  // FIELD
  if(display_field_is() && !display_info) {
    show_custom_field();
  }
  
  // VEHICLE
  if(display_vehicle_is()) {
    if(!pause_is) {
      update_vehicle(get_ff(), get_velocity_vehicle_gui());
    }
    show_vehicle(get_rgb_vehicle(), get_alpha_vehicle());
  }
  


  // info();

  // SPOT
  if(display_spot_is()) {
    show_spot();
  }

  // REVERSE
  if(force_field != null) force_field.reverse_flow(false);

  // MAPPING
  mask_mapping(set_mask_is(),num_mask);

  // GUI
  if(!external_gui_is) get_controller_gui();
  update_value(time_count_ff);

  interface_display(use_leapmotion,force_field);

  if(!ff_is()) {
    println("new force field grid, with cell size:",get_size_cell_ff());
    init_ff(get_type_ff(),get_pattern_ff(),get_size_cell_ff(),g);
  }

  /**
  MISC
  */
  cursor_manager();
  diaporama(240);  
  media_end();
  save_dial_force(30);
  global_reset();
}





































