/**
internal GUI Force
2017-2018
http://stanlepunk.xyz/
v 0.3.3
*/
import controlP5.*;
boolean gui_init_controller = false;

ControlP5 gui_mode;
ControlP5 gui_button;
CheckBox checkbox_main ;
CheckBox checkbox_channel ;
CheckBox checkbox_mag_grav ;
CheckBox checkbox_vehicle ;

DropdownList media;


ControlP5 gui_main;
ControlP5 gui_static_img_2D;
ControlP5 gui_static_img_3D;
ControlP5 gui_static_generative;
ControlP5 gui_dynamic_mag_grav;
ControlP5 gui_dynamic_fluid;
ControlP5 gui_dynamic_spot;
ControlP5 gui_main_movie;
ControlP5 gui_vehicle;




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
int col_2_x = 150 ;

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
	space_interface = 15;
	int max = 1;
  

  gui_mode();
  gui_button(space_interface, slider_width, 3, TOP);
  // main
  gui_main(space_interface, max, slider_width, 3, TOP);

  gui_main_movie(space_interface, max, slider_width, 2, BOTTOM);
  
  // menu static field
  gui_static_generative(space_interface, max, slider_width, 29.5, TOP);
  gui_static_image(space_interface, max, slider_width, 33, TOP);

  // menu dynamic field
  gui_dynamic_fluid(space_interface, max, slider_width, 29.5, TOP);
  // gui_dynamic_mag_grav(space_interface, max, slider_width, 29.5, TOP);

  gui_dynamic_spot(space_interface, max, slider_width, 33, TOP);

  // vehicle
  gui_vehicle(space_interface, max, slider_width, 41.5, TOP);
  
  // boolean to give authorization to update controller
  gui_init_controller = true;
}


void build_gui() {
	gui_button = new ControlP5(this);
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
	ButtonBar b = gui_mode.addButtonBar("mode").setPosition(0,0).setSize(width,15).addItems(mode).setColor(red_gui);
}


void gui_button(int space, int w, float start_pos, int from) {
	String [] method_name = {"bool_background", "bool_vehicle", "bool_image"};
	String [] label = {"background", "vehicle", "image"};
	int w_button = width /(label.length +2);
	// bar
	gui_button.addToggle(method_name[0]).setLabel(label[0]).setPosition(w_button*0,16).setSize(w_button,15).setColor(red_gui).getCaptionLabel().align(CENTER,CENTER);
	gui_button.addToggle(method_name[1]).setLabel(label[1]).setPosition(w_button*1,16).setSize(w_button,15).setColor(red_gui).getCaptionLabel().align(CENTER,CENTER);
	gui_button.addToggle(method_name[2]).setLabel(label[2]).setPosition(w_button*2,16).setSize(w_button,15).setColor(red_gui).getCaptionLabel().align(CENTER,CENTER);

	// dropdown
	String [] medias = {"List empty","load items","from the","main sketch"} ;
	media = gui_button.addDropdownList("media_list").setPosition(width-w_button,16).setHeight(150).setBarHeight(15).setColor(red_gui).addItems(medias);
	
	// column
	checkbox_main = gui_button.addCheckBox("main_setting").setPosition(col_1_x,pos_slider_y(space, start_pos +0, from)).setSize(w/3,10).setItemsPerRow(1).setSpacingRow(space/2)
														.addItem("resize window",1).addItem("fit image",1).addItem("show must go on",1).setColor(grey_0_gui);
  if(gui_change_size_window_is) checkbox_main.activate(0);
  if(gui_fullfit_image_is) checkbox_main.activate(1);
  if(gui_show_must_go_on) checkbox_main.activate(2);

	checkbox_channel = gui_button.addCheckBox("channel_setting").setPosition(10,pos_slider_y(space, start_pos +4, from)).setSize(w/3,10).setItemsPerRow(1).setSpacingRow(space/2)
																.addItem("WARP",1).setColor(red_gui);
	if(gui_warp_is) checkbox_channel.activate(0);

	checkbox_mag_grav = gui_button.addCheckBox("spot_setting").setPosition(10,pos_slider_y(space, start_pos +5, from)).setSize(w/3,10).setItemsPerRow(1).setSpacingRow(space/2)
																.addItem("full_reset_field",1).setColor(grey_0_gui);
	if(gui_full_reset_field_is) checkbox_mag_grav.activate(0);

	checkbox_vehicle = gui_button.addCheckBox("vehicle_setting").setPosition(10,pos_slider_y(space, start_pos +6, from)).setSize(w/3,10).setItemsPerRow(1).setSpacingRow(space/2)
																.addItem("PIXEL / SHAPE",1).setColor(red_gui);
	if(gui_vehicle_pixel_is) checkbox_vehicle.activate(0);
}



void bool_background(boolean state) {
	state_button(true);
	display_background = state ;
}

void bool_vehicle(boolean state) {
	state_button(true);
	display_vehicle = state ;
}

void bool_image(boolean state) {
	state_button(true);
	display_warp = state ;
}

void mode(int n) {
	state_button(true);
	for (int i = 0 ; i < mode.length ; i++) {
		if(n == i) mode[i] = true; else mode[i] = false;
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


















void gui_main(int space, int max, int w, float start_pos, int from) {	
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

/*
void gui_dynamic_mag_grav(int space, int max, int w, float start_pos, int from) {

}
*/


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

	  if(theEvent.isFrom(checkbox_vehicle)) {
	  	state_button(true);
			if(checkbox_vehicle.getArrayValue(0) == 1) vehicle_pixel_is = true; else vehicle_pixel_is = false;
	  } 

	  if(theEvent.isFrom(checkbox_mag_grav)) {
	  	state_button(true);
			if(checkbox_mag_grav.getArrayValue(0) == 1) full_reset_field_is = true; else full_reset_field_is = false;
	  }
    
    if (theEvent.isFrom(media)) {
    	state_button(true);
	    which_media = (int)theEvent.getController().getValue();
	  }
	}	 
}



/**
set controller
*/
/*
void set_check_gui_main_display(boolean state) {
	if(state) {
		checkbox_main.activate(2);
	} else {
		println("disable display");
		checkbox_main.deactivate(2);
	}
}

void set_check_gui_dynamic_mag_grav(boolean state) {
	if(state) {
		checkbox_mag_grav.activate(0);
	} else {		
		checkbox_mag_grav.deactivate(0);
	}
}
*/














/**
get controller
*/
void get_controller_gui() {
	// get_controller_movie();
	get_controller_main();
}

float ref_power_cycling;
boolean switch_off_power_cycling;
void get_controller_main() {
	if(!warp_is) {
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

/*
float movie_pos_normal ;
void get_controller_movie() {
	gui_main_movie.getController("header_movie").setValue(movie_pos_normal);
	gui_main_movie.getController("speed_movie");
}
*/












void set_internal_boolean() {
	if(display_background) gui_display_background = true ; else gui_display_background = false;
  if(change_size_window_is) gui_change_size_window_is = true ; else gui_change_size_window_is = false;
	if(fullfit_image_is) gui_fullfit_image_is = true ; else gui_fullfit_image_is = false;
	if(show_must_go_on) gui_show_must_go_on = true ; else gui_show_must_go_on = false ;
	if(warp_is) gui_warp_is = true; else gui_warp_is = false;
	if(full_reset_field_is) gui_full_reset_field_is = true ; else  gui_full_reset_field_is = false;
	if(vehicle_pixel_is) gui_vehicle_pixel_is = true ; else gui_vehicle_pixel_is = false;
}


void show_gui(boolean mouse_is) {
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

	if(display_vehicle_is()) gui_vehicle.show() ; else gui_vehicle.hide();

	if(movie_warp_is()) gui_main_movie.show(); else gui_main_movie.hide();	

	if(!mouse_is && spot_num > 2) {
		gui_dynamic_spot.show(); 
	} else {
		gui_dynamic_spot.hide();
	}
}



