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

ControlP5 gui_dynamic_fluid;
ControlP5 gui_dynamic_mouse, gui_main_movie;


// global slider


boolean abs_cycling = true;
boolean gui_resize_window = false;
boolean gui_fullfit_image = true;
boolean gui_display_bg = true;




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
  gui_static_generative(space_interface, max, slider_width, 25, TOP, font_gui);
  gui_static_image(space_interface, max, slider_width, 30, TOP, font_gui);

  // menu dynamic field
  gui_dynamic_fluid(space_interface, max, slider_width, 25, TOP, font_gui);
  gui_dynamic_mouse(space_interface, max, slider_width, 30, TOP, font_gui);


  

}




/*
* main
*/
float alpha_bg;
float alpha_vehicle;
float alpha_warp;

Vec4 rgba_channel ;

float red_channel;
float green_channel;
float blue_channel;

float power_channel;
float power_channel_max;

float warp_power;

float red_cycling;
float green_cycling;
float blue_cycling;

float tempo_refresh;

float cell_force_field;

float spot_force_field;

void gui_main(int space, int max, int w, int start_pos, int from, PFont font) {
	gui_main = new ControlP5(this);

	alpha_bg = 1.;
	alpha_vehicle = 1.;
	alpha_warp = 1.;

	rgba_channel = Vec4(1);
	red_channel = .9;
	green_channel = .9;
	blue_channel = .9;
	power_channel = .37;

	red_cycling = 0;
	green_cycling = 0;
	blue_cycling = 0;

	warp_power = .35;

  tempo_refresh = 1.;
	cell_force_field = 25.;
	spot_force_field = 5.;

	check_gui_main = gui_main.addCheckBox("main_setting").setPosition(10,pos_slider_y(space, start_pos +0, from)).setSize(w/3,10).setItemsPerRow(1).setSpacingRow(space/2).addItem("resize_window",1).addItem("fit_image",1).addItem("background",1);
  if(change_size_window_is) check_gui_main.activate(0);
  if(fullfit_image_is) check_gui_main.activate(1);
  if(display_bg) check_gui_main.activate(2);



  gui_main.addSlider("alpha_bg").setPosition(10,pos_slider_y(space, start_pos +3.25, from)).setWidth(w).setRange(0,max).setFont(font);
  gui_main.addSlider("alpha_vehicle").setPosition(10,pos_slider_y(space, start_pos +4.25, from)).setWidth(w).setRange(0,max).setFont(font);
  gui_main.addSlider("alpha_warp").setPosition(10,pos_slider_y(space, start_pos +5.25, from)).setWidth(w).setRange(0,max).setFont(font);

	gui_main.addSlider("red_channel").setPosition(10,pos_slider_y(space, start_pos +7, from)).setWidth(w).setRange(0,max).setFont(font);
	gui_main.addSlider("green_channel").setPosition(10,pos_slider_y(space, start_pos +8, from)).setWidth(w).setRange(0,max).setFont(font);
	gui_main.addSlider("blue_channel").setPosition(10,pos_slider_y(space, start_pos +9, from)).setWidth(w).setRange(0,max).setFont(font);

	gui_main.addSlider("power_channel").setPosition(10,pos_slider_y(space, start_pos +11, from)).setWidth(w).setRange(0,max).setFont(font);

	gui_main.addSlider("red_cycling").setPosition(10,pos_slider_y(space, start_pos +13, from)).setWidth(w).setRange(0,max).setFont(font);
	gui_main.addSlider("green_cycling").setPosition(10,pos_slider_y(space, start_pos +14, from)).setWidth(w).setRange(0,max).setFont(font);
	gui_main.addSlider("blue_cycling").setPosition(10,pos_slider_y(space, start_pos +15, from)).setWidth(w).setRange(0,max).setFont(font);

	gui_main.addSlider("warp_power").setPosition(10,pos_slider_y(space, start_pos +16, from)).setWidth(w).setRange(0,max).setFont(font);

	// radio_button_cycling = gui_main.addRadioButton("abs_cycling").setValue(0).setPosition(10,pos_slider_y(space, start_pos +10, from)).setSize(w,10).addItem("absolute_cycling",1).setFont(font);
	check_gui_main_channel = gui_main.addCheckBox("channel_setting").setPosition(10,pos_slider_y(space, start_pos +17, from)).setSize(w/3,10).setItemsPerRow(1).setSpacingRow(space/2).addItem("absolute_cycling",1);
	//check_img = gui_static_img_2D.addCheckBox("img_setting").setPosition(10,pos_slider_y(space, start_pos +6, from)).setSize(w/3,10).setItemsPerRow(1).setSpacingRow(space/2).addItem("fit_image",1);
  
  int max_tempo = 10 ;
	gui_main.addSlider("tempo_refresh").setPosition(10,pos_slider_y(space, start_pos +18, from)).setWidth(w).setRange(1,max_tempo).setNumberOfTickMarks(max_tempo).setFont(font);
  
  int max_cell = 50;
	gui_main.addSlider("cell_force_field").setPosition(10,pos_slider_y(space, start_pos +20, from)).setWidth(w).setRange(1,max_cell).setNumberOfTickMarks(max_cell).setFont(font);
  
  int max_spot = 100 ;
	gui_main.addSlider("spot_force_field").setPosition(10,pos_slider_y(space, start_pos +22, from)).setWidth(w).setRange(1,max_spot).setNumberOfTickMarks(max_spot).setFont(font);


}

/*
* movie
*/

float header_movie;
float speed_movie;

void gui_main_movie(int space, int max, int w, int start_pos, int from, PFont font) {
	gui_main_movie = new ControlP5(this);
	header_movie = 0 ;
	speed_movie = 1;
	int max_speed = 6 ;

	gui_main_movie.addSlider("header_movie").setPosition(10,pos_slider_y(space, start_pos, from)).setWidth(w).setRange(0,max).setFont(font);

	gui_main_movie.addSlider("speed_movie").setPosition(10,pos_slider_y(space, start_pos +2, from)).setWidth(w).setRange(-max_speed,max_speed).setNumberOfTickMarks((max_speed *8) +1).setFont(font);
}


/*
* fluid
*/
float frequence;
float viscosity;
float diffusion;

void gui_dynamic_fluid(int space, int max, int w, int start_pos, int from, PFont font) {
	gui_dynamic_fluid = new ControlP5(this);
	frequence = .3;
	viscosity = .3;
	diffusion = .3;

	gui_dynamic_fluid.addSlider("frequence").setPosition(10,pos_slider_y(space, start_pos +0, from)).setWidth(w).setRange(0,max).setFont(font);
  gui_dynamic_fluid.addSlider("viscosity").setPosition(10,pos_slider_y(space, start_pos +1, from)).setWidth(w).setRange(0,max).setFont(font);
  gui_dynamic_fluid.addSlider("diffusion").setPosition(10,pos_slider_y(space, start_pos +2, from)).setWidth(w).setRange(0,max).setFont(font);
}



/*
* generative seting for CHAOS and PERLIN field
*/
float range_min_gen;
float range_max_gen;
float power_gen;

void gui_static_generative(int space, int max, int w, int start_pos, int from, PFont font) {
	gui_static_generative = new ControlP5(this);

	range_min_gen = 0.;
	range_max_gen = 1.;
	power_gen = 1. ;
	
  
	gui_static_generative.addSlider("range_min_gen").setPosition(10,pos_slider_y(space, start_pos +0, from)).setWidth(w).setRange(0,max).setFont(font);
	gui_static_generative.addSlider("range_max_gen").setPosition(10,pos_slider_y(space, start_pos +1, from)).setWidth(w).setRange(0,max).setFont(font);
	float power_max = 3 ;
	gui_static_generative.addSlider("power_gen").setPosition(10,pos_slider_y(space, start_pos +2, from)).setWidth(w).setRange(-power_max,power_max).setFont(font);

}




/*
* image sorting channel
*/
float vel_sort = 6.;
float x_sort = 1.;
float y_sort = 1.;
float z_sort = 1.;

void gui_static_image(int space, int max, int w, int start_pos, int from, PFont font) {
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




/*
* mouse device
*/
float radius_mouse ;
float min_radius_mouse ;
float max_radius_mouse ;
float speed_mouse;
float distribution_mouse;
float spiral_mouse;
float beat_mouse;
float motion_mouse;

void gui_dynamic_mouse(int space, int max, int w, int start_pos, int from, PFont font){
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

  int min_mark_beat = 1 ;
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


void update_gui_value(boolean update_is) {
	int size = ceil(cell_force_field) +2;
  set_cell_grid_ff(size);

	update_value_ff_fluid(frequence,viscosity,diffusion,update_is);
	update_value_ff_generative(range_min_gen,range_max_gen,power_gen,update_is);

	update_rgba_channel();
  
  set_sorting_channel_ff_2D(floor(x_sort), floor(y_sort), floor(vel_sort));

  set_resize_window(gui_resize_window);
  set_fit_image(gui_fullfit_image);
  set_alpha_background(alpha_bg);
  set_alpha_vehicle(alpha_vehicle);
  set_alpha_warp(alpha_warp);

  display_bg(gui_display_bg);
}


void update_rgba_channel() {
	float cr = 1.;
  float cg = 1.;
  float cb = 1.;
  if(red_cycling != 0) {
  	cr = sin(frameCount *(red_cycling *red_cycling *.1)); 
  }
  if(green_cycling != 0) {
  	cg = sin(frameCount *(green_cycling *green_cycling *.1)); 
  }
  if(blue_cycling != 0) {
  	cb = sin(frameCount *(blue_cycling *blue_cycling *.1)); 
  }

  if(abs_cycling) {
  	cr = abs(cr) ;
  	cg = abs(cg) ;
  	cb = abs(cb) ;
  }

  Vec4 sin_val = Vec4(1);
  sin_val.set(cr,cg,cb,1);

	rgba_channel.set(red_channel,green_channel,blue_channel,1);
	power_channel_max = (power_channel *power_channel)  *10f;
  
	rgba_channel.mult(power_channel_max);
	
	float min_src = 0 ;
	float max_src = 1 ;
	float min_dst = .01 ;
	rgba_channel.set(sin_val.map_vec(Vec4(min_src), Vec4(max_src), Vec4(min_dst), rgba_channel));

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
  }

  if(theEvent.isFrom(check_gui_main_channel)) {
		if(check_gui_main_channel.getArrayValue(0) == 1) abs_cycling = true ; else abs_cycling = false ;
  } 
}



/**
get controller
*/
void get_controller_gui() {
	// get_controller_main();
	get_controller_movie();
	// get_controller_fluid();
	// get_controller_mouse();
	// get_controller_image();
	
}

void get_check_gui_main_display() {
	if(display_bg_is()) {
		check_gui_main.activate(2);
	} else {
		println("disable");
		check_gui_main.deactivate(2);
	}
}



void get_controller_main() {
	
	/*
	gui_main.getController("red_channel");
	gui_main.getController("green_channel");
	gui_main.getController("blue_channel");

	gui_main.getController("power_channel");

	gui_main.getController("red_cycling");
	gui_main.getController("green_cycling");
	gui_main.getController("blue_cycling");

	gui_main.getController("warp_power");

	gui_main.getController("absolute_cycling");
  
	gui_main.getController("tempo_refresh");
  
	gui_main.getController("cell_force_field");
  
	gui_main.getController("spot_force_field");
	*/
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

/*
* mouse device
*/
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

int get_tempo_refresh_gui() {
	return ceil(tempo_refresh);
}

float get_red_channel_gui() {
	return red_channel;
}
float get_green_channel_gui() {
	return green_channel;
}
float get_blue_channel_gui() {
	return blue_channel;
}

Vec3 get_rgb_channel_norm_gui() {
	return Vec3(red_channel,green_channel,blue_channel);

}

Vec4 get_rgba_channel_mapped_gui() {
	return rgba_channel;
}

/*
Vec3 get_rgb_channel_mapped_gui() {
	return rgb_channel;
}
*/


float get_warp_power_gui() {
	return warp_power;
}


float get_pos_movie_norm_gui() {
	return movie_pos_normal ;
}

float get_speed_movie_gui() {
	return speed_movie ;
}

int get_num_spot_gui() {
	return int(spot_force_field) ;
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
	return motion_mouse * motion_mouse * motion_mouse * motion_mouse *motion_mouse;
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



/**
display
*/

/**
instruction
*/
void warp_instruction() {
  textAlign(CENTER);
  //background(255);
  fill(255) ;
  textFont(font_gui);
  text("PRESS 'CMD' + 'O' TO SELECT MEDIA FILE", width/2, height/2);
  text("PRESS 'CMD' + 'SHIFT' + 'O' TO SELECT MEDIA FOLDER", width/2, height/2 +(font_gui.getSize() *1.5));
  text("PRESS 'V' TO SELECT CAMERA", width/2, height/2 +(font_gui.getSize() *3));
}




void interface_display(boolean mouse_is, Force_field ff) {
	size_gui.set(size_gui.x, height);
	if(!interface_is()) { 
		hide_all_gui();
	} else {
		background_interface();
		show_gui(mouse_is, ff);
		show_info(ff);
	}
}



/**
info on the right place
*/
void show_info(Force_field ff) {
	fill(255);
	int pos_x = ceil(width-size_gui.x +10) ;

	String type_ff = "no froce field apply" ;
	if(ff.get_type() == r.FLUID) type_ff = "fluid" ;
	else if(ff.get_type() == r.MAGNETIC) type_ff = "magnetic" ;
	else if(ff.get_type() == r.GRAVITY) type_ff = "gravity" ;
	else if(ff.get_type() == r.CHAOS) type_ff = "chaos" ;
	else if(ff.get_type() == r.PERLIN) type_ff = "perlin" ;
	else if(ff.get_type() == IMAGE) type_ff = "image" ;

	info_line("Force field" + " " + type_ff, pos_x, space_interface, 1, TOP);
  
  

	image(get_img_velocity_ff(),pos_x, 2 *10) ;
	image(get_img_direction_ff(),pos_x, (2 *10) +get_img_velocity_ff().height +2);
	int step_y = get_img_velocity_ff().height / 7 ;

	// library
	int items = warp.library_size() ;
	if(items < 0) items = 0 ;
	info_line("Media library" + " " +items + " items", pos_x, space_interface, 3 +step_y, TOP);
  
  String diaporama_state = "not available";
  if(warp.library_size() > 0) {
  	if(diaporama_is) diaporama_state = "play" ; else diaporama_state = "stop" ;
  } 
  // image display
  info_line("media" + " " +warp.get_name(), pos_x, space_interface, 4 +step_y, TOP);
  // diaporama
	info_line("Diaporama" + " " +diaporama_state, pos_x, space_interface, 5 +step_y, TOP);
	// sorting channel
	if(ff.get_type() == IMAGE) {
		String [] sort = sorting_channel_toString(get_sorting_channel_ff_2D());
		info_line("velocity sort:" + sort[2], pos_x, space_interface, 6 +step_y, TOP);
		info_line("x coord sort:" + sort[0], pos_x, space_interface, 7 +step_y, TOP);
		info_line("y coord sort:" + sort[1], pos_x, space_interface, 8 +step_y, TOP);
	}
	// frame rate
	info_line("Frame rate" + " " +(int)frameRate, pos_x, space_interface, 10 +step_y, TOP);
	// device
	String device_cursor = "mouse";
	if(use_leapmotion)  device_cursor = "leapmotion";
	info_line("Device cursor: "+device_cursor, pos_x, space_interface, 11 +step_y, TOP);
}










String [] sorting_channel_toString(int [] a) {
	String [] data  = new String[a.length];
	for(int i = 0 ; i < a.length ; i++) {
		if(a[i] == r.RED) data[i] = "Red";
		else if(a[i] == r.GREEN) data[i] = "Green";
		else if(a[i] == r.BLUE) data[i] = "Blue";
		else if(a[i] == r.HUE) data[i] = "Hue";
		else if(a[i] == r.SATURATION) data[i] = "Saturation";
		else if(a[i] == r.BRIGHTNESS) data[i] = "Brightness";
		else data[i] = "Alpha";
	}
	return data;
}

void info_line(String s, int pos_x, int space, int rank, int from) {
	float pos_y = pos_slider_y(space, rank, from);
	// int pos_x = ceil(width-size_gui.x +10) ;
	textAlign(LEFT);
	text(s,pos_x,pos_y);
}

void hide_all_gui() {
	gui_main.hide();

	gui_dynamic_fluid.hide();
	gui_static_img_2D.hide();
	gui_static_img_3D.hide();
	gui_static_generative.hide();

	gui_dynamic_mouse.hide();
	gui_main_movie.hide();
}

void show_gui(boolean mouse_is, Force_field ff) {
	gui_main.show();

	// show menu depend of force field type
	if(ff.get_type() == IMAGE) gui_static_img_2D.show(); else gui_static_img_2D.hide();

	if(ff.get_type() == r.FLUID) gui_dynamic_fluid.show(); else gui_dynamic_fluid.hide();
	if(ff.get_type() == r.CHAOS || ff.get_type() == r.PERLIN || ff.get_type() == IMAGE) gui_static_generative.show(); else gui_static_generative.hide();


	if(movie_warp_is()) gui_main_movie.show(); else gui_main_movie.hide();	

	if(!mouse_is && get_spot_num_ff() > 2) {
		gui_dynamic_mouse.show(); 
	} else {
		gui_dynamic_mouse.hide();
	}
}









/**
util method
*/
float pos_slider_y(int space, float start_pos, int from) {
	float pos_y = 0 ;
	if(from == BOTTOM || from == DOWN) {
		pos_y = height -(space *start_pos);
	} else {
		pos_y = space *start_pos;
	}
	return pos_y ;
}


void background_interface() {
	fill(0,125);
	noStroke();
	/* left part */
	rect(pos_gui,size_gui);
	/* right part */
	rect(Vec2(width-size_gui.x,pos_gui.y),size_gui);
}


void hide_interface() {
	if(interface_is) interface_is = false ; else interface_is = true;
}

boolean interface_is = false;
boolean interface_is() {
	return interface_is ;
}


/**
get
*/
Vec2 get_pos_interface() {
	return pos_gui;
}

Vec2 get_size_interface() {
	return size_gui;
}











