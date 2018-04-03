/**
GUI UPDATE
v 0.2.0
*/

boolean news_from_gui;
boolean gui_news_is() {
  return news_from_gui;
}

boolean news_from_gui_ext;
boolean gui_news_ext_is() {
  return news_from_gui_ext;
}


boolean vehicle_reset_gui_is;
boolean field_reset_gui_is;
boolean warp_reset_gui_is;

int ref_cell_size;
int ref_num_vehicle;
int ref_sort_channel;
float ref_warp_value;
void update_value(int t_count) {
  if(gui_news_is() || gui_news_ext_is()) {
    must_update_from_gui(t_count);
  }


  if(!pause_is) {
    must_update_from_app(t_count);
  } else {

  }
}


void must_update_from_gui(int t_count) {
  // reset field
  int size = ceil(cell_force_field) +2;
  int sum_sort_channel = int(x_sort + y_sort +vel_sort);
  if(ref_cell_size != size || sum_sort_channel != ref_sort_channel) {
    set_cell_grid_ff(size);
    ref_cell_size = size;
    ref_sort_channel = sum_sort_channel;
    field_reset_gui_is = true;
  }

  // reset vehicle
  if(ref_num_vehicle != get_num_vehicle()) {
    ref_num_vehicle = get_num_vehicle();
    vehicle_reset_gui_is = true;
  }
  

  boolean update_is = false ;
  update_value_ff_fluid(frequence,viscosity,diffusion,update_is);
  update_value_ff_generative(range_min_gen,range_max_gen,power_gen,update_is);


  float sum_warp_value = red_cycling +green_cycling +blue_cycling +power_cycling 
                        +red_warp +green_warp +blue_warp          +power_warp;
  if(ref_warp_value != sum_warp_value) {
    update_rgba_warp(t_count);
    ref_warp_value = sum_warp_value;
  }

  
  
  set_sorting_channel_ff_2D(floor(x_sort), floor(y_sort), floor(vel_sort));
  
  if(!external_gui_is) {
    set_resize_window(gui_change_size_window_is);
    set_full_reset_field(gui_fullreset_field_is);
    set_fit_image(gui_fullfit_image_is);
    // set_vehicle_pixel_is(get_type_vehicle());
    display_background(gui_display_bg);
    show_must_go_on(gui_show_must_go_on);
  } else {
    /**
    * When the change is from external GUI, the update is done in 
    void catch_osc_data(Object [] data)
    */
    int temp_mode = -1; 
    for(int i = 0 ; i < mode.length; i++) {
      if(mode[i]) {
        temp_mode = i;
      }
    }
    if(temp_mode != -1) set_mode_ff(temp_mode);  
  }
  news_from_gui = false;
  news_from_gui_ext = false;
}


void must_update_from_app(int t_count) {
  update_rgba_warp(t_count);
}







void update_rgb_vehicle() {
	// nothing special at this time
}
































/**
Get and Set GUI data from inside or outside GUI
v 0.0.1
*/
/**
get boolean
*/
boolean get_full_reset_field_is_gui() {
  return gui_full_reset_field_is ;
}

/*
boolean get_vehicle_pixel_is_gui() {
  return gui_vehicle_pixel_is;
}
*/

/**
get int
*/
int get_num_vehicle() {
  int max = max_vehicle_ff ;
  if(get_type_vehicle() == r.PIXEL) max = max_vehicle_ff;
  else if(get_type_vehicle() == SHAPE) max = int(max_vehicle_ff / 250.);
  else max /= 5;
  return int(num_vehicle *num_vehicle *num_vehicle *max);
}

int get_tempo_refresh_gui() {
  return ceil(tempo_refresh);
}

int get_num_spot_gui() {
  return int(spot_num) ;
}

int get_range_spot_gui() {
  return int(spot_range) ;
}

int get_beat_spot() {
  return (int)beat_spot;
}

int get_spiral_spot() {
  return (int) spiral_spot;
}




/** 
get float
*/
float get_alpha_background() {
  return map_colour(alpha_background, g.colorModeA);
}







// field

float get_length_field() {
  return .1 + length_field;
}

float get_alpha_field() {
  return alpha_field;
  // don't mapped on the scale colorMode because the colour is normalized
  // return map_colour(alpha_field, g.colorModeA);
}

float get_thickness_field() {
  return .1 +((thickness_field *thickness_field *thickness_field) *height *.05);
}




// sprite
float get_size_vehicle() {
  float size = 1 +(size_vehicle *height *.1);
  if(get_type_vehicle() == r.PIXEL) size =1;
  if(get_type_vehicle() == TRIANGLE) size *= .5;
  else if(get_type_vehicle() == SHAPE) size *= .2;
  return size;
}

float get_size_spot() {
  float size = 1 +(size_spot *height *.1);
  if(get_type_spot() == r.PIXEL) size =1;
  if(get_type_spot() == TRIANGLE) size *= .5;
  else if(get_type_spot() == SHAPE) size *= .2;
  return size;
}







// vehicle
float get_velocity_vehicle_gui() {
  return velocity_vehicle;
}

float get_alpha_vehicle() {
  return map_colour(alpha_vehicle, g.colorModeA);
}

float get_red_vehicle() {
  return map_colour(red_vehicle, g.colorModeX);
}

float get_green_vehicle() {
  return map_colour(green_vehicle, g.colorModeY);
}
float get_blue_vehicle() {
  return map_colour(blue_vehicle, g.colorModeZ);
}

Vec3 get_rgb_vehicle() {
  return Vec3(get_red_vehicle(), get_green_vehicle(), get_blue_vehicle());
}




// warp
float get_alpha_warp() {
  return map_colour(alpha_warp, g.colorModeA);
}

Vec4 get_rgba_warp_mapped_gui() {
  return rgba_warp;
}

float get_power_cycling_gui() {
  return power_cycling;
}






// spot
float get_alpha_spot() {
  return map_colour(alpha_spot, g.colorModeA);
}

float get_red_spot() {
  return map_colour(red_spot, g.colorModeX);
}

float get_green_spot() {
  return map_colour(green_spot, g.colorModeY);
}
float get_blue_spot() {
  return map_colour(blue_spot, g.colorModeZ);
}

Vec3 get_rgb_spot() {
  return Vec3(get_red_spot(), get_green_spot(), get_blue_spot());
}

float get_speed_spot() {
  return speed_spot *speed_spot *speed_spot;
}

float get_radius_spot() {
  if(width > height) {
    return radius_spot *height *.66;
  } else return radius_spot*width *.66;
}


float get_min_radius_spot() {
  return min_radius_spot;
}

float get_max_radius_spot() {
  return max_radius_spot;
}

float get_motion_spot() {
  return motion_spot *motion_spot *motion_spot *motion_spot *motion_spot;
}

float get_distribution_spot() {
  return distribution_spot;
}




/**
local setting
*/
float map_colour(float mult_f, float max) {
  return map(mult_f,0,1,0.,max);
}




































/**
OSC
Message reception
*/
import oscP5.*;
import netP5.*;
OscP5 osc_reception;
NetAddress destination;



void osc_setup() {
  osc_reception = new OscP5(this,12000);
  destination = new NetAddress("127.0.0.1",12000);
}

void oscEvent(OscMessage theOscMessage) {
  news_from_gui = true;
  news_from_gui_ext = true ;
  if(external_gui_is) {
    println("reception",theOscMessage.arguments().length, frameCount);
    for(int i = 0 ; i < theOscMessage.arguments().length ; i++) {
      println(i, theOscMessage.arguments()[i]);
    }
    catch_osc_data(theOscMessage.arguments());
  }
}


void catch_osc_data(Object [] data) {
  // slider
  alpha_background = (Float)data[0];
  // VECTOR FIELD
  cell_force_field = (Float)data[1];
  // MISC
  tempo_refresh = (Float)data[2];
  // SPOT
  size_spot = (Float)data[3];
  alpha_spot = (Float)data[4];
  red_spot = (Float)data[5];
  green_spot = (Float)data[6];
  blue_spot = (Float)data[7];
  // VEHICLE
  size_vehicle = (Float)data[8];
  alpha_vehicle = (Float)data[9];
  red_vehicle = (Float)data[10];
  green_vehicle = (Float)data[11];
  blue_vehicle = (Float)data[12];
  num_vehicle = (Float)data[13];
  velocity_vehicle = (Float)data[14];
  // WARP IMAGE
  alpha_warp = (Float)data[15];
  red_warp = (Float)data[16];
  green_warp = (Float)data[17];
  blue_warp = (Float)data[18];
  power_warp = (Float)data[19];
  red_cycling = (Float)data[20];
  green_cycling = (Float)data[21];
  blue_cycling = (Float)data[22];
  power_cycling = (Float)data[23];
  // MOVIE
  header_target_movie = (Float)data[24];
  speed_movie = (Float)data[25];
  // FLUID
  frequence = (Float)data[26];
  viscosity = (Float)data[27];
  diffusion = (Float)data[28];
  // generative seting for CHAOS and PERLIN field
  range_min_gen = (Float)data[29];
  range_max_gen = (Float)data[30];
  power_gen = (Float)data[31];
  // SORT IMAGE
  vel_sort = (Float)data[32];
  x_sort = (Float)data[33];
  y_sort = (Float)data[34];
  z_sort = (Float)data[35];
  // SPOT
  spot_num = (Float)data[36];
  spot_range = (Float)data[37];
  radius_spot = (Float)data[38];
  min_radius_spot = (Float)data[39];
  max_radius_spot = (Float)data[40];
  speed_spot = (Float)data[41];
  distribution_spot = (Float)data[42];
  spiral_spot = (Float)data[43];
  beat_spot = (Float)data[44];
  motion_spot = (Float)data[45];

  // FIELD
  colour_field = (int)data[46];
  colour_field_min = (Float)data[47];
  colour_field_max = (Float)data[48];
  length_field = (Float)data[49];
  thickness_field = (Float)data[50];
  alpha_field = (Float)data[51];

  // button
  for(int i = 0 ; i < mode.length ; i++) {
    if((int)data[52+i] == 0) mode[i] = false ; else mode[i] = true;
  }
  
  if((int)data[59] == 0) display_background(false); else display_background(true);
  if((int)data[60] == 0) display_vehicle(false); else display_vehicle(true);
  if((int)data[61] == 0) display_warp(false); else display_warp(true);
  if((int)data[62] == 0) display_field(false); else display_field(true);
  if((int)data[63] == 0) display_spot(false); else display_spot(true);

  if((int)data[64] == 0) set_resize_window(false); else set_resize_window(true);
  if((int)data[65] == 0) set_fit_image(false); else set_fit_image(true);
  if((int)data[66] == 0) show_must_go_on(false); else show_must_go_on(true);
  if((int)data[67] == 0) set_warp_fx_is(false); else set_warp_fx_is(true);
  if((int)data[68] == 0) set_shader_fx_is(false); else set_shader_fx_is(true);
  if((int)data[69] == 0) set_full_reset_field(false); else set_full_reset_field(true);

  type_vehicle = (int)data[70];
  type_spot = (int)data[71];
  int data_target = 72 ;
  if(which_media != (int)data[data_target]) {
    which_media = (int)data[data_target];
    select_media_to_display(); 
  }
}


















