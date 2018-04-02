/**
internal GUI Force
2017-2018
http://stanlepunk.xyz/
v 0.4.0
*/
import controlP5.*;
boolean gui_init_controller = false;

ControlP5 gui_mode;
RadioButton radio_mode;

ControlP5 gui_button;

CheckBox checkbox_main ;
CheckBox checkbox_channel ;
CheckBox checkbox_mag_grav ;
CheckBox checkbox_vehicle ;

DropdownList media;
DropdownList vehicle;
DropdownList spot;


ControlP5 gui_main;
ControlP5 gui_warp;
ControlP5 gui_static_img_2D;
ControlP5 gui_static_img_3D;
ControlP5 gui_static_generative;
ControlP5 gui_dynamic_mag_grav;
ControlP5 gui_dynamic_fluid;
ControlP5 gui_dynamic_spot;
ControlP5 gui_main_movie;
ControlP5 gui_vehicle;
ControlP5 gui_spot;
ControlP5 gui_field;


// global slider
boolean gui_display_background;
boolean gui_display_vehicle;
boolean gui_display_warp;
/*
boolean gui_change_size_window_is ;
boolean gui_fullfit_image_is ;
boolean gui_show_must_go_on;
boolean gui_warp_is;
boolean gui_full_reset_field_is;
boolean gui_vehicle_pixel_is;
*/


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
	build_gui();

	red_gui = new CColor(r.BLOOD,r.CARMINE,r.RED,r.WHITE,r.WHITE);
	grey_0_gui = new CColor(r.GRAY_3,r.GRAY_2,r.GRAY_4,r.WHITE,r.WHITE);

	pos_gui = pos.copy();
	size_gui = size.copy();
	int slider_width = 100 ;
	int bar_height = 15 ;
	space_interface = 12;
	int max = 1;
  
  gui_mode();

  // COL 1
  // menu static field
  gui_static_generative(space_interface, max, slider_width, col_1_x, 19.5, TOP,grey_0_gui);
  gui_static_image(space_interface, max, slider_width, col_1_x, 23, TOP,grey_0_gui);
  // menu dynamic field
  gui_dynamic_fluid(space_interface, max, slider_width, col_1_x, 19.5, TOP,grey_0_gui);
  gui_dynamic_spot(space_interface, max, slider_width, col_1_x, 23, TOP,grey_0_gui);
  
  // COL 2
  gui_misc_G(space_interface, max, slider_width, col_2_x, 3, TOP);
  gui_vehicle(space_interface, max, slider_width, col_2_x, 33, TOP,grey_0_gui);

  gui_field(gui_field, space_interface, max, slider_width, col_2_x, 36, TOP,red_gui);

  gui_main_movie(space_interface, max, slider_width, col_2_x, 1, BOTTOM,grey_0_gui);

  gui_button_G(bar_height);
 
  // boolean to give authorization to update controller
  gui_init_controller = true;
}




void build_gui() {
	gui_button = new ControlP5(this);
	gui_mode = new ControlP5(this);
	gui_main = new ControlP5(this);
	gui_warp = new ControlP5(this);
	gui_vehicle = new ControlP5(this);
	gui_spot = new ControlP5(this);
	gui_dynamic_mag_grav = new ControlP5(this);
	gui_dynamic_fluid = new ControlP5(this);
	gui_main_movie = new ControlP5(this);
	gui_static_generative = new ControlP5(this);
	gui_dynamic_spot = new ControlP5(this);
	gui_static_img_2D = new ControlP5(this);
	gui_static_img_3D = new ControlP5(this);
	gui_field = new ControlP5(this);
}


void gui_mode() {
	String [] station = {"PERLIN","CHAOS","EQUATION","IMAGE","GRAVITY","MAGNETIC","FLUID"};
  String name = "mode";
  iVec2 pos = iVec2(0,0);
  int num_by_line = station.length;
  iVec2 size = iVec2((int)width/num_by_line,15); 
  iVec2 spacing = iVec2(0,0);
  radio_mode = set_radio(name, pos, size, num_by_line, spacing, gui_mode, radio_mode, station, red_gui);
}

void mode(int n) {
  if(n != -1) {
  	state_button(true);
  	for (int i = 0 ; i < mode.length ; i++) {
			if(n == i) {
				mode[i] = true; 
			} else {
				mode[i] = false;
			}
		}
  }

	if(mode[0]) perlin_true();
	else if (mode[1]) chaos_true();
	else if (mode[2]) equation_true();
	else if (mode[3]) image_true();
	else if (mode[4]) gravity_true();
	else if (mode[5]) magnetic_true();
	else if (mode[6]) fluid_true();
	else perlin_true();
}


void gui_button_G(int bar_h) {
  //String name = "display";
  iVec2 pos = iVec2(0,bar_h +1);
  int num_by_line = display_label.length;
  iVec2 size = iVec2 (int(width/(num_by_line *1.5)),bar_h); 
  // iVec2 spacing = iVec2(0,0);
  // display
  set_button(pos, size, num_by_line, gui_button, display_method_name, display_label, red_gui);
  // misc
  pos.set(0,(bar_h +1)*3);
  size.set(90,bar_h); 
  num_by_line = 1;
  set_button(pos, size, num_by_line, gui_button, misc_method_name, misc_label, misc_ref, grey_0_gui);

	// dropdown
	pos.set(0,16);
	int h_dropdown = 150 ;
	int w_dropdown = int(size.x *1.5);
	String [] shape_menu = {"pixel","point","triangle","shape"} ;
	String [] media_menu = {"List empty","load items","from the","main sketch"} ;
	media = gui_button.addDropdownList("media_list").setPosition(width -w_dropdown,pos.y*12).setSize(w_dropdown,h_dropdown*2).setBarHeight(bar_h).setColor(red_gui).addItems(media_menu);
	vehicle = gui_button.addDropdownList("vehicle_list").setPosition(width -w_dropdown,pos.y*6.9).setSize(w_dropdown,h_dropdown).setBarHeight(bar_h).setColor(grey_0_gui).addItems(shape_menu);
	spot = gui_button.addDropdownList("spot_list").setPosition(width -w_dropdown,pos.y*3.2).setSize(w_dropdown,h_dropdown).setBarHeight(bar_h).setColor(red_gui).addItems(shape_menu);

	
	
	// column
	/*
	checkbox_main = gui_button.addCheckBox("main_setting").setPosition(pos_x,pos_slider_y(space, pos_y +0, from)).setSize(w/3,10).setItemsPerRow(1).setSpacingRow(space/2)
														.addItem("resize window",1).addItem("fit image",1).addItem("show must go on",1).setColor(grey_0_gui);
  if(gui_change_size_window_is) checkbox_main.activate(0);
  if(gui_fullfit_image_is) checkbox_main.activate(1);
  if(gui_show_must_go_on) checkbox_main.activate(2);

	checkbox_channel = gui_button.addCheckBox("channel_setting").setPosition(pos_x,pos_slider_y(space, pos_y +4, from)).setSize(w/3,10).setItemsPerRow(1).setSpacingRow(space/2)
																.addItem("WARP",1).setColor(red_gui);
	if(gui_warp_is) checkbox_channel.activate(0);

	checkbox_mag_grav = gui_button.addCheckBox("spot_setting").setPosition(pos_x,pos_slider_y(space, pos_y +5, from)).setSize(w/3,10).setItemsPerRow(1).setSpacingRow(space/2)
																.addItem("full_reset_field",1).setColor(grey_0_gui);
	if(gui_full_reset_field_is) checkbox_mag_grav.activate(0);
	*/
}













/**
method call by CP5
*/
/**
control event
v 0.0.3
*/
public void controlEvent(ControlEvent theEvent) {
	if(gui_init_controller) {
		/*
		if(theEvent.isFrom(checkbox_main)) {
			state_button(true);
			if(checkbox_main.getArrayValue(0) == 1) change_size_window_is = true; else change_size_window_is = false;
			if(checkbox_main.getArrayValue(1) == 1) fullfit_image_is = true; else fullfit_image_is = false;
			if(checkbox_main.getArrayValue(2) == 1) show_must_go_on = true; else show_must_go_on = false;
	  }

	  if(theEvent.isFrom(checkbox_channel)) {
	  	state_button(true);
			if(checkbox_channel.getArrayValue(0) == 1) misc_warp_fx = true; else misc_warp_fx = false;
	  }

	  if(theEvent.isFrom(checkbox_mag_grav)) {
	  	state_button(true);
			if(checkbox_mag_grav.getArrayValue(0) == 1) full_reset_field_is = true; else full_reset_field_is = false;
	  }
	  */
    
    if (theEvent.isFrom(media)) {
    	state_button(true);
	    which_media = (int)theEvent.getController().getValue();
	  }

	  if (theEvent.isFrom(vehicle)) {
    	state_button(true);
    	type_vehicle = get_shape_type(theEvent.getController().getValue());
	  }

	  if (theEvent.isFrom(spot)) {
    	state_button(true);
	    type_spot = get_shape_type(theEvent.getController().getValue());
	  }
	}	 
}

// see menu dropdwon "pixel","point","triangle","shape"
int get_shape_type(float value_controller) {
	int v = (int)value_controller;
	if(v==0) return r.PIXEL;
	else if(v==1) return POINT;
	else if(v==2) return TRIANGLE;
	else if(v==3) return SHAPE;
	else return r.PIXEL;
}



// display
void bool_background(boolean state) {
	state_button(true);
	display_background = state;
}

void bool_vehicle(boolean state) {
	state_button(true);
	display_vehicle = state ;
}

void bool_warp(boolean state) {
	state_button(true);
	display_warp = state ;
}

void bool_field(boolean state) {
	state_button(true);
	display_field = state ;
}

void bool_spot(boolean state) {
	state_button(true);
	display_spot = state ;
}




// misc
void bool_size_window(boolean state) {
	state_button(true);
	change_size_window_is = state;
}

void bool_fit_image(boolean state) {
	state_button(true);
	fullfit_image_is = state;
}

void bool_show(boolean state) {
	state_button(true);
	show_must_go_on = state;
}

void bool_warp_fx(boolean state) {
	state_button(true);
	misc_warp_fx = state;
}

void bool_shader_fx(boolean state) {
	state_button(true);
	misc_shader_fx = state;
}

void bool_curtain(boolean state) {
	state_button(true);
	misc_curtain = state;
}

void bool_full_reset(boolean state) {
	state_button(true);
	full_reset_field_is = state;
}



















// set button state
void perlin_true() {
	mode_perlin = true; 
	mode_chaos = false;
	mode_equation = false;
	mode_image = false;
	mode_gravity = false;
	mode_magnetic = false;
	mode_fluid = false;
}

void chaos_true() {
	mode_perlin = false; 
	mode_chaos = true;
	mode_equation = false;
	mode_image = false;
	mode_gravity = false;
	mode_magnetic = false;
	mode_fluid = false;
}

void equation_true() {
	mode_perlin = false; 
	mode_chaos = false;
	mode_equation = true;
	mode_image = false;
	mode_gravity = false;
	mode_magnetic = false;
	mode_fluid = false;
}

void image_true() {
	mode_perlin = false; 
	mode_chaos = false;
	mode_equation = false;
	mode_image = true;
	mode_gravity = false;
	mode_magnetic = false;
	mode_fluid = false;
}

void gravity_true() {
	mode_perlin = false; 
	mode_chaos = false;
	mode_equation = false;
	mode_image = false;
	mode_gravity = true;
	mode_magnetic = false;
	mode_fluid = false;
}

void magnetic_true() {
	mode_perlin = false; 
	mode_chaos = false;
	mode_equation = false;
	mode_image = false;
	mode_gravity = false;
	mode_magnetic = true;
	mode_fluid = false;
}

void fluid_true() {
	mode_perlin = false; 
	mode_chaos = false;
	mode_equation = false;
	mode_image = false;
	mode_gravity = false;
	mode_magnetic = false;
	mode_fluid = true;
}











void gui_misc_G(int space, int max, int w, float pos_x, float pos_y, int from) {
	slider_misc_background(space, max, w, pos_x, pos_y, from, grey_0_gui);
	slider_misc_spot(space, max, w, pos_x , pos_y +1.25, from, red_gui);
	slider_misc_vehicle(space, max, w, pos_x , pos_y +6.5, from, grey_0_gui);
	slider_misc_warp(space, max, w, pos_x , pos_y +12., from, red_gui);

  int max_tempo = 10 ;
	gui_warp.addSlider("tempo_refresh").setPosition(pos_x,pos_slider_y(space, pos_y +22, from)).setWidth(w).setRange(1,max_tempo).setNumberOfTickMarks(max_tempo).setColor(grey_0_gui);
  int max_cell = 50;
	gui_main.addSlider("cell_force_field").setPosition(pos_x,pos_slider_y(space, pos_y +24, from)).setWidth(w).setRange(1,max_cell).setNumberOfTickMarks(max_cell).setColor(grey_0_gui); 
  int max_spot = 100 ;
  if(use_leapmotion) max_spot = 10;
	gui_main.addSlider("spot_num").setPosition(pos_x,pos_slider_y(space, pos_y +26, from)).setWidth(w).setRange(1,max_spot).setNumberOfTickMarks(max_spot).setColor(red_gui);
	int range_spot = 10;
	gui_main.addSlider("spot_range").setPosition(pos_x,pos_slider_y(space, pos_y +28, from)).setWidth(w).setRange(0,range_spot).setNumberOfTickMarks(range_spot +1).setColor(red_gui);
}


void slider_misc_background(int space, int max, int w, float pos_x, float pos_y, int from, CColor c) {
	gui_main.addSlider("alpha_background").setLabel("alpha background").setPosition(pos_x,pos_slider_y(space, pos_y +0, from)).setWidth(w).setRange(0,max).setColor(c);
}

void slider_misc_spot(int space, int max, int w, float pos_x, float pos_y, int from, CColor c) {
	gui_spot.addSlider("size_spot").setLabel("spot size").setPosition(pos_x,pos_slider_y(space, pos_y +0, from)).setWidth(w).setRange(0,max).setColor(c);
	gui_spot.addSlider("red_spot").setLabel("red").setPosition(pos_x,pos_slider_y(space, pos_y +1, from)).setWidth(w).setRange(0,max).setColor(c);
	gui_spot.addSlider("green_spot").setLabel("green").setPosition(pos_x,pos_slider_y(space, pos_y +2, from)).setWidth(w).setRange(0,max).setColor(c);
	gui_spot.addSlider("blue_spot").setLabel("blue").setPosition(col_2_x,pos_slider_y(space, pos_y +3, from)).setWidth(w).setRange(0,max).setColor(c);	
	gui_spot.addSlider("alpha_spot").setLabel("alpha").setPosition(pos_x,pos_slider_y(space, pos_y +4, from)).setWidth(w).setRange(0,max).setColor(c);
 
}

void slider_misc_vehicle(int space, int max, int w, float pos_x, float pos_y, int from, CColor c) {
	gui_vehicle.addSlider("size_vehicle").setLabel("vehicle size").setPosition(pos_x,pos_slider_y(space, pos_y +0, from)).setWidth(w).setRange(0,max).setColor(c);
	gui_vehicle.addSlider("red_vehicle").setLabel("red").setPosition(pos_x,pos_slider_y(space, pos_y +1, from)).setWidth(w).setRange(0,max).setColor(c);
	gui_vehicle.addSlider("green_vehicle").setLabel("greene").setPosition(pos_x,pos_slider_y(space, pos_y +2, from)).setWidth(w).setRange(0,max).setColor(c);
	gui_vehicle.addSlider("blue_vehicle").setLabel("green").setPosition(col_2_x,pos_slider_y(space, pos_y +3, from)).setWidth(w).setRange(0,max).setColor(c);	
  gui_vehicle.addSlider("alpha_vehicle").setLabel("alpha").setPosition(pos_x,pos_slider_y(space, pos_y +4, from)).setWidth(w).setRange(0,max).setColor(c);
}


void slider_misc_warp(int space, int max, int w, float pos_x, float pos_y, int from, CColor c) {
  gui_warp.addSlider("power_warp").setLabel("Warp power").setPosition(pos_x,pos_slider_y(space, pos_y +0, from)).setWidth(w).setRange(0,max).setColor(c);
	gui_warp.addSlider("red_warp").setLabel("red").setPosition(pos_x,pos_slider_y(space, pos_y +1, from)).setWidth(w).setRange(0,max).setColor(c);
	gui_warp.addSlider("green_warp").setLabel("green").setPosition(pos_x,pos_slider_y(space, pos_y +2, from)).setWidth(w).setRange(0,max).setColor(c);
	gui_warp.addSlider("blue_warp").setLabel("blue").setPosition(pos_x,pos_slider_y(space, pos_y +3, from)).setWidth(w).setRange(0,max).setColor(c);
	
  gui_warp.addSlider("power_cycling").setLabel("Warp Cycling").setPosition(pos_x,pos_slider_y(space, pos_y +4.25, from)).setWidth(w).setRange(0,max).setColor(c);  
	gui_warp.addSlider("red_cycling").setLabel("red").setPosition(pos_x,pos_slider_y(space, pos_y +5.25, from)).setWidth(w).setRange(0,max).setColor(c);
	gui_warp.addSlider("green_cycling").setLabel("green").setPosition(pos_x,pos_slider_y(space, pos_y +6.25, from)).setWidth(w).setRange(0,max).setColor(c);
	gui_warp.addSlider("blue_cycling").setLabel("blue").setPosition(pos_x,pos_slider_y(space, pos_y +7.25, from)).setWidth(w).setRange(0,max).setColor(c);
	
	gui_warp.addSlider("alpha_warp").setLabel("alpha").setPosition(pos_x,pos_slider_y(space, pos_y +8.25, from)).setWidth(w).setRange(0,max).setColor(c);	
}







void gui_vehicle(int space, int max, int w, float pos_x, float pos_y, int from, CColor c) {	
  int min_num_vehicle = 0 ;
  int max_num_vehicle = 1 ;
  int max_speed = 25 ;
  int max_velocity_vehicle = max_speed ;
	gui_vehicle.addSlider("num_vehicle").setPosition(pos_x,pos_slider_y(space, pos_y +0, from)).setWidth(w).setRange(min_num_vehicle,max_num_vehicle).setColor(c);
  gui_vehicle.addSlider("velocity_vehicle").setPosition(pos_x,pos_slider_y(space, pos_y +1, from)).setWidth(w).setRange(0,max_velocity_vehicle).setColor(c);
}



void gui_field(ControlP5 cp5, int space, int max, int w, float pos_x, float pos_y, int from, CColor c) {	
  int num_colour_field = 11;
	cp5.addSlider("colour_field").setPosition(pos_x,pos_slider_y(space, pos_y +0, from)).setWidth(w).setRange(0,num_colour_field-1).setNumberOfTickMarks(num_colour_field).setColor(c);
	cp5.addSlider("colour_field_min").setLabel("minimum").setPosition(pos_x,pos_slider_y(space, pos_y +2, from)).setWidth(w).setRange(0,1).setColor(c);
	cp5.addSlider("colour_field_max").setLabel("maximum").setPosition(pos_x,pos_slider_y(space, pos_y +3, from)).setWidth(w).setRange(0,1).setColor(c);
	cp5.addSlider("length_field").setLabel("vector size").setPosition(pos_x,pos_slider_y(space, pos_y +4, from)).setWidth(w).setRange(0,1).setColor(c);
}





void gui_main_movie(int space, int max, int w, float pos_x, float pos_y, int from, CColor c) {
	int max_speed = 6 ;
	gui_main_movie.addSlider("speed_movie").setLabel("speed movie").setPosition(pos_x,pos_slider_y(space, pos_y +1, from)).setWidth(w).setRange(-max_speed,max_speed).setNumberOfTickMarks((max_speed *8) +1).setColor(c);
	gui_main_movie.addSlider("header_movie").setLabel("reader").setPosition(pos_x,pos_slider_y(space, pos_y +2.5, from)).setWidth(w).setRange(0,max).setColor(c);
	gui_main_movie.addSlider("header_target_movie").setLabel("go to").setPosition(pos_x,pos_slider_y(space, pos_y +3.5, from)).setWidth(w).setRange(0,max).setColor(c);
	
}


void gui_dynamic_fluid(int space, int max, int w, float pos_x, float pos_y, int from, CColor c) {
	gui_dynamic_fluid.addSlider("frequence").setPosition(pos_x,pos_slider_y(space, pos_y +0, from)).setWidth(w).setRange(0,max).setColor(c);
  gui_dynamic_fluid.addSlider("viscosity").setPosition(pos_x,pos_slider_y(space, pos_y +1, from)).setWidth(w).setRange(0,max).setColor(c);
  gui_dynamic_fluid.addSlider("diffusion").setPosition(pos_x,pos_slider_y(space, pos_y +2, from)).setWidth(w).setRange(0,max).setColor(c);
}


void gui_static_generative(int space, int max, int w, float pos_x, float pos_y, int from, CColor c) {
	gui_static_generative.addSlider("range_min_gen").setPosition(pos_x,pos_slider_y(space, pos_y +0, from)).setWidth(w).setRange(0,max).setColor(c);
	gui_static_generative.addSlider("range_max_gen").setPosition(pos_x,pos_slider_y(space, pos_y +1, from)).setWidth(w).setRange(0,max).setColor(c);
	float power_max = 3 ;
	gui_static_generative.addSlider("power_gen").setPosition(pos_x,pos_slider_y(space, pos_y +2, from)).setWidth(w).setRange(-power_max,power_max).setColor(c);
}


void gui_static_image(int space, int max, int w, float pos_x, float pos_y, int from, CColor c) {
  int min_mark = 0;
	int max_mark = 6;
	int mark = 7;
	gui_static_img_2D.addSlider("vel_sort").setPosition(pos_x,pos_slider_y(space, pos_y +0, from)).setWidth(w).setRange(min_mark,max_mark).setNumberOfTickMarks(mark).setColor(c);
	gui_static_img_2D.addSlider("x_sort").setPosition(pos_x,pos_slider_y(space, pos_y +1.5, from)).setWidth(w).setRange(min_mark,max_mark).setNumberOfTickMarks(mark).setColor(c);
	gui_static_img_2D.addSlider("y_sort").setPosition(pos_x,pos_slider_y(space, pos_y +3, from)).setWidth(w).setRange(min_mark,max_mark).setNumberOfTickMarks(mark).setColor(c);
	gui_static_img_3D.addSlider("z_sort").setPosition(pos_x,pos_slider_y(space, pos_y +4.5, from)).setWidth(w).setRange(min_mark,max_mark).setNumberOfTickMarks(mark).setColor(c);
}


void gui_dynamic_spot(int space, int max, int w, float pos_x, float pos_y, int from, CColor c){
	float max_min_radius = 1 ;
	float max_max_radius = 7. ;
	int min_mark_spiral = 0;
	int max_mark_spiral = 20;
  int spiral_mark = 21;
  int min_mark_beat = 0 ;
  int max_mark_beat = 200;

	gui_dynamic_spot.addSlider("radius_spot").setPosition(pos_x,pos_slider_y(space, pos_y +0, from)).setWidth(w).setRange(0,max).setColor(red_gui);
	gui_dynamic_spot.addSlider("min_radius_spot").setPosition(pos_x,pos_slider_y(space, pos_y +1, from)).setWidth(w).setRange(0,max_min_radius).setColor(red_gui);
	gui_dynamic_spot.addSlider("max_radius_spot").setPosition(pos_x,pos_slider_y(space, pos_y +2, from)).setWidth(w).setRange(max_min_radius,max_max_radius).setColor(red_gui);
  
  gui_dynamic_spot.addSlider("distribution_spot").setPosition(pos_x,pos_slider_y(space, pos_y +3, from)).setWidth(w).setRange(0,TAU).setColor(red_gui);
  gui_dynamic_spot.addSlider("spiral_spot").setPosition(pos_x,pos_slider_y(space, pos_y +4, from)).setWidth(w).setRange(min_mark_spiral,max_mark_spiral).setNumberOfTickMarks(spiral_mark).setColor(red_gui);
  gui_dynamic_spot.addSlider("beat_spot").setPosition(pos_x,pos_slider_y(space, pos_y +5.5, from)).setWidth(w).setRange(min_mark_beat,max_mark_beat).setColor(red_gui);

  gui_dynamic_spot.addSlider("speed_spot").setPosition(pos_x,pos_slider_y(space, pos_y +6.5, from)).setWidth(w).setRange(-max,max).setColor(red_gui);
  gui_dynamic_spot.addSlider("motion_spot").setPosition(pos_x,pos_slider_y(space, pos_y +7.5, from)).setWidth(w).setRange(0,max).setColor(red_gui);
}
















































/**
set controller
v 0.0.2
*/
void set_controller_from_outside() {
	set_controller_main();
}

float ref_power_cycling;
boolean switch_off_power_cycling;
void set_controller_main() {
	if(!misc_warp_fx) {
		if(!switch_off_power_cycling) ref_power_cycling = power_cycling;
		switch_off_power_cycling = true;
		gui_warp.getController("power_cycling").setValue(0);
	} else {
		if(switch_off_power_cycling) {
			gui_warp.getController("power_cycling").setValue(ref_power_cycling);
		} 
		switch_off_power_cycling = false;
	}
}












/*
void set_internal_boolean() {
	if(display_background) gui_display_background = true ; else gui_display_background = false;
  if(change_size_window_is) gui_change_size_window_is = true ; else gui_change_size_window_is = false;
	if(fullfit_image_is) gui_fullfit_image_is = true ; else gui_fullfit_image_is = false;
	if(show_must_go_on) gui_show_must_go_on = true ; else gui_show_must_go_on = false ;
	if(misc_warp_fx) gui_warp_is = true; else gui_warp_is = false;
	if(full_reset_field_is) gui_full_reset_field_is = true ; else  gui_full_reset_field_is = false;
}
*/


void show_gui() {
	gui_main.show();
	// show menu depend of force field type
  if(mode_gravity_is() || mode_magnetic_is() || mode_fluid_is()) {
  	if(mode_fluid_is()) {
  		gui_dynamic_fluid.show(); 
  	} else gui_dynamic_fluid.hide();
  	if(mode_gravity_is() || mode_magnetic_is()) {
  		gui_dynamic_mag_grav.show(); 
  	} else gui_dynamic_mag_grav.hide();
  } else {
  	gui_dynamic_fluid.hide();
  	gui_dynamic_mag_grav.hide();
  }
  
  if(mode_image_is()) {
  	gui_static_img_2D.show(); 
  } else {
  	gui_static_img_2D.hide();
  	gui_static_img_3D.hide();
  }

	if(mode_chaos_is() || mode_perlin_is() || mode_image_is()) {
		gui_static_generative.show(); 
	} else gui_static_generative.hide();

	if(display_spot_is()) gui_spot.show() ; else gui_spot.hide();

	if(display_vehicle_is()) gui_vehicle.show() ; else gui_vehicle.hide();

	if(display_warp_is()) gui_warp.show(); else gui_warp.hide();

	if(display_field_is()) gui_field.show(); else gui_field.hide();

	if(movie_warp_is()) gui_main_movie.show(); else gui_main_movie.hide();	

	if(!use_leapmotion && spot_num > 2 && (mode_gravity_is() || mode_magnetic_is() || mode_fluid_is())) {
		// println(!use_leapmotion,spot_num, mode_gravity_is(),mode_magnetic_is(),mode_fluid_is(),frameCount);
		gui_dynamic_spot.show(); 
	} else {
		//println(!use_leapmotion,spot_num, mode_gravity_is(),mode_magnetic_is(),mode_fluid_is(),frameCount);
		gui_dynamic_spot.hide();
	}
}















/**
global method CP5
v 0.0.2
*/
RadioButton set_radio(String name, iVec2 pos, iVec2 size, int num, iVec2 spacing, ControlP5 cp5, RadioButton rb, String [] station, CColor c) {
  cp5 = new ControlP5(this);
  rb = cp5.addRadioButton(name).setPosition(pos.x,pos.y).setSize(size.x,size.y).setItemsPerRow(num).setSpacingColumn(spacing.x).setSpacingRow(spacing.y);

  for(int i = 0 ; i < station.length ;i++) {
    rb.addItem(station[i],i).setColor(c) ; 
  }

  int target = 0 ;
  for(Toggle t : rb.getItems()) {
    t.setLabel(station[target]).getCaptionLabel().align(CENTER,CENTER);
    target++;
  }
  return rb ;  
}




void set_button(iVec2 pos, iVec2 size, int num, ControlP5 cp5, String [] method_name, String [] label, CColor c) {
	boolean [] state = new boolean[method_name.length];
	set_button(pos,size,num,cp5,method_name,label,state,c);
}

void set_button(iVec2 pos, iVec2 size, int num, ControlP5 cp5, String [] method_name, String [] label, boolean [] state, CColor c) {
	iVec2 p = iVec2();
	int rx = 0;
	int ry = 0;
  for(int i = 0 ; i < method_name.length ;i++) { 
  	p.set(pos.x +(size.x *rx), pos.y +(size.y *ry));
  	cp5.addToggle(method_name[i]).setLabel(label[i])
  			.setPosition(p.x,p.y).setSize(size.x,size.y)
  			.setColor(c).getCaptionLabel().align(CENTER,CENTER);
  	set_state_button(cp5,method_name[i],state[i]);
  	// compute position in pseudo grid
  	if((i+1)%num == 0) {
  		ry++;
  		rx = 0 ;
  	} else {
  		rx++ ;
  	}
  }

  /*
  if(cp5.getController(name[0]) instanceof Toggle) {
  	Toggle t = (Toggle) cp5.getController(name[0]);
  	t.setState(true);
  }
  */
}



void set_state_button(ControlP5 cp5, String method_name, boolean state) {
  if(gui_button.getController(method_name) instanceof Toggle) {
    Toggle t = (Toggle) cp5.getController(method_name);
    t.setState(state);
  }
}






