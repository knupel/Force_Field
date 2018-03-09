/**
Interface force field 
2017-2018
http://stanlepunk.xyz/
v 0.3.0
*/
import controlP5.*;
ControlP5 gui_main; 
CheckBox check_gui_main_channel, check_gui_main ;

ControlP5 gui_static_img_2D,gui_static_img_3D;

ControlP5 gui_static_generative;


ControlP5 gui_dynamic_mag_grav;
CheckBox check_gui_dynamic_mag_grav_reset ;

ControlP5 gui_dynamic_fluid;
ControlP5 gui_dynamic_mouse, gui_main_movie;

ControlP5 gui_vehicle;


// global slider
boolean gui_fullreset_field_is = false;
boolean abs_cycling = true;
boolean gui_resize_window = false;
boolean gui_fullfit_image = true;
boolean gui_display_bg = true;
boolean gui_show_must_go_on = true;




Vec2 pos_gui ;
Vec2 size_gui ;

int space_interface ;

PFont font_gui ;

/**
setup
*/
void interface_setup(Vec2 pos, Vec2 size) {
	int size_font = 10 ;
	font_gui = createFont("Lucida",size_font,false); // use true/false for smooth/no-smooth
	// font_gui = createFont("ArialNarrow",size_font,false); // use true/false for smooth/no-smooth
	// PFont pfont = createFont("DIN-Light",8,false); // use true/false for smooth/no-smooth

	pos_gui = pos.copy();
	size_gui = size.copy();
	int slider_width = 100 ;
	space_interface = ceil(font_gui.getSize() *1.5) ;
	int max = 1;

  // main
  gui_main(space_interface, max, slider_width, 1, TOP, font_gui);
  gui_main_movie(space_interface, max, slider_width, 2, BOTTOM, font_gui);
  
  // menu static field
  gui_static_generative(space_interface, max, slider_width, 29.5, TOP, font_gui);
  gui_static_image(space_interface, max, slider_width, 33, TOP, font_gui);

  // menu dynamic field
  gui_dynamic_fluid(space_interface, max, slider_width, 29.5, TOP, font_gui);
  gui_dynamic_mag_grav(space_interface, max, slider_width, 29.5, TOP, font_gui);

  gui_dynamic_mouse(space_interface, max, slider_width, 33, TOP, font_gui);

  // vehicle
  gui_vehicle(space_interface, max, slider_width, 41.5, TOP, font_gui);

}













// main
float alpha_bg;
float alpha_vehicle;
float alpha_warp;

float red_vehicle;
float green_vehicle;
float blue_vehicle;

Vec4 rgba_warp ;
float red_warp;
float green_warp;
float blue_warp;
float power_warp;
float power_warp_max;

float red_cycling;
float green_cycling;
float blue_cycling;
float power_cycling;

float tempo_refresh;

float cell_force_field;

float spot_num;
float spot_range;

void gui_main(int space, int max, int w, float start_pos, int from, PFont font) {
	gui_main = new ControlP5(this);

	alpha_bg = 1.;
	alpha_vehicle = 1.;
	red_vehicle = .9;
	green_vehicle = 0;
	blue_vehicle = 0;

	alpha_warp = 1.;
	rgba_warp = Vec4(1);
	red_warp = .9;
	green_warp = .9;
	blue_warp = .9;
	power_warp = .37;

	red_cycling = 0;
	green_cycling = 0;
	blue_cycling = 0;
	power_cycling = .35;

  tempo_refresh = 1.;
	cell_force_field = 25.;
	spot_num = 2.;
	spot_range = 2.;

	check_gui_main = gui_main.addCheckBox("main_setting").setPosition(10,pos_slider_y(space, start_pos +0, from)).setSize(w/3,10).setItemsPerRow(1).setSpacingRow(space/2)
														.addItem("resize_window",1).addItem("fit_image",1).addItem("background",1).addItem("show must go on",1);
  if(change_size_window_is) check_gui_main.activate(0);
  if(fullfit_image_is) check_gui_main.activate(1);
  if(display_bg) check_gui_main.activate(2);
  if(show_must_go_on) check_gui_main.activate(3);

  gui_main.addSlider("alpha_bg").setPosition(10,pos_slider_y(space, start_pos +4.5, from)).setWidth(w).setRange(0,max).setFont(font);
  gui_main.addSlider("alpha_vehicle").setPosition(10,pos_slider_y(space, start_pos +5.5, from)).setWidth(w).setRange(0,max).setFont(font);
  gui_main.addSlider("alpha_warp").setPosition(10,pos_slider_y(space, start_pos +6.5, from)).setWidth(w).setRange(0,max).setFont(font);

  gui_main.addSlider("red_vehicle").setPosition(10,pos_slider_y(space, start_pos +7.75, from)).setWidth(w).setRange(0,max).setFont(font);
	gui_main.addSlider("green_vehicle").setPosition(10,pos_slider_y(space, start_pos +8.75, from)).setWidth(w).setRange(0,max).setFont(font);
	gui_main.addSlider("blue_vehicle").setPosition(10,pos_slider_y(space, start_pos +9.75, from)).setWidth(w).setRange(0,max).setFont(font);

	gui_main.addSlider("red_warp").setPosition(10,pos_slider_y(space, start_pos +11.0, from)).setWidth(w).setRange(0,max).setFont(font);
	gui_main.addSlider("green_warp").setPosition(10,pos_slider_y(space, start_pos +12.0, from)).setWidth(w).setRange(0,max).setFont(font);
	gui_main.addSlider("blue_warp").setPosition(10,pos_slider_y(space, start_pos +13.0, from)).setWidth(w).setRange(0,max).setFont(font);
	gui_main.addSlider("power_warp").setPosition(10,pos_slider_y(space, start_pos +14.0, from)).setWidth(w).setRange(0,max).setFont(font);

	gui_main.addSlider("red_cycling").setPosition(10,pos_slider_y(space, start_pos +15.25, from)).setWidth(w).setRange(0,max).setFont(font);
	gui_main.addSlider("green_cycling").setPosition(10,pos_slider_y(space, start_pos +16.25, from)).setWidth(w).setRange(0,max).setFont(font);
	gui_main.addSlider("blue_cycling").setPosition(10,pos_slider_y(space, start_pos +17.25, from)).setWidth(w).setRange(0,max).setFont(font);
	gui_main.addSlider("power_cycling").setPosition(10,pos_slider_y(space, start_pos +18.25, from)).setWidth(w).setRange(0,max).setFont(font);

	// radio_button_cycling = gui_main.addRadioButton("abs_cycling").setValue(0).setPosition(10,pos_slider_y(space, start_pos +10, from)).setSize(w,10).addItem("absolute_cycling",1).setFont(font);
	check_gui_main_channel = gui_main.addCheckBox("channel_setting").setPosition(10,pos_slider_y(space, start_pos +19.75, from)).setSize(w/3,10).setItemsPerRow(1).setSpacingRow(space/2).addItem("absolute_cycling",1);
	//check_img = gui_static_img_2D.addCheckBox("img_setting").setPosition(10,pos_slider_y(space, start_pos +6, from)).setSize(w/3,10).setItemsPerRow(1).setSpacingRow(space/2).addItem("fit_image",1);
  
  int max_tempo = 10 ;
	gui_main.addSlider("tempo_refresh").setPosition(10,pos_slider_y(space, start_pos +20.75, from)).setWidth(w).setRange(1,max_tempo).setNumberOfTickMarks(max_tempo).setFont(font);
  
  int max_cell = 50;
	gui_main.addSlider("cell_force_field").setPosition(10,pos_slider_y(space, start_pos +22.75, from)).setWidth(w).setRange(1,max_cell).setNumberOfTickMarks(max_cell).setFont(font);
  
  int max_spot = 100 ;
	gui_main.addSlider("spot_num").setPosition(10,pos_slider_y(space, start_pos +24.75, from)).setWidth(w).setRange(1,max_spot).setNumberOfTickMarks(max_spot).setFont(font);

	int range_spot = 10;
	gui_main.addSlider("spot_range").setPosition(10,pos_slider_y(space, start_pos +26.5, from)).setWidth(w).setRange(0,range_spot).setNumberOfTickMarks(range_spot +1).setFont(font);
}



float num_vehicle;
float velocity_vehicle;
void gui_vehicle(int space, int max, int w, float start_pos, int from, PFont font) {
	gui_vehicle = new ControlP5(this);
	num_vehicle = .1;
  velocity_vehicle = 5;
  int min_num_vehicle = 0 ;
  int max_num_vehicle = 1 ;
  int max_speed = 25 ;
  //int min_velocity_vehicle = -max_speed ;
  int max_velocity_vehicle = max_speed ;
	gui_main.addSlider("num_vehicle").setPosition(10,pos_slider_y(space, start_pos +0, from)).setWidth(w).setRange(min_num_vehicle,max_num_vehicle).setFont(font);
  gui_main.addSlider("velocity_vehicle").setPosition(10,pos_slider_y(space, start_pos +1, from)).setWidth(w).setRange(0,max_velocity_vehicle).setFont(font);

}


// movie
float header_movie;
float speed_movie;
void gui_main_movie(int space, int max, int w, float start_pos, int from, PFont font) {
	gui_main_movie = new ControlP5(this);
	header_movie = 0 ;
	speed_movie = 1;
	int max_speed = 6 ;

	gui_main_movie.addSlider("header_movie").setPosition(10,pos_slider_y(space, start_pos, from)).setWidth(w).setRange(0,max).setFont(font);

	gui_main_movie.addSlider("speed_movie").setPosition(10,pos_slider_y(space, start_pos +2, from)).setWidth(w).setRange(-max_speed,max_speed).setNumberOfTickMarks((max_speed *8) +1).setFont(font);
}



// fluid
float frequence;
float viscosity;
float diffusion;
void gui_dynamic_fluid(int space, int max, int w, float start_pos, int from, PFont font) {
	gui_dynamic_fluid = new ControlP5(this);
	frequence = .3;
	viscosity = .3;
	diffusion = .3;

	gui_dynamic_fluid.addSlider("frequence").setPosition(10,pos_slider_y(space, start_pos +0, from)).setWidth(w).setRange(0,max).setFont(font);
  gui_dynamic_fluid.addSlider("viscosity").setPosition(10,pos_slider_y(space, start_pos +1, from)).setWidth(w).setRange(0,max).setFont(font);
  gui_dynamic_fluid.addSlider("diffusion").setPosition(10,pos_slider_y(space, start_pos +2, from)).setWidth(w).setRange(0,max).setFont(font);
}


void gui_dynamic_mag_grav(int space, int max, int w, float start_pos, int from, PFont font) {
	gui_dynamic_mag_grav = new ControlP5(this);

	check_gui_dynamic_mag_grav_reset = gui_dynamic_mag_grav.addCheckBox("spot_setting").setPosition(10,pos_slider_y(space, start_pos +0, from)).setSize(w/3,10).setItemsPerRow(1).setSpacingRow(space/2).addItem("full_reset_field",1);
	if(full_reset_field_is) check_gui_dynamic_mag_grav_reset.activate(0);
}



// generative seting for CHAOS and PERLIN field
float range_min_gen;
float range_max_gen;
float power_gen;
void gui_static_generative(int space, int max, int w, float start_pos, int from, PFont font) {
	gui_static_generative = new ControlP5(this);

	range_min_gen = 0.;
	range_max_gen = 1.;
	power_gen = 1. ;
	
	gui_static_generative.addSlider("range_min_gen").setPosition(10,pos_slider_y(space, start_pos +0, from)).setWidth(w).setRange(0,max).setFont(font);
	gui_static_generative.addSlider("range_max_gen").setPosition(10,pos_slider_y(space, start_pos +1, from)).setWidth(w).setRange(0,max).setFont(font);
	float power_max = 3 ;
	gui_static_generative.addSlider("power_gen").setPosition(10,pos_slider_y(space, start_pos +2, from)).setWidth(w).setRange(-power_max,power_max).setFont(font);
}





// image sorting channel
float vel_sort = 6.;
float x_sort = 1.;
float y_sort = 1.;
float z_sort = 1.;

void gui_static_image(int space, int max, int w, float start_pos, int from, PFont font) {
	gui_static_img_2D = new ControlP5(this);
	gui_static_img_3D = new ControlP5(this);

	vel_sort = 1.;
	x_sort = 1.;
	y_sort = 1.;
	z_sort = 1.;
  
  int min_mark = 0;
	int max_mark = 6;
	int mark = 7;
	gui_static_img_2D.addSlider("vel_sort").setPosition(10,pos_slider_y(space, start_pos +0, from)).setWidth(w).setRange(min_mark,max_mark).setNumberOfTickMarks(mark).setFont(font);
	gui_static_img_2D.addSlider("x_sort").setPosition(10,pos_slider_y(space, start_pos +1.5, from)).setWidth(w).setRange(min_mark,max_mark).setNumberOfTickMarks(mark).setFont(font);
	gui_static_img_2D.addSlider("y_sort").setPosition(10,pos_slider_y(space, start_pos +3, from)).setWidth(w).setRange(min_mark,max_mark).setNumberOfTickMarks(mark).setFont(font);
	gui_static_img_3D.addSlider("z_sort").setPosition(10,pos_slider_y(space, start_pos +4.5, from)).setWidth(w).setRange(min_mark,max_mark).setNumberOfTickMarks(mark).setFont(font);

}




// mouse device
float radius_mouse ;
float min_radius_mouse ;
float max_radius_mouse ;
float speed_mouse;
float distribution_mouse;
float spiral_mouse;
float beat_mouse;
float motion_mouse;

void gui_dynamic_mouse(int space, int max, int w, float start_pos, int from, PFont font){
	gui_dynamic_mouse = new ControlP5(this);

	radius_mouse = .3;

	min_radius_mouse = .0;
	float max_min_radius = 1 ;

	max_radius_mouse = 1.;
	float max_max_radius = 7. ;

	speed_mouse = 0.;
	distribution_mouse = 0.;

	int min_mark_spiral = 0;
	int max_mark_spiral = 20;
  int spiral_mark = 21;

  int min_mark_beat = 0 ;
  int max_mark_beat = 200;

	gui_dynamic_mouse.addSlider("radius_mouse").setPosition(10,pos_slider_y(space, start_pos +0, from)).setWidth(w).setRange(0,max).setFont(font);
	gui_dynamic_mouse.addSlider("min_radius_mouse").setPosition(10,pos_slider_y(space, start_pos +1, from)).setWidth(w).setRange(0,max_min_radius).setFont(font);
	gui_dynamic_mouse.addSlider("max_radius_mouse").setPosition(10,pos_slider_y(space, start_pos +2, from)).setWidth(w).setRange(max_min_radius,max_max_radius).setFont(font);
  
  gui_dynamic_mouse.addSlider("distribution_mouse").setPosition(10,pos_slider_y(space, start_pos +3, from)).setWidth(w).setRange(0,TAU).setFont(font);
  gui_dynamic_mouse.addSlider("spiral_mouse").setPosition(10,pos_slider_y(space, start_pos +4, from)).setWidth(w).setRange(min_mark_spiral,max_mark_spiral).setNumberOfTickMarks(spiral_mark).setFont(font);;
  gui_dynamic_mouse.addSlider("beat_mouse").setPosition(10,pos_slider_y(space, start_pos +5.5, from)).setWidth(w).setRange(min_mark_beat,max_mark_beat).setFont(font);

  gui_dynamic_mouse.addSlider("speed_mouse").setPosition(10,pos_slider_y(space, start_pos +6.5, from)).setWidth(w).setRange(-max,max).setFont(font);
  gui_dynamic_mouse.addSlider("motion_mouse").setPosition(10,pos_slider_y(space, start_pos +7.5, from)).setWidth(w).setRange(0,max).setFont(font);
}



















/**
draw update
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

  set_resize_window(gui_resize_window);
  set_full_reset_field(gui_fullreset_field_is);
  set_fit_image(gui_fullfit_image);

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

  if(abs_cycling) {
  	cr = abs(cr) ;
  	cg = abs(cg) ;
  	cb = abs(cb) ;
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


/**
control event
v 0.0.2
*/
public void controlEvent(ControlEvent theEvent) {
	if(theEvent.isFrom(check_gui_main)) {
		if(check_gui_main.getArrayValue(0) == 1) gui_resize_window = true ; else gui_resize_window = false ;
		if(check_gui_main.getArrayValue(1) == 1) gui_fullfit_image = true ; else gui_fullfit_image = false ;
		if(check_gui_main.getArrayValue(2) == 1) gui_display_bg = true ; else gui_display_bg = false;
		if(check_gui_main.getArrayValue(3) == 1) gui_show_must_go_on = true ; else gui_show_must_go_on = false;
  }

  if(theEvent.isFrom(check_gui_main_channel)) {
		if(check_gui_main_channel.getArrayValue(0) == 1) abs_cycling = true ; else abs_cycling = false ;
  } 

  if(theEvent.isFrom(check_gui_dynamic_mag_grav_reset)) {
		if(check_gui_dynamic_mag_grav_reset.getArrayValue(0) == 1) gui_fullreset_field_is = true ; else gui_fullreset_field_is = false ;
  } 
}



/**
set controller
*/
void set_check_gui_main_display() {
	if(display_bg_is()) {
		check_gui_main.activate(2);
	} else {
		println("disable display");
		check_gui_main.deactivate(2);
	}
}

void set_check_gui_dynamic_mag_grav() {
	if(full_reset_field_is) {
		check_gui_dynamic_mag_grav_reset.activate(0);
	} else {		
		check_gui_dynamic_mag_grav_reset.deactivate(0);
	}
}














/**
get controller
*/
void get_controller_gui() {
	get_controller_movie();
}

void get_controller_main() {
	//
}

float movie_pos_normal ;
void get_controller_movie() {
	gui_main_movie.getController("header_movie").setValue(movie_pos_normal);
	gui_main_movie.getController("speed_movie");
}

void get_controller_fluid() {
	gui_dynamic_fluid.getController("frequence");
  gui_dynamic_fluid.getController("viscosity");
  gui_dynamic_fluid.getController("diffusion");
}


// mouse device
void get_controller_mouse() {
	gui_dynamic_mouse.getController("radius_mouse");
  gui_dynamic_mouse.getController("speed_mouse");
  gui_dynamic_mouse.getController("angle_mouse");
}



































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

int get_num_vehicle_gui() {
	return int(num_vehicle *num_vehicle *num_vehicle * max_vehicle_ff);
}

float get_velocity_vehicle_gui() {
	return velocity_vehicle;
}

int get_tempo_refresh_gui() {
	return ceil(tempo_refresh);
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

int get_num_spot_gui() {
	return int(spot_num) ;
}

int get_range_spot_gui() {
	return int(spot_range) ;
}

float get_speed_mouse() {
	return speed_mouse *speed_mouse *speed_mouse;
}

float get_radius_mouse() {
	if(width > height) {
		return radius_mouse *height *.66;
	} else return radius_mouse *width *.66;
}


float get_min_radius_mouse() {
	return min_radius_mouse;
}

float get_max_radius_mouse() {
	return max_radius_mouse;
}

float get_motion_mouse() {
	return motion_mouse *motion_mouse *motion_mouse *motion_mouse *motion_mouse;
}

int get_beat_mouse() {
	return (int)beat_mouse;
}

int get_spiral_mouse() {
	return (int) spiral_mouse;
}

float get_distribution_mouse() {
	return distribution_mouse;
}



















































