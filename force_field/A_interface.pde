import controlP5.*;
ControlP5 cp_main, cp_fluid, cp_mouse, cp_movie;


// global slider
float red_channel;
float green_channel;
float blue_channel;

float power_channel;
float power_channel_max;

float warp_power;

float red_cycling;
float green_cycling;
float blue_cycling;

boolean abs_cycling = true;

float tempo_refresh;

float cell_force_field;

float spot_force_field;

// fluid slider
float frequence;
float viscosity;
float diffusion;

Vec2 pos_gui ;
Vec2 size_gui ;

float radius_mouse ;
float speed_mouse;
float angle_mouse;

// movie control
float header_movie;
float speed_movie;

int space_interface ;



PFont font_gui ;

void interface_setup(Vec2 pos, Vec2 size) {
	int size_font = 10 ;
	font_gui = createFont("Lucida",size_font,false); // use true/false for smooth/no-smooth
	// font_gui = createFont("ArialNarrow",size_font,false); // use true/false for smooth/no-smooth
	// PFont pfont = createFont("DIN-Light",8,false); // use true/false for smooth/no-smooth
  //ControlFont font = new ControlFont(font_gui,size_font);

	pos_gui = pos.copy();
	size_gui = size.copy();
	int sw = 100 ;
	space_interface = ceil(font_gui.getSize() *1.5) ;
	int max = 1;

  slider_main(space_interface, max, sw, 1, TOP, font_gui);
  slider_fluid(space_interface, max, sw, 19, TOP, font_gui);

  slider_mouse(space_interface, max, sw, 24, TOP, font_gui);

  slider_movie(space_interface, max, sw, 2, BOTTOM, font_gui);
}

/*
* main
*/
void slider_main(int space, int max, int sw, int start_pos, int from, PFont font) {
	cp_main = new ControlP5(this);

	rgba_channel = Vec4(1);
	red_channel = .9;
	green_channel = .9;
	blue_channel = .9;
	power_channel = .3;

	red_cycling = 0;
	green_cycling = 0;
	blue_cycling = 0;

	warp_power = .9;

  tempo_refresh = 1.;
	cell_force_field = 25.;
	spot_force_field = 5.;

	cp_main.addSlider("red_channel").setPosition(10,pos_slider_y(space, start_pos +0, from)).setWidth(sw).setRange(0,max).setFont(font);
	cp_main.addSlider("green_channel").setPosition(10,pos_slider_y(space, start_pos +1, from)).setWidth(sw).setRange(0,max).setFont(font);
	cp_main.addSlider("blue_channel").setPosition(10,pos_slider_y(space, start_pos +2, from)).setWidth(sw).setRange(0,max).setFont(font);

	cp_main.addSlider("power_channel").setPosition(10,pos_slider_y(space, start_pos +4, from)).setWidth(sw).setRange(0,max).setFont(font);

	cp_main.addSlider("red_cycling").setPosition(10,pos_slider_y(space, start_pos +6, from)).setWidth(sw).setRange(0,max).setFont(font);
	cp_main.addSlider("green_cycling").setPosition(10,pos_slider_y(space, start_pos +7, from)).setWidth(sw).setRange(0,max).setFont(font);
	cp_main.addSlider("blue_cycling").setPosition(10,pos_slider_y(space, start_pos +8, from)).setWidth(sw).setRange(0,max).setFont(font);

	cp_main.addSlider("warp_power").setPosition(10,pos_slider_y(space, start_pos +9, from)).setWidth(sw).setRange(0,max).setFont(font);

	cp_main.addButton("absolute_cycling").setValue(0).setPosition(10,pos_slider_y(space, start_pos +10, from)).setSize(sw,10).setFont(font);
  
  int max_tempo = 10 ;
	cp_main.addSlider("tempo_refresh").setPosition(10,pos_slider_y(space, start_pos +12, from)).setWidth(sw).setRange(1,max_tempo).setNumberOfTickMarks(max_tempo).setFont(font);
  
  int max_cell = 50;
	cp_main.addSlider("cell_force_field").setPosition(10,pos_slider_y(space, start_pos +14, from)).setWidth(sw).setRange(1,max_cell).setNumberOfTickMarks(max_cell).setFont(font);
  
  int max_spot = 10 ;
	cp_main.addSlider("spot_force_field").setPosition(10,pos_slider_y(space, start_pos +16, from)).setWidth(sw).setRange(1,max_spot).setNumberOfTickMarks(max_spot).setFont(font);
}

/*
* movie
*/
void slider_movie(int space, int max, int sw, int start_pos, int from, PFont font) {
	cp_movie = new ControlP5(this);
	header_movie = 0 ;
	speed_movie = 1;
	int max_speed = 6 ;

	cp_movie.addSlider("header_movie").setPosition(10,pos_slider_y(space, start_pos, from)).setWidth(sw).setRange(0,max).setFont(font);

	cp_movie.addSlider("speed_movie").setPosition(10,pos_slider_y(space, start_pos +2, from)).setWidth(sw).setRange(-max_speed,max_speed).setNumberOfTickMarks((max_speed *8) +1).setFont(font);
}


/*
* fluid
*/
void slider_fluid(int space, int max, int sw, int start_pos, int from, PFont font) {
	cp_fluid = new ControlP5(this);
	frequence = .3;
	viscosity = .3;
	diffusion = .3;

	cp_fluid.addSlider("frequence").setPosition(10,pos_slider_y(space, start_pos +0, from)).setWidth(sw).setRange(0,max).setFont(font);
  cp_fluid.addSlider("viscosity").setPosition(10,pos_slider_y(space, start_pos +1, from)).setWidth(sw).setRange(0,max).setFont(font);
  cp_fluid.addSlider("diffusion").setPosition(10,pos_slider_y(space, start_pos +2, from)).setWidth(sw).setRange(0,max).setFont(font);
}

/*
* mouse device
*/
void slider_mouse(int space, int max, int sw, int start_pos, int from, PFont font){
	cp_mouse = new ControlP5(this);

	radius_mouse = .3;
	speed_mouse = 0.;
	angle_mouse = 0.;

	cp_mouse.addSlider("radius_mouse").setPosition(10,pos_slider_y(space, start_pos +0, from)).setWidth(sw).setRange(0,max).setFont(font);
  cp_mouse.addSlider("speed_mouse").setPosition(10,pos_slider_y(space, start_pos +1, from)).setWidth(sw).setRange(0,max).setFont(font);
  cp_mouse.addSlider("angle_mouse").setPosition(10,pos_slider_y(space, start_pos +2, from)).setWidth(sw).setRange(0,TAU).setFont(font);
}



















/**
update
*/
Vec4 rgba_channel ;

void interface_value() {
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
}




void interface_update() {
	get_controller_main();
	get_controller_movie();
	get_controller_fluid();
	get_controller_mouse();
	
}


float movie_pos_normal ;


void get_controller_main() {
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
}

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









/*
local method
*/
float pos_slider_y(int space, int start_pos, int from) {
	float pos_y = 0 ;
	if(from == BOTTOM || from == DOWN) {
		pos_y = height -(space *start_pos);
	} else {
		pos_y = space *start_pos;
	}
	return pos_y ;
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
	return radius_mouse *height;
}

float get_angle_mouse() {
	return angle_mouse;
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
  text("PRESS 'N' TO SELECT MEDIA FOLDER", width/2, height/2);
  text("PRESS 'V' TO SELECT CAMERA", width/2, height/2 +(font_gui.getSize() *1.5));
}




void interface_display(boolean mouse_is, Force_field ff) {
	size_gui.set(size_gui.x, height);
	if(!interface_is()) { 
		hide_all_gui();
	} else {
		background_interface();
		show_gui(mouse_is);
		show_info(ff);
	}
}




void show_info(Force_field ff) {
	fill(255,0,0);
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
	// frame rate
	info_line("Frame rate" + " " +(int)frameRate, space_interface, 6, TOP);
	// devise
	String device_cursor = "mouse";
	if(use_leapmotion)  device_cursor = "leapmotion";
	info_line("Device cursor: "+device_cursor, space_interface, 7, TOP);
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
	cp_movie.hide();
}

void show_gui(boolean mouse_is) {
	cp_main.show();
	if(movie_warp_is()) cp_movie.show(); else cp_movie.hide();
	if(get_type_ff() == r.FLUID) cp_fluid.show(); else cp_fluid.hide();
	if(!mouse_is) cp_mouse.show(); else cp_mouse.hide();
}

void background_interface() {
	fill(0,125);
	noStroke();
	/* left part */
	rect(pos_gui,size_gui);
	/* right part */
	rect(Vec2(width-size_gui.x,pos_gui.y),size_gui);
}




/*
get
*/
Vec2 get_pos_interface() {
	return pos_gui;
}

Vec2 get_size_interface() {
	return size_gui;
}

/*
event
*/
public void controlEvent(ControlEvent theEvent) {
  if(theEvent.getController().getName().equals("absolute_cycling")){
  	if(abs_cycling) {
  		abs_cycling = false ; 
  	} else {
  		abs_cycling = true ;
  	}
  }
}

void hide_interface() {
	if(interface_is) interface_is = false ; else interface_is = true;
}

boolean interface_is = false;
boolean interface_is() {
	return interface_is ;
}