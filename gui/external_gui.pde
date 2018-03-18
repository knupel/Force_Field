/**
internal GUI Force
2017-2018
http://stanlepunk.xyz/
v 0.3.0
*/
import controlP5.*;
boolean gui_init_controller = false;

ControlP5 gui_mode;
ControlP5 gui_main;
ControlP5 gui_static_img_2D;
ControlP5 gui_static_img_3D;
ControlP5 gui_static_generative;
ControlP5 gui_dynamic_mag_grav;
ControlP5 gui_dynamic_fluid;
ControlP5 gui_dynamic_spot;
ControlP5 gui_main_movie;
ControlP5 gui_vehicle;

CheckBox check_gui_main ;
CheckBox check_gui_main_channel ;
CheckBox check_gui_dynamic_mag_grav_reset ;
CheckBox check_gui_vehicle ;






// global slider
boolean gui_fullreset_field_is;
boolean gui_warp_is;
//boolean abs_cycling = true;
boolean gui_change_size_window_is ;
boolean gui_fullfit_image_is ;
boolean gui_display_bg ;
boolean gui_vehicle_pixel_is;
boolean gui_show_must_go_on;
boolean gui_full_reset_field_is;


Vec2 pos_gui ;
Vec2 size_gui ;

int space_interface ;

CColor red_gui ;
CColor grey_0_gui ;

int col_1_x = 10 ;
int col_2_x = 200 ;

/**
setup
*/
void gui_setup(Vec2 pos, Vec2 size) {
	// check boolean setting from top first tab sketch 
  // if(pause_is);
  // if(fullScreen_is);
	// if(use_leapmotion);
	// if(interface_is);
	// if(hide_menu_bar);
	// if(inside_gui);
	// if(display_result_warp);
	// if(display_result_vehicle);
  
  if(warp_is) gui_warp_is = true; else gui_warp_is = false;
	if(full_reset_field_is) gui_full_reset_field_is = true ; else  gui_full_reset_field_is = false;
	if(change_size_window_is) gui_change_size_window_is = true ; else gui_change_size_window_is = false;
	if(fullfit_image_is) gui_fullfit_image_is = true ; else gui_fullfit_image_is = false;
	if(display_bg) gui_display_bg = true ; else gui_display_bg = false;
	if(vehicle_pixel_is) gui_vehicle_pixel_is = true ; else gui_vehicle_pixel_is = false;
	if(show_must_go_on) gui_show_must_go_on = true ; else gui_show_must_go_on = false ;



	build_gui();

	red_gui = new CColor(r.BLOOD,r.CARMINE,r.RED,r.WHITE,r.WHITE);
	grey_0_gui = new CColor(r.GRAY_3,r.GRAY_2,r.GRAY_4,r.WHITE,r.WHITE);

	pos_gui = pos.copy();
	size_gui = size.copy();
	int slider_width = 100 ;
	space_interface = 15;
	int max = 1;
  

  gui_mode();
  // main
  gui_main(space_interface, max, slider_width, 3, TOP);

  gui_main_movie(space_interface, max, slider_width, 2, BOTTOM);
  
  // menu static field
  gui_static_generative(space_interface, max, slider_width, 29.5, TOP);
  gui_static_image(space_interface, max, slider_width, 33, TOP);

  // menu dynamic field
  gui_dynamic_fluid(space_interface, max, slider_width, 29.5, TOP);
  gui_dynamic_mag_grav(space_interface, max, slider_width, 29.5, TOP);

  gui_dynamic_spot(space_interface, max, slider_width, 33, TOP);

  // vehicle
  gui_vehicle(space_interface, max, slider_width, 41.5, TOP);
  
  // boolean to give authorization to update controller
  gui_init_controller = true;
}


void build_gui() {
	gui_mode = new ControlP5(this);
	gui_main = new ControlP5(this);
	gui_vehicle = new ControlP5(this);
	gui_dynamic_mag_grav = new ControlP5(this);
	gui_dynamic_fluid = new ControlP5(this);
	gui_main_movie = new ControlP5(this);
	gui_static_generative = new ControlP5(this);
	gui_dynamic_spot = new ControlP5(this);
	gui_static_img_2D = new ControlP5(this);
	gui_static_img_3D = new ControlP5(this);
}


void gui_mode() {
	String [] mode = {"PERLIN","CHAOS","EQUATION","IMAGE","GRAVITY","MAGNETIC","FLUID"};
	ButtonBar b = gui_mode.addButtonBar("mode").setPosition(0,0).setSize(width,20).addItems(mode).setColor(red_gui);
}

void mode(int n) {
	println("bar clicked, item-value:", n);
}


void gui_main(int space, int max, int w, float start_pos, int from) {	
	check_gui_main = gui_main.addCheckBox("main_setting").setPosition(col_1_x,pos_slider_y(space, start_pos +0, from)).setSize(w/3,10).setItemsPerRow(1).setSpacingRow(space/2)
														.addItem("resize window",1).addItem("fit image",1).addItem("background",1).addItem("show must go on",1).setColor(grey_0_gui);
  if(gui_change_size_window_is) check_gui_main.activate(0);
  if(gui_fullfit_image_is) check_gui_main.activate(1);
  if(gui_display_bg) check_gui_main.activate(2);
  if(gui_show_must_go_on) check_gui_main.activate(3);

  gui_main.addSlider("alpha_bg").setLabel("alpha background").setPosition(col_2_x,pos_slider_y(space, start_pos +0, from)).setWidth(w).setRange(0,max).setColor(grey_0_gui);
  gui_main.addSlider("alpha_vehicle").setLabel("alpha vehicle").setPosition(col_2_x,pos_slider_y(space, start_pos +1, from)).setWidth(w).setRange(0,max).setColor(grey_0_gui);
  gui_main.addSlider("alpha_warp").setLabel("alpha warp").setPosition(col_2_x,pos_slider_y(space, start_pos +2, from)).setWidth(w).setRange(0,max).setColor(grey_0_gui);

  gui_main.addSlider("red_vehicle").setPosition(col_2_x,pos_slider_y(space, start_pos +3.25, from)).setWidth(w).setRange(0,max).setColor(red_gui);
	gui_main.addSlider("green_vehicle").setPosition(col_2_x,pos_slider_y(space, start_pos +4.25, from)).setWidth(w).setRange(0,max).setColor(red_gui);
	gui_main.addSlider("blue_vehicle").setPosition(col_2_x,pos_slider_y(space, start_pos +5.25, from)).setWidth(w).setRange(0,max).setColor(red_gui);

	gui_main.addSlider("red_warp").setPosition(col_2_x,pos_slider_y(space, start_pos +6.5, from)).setWidth(w).setRange(0,max).setColor(grey_0_gui);
	gui_main.addSlider("green_warp").setPosition(col_2_x,pos_slider_y(space, start_pos +7.5, from)).setWidth(w).setRange(0,max).setColor(grey_0_gui);
	gui_main.addSlider("blue_warp").setPosition(col_2_x,pos_slider_y(space, start_pos +8.5, from)).setWidth(w).setRange(0,max).setColor(grey_0_gui);

	gui_main.addSlider("power_warp").setPosition(col_2_x,pos_slider_y(space, start_pos +9.5, from)).setWidth(w).setRange(0,max).setColor(grey_0_gui);
  
	gui_main.addSlider("red_cycling").setPosition(col_2_x,pos_slider_y(space, start_pos +10.75, from)).setWidth(w).setRange(0,max).setColor(red_gui);
	gui_main.addSlider("green_cycling").setPosition(col_2_x,pos_slider_y(space, start_pos +11.75, from)).setWidth(w).setRange(0,max).setColor(red_gui);
	gui_main.addSlider("blue_cycling").setPosition(col_2_x,pos_slider_y(space, start_pos +12.75, from)).setWidth(w).setRange(0,max).setColor(red_gui);

	gui_main.addSlider("power_cycling").setPosition(col_2_x,pos_slider_y(space, start_pos +13.75, from)).setWidth(w).setRange(0,max).setColor(red_gui);

	check_gui_main_channel = gui_main.addCheckBox("channel_setting").setPosition(10,pos_slider_y(space, start_pos +14.75, from)).setSize(w/3,10).setItemsPerRow(1).setSpacingRow(space/2)
																		.addItem("WARP ON/OFF",1).setColor(red_gui);
	if(gui_warp_is) check_gui_main_channel.activate(0);
  
  int max_tempo = 10 ;
	gui_main.addSlider("tempo_refresh").setPosition(col_2_x,pos_slider_y(space, start_pos +15.75, from)).setWidth(w).setRange(1,max_tempo).setNumberOfTickMarks(max_tempo).setColor(grey_0_gui);
  
  int max_cell = 50;
	gui_main.addSlider("cell_force_field").setPosition(col_2_x,pos_slider_y(space, start_pos +18.25, from)).setWidth(w).setRange(1,max_cell).setNumberOfTickMarks(max_cell).setColor(grey_0_gui);
  
  int max_spot = 100 ;
  if(use_leapmotion) max_spot = 10;
	gui_main.addSlider("spot_num").setPosition(col_2_x,pos_slider_y(space, start_pos +20.25, from)).setWidth(w).setRange(1,max_spot).setNumberOfTickMarks(max_spot).setColor(grey_0_gui);

	int range_spot = 10;
	gui_main.addSlider("spot_range").setPosition(col_2_x,pos_slider_y(space, start_pos +22, from)).setWidth(w).setRange(0,range_spot).setNumberOfTickMarks(range_spot +1).setColor(grey_0_gui);
}


void gui_vehicle(int space, int max, int w, float start_pos, int from) {	
  int min_num_vehicle = 0 ;
  int max_num_vehicle = 1 ;
  int max_speed = 25 ;
  int max_velocity_vehicle = max_speed ;
	gui_vehicle.addSlider("num_vehicle").setPosition(col_2_x,pos_slider_y(space, start_pos +0, from)).setWidth(w).setRange(min_num_vehicle,max_num_vehicle).setColor(grey_0_gui);
  gui_vehicle.addSlider("velocity_vehicle").setPosition(col_2_x,pos_slider_y(space, start_pos +1, from)).setWidth(w).setRange(0,max_velocity_vehicle).setColor(grey_0_gui);
  check_gui_vehicle = gui_vehicle.addCheckBox("vehicle_setting").setPosition(10,pos_slider_y(space, start_pos +2, from)).setSize(w/3,10).setItemsPerRow(1).setSpacingRow(space/2)
																		.addItem("PIXEL / SHAPE",1).setColor(grey_0_gui);
	if(gui_vehicle_pixel_is) check_gui_vehicle.activate(0);
}


void gui_main_movie(int space, int max, int w, float start_pos, int from) {
	int max_speed = 6 ;
	gui_main_movie.addSlider("header_movie").setPosition(col_2_x,pos_slider_y(space, start_pos, from)).setWidth(w).setRange(0,max).setColor(grey_0_gui);
	gui_main_movie.addSlider("speed_movie").setPosition(col_2_x,pos_slider_y(space, start_pos +2, from)).setWidth(w).setRange(-max_speed,max_speed).setNumberOfTickMarks((max_speed *8) +1).setColor(grey_0_gui);
}


void gui_dynamic_fluid(int space, int max, int w, float start_pos, int from) {
	gui_dynamic_fluid.addSlider("frequence").setPosition(col_2_x,pos_slider_y(space, start_pos +0, from)).setWidth(w).setRange(0,max).setColor(grey_0_gui);
  gui_dynamic_fluid.addSlider("viscosity").setPosition(col_2_x,pos_slider_y(space, start_pos +1, from)).setWidth(w).setRange(0,max).setColor(grey_0_gui);
  gui_dynamic_fluid.addSlider("diffusion").setPosition(col_2_x,pos_slider_y(space, start_pos +2, from)).setWidth(w).setRange(0,max).setColor(grey_0_gui);
}


void gui_dynamic_mag_grav(int space, int max, int w, float start_pos, int from) {
	check_gui_dynamic_mag_grav_reset = gui_dynamic_mag_grav.addCheckBox("spot_setting").setPosition(10,pos_slider_y(space, start_pos +0, from)).setSize(w/3,10).setItemsPerRow(1).setSpacingRow(space/2).addItem("full_reset_field",1).setColor(grey_0_gui);
	if(gui_full_reset_field_is) check_gui_dynamic_mag_grav_reset.activate(0);
}


void gui_static_generative(int space, int max, int w, float start_pos, int from) {
	gui_static_generative.addSlider("range_min_gen").setPosition(col_2_x,pos_slider_y(space, start_pos +0, from)).setWidth(w).setRange(0,max).setColor(grey_0_gui);
	gui_static_generative.addSlider("range_max_gen").setPosition(col_2_x,pos_slider_y(space, start_pos +1, from)).setWidth(w).setRange(0,max).setColor(grey_0_gui);
	float power_max = 3 ;
	gui_static_generative.addSlider("power_gen").setPosition(col_2_x,pos_slider_y(space, start_pos +2, from)).setWidth(w).setRange(-power_max,power_max).setColor(grey_0_gui);
}


void gui_static_image(int space, int max, int w, float start_pos, int from) {
  int min_mark = 0;
	int max_mark = 6;
	int mark = 7;
	gui_static_img_2D.addSlider("vel_sort").setPosition(col_2_x,pos_slider_y(space, start_pos +0, from)).setWidth(w).setRange(min_mark,max_mark).setNumberOfTickMarks(mark).setColor(grey_0_gui);
	gui_static_img_2D.addSlider("x_sort").setPosition(col_2_x,pos_slider_y(space, start_pos +1.5, from)).setWidth(w).setRange(min_mark,max_mark).setNumberOfTickMarks(mark).setColor(grey_0_gui);
	gui_static_img_2D.addSlider("y_sort").setPosition(col_2_x,pos_slider_y(space, start_pos +3, from)).setWidth(w).setRange(min_mark,max_mark).setNumberOfTickMarks(mark).setColor(grey_0_gui);
	gui_static_img_3D.addSlider("z_sort").setPosition(col_2_x,pos_slider_y(space, start_pos +4.5, from)).setWidth(w).setRange(min_mark,max_mark).setNumberOfTickMarks(mark).setColor(grey_0_gui);
}


void gui_dynamic_spot(int space, int max, int w, float start_pos, int from){
	float max_min_radius = 1 ;
	float max_max_radius = 7. ;
	int min_mark_spiral = 0;
	int max_mark_spiral = 20;
  int spiral_mark = 21;
  int min_mark_beat = 0 ;
  int max_mark_beat = 200;

	gui_dynamic_spot.addSlider("radius_spot").setPosition(col_2_x,pos_slider_y(space, start_pos +0, from)).setWidth(w).setRange(0,max).setColor(red_gui);
	gui_dynamic_spot.addSlider("min_radius_spot").setPosition(col_2_x,pos_slider_y(space, start_pos +1, from)).setWidth(w).setRange(0,max_min_radius).setColor(red_gui);
	gui_dynamic_spot.addSlider("max_radius_spot").setPosition(col_2_x,pos_slider_y(space, start_pos +2, from)).setWidth(w).setRange(max_min_radius,max_max_radius).setColor(red_gui);
  
  gui_dynamic_spot.addSlider("distribution_spot").setPosition(col_2_x,pos_slider_y(space, start_pos +3, from)).setWidth(w).setRange(0,TAU).setColor(red_gui);
  gui_dynamic_spot.addSlider("spiral_spot").setPosition(col_2_x,pos_slider_y(space, start_pos +4, from)).setWidth(w).setRange(min_mark_spiral,max_mark_spiral).setNumberOfTickMarks(spiral_mark).setColor(red_gui);
  gui_dynamic_spot.addSlider("beat_spot").setPosition(col_2_x,pos_slider_y(space, start_pos +5.5, from)).setWidth(w).setRange(min_mark_beat,max_mark_beat).setColor(red_gui);

  gui_dynamic_spot.addSlider("speed_spot").setPosition(col_2_x,pos_slider_y(space, start_pos +6.5, from)).setWidth(w).setRange(-max,max).setColor(red_gui);
  gui_dynamic_spot.addSlider("motion_spot").setPosition(col_2_x,pos_slider_y(space, start_pos +7.5, from)).setWidth(w).setRange(0,max).setColor(red_gui);
}






















/**
control event
v 0.0.3
*/
public void controlEvent(ControlEvent theEvent) {
	if(gui_init_controller) {
		if(theEvent.isFrom(check_gui_main)) {
			if(check_gui_main.getArrayValue(0) == 1) gui_change_size_window_is = true; else gui_change_size_window_is = false;
			if(check_gui_main.getArrayValue(1) == 1) gui_fullfit_image_is = true; else gui_fullfit_image_is = false;
			if(check_gui_main.getArrayValue(2) == 1) gui_display_bg = true; else gui_display_bg = false;
			if(check_gui_main.getArrayValue(3) == 1) gui_show_must_go_on = true; else gui_show_must_go_on = false;
	  }

	  if(theEvent.isFrom(check_gui_main_channel)) {
			if(check_gui_main_channel.getArrayValue(0) == 1) gui_warp_is = true; else gui_warp_is = false;
	  }

	  if(theEvent.isFrom(check_gui_vehicle)) {
			if(check_gui_vehicle.getArrayValue(0) == 1) gui_vehicle_pixel_is = true; else gui_vehicle_pixel_is = false;
	  } 

	  if(theEvent.isFrom(check_gui_dynamic_mag_grav_reset)) {
			if(check_gui_dynamic_mag_grav_reset.getArrayValue(0) == 1) gui_fullreset_field_is = true; else gui_fullreset_field_is = false;
	  }
	}	 
}



/**
set controller
*/
void set_check_gui_main_display(boolean state) {
	if(state) {
		check_gui_main.activate(2);
	} else {
		println("disable display");
		check_gui_main.deactivate(2);
	}
}

void set_check_gui_dynamic_mag_grav(boolean state) {
	if(state) {
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
	get_controller_main();
}

float ref_power_cycling;
boolean switch_off_power_cycling;
void get_controller_main() {
	if(!gui_warp_is) {
		if(!switch_off_power_cycling) ref_power_cycling = power_cycling;
		switch_off_power_cycling = true;
		gui_main.getController("power_cycling").setValue(0);
	} else {
		if(switch_off_power_cycling) {
			gui_main.getController("power_cycling").setValue(ref_power_cycling);
		} 
		switch_off_power_cycling = false;
	}
}

float movie_pos_normal ;
void get_controller_movie() {
	gui_main_movie.getController("header_movie").setValue(movie_pos_normal);
	gui_main_movie.getController("speed_movie");
}




