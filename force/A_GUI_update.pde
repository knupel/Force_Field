/**
OSC
Message reception
*/
import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress destination;

void osc_setup() {
  oscP5 = new OscP5(this,12000);
  destination = new NetAddress("127.0.0.1",12000);
}

void oscEvent(OscMessage theOscMessage) {
   println("type", theOscMessage.typetag());
   if(external_gui_is) {
    print("Message from address pattern",theOscMessage.addrPattern());
    catch_osc_data(theOscMessage.arguments());
  }
}


void catch_osc_data(Object [] data) {
  /*
  alpha_bg = float(data[0]);
  // VECTOR FIELD
  cell_force_field = float(data[1]);
  // MISC
  tempo_refresh = float(data[2]);
  // VEHICLE
  alpha_vehicle = float(data[3]);
  red_vehicle = float(data[4]);
  green_vehicle = float(data[5]);
  blue_vehicle = float(data[6]);
  num_vehicle = float(data[7]);
  velocity_vehicle = float(data[9]);
  // WARP IMAGE
  alpha_warp = float(data[9]);
  red_warp = float(data[10]);
  green_warp = float(data[11]);
  blue_warp = float(data[12]);
  power_warp = float(data[13]);
  red_cycling = float(data[14]);
  green_cycling = float(data[15]);
  blue_cycling = float(data[16]);
  power_cycling = float(data[17]);
  // MOVIE
  header_movie = float(data[18]);
  speed_movie = float(data[19]);
  // FLUID
  frequence = float(data[20]);
  viscosity = float(data[21]);
  diffusion = float(data[22]);
  // generative seting for CHAOS and PERLIN field
  range_min_gen = float(data[23]);
  range_max_gen = float(data[24]);
  power_gen = float(data[25]);
  // SORT IMAGE
  vel_sort = float(data[26]);
  x_sort = float(data[27]);
  y_sort = float(data[28]);
  z_sort = float(data[29]);
  // SPOT
  spot_num = float(data[30]);
  spot_range = float(data[31]);
  radius_spot = float(data[32]);
  min_radius_spot = float(data[33]);
  max_radius_spot = float(data[34]);
  speed_spot = float(data[35]);
  distribution_spot = float(data[36]);
  spiral_spot = float(data[37]);
  beat_spot = float(data[38]);
  motion_spot = float(data[39]);
  */
}



/**
Get and Set GUI data from inside or outside GUI
v 0.0.1
*/
Vec4 rgba_warp = Vec4(1);
float power_warp_max;
/**
set GUI 
value slider in the draw
*/
void set_pos_movie_norm_gui(float f) {
  movie_pos_normal = f;
}

/**
get GUI
*/

/**
get boolean
*/
boolean get_full_reset_field_is_gui() {
  return gui_full_reset_field_is ;
}

boolean get_vehicle_pixel_is_gui() {
  return gui_vehicle_pixel_is;
}

/**
get int
*/
int get_num_vehicle_gui() {
  return int(num_vehicle *num_vehicle *num_vehicle * max_vehicle_ff);
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
float get_velocity_vehicle_gui() {
  return velocity_vehicle;
}

float get_red_vehicle_gui() {
  return red_vehicle;
}
float get_green_vehicle_gui() {
  return green_vehicle;
}
float get_blue_vehicle_gui() {
  return blue_vehicle;
}

Vec3 get_rgb_vehicle_gui() {
  return Vec3(red_vehicle,green_vehicle,blue_vehicle);
}

Vec4 get_rgba_warp_mapped_gui() {
  return rgba_warp;
}

/*
Vec3 get_rgb_channel_mapped_gui() {
  return rgb_channel;
}
*/


float get_power_cycling_gui() {
  return power_cycling;
}



float get_pos_movie_norm_gui() {
  return movie_pos_normal ;
}

float get_speed_movie_gui() {
  return speed_movie ;
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
GUI update
v 0.1.0
*/

boolean reset_authorization_from_gui ;
int ref_cell_size;
int ref_num_vehicle;
int ref_sort_channel;
void update_gui_value(boolean update_is, int t_count) {
	int size = ceil(cell_force_field) +2;
	int sort_channel_sum = int(x_sort + y_sort +vel_sort);
	if(ref_cell_size != size || ref_num_vehicle != get_num_vehicle_gui() || sort_channel_sum != ref_sort_channel) {
		set_cell_grid_ff(size);
		ref_cell_size = size;
		ref_num_vehicle = get_num_vehicle_gui();
		ref_sort_channel = sort_channel_sum;
    reset_authorization_from_gui = true;
	}

	update_value_ff_fluid(frequence,viscosity,diffusion,update_is);
	update_value_ff_generative(range_min_gen,range_max_gen,power_gen,update_is);

  set_alpha_background(alpha_bg);
  
  set_alpha_vehicle(alpha_vehicle);
  // nothing special at this time
  update_rgb_vehicle();
  

  set_alpha_warp(alpha_warp);
	update_rgba_warp(t_count);
  
  set_sorting_channel_ff_2D(floor(x_sort), floor(y_sort), floor(vel_sort));

  set_resize_window(gui_change_size_window_is);
  set_full_reset_field(gui_fullreset_field_is);
  set_fit_image(gui_fullfit_image_is);
  set_vehicle_pixel_is(gui_vehicle_pixel_is);

  display_bg(gui_display_bg);
  show_must_go_on(gui_show_must_go_on);
}

void update_rgb_vehicle() {
	// nothing special at this time
}

void update_rgba_warp(int t_count) {
	float cr = 1.;
  float cg = 1.;
  float cb = 1.;
  if(red_cycling != 0) {
  	cr = sin(t_count *(red_cycling *red_cycling *.1)); 
  }
  if(green_cycling != 0) {
  	cg = sin(t_count *(green_cycling *green_cycling *.1)); 
  }
  if(blue_cycling != 0) {
  	cb = sin(t_count *(blue_cycling *blue_cycling *.1)); 
  }
  

  Vec4 sin_val = Vec4(1);
  sin_val.set(cr,cg,cb,1);

	rgba_warp.set(red_warp,green_warp,blue_warp,1);
	power_warp_max = (power_warp *power_warp) *10f;
  
	rgba_warp.mult(power_warp_max);
	
	float min_src = 0 ;
	float max_src = 1 ;
	float min_dst = .01 ;
	rgba_warp.set(sin_val.map_vec(Vec4(min_src), Vec4(max_src), Vec4(min_dst), rgba_warp));
}
