/**
internal GUI Force
2017-2018
http://stanlepunk.xyz/
v 0.3.3
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


// global slider
boolean gui_display_background;
boolean gui_display_vehicle;
boolean gui_display_warp;

boolean gui_change_size_window_is ;
boolean gui_fullfit_image_is ;
boolean gui_show_must_go_on;
boolean gui_warp_is;
boolean gui_full_reset_field_is;
boolean gui_vehicle_pixel_is;


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
	// this variable is used in internal GUI
	set_internal_boolean();
	build_gui();

	red_gui = new CColor(r.BLOOD,r.CARMINE,r.RED,r.WHITE,r.WHITE);
	grey_0_gui = new CColor(r.GRAY_3,r.GRAY_2,r.GRAY_4,r.WHITE,r.WHITE);

	pos_gui = pos.copy();
	size_gui = size.copy();
	int slider_width = 100 ;
	space_interface = 12;
	int max = 1;
  
  gui_mode();

  // COL 1
  // menu static field
  gui_static_generative(space_interface, max, slider_width, col_1_x, 19.5, TOP);
  gui_static_image(space_interface, max, slider_width, col_1_x, 23, TOP);
  // menu dynamic field
  gui_dynamic_fluid(space_interface, max, slider_width, col_1_x, 19.5, TOP);
  gui_dynamic_spot(space_interface, max, slider_width, col_1_x, 23, TOP);
  // vehicle
  


  // COL 2
  gui_misc(space_interface, max, slider_width, col_2_x, 3, TOP);
  gui_vehicle(space_interface, max, slider_width, col_2_x, 32, TOP);
  gui_main_movie(space_interface, max, slider_width, col_2_x, 1, BOTTOM);

  gui_button(space_interface, slider_width, col_1_x, 3, TOP);



  
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
	state_button(true);
	for (int i = 0 ; i < mode.length ; i++) {
		if(n == i) {
			mode[i] = true; 
		} else {
			mode[i] = false;
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


void gui_button(int space, int w, float pos_x, float pos_y, int from) {
	/*
	String [] method_name = {"bool_background", "bool_vehicle", "bool_warp", "bool_field", "bool_spot"};
	String [] label = {"background", "vehicle", "warp", "force field", "spot"};
	int w_button = width /(label.length +2);
	// bar
	gui_button.addToggle(method_name[0]).setLabel(label[0]).setPosition(w_button*0,16).setSize(w_button,15).setColor(red_gui).getCaptionLabel().align(CENTER,CENTER);
	gui_button.addToggle(method_name[1]).setLabel(label[1]).setPosition(w_button*1,16).setSize(w_button,15).setColor(red_gui).getCaptionLabel().align(CENTER,CENTER);
	gui_button.addToggle(method_name[2]).setLabel(label[2]).setPosition(w_button*2,16).setSize(w_button,15).setColor(red_gui).getCaptionLabel().align(CENTER,CENTER);
	gui_button.addToggle(method_name[3]).setLabel(label[3]).setPosition(w_button*3,16).setSize(w_button,15).setColor(red_gui).getCaptionLabel().align(CENTER,CENTER);
	gui_button.addToggle(method_name[4]).setLabel(label[4]).setPosition(w_button*4,16).setSize(w_button,15).setColor(red_gui).getCaptionLabel().align(CENTER,CENTER);
	*/
	String [] method_name = {"bool_background", "bool_vehicle", "bool_warp", "bool_field", "bool_spot"};
	String [] label = {"background", "vehicle", "warp", "force field", "spot"};
  String name = "display";
  iVec2 pos = iVec2(0,16);
  int num_by_line = label.length;
  iVec2 size = iVec2 (int(width/(num_by_line *1.5)),15); 
  iVec2 spacing = iVec2(0,0);

  set_buttons(pos, size, num_by_line, spacing, gui_button, method_name, label, red_gui);


	// dropdown
	int h_dropdown = 150 ;
	int w_dropdown = int(size.x *1.5);
	String [] media_menu = {"List empty","load items","from the","main sketch"} ;
	media = gui_button.addDropdownList("media_list").setPosition(width -w_dropdown,16 +(h_dropdown*0)).setSize(w_dropdown,h_dropdown).setBarHeight(15).setColor(red_gui).addItems(media_menu);

	String [] shape_menu = {"pixel","point","triangle","shape"} ;
	vehicle = gui_button.addDropdownList("vehicle_list").setPosition(width -w_dropdown,16+(h_dropdown*1)).setSize(w_dropdown,h_dropdown).setBarHeight(15).setColor(red_gui).addItems(shape_menu);
	spot = gui_button.addDropdownList("spot_list").setPosition(width -w_dropdown,16+(h_dropdown*2)).setSize(w_dropdown,h_dropdown).setBarHeight(15).setColor(red_gui).addItems(shape_menu);
	
	// column
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

}



void bool_background(boolean state) {
	state_button(true);
	display_background = state ;
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











void gui_misc(int space, int max, int w, float pos_x, float pos_y, int from) {
	slider_misc_alpha(space, max, w, pos_x, pos_y, from);
	slider_misc_spot(space, max, w, pos_x , pos_y +4.25,from);
	slider_misc_vehicle(space, max, w, pos_x , pos_y +8.5,from);
	slider_misc_warp(space, max, w, pos_x , pos_y +13.,from);

  int max_tempo = 10 ;
	gui_warp.addSlider("tempo_refresh").setPosition(pos_x,pos_slider_y(space, pos_y +22, from)).setWidth(w).setRange(1,max_tempo).setNumberOfTickMarks(max_tempo).setColor(grey_0_gui);
  
  int max_cell = 50;
	gui_main.addSlider("cell_force_field").setPosition(pos_x,pos_slider_y(space, pos_y +24, from)).setWidth(w).setRange(1,max_cell).setNumberOfTickMarks(max_cell).setColor(grey_0_gui);
  
  int max_spot = 100 ;
  if(use_leapmotion) max_spot = 10;
	gui_main.addSlider("spot_num").setPosition(pos_x,pos_slider_y(space, pos_y +25, from)).setWidth(w).setRange(1,max_spot).setNumberOfTickMarks(max_spot).setColor(grey_0_gui);

	int range_spot = 10;
	gui_main.addSlider("spot_range").setPosition(pos_x,pos_slider_y(space, pos_y +27, from)).setWidth(w).setRange(0,range_spot).setNumberOfTickMarks(range_spot +1).setColor(grey_0_gui);
}


void slider_misc_alpha(int space, int max, int w, float pos_x, float pos_y, int from) {
	gui_main.addSlider("alpha_background").setLabel("alpha background").setPosition(pos_x,pos_slider_y(space, pos_y +0, from)).setWidth(w).setRange(0,max).setColor(grey_0_gui);
  gui_spot.addSlider("alpha_spot").setLabel("alpha spot").setPosition(pos_x,pos_slider_y(space, pos_y +1, from)).setWidth(w).setRange(0,max).setColor(grey_0_gui);
  gui_vehicle.addSlider("alpha_vehicle").setLabel("alpha vehicle").setPosition(pos_x,pos_slider_y(space, pos_y +2, from)).setWidth(w).setRange(0,max).setColor(grey_0_gui);
  gui_warp.addSlider("alpha_warp").setLabel("alpha warp").setPosition(pos_x,pos_slider_y(space, pos_y +3, from)).setWidth(w).setRange(0,max).setColor(grey_0_gui);
}

void slider_misc_spot(int space, int max, int w, float pos_x, float pos_y, int from) {
	gui_spot.addSlider("size_spot").setLabel("size spot").setPosition(pos_x,pos_slider_y(space, pos_y +0, from)).setWidth(w).setRange(0,max).setColor(red_gui);
	gui_spot.addSlider("red_spot").setLabel("red spot").setPosition(pos_x,pos_slider_y(space, pos_y +1, from)).setWidth(w).setRange(0,max).setColor(red_gui);
	gui_spot.addSlider("green_spot").setLabel("green spot").setPosition(pos_x,pos_slider_y(space, pos_y +2, from)).setWidth(w).setRange(0,max).setColor(red_gui);
	gui_spot.addSlider("blue_spot").setLabel("blue spot").setPosition(col_2_x,pos_slider_y(space, pos_y +3, from)).setWidth(w).setRange(0,max).setColor(red_gui);	

}

void slider_misc_vehicle(int space, int max, int w, float pos_x, float pos_y, int from) {
	gui_vehicle.addSlider("size_vehicle").setLabel("size vehicle").setPosition(pos_x,pos_slider_y(space, pos_y +0, from)).setWidth(w).setRange(0,max).setColor(red_gui);
	gui_vehicle.addSlider("red_vehicle").setLabel("red vehicle").setPosition(pos_x,pos_slider_y(space, pos_y +1, from)).setWidth(w).setRange(0,max).setColor(red_gui);
	gui_vehicle.addSlider("green_vehicle").setLabel("green vehicle").setPosition(pos_x,pos_slider_y(space, pos_y +2, from)).setWidth(w).setRange(0,max).setColor(red_gui);
	gui_vehicle.addSlider("blue_vehicle").setLabel("green vehicle").setPosition(col_2_x,pos_slider_y(space, pos_y +3, from)).setWidth(w).setRange(0,max).setColor(red_gui);	
}


void slider_misc_warp(int space, int max, int w, float pos_x, float pos_y, int from) {
	gui_warp.addSlider("red_warp").setPosition(pos_x,pos_slider_y(space, pos_y +0, from)).setWidth(w).setRange(0,max).setColor(grey_0_gui);
	gui_warp.addSlider("green_warp").setPosition(pos_x,pos_slider_y(space, pos_y +1, from)).setWidth(w).setRange(0,max).setColor(grey_0_gui);
	gui_warp.addSlider("blue_warp").setPosition(pos_x,pos_slider_y(space, pos_y +2, from)).setWidth(w).setRange(0,max).setColor(grey_0_gui);
	gui_warp.addSlider("power_warp").setPosition(pos_x,pos_slider_y(space, pos_y +3, from)).setWidth(w).setRange(0,max).setColor(grey_0_gui);
  
	gui_warp.addSlider("red_cycling").setPosition(pos_x,pos_slider_y(space, pos_y +4.25, from)).setWidth(w).setRange(0,max).setColor(red_gui);
	gui_warp.addSlider("green_cycling").setPosition(pos_x,pos_slider_y(space, pos_y +5.25, from)).setWidth(w).setRange(0,max).setColor(red_gui);
	gui_warp.addSlider("blue_cycling").setPosition(pos_x,pos_slider_y(space, pos_y +6.25, from)).setWidth(w).setRange(0,max).setColor(red_gui);
	gui_warp.addSlider("power_cycling").setPosition(pos_x,pos_slider_y(space, pos_y +7.25, from)).setWidth(w).setRange(0,max).setColor(red_gui);
}







void gui_vehicle(int space, int max, int w, float pos_x, float pos_y, int from) {	
  int min_num_vehicle = 0 ;
  int max_num_vehicle = 1 ;
  int max_speed = 25 ;
  int max_velocity_vehicle = max_speed ;
	gui_vehicle.addSlider("num_vehicle").setPosition(pos_x,pos_slider_y(space, pos_y +0, from)).setWidth(w).setRange(min_num_vehicle,max_num_vehicle).setColor(grey_0_gui);
  gui_vehicle.addSlider("velocity_vehicle").setPosition(pos_x,pos_slider_y(space, pos_y +1, from)).setWidth(w).setRange(0,max_velocity_vehicle).setColor(grey_0_gui);
}


void gui_main_movie(int space, int max, int w, float pos_x, float pos_y, int from) {
	int max_speed = 6 ;
	gui_main_movie.addSlider("header_movie").setPosition(pos_x,pos_slider_y(space, pos_y, from)).setWidth(w).setRange(0,max).setColor(grey_0_gui);
	gui_main_movie.addSlider("speed_movie").setPosition(pos_x,pos_slider_y(space, pos_y +2, from)).setWidth(w).setRange(-max_speed,max_speed).setNumberOfTickMarks((max_speed *8) +1).setColor(grey_0_gui);
}


void gui_dynamic_fluid(int space, int max, int w, float pos_x, float pos_y, int from) {
	gui_dynamic_fluid.addSlider("frequence").setPosition(pos_x,pos_slider_y(space, pos_y +0, from)).setWidth(w).setRange(0,max).setColor(grey_0_gui);
  gui_dynamic_fluid.addSlider("viscosity").setPosition(pos_x,pos_slider_y(space, pos_y +1, from)).setWidth(w).setRange(0,max).setColor(grey_0_gui);
  gui_dynamic_fluid.addSlider("diffusion").setPosition(pos_x,pos_slider_y(space, pos_y +2, from)).setWidth(w).setRange(0,max).setColor(grey_0_gui);
}


void gui_static_generative(int space, int max, int w, float pos_x, float pos_y, int from) {
	gui_static_generative.addSlider("range_min_gen").setPosition(pos_x,pos_slider_y(space, pos_y +0, from)).setWidth(w).setRange(0,max).setColor(grey_0_gui);
	gui_static_generative.addSlider("range_max_gen").setPosition(pos_x,pos_slider_y(space, pos_y +1, from)).setWidth(w).setRange(0,max).setColor(grey_0_gui);
	float power_max = 3 ;
	gui_static_generative.addSlider("power_gen").setPosition(pos_x,pos_slider_y(space, pos_y +2, from)).setWidth(w).setRange(-power_max,power_max).setColor(grey_0_gui);
}


void gui_static_image(int space, int max, int w, float pos_x, float pos_y, int from) {
  int min_mark = 0;
	int max_mark = 6;
	int mark = 7;
	gui_static_img_2D.addSlider("vel_sort").setPosition(pos_x,pos_slider_y(space, pos_y +0, from)).setWidth(w).setRange(min_mark,max_mark).setNumberOfTickMarks(mark).setColor(grey_0_gui);
	gui_static_img_2D.addSlider("x_sort").setPosition(pos_x,pos_slider_y(space, pos_y +1.5, from)).setWidth(w).setRange(min_mark,max_mark).setNumberOfTickMarks(mark).setColor(grey_0_gui);
	gui_static_img_2D.addSlider("y_sort").setPosition(pos_x,pos_slider_y(space, pos_y +3, from)).setWidth(w).setRange(min_mark,max_mark).setNumberOfTickMarks(mark).setColor(grey_0_gui);
	gui_static_img_3D.addSlider("z_sort").setPosition(pos_x,pos_slider_y(space, pos_y +4.5, from)).setWidth(w).setRange(min_mark,max_mark).setNumberOfTickMarks(mark).setColor(grey_0_gui);
}


void gui_dynamic_spot(int space, int max, int w, float pos_x, float pos_y, int from){
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
control event
v 0.0.3
*/
public void controlEvent(ControlEvent theEvent) {
	if(gui_init_controller) {
		if(theEvent.isFrom(checkbox_main)) {
			state_button(true);
			if(checkbox_main.getArrayValue(0) == 1) change_size_window_is = true; else change_size_window_is = false;
			if(checkbox_main.getArrayValue(1) == 1) fullfit_image_is = true; else fullfit_image_is = false;
			if(checkbox_main.getArrayValue(2) == 1) show_must_go_on = true; else show_must_go_on = false;
	  }

	  if(theEvent.isFrom(checkbox_channel)) {
	  	state_button(true);
			if(checkbox_channel.getArrayValue(0) == 1) warp_is = true; else warp_is = false;
	  }

	  if(theEvent.isFrom(checkbox_mag_grav)) {
	  	state_button(true);
			if(checkbox_mag_grav.getArrayValue(0) == 1) full_reset_field_is = true; else full_reset_field_is = false;
	  }
    
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
	if(!warp_is) {
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













void set_internal_boolean() {
	if(display_background) gui_display_background = true ; else gui_display_background = false;
  if(change_size_window_is) gui_change_size_window_is = true ; else gui_change_size_window_is = false;
	if(fullfit_image_is) gui_fullfit_image_is = true ; else gui_fullfit_image_is = false;
	if(show_must_go_on) gui_show_must_go_on = true ; else gui_show_must_go_on = false ;
	if(warp_is) gui_warp_is = true; else gui_warp_is = false;
	if(full_reset_field_is) gui_full_reset_field_is = true ; else  gui_full_reset_field_is = false;
	//if(vehicle_pixel_is) gui_vehicle_pixel_is = true ; else gui_vehicle_pixel_is = false;
}


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

	if(movie_warp_is()) gui_main_movie.show(); else gui_main_movie.hide();	

	if(!use_leapmotion && spot_num > 2 && (mode_gravity_is() || mode_magnetic_is() || mode_fluid_is())) {
		gui_dynamic_spot.show(); 
	} else {
		gui_dynamic_spot.hide();
	}
}















/**
global method CP5
v 0.0.1
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

void set_buttons(iVec2 pos, iVec2 size, int num, iVec2 spacing, ControlP5 cp5, String [] method_name, String [] label, CColor c) {
  cp5 = new ControlP5(this);
  for(int i = 0 ; i < method_name.length ;i++) {

  	cp5.addToggle(method_name[i]).setLabel(label[i])
  			.setPosition(pos.x+(size.x *i),pos.y).setSize(size.x,size.y)
  			//.setItemsPerRow(num).setSpacingColumn(spacing.x).setSpacingRow(spacing.y)
  			.setColor(c).getCaptionLabel().align(CENTER,CENTER);
  }
}






