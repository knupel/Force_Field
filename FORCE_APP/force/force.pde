 
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

boolean interface_is = true;
boolean hide_menu_bar = false;
boolean inside_gui = false;

int time_count_ff;

int type_field;
int pattern_field;

int num_mask = 4;

PGraphics pg;



boolean full_screen_is = false;
ivec2 size = ivec2(850,550); // Yougtimer CFPTS
ivec2 pos_window = ivec2(0,0); // Yougtimer CFPTS




void settings() {
  String renderer = P3D ;
  if(full_screen_is) {
    fullScreen(renderer,2);
    hide_menu_bar = true;
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


  background(0);

  if(use_leapmotion) leap_setup();

  project_setup();
  // save_import_path();

  set_spot_shape(path_project_shape);
  set_vehicle_shape(path_project_shape);

  set_vehicle(get_num_vehicle());

  warp_setup();
  set_info(false); 
  
  set_interface(vec2(0), vec2(250,height));
  osc_setup();

  gui_setup(); 
 
  mode_ff();

  sound_system_setup();

  load_last_media_save();

}

void load_last_media_save() {
  movie_warp_is(false);
  add_g_surface();
  load_media_save();
  if(!change_size_window_is) {
    warp.image_library_fit(g, fullfit_image_is);
    warp.image_library_crop(g);
  }
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
    if(dead_list != null) {
      String [] dead_link = split(dead_list,"***");
      text("dead link",20,20);
      for(int i = 0 ; i < dead_link.length ; i++) {
        if(!dead_link[i].equals("null")) text(dead_link[i], 20, 20*(i+1));
      }
    }
  } else {

    if(full_screen_is) {
      init_display_mac_etienne();
    } else {
      init_display_home();
    }
    init_force = true;
  }
}


















/**
SUPER DRAW
*/
void force() {
  if(!pause_is || show_must_go_on_is()) time_count_ff++;
  
  if(interface_is()) {
    inside_gui = inside(get_pos_interface(), get_size_interface(), vec2(mouseX,mouseY));
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
        force_field_spot_coord(ivec2(mouseX,mouseY),mousePressed,pause_is);
      } else if(show_must_go_on_is()){
        force_field_spot_coord(ivec2(mouseX,mouseY),false,pause_is);
      } else if(inside_gui && show_must_go_on_is()) {
        force_field_spot_coord(ivec2(mouseX,mouseY),false,show_must_go_on_is());
      } else {
        force_field_spot_coord(ivec2(mouseX,mouseY),false,show_must_go_on_is());
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
  

  if(!curtain_is()) {
    display_show();
  } else {
    background_rope(r.BLACK,25);
  }
  
  


  // info();



  // REVERSE
  if(force_field != null) force_field.reverse_flow(false);

  // MAPPING
  // mask border
  mask_mapping(set_mask_is());
  /**
  int type_mask = 1 ; // block
  int num_mask = 4 ;
  int point_by_mask = 4 ;
  mask_mapping(set_mask_is(),type_mask,num_mask,point_by_mask);
  */

  // GUI
  update_value(time_count_ff);
  if(interface_is()) {
    interface_display(use_leapmotion,force_field);
  }

  if(!ff_is()) {
    println("new force field grid, with cell size:",get_size_cell_ff());
    init_ff(type_field,pattern_field,get_size_cell_ff(),g);
  }

  /**
  MISC
  */
  // sound_system_update();
  cursor_manager();
  diaporama(240);  
  force_import_update();
  save_dial_force(30);
  global_reset();
}



void display_show() {
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
  if(get_renderer() == P3D) {
    start_matrix();
    translateZ(1);
  }
  // SPOT
  if(display_spot_is()) {
    show_spot();
  }

  // VEHICLE
  if(display_vehicle_is()) {
    if(!pause_is) {
      update_vehicle(get_ff(), get_velocity_vehicle_gui());
    }
    show_vehicle(get_rgb_vehicle(), get_alpha_vehicle());
  }

  // OTHER
  if(display_other_is()) {
    show_other();
    if(use_sound_is()) sound_system_draw();
  }

  if(get_renderer() == P3D) {
    stop_matrix();
  }
}





































