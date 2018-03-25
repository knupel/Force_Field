
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
String force_version = "0.3.2";
boolean external_gui_is = true;

boolean use_leapmotion = false;

boolean pause_is = false;

boolean fullScreen_is = false;



boolean interface_is = true;
boolean hide_menu_bar = false;
boolean inside_gui = false;

int time_count_ff;

PGraphics pg;

int type_field;
int pattern_field;

int which_cam = 0 ; // 0 is the camera fullsize / max frameRate by default if there is camera plug is the external cam is catch

void settings() {
  if(fullScreen_is) {
    // fullScreen(P2D,1);
    fullScreen(P2D);      
  } else {
    size(1200,750,P2D);
    // size(800,800,P2D);
    //size(1600,870,P2D); // 2eme écran macbook
    // size(1900,1200,P2D); // 2 recopie écran macbook

  }
  set_cell_grid_ff(10);
  // type_field = r.FLUID;
  // type_field = r.GRAVITY; /* you can also use HOLE constant */
  // type_field = r.MAGNETIC;
  type_field = r.STATIC;

  // pattern_field = r.BLANK;
  pattern_field = r.PERLIN;
  // pattern_field = r.CHAOS;
  // pattern_field = IMAGE;

  if(hide_menu_bar) PApplet.hideMenuBar();
}








/**
SETUP
*/
void setup() {
  info_system();
    if(!fullscreen_is) {
    int offset_x = 30 ;
    int offset_y = 50 ;
    surface.setLocation(get_display_size().x -width -offset_x, offset_y);
  }

  background(0);

  if(use_leapmotion) leap_setup();

  set_vehicle(get_num_vehicle_gui());
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
boolean first_draw_round;
void draw() {
  if(first_draw_round) {
    super_draw();
  } else {
    background(0);
    first_draw_round = true;
  }
}

void super_draw() {
  if(!pause_is || show_must_go_on_is()) time_count_ff++;
  if(hide_menu_bar) PApplet.hideMenuBar();
  if(use_leapmotion) leap_update();

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
  DISPLAY RESULT
  */
  if(display_background_is()) {
    if(get_alpha_bg() > 0 ) background_rope(0,get_alpha_bg());
  }

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
  if(display_vehicle_is()) {
    if(!pause_is) {
      update_vehicle(get_ff(),get_velocity_vehicle_gui());
    }
    show_vehicle(get_rgb_vehicle_gui(), get_alpha_vehicle());
  } 



  

   
  
   
  





  /**
  INFO
   */
  info(display_field, display_grid, display_spot);

  if(force_field != null) force_field.reverse_flow(false);





  /**
  GUI
  interface gui
  */
  mask_mapping(set_mask_is());

  if(!external_gui_is) get_controller_gui();
  if(gui_news_is() || gui_news_ext_is()) update_gui_value(false, time_count_ff);
  interface_display(use_leapmotion, force_field);

  if(!ff_is()) {
    println("new force field grid, with cell size:", get_size_cell_ff());
    init_ff(get_type_ff(),get_pattern_ff(),get_size_cell_ff(),g);
  }
  /*
  if(get_type_ff() == IMAGE) {
    if(!sort_channel_is()) {
      force_field_init_is = false ;
      build_ff(force_field.get_type(), get_resolution_ff(), warp.get_image(), get_sorting_channel_ff_2D());
      update_ff();
    }
  }
  */

  cursor_manager();
  diaporama(240);  
  media_end();
  save_value_app_too_controller(60);

  if(reset_authorization_from_gui) {
    global_reset();
    reset_authorization_from_gui = false ;
  }
}





































