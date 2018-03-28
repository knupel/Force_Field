/**
internal GUI Force
2017-2018
http://stanlepunk.xyz/
v 0.3.0
*/
import controlP5.*;
boolean gui_init_controller = false;

ControlP5 gui_main; 

CheckBox check_gui_main ;
CheckBox check_gui_main_channel ;

ControlP5 gui_static_img_2D,gui_static_img_3D;

ControlP5 gui_static_generative;

ControlP5 gui_dynamic_mag_grav;
CheckBox check_gui_dynamic_mag_grav_reset ;

ControlP5 gui_dynamic_fluid;
ControlP5 gui_dynamic_spot, gui_main_movie;

ControlP5 gui_vehicle;
CheckBox check_gui_vehicle ;

// global slider
boolean gui_fullreset_field_is;
boolean gui_warp_is;
//boolean abs_cycling = true;
boolean gui_change_size_window_is ;
boolean gui_fullfit_image_is ;
boolean gui_display_bg ;
// boolean gui_vehicle_pixel_is;
boolean gui_show_must_go_on;
boolean gui_full_reset_field_is;

int space_interface ;

PFont font_gui ;

CColor red_gui ;
CColor grey_0_gui ;

/**
setup
*/
void gui_setup() {
	// check boolean setting from top first tab sketch 
	/*
  if(pause_is);
  if(fullScreen_is);
	if(use_leapmotion);
	if(interface_is);
	if(hide_menu_bar);
	if(inside_gui);
	if(display_warp);
	if(display_vehicle);
	*/
  
  if(warp_is) gui_warp_is = true; else gui_warp_is = false;
	if(full_reset_field_is) gui_full_reset_field_is = true ; else  gui_full_reset_field_is = false;
	if(change_size_window_is) gui_change_size_window_is = true ; else gui_change_size_window_is = false;
	if(fullfit_image_is) gui_fullfit_image_is = true ; else gui_fullfit_image_is = false;
	if(display_background) gui_display_bg = true ; else gui_display_bg = false;
	// if(vehicle_pixel_is) gui_vehicle_pixel_is = true ; else gui_vehicle_pixel_is = false;
	if(show_must_go_on) gui_show_must_go_on = true ; else gui_show_must_go_on = false ;


	int size_font = 10 ;
	font_gui = createFont("Lucida",size_font,false); // use true/false for smooth/no-smooth

	red_gui = new CColor(r.BLOOD,r.CARMINE,r.RED,r.WHITE,r.WHITE);
	grey_0_gui = new CColor(r.GRAY_3,r.GRAY_2,r.GRAY_4,r.WHITE,r.WHITE);

  
	
	space_interface = ceil(font_gui.getSize() *1.5) ;
	
	if(!external_gui_is) gui_int_controller(space_interface);

  // main
  
}


void gui_int_controller(int space) {
	int slider_width = 100 ;
	int max = 1;
	gui_main(space, max, slider_width, 1, TOP, font_gui);

  gui_main_movie(space, max, slider_width, 2, BOTTOM, font_gui);
  
  // menu static field
  gui_static_generative(space, max, slider_width, 29.5, TOP, font_gui);
  gui_static_image(space, max, slider_width, 33, TOP, font_gui);

  // menu dynamic field
  gui_dynamic_fluid(space, max, slider_width, 29.5, TOP, font_gui);
  gui_dynamic_mag_grav(space_interface, max, slider_width, 29.5, TOP, font_gui);

  gui_dynamic_spot(space, max, slider_width, 33, TOP, font_gui);

  // vehicle
  gui_vehicle(space, max, slider_width, 41.5, TOP, font_gui);
  
  // boolean to give authorization to update controller
  gui_init_controller = true;
}















void gui_main(int space, int max, int w, float start_pos, int from, PFont font) {
	gui_main = new ControlP5(this);

	check_gui_main = gui_main.addCheckBox("main_setting").setPosition(10,pos_slider_y(space, start_pos +0, from)).setSize(w/3,10).setItemsPerRow(1).setSpacingRow(space/2)
														.addItem("resize window",1).addItem("fit image",1).addItem("background",1).addItem("show must go on",1).setColor(grey_0_gui);
  if(gui_change_size_window_is) check_gui_main.activate(0);
  if(gui_fullfit_image_is) check_gui_main.activate(1);
  if(gui_display_bg) check_gui_main.activate(2);
  if(gui_show_must_go_on) check_gui_main.activate(3);

  gui_main.addSlider("alpha_bg").setPosition(10,pos_slider_y(space, start_pos +4.5, from)).setWidth(w).setRange(0,max).setFont(font).setColor(grey_0_gui);
  gui_main.addSlider("alpha_vehicle").setPosition(10,pos_slider_y(space, start_pos +5.5, from)).setWidth(w).setRange(0,max).setFont(font).setColor(grey_0_gui);
  gui_main.addSlider("alpha_warp").setPosition(10,pos_slider_y(space, start_pos +6.5, from)).setWidth(w).setRange(0,max).setFont(font).setColor(grey_0_gui);

  gui_main.addSlider("red_vehicle").setPosition(10,pos_slider_y(space, start_pos +7.75, from)).setWidth(w).setRange(0,max).setFont(font).setColor(red_gui);
	gui_main.addSlider("green_vehicle").setPosition(10,pos_slider_y(space, start_pos +8.75, from)).setWidth(w).setRange(0,max).setFont(font).setColor(red_gui);
	gui_main.addSlider("blue_vehicle").setPosition(10,pos_slider_y(space, start_pos +9.75, from)).setWidth(w).setRange(0,max).setFont(font).setColor(red_gui);

	gui_main.addSlider("red_warp").setPosition(10,pos_slider_y(space, start_pos +11.0, from)).setWidth(w).setRange(0,max).setFont(font).setColor(grey_0_gui);
	gui_main.addSlider("green_warp").setPosition(10,pos_slider_y(space, start_pos +12.0, from)).setWidth(w).setRange(0,max).setFont(font).setColor(grey_0_gui);
	gui_main.addSlider("blue_warp").setPosition(10,pos_slider_y(space, start_pos +13.0, from)).setWidth(w).setRange(0,max).setFont(font).setColor(grey_0_gui);
	gui_main.addSlider("power_warp").setPosition(10,pos_slider_y(space, start_pos +14.0, from)).setWidth(w).setRange(0,max).setFont(font).setColor(grey_0_gui);
  
  
  //CColor c = new CColor(r.RED,r.BLOOD,r.CARMINE,r.WHITE,r.WHITE);
	gui_main.addSlider("red_cycling").setPosition(10,pos_slider_y(space, start_pos +15.25, from)).setWidth(w).setRange(0,max).setFont(font).setColor(red_gui);
	gui_main.addSlider("green_cycling").setPosition(10,pos_slider_y(space, start_pos +16.25, from)).setWidth(w).setRange(0,max).setFont(font).setColor(red_gui);
	gui_main.addSlider("blue_cycling").setPosition(10,pos_slider_y(space, start_pos +17.25, from)).setWidth(w).setRange(0,max).setFont(font).setColor(red_gui);
	gui_main.addSlider("power_cycling").setPosition(10,pos_slider_y(space, start_pos +18.25, from)).setWidth(w).setRange(0,max).setFont(font).setColor(red_gui);

	check_gui_main_channel = gui_main.addCheckBox("channel_setting").setPosition(10,pos_slider_y(space, start_pos +19.25, from)).setSize(w/3,10).setItemsPerRow(1).setSpacingRow(space/2)
																		.addItem("WARP ON/OFF",1).setColor(red_gui);
	if(gui_warp_is) check_gui_main_channel.activate(0);
  
  int max_tempo = 10 ;
	gui_main.addSlider("tempo_refresh").setPosition(10,pos_slider_y(space, start_pos +20.75, from)).setWidth(w).setRange(1,max_tempo).setNumberOfTickMarks(max_tempo).setFont(font).setColor(grey_0_gui);
  
  int max_cell = 50;
	gui_main.addSlider("cell_force_field").setPosition(10,pos_slider_y(space, start_pos +22.75, from)).setWidth(w).setRange(1,max_cell).setNumberOfTickMarks(max_cell).setFont(font).setColor(grey_0_gui);
  
  int max_spot = 100 ;
  if(use_leapmotion) max_spot = 10;
	gui_main.addSlider("spot_num").setPosition(10,pos_slider_y(space, start_pos +24.75, from)).setWidth(w).setRange(1,max_spot).setNumberOfTickMarks(max_spot).setFont(font).setColor(grey_0_gui);

	int range_spot = 10;
	gui_main.addSlider("spot_range").setPosition(10,pos_slider_y(space, start_pos +26.5, from)).setWidth(w).setRange(0,range_spot).setNumberOfTickMarks(range_spot +1).setFont(font).setColor(grey_0_gui);
}



void gui_vehicle(int space, int max, int w, float start_pos, int from, PFont font) {
	gui_vehicle = new ControlP5(this);
  int min_num_vehicle = 0 ;
  int max_num_vehicle = 1 ;
  int max_speed = 25 ;
  //int min_velocity_vehicle = -max_speed ;
  int max_velocity_vehicle = max_speed ;
	gui_vehicle.addSlider("num_vehicle").setPosition(10,pos_slider_y(space, start_pos +0, from)).setWidth(w).setRange(min_num_vehicle,max_num_vehicle).setFont(font).setColor(grey_0_gui);
  gui_vehicle.addSlider("velocity_vehicle").setPosition(10,pos_slider_y(space, start_pos +1, from)).setWidth(w).setRange(0,max_velocity_vehicle).setFont(font).setColor(grey_0_gui);
  /*
  check_gui_vehicle = gui_vehicle.addCheckBox("vehicle_setting").setPosition(10,pos_slider_y(space, start_pos +2, from)).setSize(w/3,10).setItemsPerRow(1).setSpacingRow(space/2)
																		.addItem("PIXEL / SHAPE",1).setColor(grey_0_gui);
	if(gui_vehicle_pixel_is) check_gui_vehicle.activate(0);
	*/
}


// movie
void gui_main_movie(int space, int max, int w, float start_pos, int from, PFont font) {
	gui_main_movie = new ControlP5(this);
	int max_speed = 6 ;

	gui_main_movie.addSlider("header_movie").setPosition(10,pos_slider_y(space, start_pos, from)).setWidth(w).setRange(0,max).setFont(font).setColor(grey_0_gui);
	gui_main_movie.addSlider("speed_movie").setPosition(10,pos_slider_y(space, start_pos +2, from)).setWidth(w).setRange(-max_speed,max_speed).setNumberOfTickMarks((max_speed *8) +1).setFont(font).setColor(grey_0_gui);
}



// fluid
void gui_dynamic_fluid(int space, int max, int w, float start_pos, int from, PFont font) {
	gui_dynamic_fluid = new ControlP5(this);
	gui_dynamic_fluid.addSlider("frequence").setPosition(10,pos_slider_y(space, start_pos +0, from)).setWidth(w).setRange(0,max).setFont(font).setColor(grey_0_gui);
  gui_dynamic_fluid.addSlider("viscosity").setPosition(10,pos_slider_y(space, start_pos +1, from)).setWidth(w).setRange(0,max).setFont(font).setColor(grey_0_gui);
  gui_dynamic_fluid.addSlider("diffusion").setPosition(10,pos_slider_y(space, start_pos +2, from)).setWidth(w).setRange(0,max).setFont(font).setColor(grey_0_gui);
}


void gui_dynamic_mag_grav(int space, int max, int w, float start_pos, int from, PFont font) {
	gui_dynamic_mag_grav = new ControlP5(this);

	check_gui_dynamic_mag_grav_reset = gui_dynamic_mag_grav.addCheckBox("spot_setting").setPosition(10,pos_slider_y(space, start_pos +0, from)).setSize(w/3,10).setItemsPerRow(1).setSpacingRow(space/2).addItem("full_reset_field",1).setColor(grey_0_gui);
	if(gui_full_reset_field_is) check_gui_dynamic_mag_grav_reset.activate(0);
}



// generative seting for CHAOS and PERLIN field
void gui_static_generative(int space, int max, int w, float start_pos, int from, PFont font) {
	gui_static_generative = new ControlP5(this);
	
	gui_static_generative.addSlider("range_min_gen").setPosition(10,pos_slider_y(space, start_pos +0, from)).setWidth(w).setRange(0,max).setFont(font).setColor(grey_0_gui);
	gui_static_generative.addSlider("range_max_gen").setPosition(10,pos_slider_y(space, start_pos +1, from)).setWidth(w).setRange(0,max).setFont(font).setColor(grey_0_gui);
	float power_max = 3 ;
	gui_static_generative.addSlider("power_gen").setPosition(10,pos_slider_y(space, start_pos +2, from)).setWidth(w).setRange(-power_max,power_max).setFont(font).setColor(grey_0_gui);
}





// image sorting channel
void gui_static_image(int space, int max, int w, float start_pos, int from, PFont font) {
	gui_static_img_2D = new ControlP5(this);
	gui_static_img_3D = new ControlP5(this);
  
  int min_mark = 0;
	int max_mark = 6;
	int mark = 7;
	gui_static_img_2D.addSlider("vel_sort").setPosition(10,pos_slider_y(space, start_pos +0, from)).setWidth(w).setRange(min_mark,max_mark).setNumberOfTickMarks(mark).setFont(font).setColor(grey_0_gui);
	gui_static_img_2D.addSlider("x_sort").setPosition(10,pos_slider_y(space, start_pos +1.5, from)).setWidth(w).setRange(min_mark,max_mark).setNumberOfTickMarks(mark).setFont(font).setColor(grey_0_gui);
	gui_static_img_2D.addSlider("y_sort").setPosition(10,pos_slider_y(space, start_pos +3, from)).setWidth(w).setRange(min_mark,max_mark).setNumberOfTickMarks(mark).setFont(font).setColor(grey_0_gui);
	gui_static_img_3D.addSlider("z_sort").setPosition(10,pos_slider_y(space, start_pos +4.5, from)).setWidth(w).setRange(min_mark,max_mark).setNumberOfTickMarks(mark).setFont(font).setColor(grey_0_gui);

}




// mouse device
void gui_dynamic_spot(int space, int max, int w, float start_pos, int from, PFont font){
	gui_dynamic_spot = new ControlP5(this);

	float max_min_radius = 1 ;

	float max_max_radius = 7. ;


	int min_mark_spiral = 0;
	int max_mark_spiral = 20;
  int spiral_mark = 21;

  int min_mark_beat = 0 ;
  int max_mark_beat = 200;

	gui_dynamic_spot.addSlider("radius_spot").setPosition(10,pos_slider_y(space, start_pos +0, from)).setWidth(w).setRange(0,max).setFont(font).setColor(red_gui);
	gui_dynamic_spot.addSlider("min_radius_spot").setPosition(10,pos_slider_y(space, start_pos +1, from)).setWidth(w).setRange(0,max_min_radius).setFont(font).setColor(red_gui);
	gui_dynamic_spot.addSlider("max_radius_spot").setPosition(10,pos_slider_y(space, start_pos +2, from)).setWidth(w).setRange(max_min_radius,max_max_radius).setFont(font).setColor(red_gui);
  
  gui_dynamic_spot.addSlider("distribution_spot").setPosition(10,pos_slider_y(space, start_pos +3, from)).setWidth(w).setRange(0,TAU).setFont(font).setColor(red_gui);
  gui_dynamic_spot.addSlider("spiral_spot").setPosition(10,pos_slider_y(space, start_pos +4, from)).setWidth(w).setRange(min_mark_spiral,max_mark_spiral).setNumberOfTickMarks(spiral_mark).setFont(font).setColor(red_gui);
  gui_dynamic_spot.addSlider("beat_spot").setPosition(10,pos_slider_y(space, start_pos +5.5, from)).setWidth(w).setRange(min_mark_beat,max_mark_beat).setFont(font).setColor(red_gui);

  gui_dynamic_spot.addSlider("speed_spot").setPosition(10,pos_slider_y(space, start_pos +6.5, from)).setWidth(w).setRange(-max,max).setFont(font).setColor(red_gui);
  gui_dynamic_spot.addSlider("motion_spot").setPosition(10,pos_slider_y(space, start_pos +7.5, from)).setWidth(w).setRange(0,max).setFont(font).setColor(red_gui);
}





















/**
control event
v 0.0.3
*/
public void controlEvent(ControlEvent theEvent) {
	if(gui_init_controller && !external_gui_is) {
		if(theEvent.isFrom(check_gui_main)) {
			if(check_gui_main.getArrayValue(0) == 1) gui_change_size_window_is = true; else gui_change_size_window_is = false;
			if(check_gui_main.getArrayValue(1) == 1) gui_fullfit_image_is = true; else gui_fullfit_image_is = false;
			if(check_gui_main.getArrayValue(2) == 1) gui_display_bg = true; else gui_display_bg = false;
			if(check_gui_main.getArrayValue(3) == 1) gui_show_must_go_on = true; else gui_show_must_go_on = false;
	  }

	  if(theEvent.isFrom(check_gui_main_channel)) {
			if(check_gui_main_channel.getArrayValue(0) == 1) gui_warp_is = true; else gui_warp_is = false;
	  }
/*
	  if(theEvent.isFrom(check_gui_vehicle)) {
			if(check_gui_vehicle.getArrayValue(0) == 1) gui_vehicle_pixel_is = true; else gui_vehicle_pixel_is = false;
	  } 
	  */

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
	gui_main_movie.getController("header_movie").setValue(get_movie_pos_norm());
	gui_main_movie.getController("speed_movie");
}


/*
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
*/




