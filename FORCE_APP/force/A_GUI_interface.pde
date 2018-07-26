/**
INTERFACE
v 0.3.0
*/
Vec2 pos_gui ;
Vec2 size_gui ;


boolean gui_warp_is;
boolean gui_fullreset_field_is;
boolean gui_full_reset_field_is;
boolean gui_change_size_window_is;
boolean gui_fullfit_image_is;
boolean gui_display_bg;
boolean gui_show_must_go_on;
int leading_interface = 10 ;

int space_interface ;
void gui_setup() {
	// check boolean setting from top first tab sketch   
  if(misc_warp_fx) gui_warp_is = true; else gui_warp_is = false;
  
	if(full_reset_field_is) gui_full_reset_field_is = true ; else  gui_full_reset_field_is = false;
	if(change_size_window_is) gui_change_size_window_is = true ; else gui_change_size_window_is = false;
	if(fullfit_image_is) gui_fullfit_image_is = true ; else gui_fullfit_image_is = false;
	if(display_background) gui_display_bg = true ; else gui_display_bg = false;
	// if(vehicle_pixel_is) gui_vehicle_pixel_is = true ; else gui_vehicle_pixel_is = false;
	if(show_must_go_on) gui_show_must_go_on = true ; else gui_show_must_go_on = false ;

	space_interface = ceil(leading_interface *1.5) ; 
}







void set_interface(Vec2 pos, Vec2 size) {
	pos_gui = pos.copy();
	size_gui = size.copy();
}



void interface_display(boolean mouse_is, Force_field ff) {
	size_gui.set(size_gui.x, height);
	background_interface();
	// check for P3D position
	if(get_renderer() == P3D) {
		start_matrix();
		translateZ(1);
	}
	instruction();
	show_info(ff);
  // check for P3D position
	if(get_renderer() == P3D) stop_matrix();
}















/**
background interface
*/
void background_interface() {
	fill(0,125);
	noStroke();
	// right part
	rect(Vec2(width-size_gui.x,pos_gui.y),size_gui);
	// down part
	int size_down_y = instruction_height ;
	rect(width/3,height - size_down_y, width/3,size_down_y);
}
/**
instruction
*/
int instruction_height = 100 ;
void instruction() {
  textAlign(CENTER);
  fill(255) ;

  int x = width/2 ;
  int y = height -instruction_height +15;
  text("Press 'CMD' + 'O' to select media file", x, y);
  text("Press 'CMD' + 'SHIFT' + 'O' to select media folder", x, y +(leading_interface *1.5));
  text("Press 'V' to select computer camera", x, y +(leading_interface *3));
  text("Press 'C' show or hide interface", x, y +(leading_interface *4.5));
  text("LEARN MORE about GUI see guide file", x, y +(leading_interface *6));
}



/**
info on the right place
*/
void show_info(Force_field ff) {
	fill(255);
	int pos_x = ceil(width-size_gui.x +10) ;

	String type_ff = "no force field apply" ;
	if(ff.get_type() == r.FLUID) type_ff = "fluid" ;
	else if(ff.get_type() == r.MAGNETIC) type_ff = "magnetic" ;
	else if(ff.get_type() == r.GRAVITY) type_ff = "gravity" ;
	else type_ff = "static" ;
  
  String pattern_ff = "nothing" ;
  if(ff.get_pattern() == r.CHAOS) pattern_ff = "chaos" ;
	else if(ff.get_pattern() == r.PERLIN) pattern_ff = "perlin" ;
	else if(ff.get_pattern() == IMAGE) pattern_ff = "image" ;
	else if(ff.get_pattern() == r.EQUATION) pattern_ff = "equation" ;

	info_line("Force field" + " " + type_ff + " mapped on " + pattern_ff, pos_x, space_interface, 1, TOP);

  display_texture(pos_x,2) ;

	int step_y = get_img_velocity_ff().height / 7 ;
	if(step_y < 10 ) step_y = 10 ;
	else if(step_y >= 10 && step_y < 13) step_y = step_y ;
	else if(step_y >= 13 && step_y < 19) step_y = step_y -1 ;
	else if(step_y >= 19 && step_y <= 23) step_y = step_y -2 ;
	else step_y = 22;


	// library
	int items = warp.library_size();
	if(items < 0) items = 0 ;
	info_line("Media library" + " " +items + " items", pos_x, space_interface, 3 +step_y, TOP);
  
  String diaporama_state = "not available";
  if(warp.library_size() > 0) {
  	if(diaporama_is) diaporama_state = "play" ; else diaporama_state = "stop" ;
  } 
  // image display
  info_line("media" + " " +warp.get_name(), pos_x, space_interface, 		4 +step_y, TOP);
  // diaporama
	info_line("Diaporama" + " " +diaporama_state, pos_x, space_interface, 5 +step_y, TOP);
	// sorting channel
	if(ff.get_pattern() == IMAGE) {
		String [] sort = sorting_channel_toString(get_sorting_channel_ff_2D());
		info_line("velocity sort:" + sort[2], pos_x, space_interface, 6 +step_y, TOP);
		info_line("x coord sort:" + sort[0], pos_x, space_interface, 	7 +step_y, TOP);
		info_line("y coord sort:" + sort[1], pos_x, space_interface, 	8 +step_y, TOP);
	}
	// frame rate
	info_line("Frame rate: "  +(int)frameRate, pos_x, space_interface, 10 +step_y, TOP);
	//grid
	info_line("Grid: "  +get_ff().cols +"x"+get_ff().rows, pos_x, space_interface, 11 +step_y, TOP);
	info_line("Cell size: "  +get_resolution_ff(), pos_x, space_interface, 12 +step_y, TOP);
	// device
	String device_cursor = "mouse";
	if(use_leapmotion) device_cursor = "leapmotion";
	info_line("Device cursor: "+device_cursor, pos_x, space_interface, 13 +step_y, TOP);

  info_line("DISPLAY", pos_x, space_interface, 													15 +step_y, TOP);
	info_line("vehicles: "+ display_vehicle_is(), pos_x, space_interface, 16 +step_y, TOP);
	info_line("warp: "+ display_warp_is(), pos_x, space_interface, 				17 +step_y, TOP);
	info_line("background: "+ display_background_is(), pos_x, space_interface, 		18 +step_y, TOP);


	info_line("MISC", pos_x, space_interface, 																20 +step_y, TOP);
	info_line("pause: "+ pause_is, pos_x, space_interface, 										21 +step_y, TOP);
	info_line("Vehicles count: "+get_num_vehicle(),pos_x, space_interface, 22 +step_y, TOP);
}


void display_texture(int x, int rank) {
	float h = get_img_velocity_ff().height;
  float w = get_img_velocity_ff().width;
  int y = rank*10 ;

  if(w > (size_gui.x -20) || h > (size_gui.x /2)) {
  	if(w > (size_gui.x -20)) {
  		w = size_gui.x -20 ;
  		h = get_img_velocity_ff().height  *(w /get_img_velocity_ff().width);
  	} else if(h > (size_gui.x /2)) {
  		h = size_gui.x /2 ;
  		w = get_img_velocity_ff().width  *(h /get_img_velocity_ff().height);
  	} else {
  		w = size_gui.x -20 ;
  		h = get_img_velocity_ff().height  *(w /get_img_velocity_ff().width);
  	}
  	image(get_img_direction_ff(),	x,y +7 +2, 				w,h) ;
  	image(get_img_velocity_ff(),	x,y +h +16 +4, 	w,h);
  } else {
  	image(get_img_direction_ff(),	x,y +7 +2) ;
  	image(get_img_velocity_ff(),	x,y +h +16 +4);
  }
  text("Texture direction",x,y +7);
	text("Texture velocity",x,y+h +16 +2);
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
	textAlign(LEFT);
	text(s,pos_x,pos_y);
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



// get
Vec2 get_pos_interface() {
	return pos_gui;
}

Vec2 get_size_interface() {
	return size_gui;
}

// misc
void hide_interface() {
	if(interface_is) interface_is = false ; else interface_is = true;
}

boolean interface_is() {
	return interface_is ;
}
















