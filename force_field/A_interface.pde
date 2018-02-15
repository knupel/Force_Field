/**
Interface force field 
2017-2018
http://stanlepunk.xyz/
v 0.2.1
*/
import controlP5.*;
ControlP5 cp_main; 
CheckBox check_channel, check_main ;

ControlP5 cp_img_2D,cp_img_3D;
ControlP5 cp_fluid ;


ControlP5 cp_mouse, cp_movie;


// global slider


boolean abs_cycling = true;
boolean gui_resize_window = false;
boolean gui_fullfit_image = true;
boolean gui_display_result = true;




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

  cp_main(space_interface, max, slider_width, 1, TOP, font_gui);
  
  // menu for differente force field
  cp_fluid(space_interface, max, slider_width, 23, TOP, font_gui);
  cp_image(space_interface, max, slider_width, 23, TOP, font_gui);

  cp_mouse(space_interface, max, slider_width, 28, TOP, font_gui);



  cp_movie(space_interface, max, slider_width, 2, BOTTOM, font_gui);

}




/*
* main
*/
float alpha_background ;

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

void cp_main(int space, int max, int w, int start_pos, int from, PFont font) {
	cp_main = new ControlP5(this);

	alpha_background = 1.;

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

	check_main = cp_main.addCheckBox("main_setting").setPosition(10,pos_slider_y(space, start_pos +0, from)).setSize(w/3,10).setItemsPerRow(1).setSpacingRow(space/2).addItem("resize_window",1).addItem("fit_image",1).addItem("display_result",1);
  if(change_size_window_is) check_main.activate(0);
  if(fullfit_image_is) check_main.activate(1);
  check_main.activate(2);



  cp_main.addSlider("alpha_background").setPosition(10,pos_slider_y(space, start_pos +3.25, from)).setWidth(w).setRange(0,max).setFont(font);

	cp_main.addSlider("red_channel").setPosition(10,pos_slider_y(space, start_pos +5, from)).setWidth(w).setRange(0,max).setFont(font);
	cp_main.addSlider("green_channel").setPosition(10,pos_slider_y(space, start_pos +6, from)).setWidth(w).setRange(0,max).setFont(font);
	cp_main.addSlider("blue_channel").setPosition(10,pos_slider_y(space, start_pos +7, from)).setWidth(w).setRange(0,max).setFont(font);

	cp_main.addSlider("power_channel").setPosition(10,pos_slider_y(space, start_pos +9, from)).setWidth(w).setRange(0,max).setFont(font);

	cp_main.addSlider("red_cycling").setPosition(10,pos_slider_y(space, start_pos +11, from)).setWidth(w).setRange(0,max).setFont(font);
	cp_main.addSlider("green_cycling").setPosition(10,pos_slider_y(space, start_pos +12, from)).setWidth(w).setRange(0,max).setFont(font);
	cp_main.addSlider("blue_cycling").setPosition(10,pos_slider_y(space, start_pos +13, from)).setWidth(w).setRange(0,max).setFont(font);

	cp_main.addSlider("warp_power").setPosition(10,pos_slider_y(space, start_pos +14, from)).setWidth(w).setRange(0,max).setFont(font);

	// radio_button_cycling = cp_main.addRadioButton("abs_cycling").setValue(0).setPosition(10,pos_slider_y(space, start_pos +10, from)).setSize(w,10).addItem("absolute_cycling",1).setFont(font);
	check_channel = cp_main.addCheckBox("channel_setting").setPosition(10,pos_slider_y(space, start_pos +15, from)).setSize(w/3,10).setItemsPerRow(1).setSpacingRow(space/2).addItem("absolute_cycling",1);
	//check_img = cp_img_2D.addCheckBox("img_setting").setPosition(10,pos_slider_y(space, start_pos +6, from)).setSize(w/3,10).setItemsPerRow(1).setSpacingRow(space/2).addItem("fit_image",1);
  
  int max_tempo = 10 ;
	cp_main.addSlider("tempo_refresh").setPosition(10,pos_slider_y(space, start_pos +16, from)).setWidth(w).setRange(1,max_tempo).setNumberOfTickMarks(max_tempo).setFont(font);
  
  int max_cell = 50;
	cp_main.addSlider("cell_force_field").setPosition(10,pos_slider_y(space, start_pos +18, from)).setWidth(w).setRange(1,max_cell).setNumberOfTickMarks(max_cell).setFont(font);
  
  int max_spot = 100 ;
	cp_main.addSlider("spot_force_field").setPosition(10,pos_slider_y(space, start_pos +20, from)).setWidth(w).setRange(1,max_spot).setNumberOfTickMarks(max_spot).setFont(font);


}

/*
* movie
*/

float header_movie;
float speed_movie;

void cp_movie(int space, int max, int w, int start_pos, int from, PFont font) {
	cp_movie = new ControlP5(this);
	header_movie = 0 ;
	speed_movie = 1;
	int max_speed = 6 ;

	cp_movie.addSlider("header_movie").setPosition(10,pos_slider_y(space, start_pos, from)).setWidth(w).setRange(0,max).setFont(font);

	cp_movie.addSlider("speed_movie").setPosition(10,pos_slider_y(space, start_pos +2, from)).setWidth(w).setRange(-max_speed,max_speed).setNumberOfTickMarks((max_speed *8) +1).setFont(font);
}


/*
* fluid
*/
float frequence;
float viscosity;
float diffusion;

void cp_fluid(int space, int max, int w, int start_pos, int from, PFont font) {
	cp_fluid = new ControlP5(this);
	frequence = .3;
	viscosity = .3;
	diffusion = .3;

	cp_fluid.addSlider("frequence").setPosition(10,pos_slider_y(space, start_pos +0, from)).setWidth(w).setRange(0,max).setFont(font);
  cp_fluid.addSlider("viscosity").setPosition(10,pos_slider_y(space, start_pos +1, from)).setWidth(w).setRange(0,max).setFont(font);
  cp_fluid.addSlider("diffusion").setPosition(10,pos_slider_y(space, start_pos +2, from)).setWidth(w).setRange(0,max).setFont(font);
}





/*
* image sorting channel
*/
float vel_sort = 6.;
float x_sort = 1.;
float y_sort = 1.;
float z_sort = 1.;

void cp_image(int space, int max, int w, int start_pos, int from, PFont font) {
	cp_img_2D = new ControlP5(this);
	cp_img_3D = new ControlP5(this);

	vel_sort = 1.;
	x_sort = 1.;
	y_sort = 1.;
	z_sort = 1.;
  
  int min_mark = 0;
	int max_mark = 6;
	int mark = 7;
	cp_img_2D.addSlider("vel_sort").setPosition(10,pos_slider_y(space, start_pos +0, from)).setWidth(w).setRange(min_mark,max_mark).setNumberOfTickMarks(mark).setFont(font);
	cp_img_2D.addSlider("x_sort").setPosition(10,pos_slider_y(space, start_pos +1.5, from)).setWidth(w).setRange(min_mark,max_mark).setNumberOfTickMarks(mark).setFont(font);
	cp_img_2D.addSlider("y_sort").setPosition(10,pos_slider_y(space, start_pos +3, from)).setWidth(w).setRange(min_mark,max_mark).setNumberOfTickMarks(mark).setFont(font);
	cp_img_3D.addSlider("z_sort").setPosition(10,pos_slider_y(space, start_pos +4.5, from)).setWidth(w).setRange(min_mark,max_mark).setNumberOfTickMarks(mark).setFont(font);

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

void cp_mouse(int space, int max, int w, int start_pos, int from, PFont font){
	cp_mouse = new ControlP5(this);

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

	cp_mouse.addSlider("radius_mouse").setPosition(10,pos_slider_y(space, start_pos +0, from)).setWidth(w).setRange(0,max).setFont(font);
	cp_mouse.addSlider("min_radius_mouse").setPosition(10,pos_slider_y(space, start_pos +1, from)).setWidth(w).setRange(0,max_min_radius).setFont(font);
	cp_mouse.addSlider("max_radius_mouse").setPosition(10,pos_slider_y(space, start_pos +2, from)).setWidth(w).setRange(max_min_radius,max_max_radius).setFont(font);
  
  cp_mouse.addSlider("distribution_mouse").setPosition(10,pos_slider_y(space, start_pos +3, from)).setWidth(w).setRange(0,TAU).setFont(font);
  cp_mouse.addSlider("spiral_mouse").setPosition(10,pos_slider_y(space, start_pos +4, from)).setWidth(w).setRange(min_mark_spiral,max_mark_spiral).setNumberOfTickMarks(spiral_mark).setFont(font);;
  cp_mouse.addSlider("beat_mouse").setPosition(10,pos_slider_y(space, start_pos +5.5, from)).setWidth(w).setRange(min_mark_beat,max_mark_beat).setFont(font);

  cp_mouse.addSlider("speed_mouse").setPosition(10,pos_slider_y(space, start_pos +6.5, from)).setWidth(w).setRange(-max,max).setFont(font);
  cp_mouse.addSlider("motion_mouse").setPosition(10,pos_slider_y(space, start_pos +7.5, from)).setWidth(w).setRange(0,max).setFont(font);
}



















/**
draw update
*/
Vec4 rgba_channel ;

void update_gui_value() {
	update_value_ff_fluid(frequence, viscosity, diffusion);
  
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
  
  int size = ceil(cell_force_field) +2;
  set_cell_grid_ff(size);

  set_sorting_channel_ff_2D(floor(x_sort), floor(y_sort), floor(vel_sort));
  set_resize_window(gui_resize_window);
  set_fit_image(gui_fullfit_image);
  set_alpha_background(alpha_background);

  display_result(gui_display_result);
}


/**
control event
v 0.0.2
*/
public void controlEvent(ControlEvent theEvent) {
	if(theEvent.isFrom(check_main)) {
		if(check_main.getArrayValue(0) == 1) gui_resize_window = true ; else gui_resize_window = false ;
		if(check_main.getArrayValue(1) == 1) gui_fullfit_image = true ; else gui_fullfit_image = false ;
		if(check_main.getArrayValue(2) == 1) gui_display_result = true ; else gui_display_result = false;
  }

  if(theEvent.isFrom(check_channel)) {
		if(check_channel.getArrayValue(0) == 1) abs_cycling = true ; else abs_cycling = false ;
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

void get_check_main_display() {
	if(display_result) {
		check_main.activate(2);
	} else {
		println("desactivate");
		check_main.deactivate(2);
	}
}



void get_controller_main() {
	
	/*
	cp_main.getController("red_channel");
	cp_main.getController("green_channel");
	cp_main.getController("blue_channel");

	cp_main.getController("power_channel");

	cp_main.getController("red_cycling");
	cp_main.getController("green_cycling");
	cp_main.getController("blue_cycling");

	cp_main.getController("warp_power");

	cp_main.getController("absolute_cycling");
  
	cp_main.getController("tempo_refresh");
  
	cp_main.getController("cell_force_field");
  
	cp_main.getController("spot_force_field");
	*/
}

float movie_pos_normal ;
void get_controller_movie() {
	cp_movie.getController("header_movie").setValue(movie_pos_normal);
	cp_movie.getController("speed_movie");
}

void get_controller_fluid() {
	cp_fluid.getController("frequence");
  cp_fluid.getController("viscosity");
  cp_fluid.getController("diffusion");
}

/*
* mouse device
*/
void get_controller_mouse() {
	cp_mouse.getController("radius_mouse");
  cp_mouse.getController("speed_mouse");
  cp_mouse.getController("angle_mouse");
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
Vec4 get_rgba_channel_gui() {
	return rgba_channel;
} 
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
  background(255);
  fill(0) ;
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
	String type_ff = "no froce field apply" ;
	if(ff.get_type() == r.FLUID) type_ff = "fluid" ;
	else if(ff.get_type() == r.MAGNETIC) type_ff = "magnetic" ;
	else if(ff.get_type() == r.GRAVITY) type_ff = "gravity" ;
	else if(ff.get_type() == r.CHAOS) type_ff = "chaos" ;
	else if(ff.get_type() == r.PERLIN) type_ff = "perlin" ;
	else if(ff.get_type() == IMAGE) type_ff = "image" ;
	info_line("Force field" + " " + type_ff, space_interface, 2, TOP);

	// library
	int items = warp.library_size() ;
	if(items < 0) items = 0 ;
	info_line("Media library" + " " +items + " items", space_interface, 3, TOP);
  
  String diaporama_state = "not available";
  if(warp.library_size() > 0) {
  	if(diaporama_is) diaporama_state = "play" ; else diaporama_state = "stop" ;
  } 
  // image display
  info_line("media" + " " +warp.get_name(), space_interface, 4, TOP);
  // diaporama
	info_line("Diaporama" + " " +diaporama_state, space_interface, 5, TOP);
	// sorting channel
	if(ff.get_type() == IMAGE) {
		String [] sort = sorting_channel_toString(get_sorting_channel_ff_2D());
		info_line("velocity sort:" + sort[2], space_interface, 6, TOP);
		info_line("x coord sort:" + sort[0], space_interface, 7, TOP);
		info_line("y coord sort:" + sort[1], space_interface, 8, TOP);
	}
	// frame rate
	info_line("Frame rate" + " " +(int)frameRate, space_interface, 10, TOP);
	// device
	String device_cursor = "mouse";
	if(use_leapmotion)  device_cursor = "leapmotion";
	info_line("Device cursor: "+device_cursor, space_interface, 11, TOP);
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

void info_line(String s, int space, int rank, int from) {
	float pos_y = pos_slider_y(space, rank, from);
	int pos_x = ceil(width-size_gui.x +10) ;
	textAlign(LEFT);
	text(s,pos_x,pos_y);

}

void hide_all_gui() {
	cp_main.hide();
	cp_fluid.hide();
	cp_mouse.hide();
	cp_img_2D.hide();
	cp_img_3D.hide();
	cp_movie.hide();
}

void show_gui(boolean mouse_is, Force_field ff) {
	cp_main.show();
	if(ff.get_type() == IMAGE) {
		cp_img_2D.show();
		// cp_image_3D.show();
	} else {
		cp_img_2D.hide();
	}
	if(movie_warp_is()) cp_movie.show(); else cp_movie.hide();
	if(ff.get_type() == r.FLUID) cp_fluid.show(); else cp_fluid.hide();
	if(!mouse_is) cp_mouse.show(); else cp_mouse.hide();
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











