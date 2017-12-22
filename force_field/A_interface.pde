import controlP5.*;
ControlP5 cp_main, cp_fluid, cp_mouse, cp_movie;


// global slider
float red_channel;
float green_channel;
float blue_channel;

float power_channel;
float power_channel_max;

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





void interface_setup(Vec2 pos, Vec2 size) {
	pos_gui = pos.copy();
	size_gui = size.copy();
	int sw = 100 ;
	int space = 8;
	int max = 1;

  slider_main(space, max, sw, 2, UP);
  slider_fluid(space, max, sw, 32, UP);

  slider_mouse(space, max, sw, 40, UP);

  slider_movie(space, max, sw, 2, DOWN);
}

/*
* main
*/
void slider_main(int space, int max, int sw, int start_pos, int from) {
	cp_main = new ControlP5(this);

	rgba_channel = Vec4(1);
	red_channel = .9;
	green_channel = .9;
	blue_channel = .9;
	power_channel = .3;

	red_cycling = 0;
	green_cycling = 0;
	blue_cycling = 0;

  tempo_refresh = 1.;
	cell_force_field = 25.;
	spot_force_field = 5.;

	cp_main.addSlider("red_channel").setPosition(10,pos_slider_y(space, start_pos +0, from)).setWidth(sw).setRange(0,max);
	cp_main.addSlider("green_channel").setPosition(10,pos_slider_y(space, start_pos +2, from)).setWidth(sw).setRange(0,max);
	cp_main.addSlider("blue_channel").setPosition(10,pos_slider_y(space, start_pos +4, from)).setWidth(sw).setRange(0,max);

	cp_main.addSlider("power_channel").setPosition(10,pos_slider_y(space, start_pos +6, from)).setWidth(sw).setRange(0,max);

	cp_main.addSlider("red_cycling").setPosition(10,pos_slider_y(space, start_pos +9, from)).setWidth(sw).setRange(0,max);
	cp_main.addSlider("green_cycling").setPosition(10,pos_slider_y(space, start_pos +11, from)).setWidth(sw).setRange(0,max);
	cp_main.addSlider("blue_cycling").setPosition(10,pos_slider_y(space, start_pos +13, from)).setWidth(sw).setRange(0,max);
	cp_main.addButton("absolute_cycling").setValue(0).setPosition(10,pos_slider_y(space, start_pos +15, from)).setSize(sw,10);
  
  int max_tempo = 10 ;
	cp_main.addSlider("tempo_refresh").setPosition(10,pos_slider_y(space, start_pos +18, from)).setWidth(sw).setRange(1,max_tempo).setNumberOfTickMarks(max_tempo);
  
  int max_cell = 50;
	cp_main.addSlider("cell_force_field").setPosition(10,pos_slider_y(space, start_pos +21, from)).setWidth(sw).setRange(1,max_cell).setNumberOfTickMarks(max_cell);
  
  int max_spot = 10 ;
	cp_main.addSlider("spot_force_field").setPosition(10,pos_slider_y(space, start_pos +24, from)).setWidth(sw).setRange(1,max_spot).setNumberOfTickMarks(max_spot);
}

/*
* movie
*/
void slider_movie(int space, int max, int sw, int start_pos, int from) {
	cp_movie = new ControlP5(this);
	header_movie = 0 ;
	speed_movie = 1;
	int max_speed = 6 ;

	cp_movie.addSlider("header_movie").setPosition(10,pos_slider_y(space, start_pos, from)).setWidth(sw).setRange(0,max);

	cp_movie.addSlider("speed_movie").setPosition(10,pos_slider_y(space, start_pos +3, from)).setWidth(sw).setRange(-max_speed,max_speed).setNumberOfTickMarks((max_speed *8) +1);
}


/*
* fluid
*/
void slider_fluid(int space, int max, int sw, int start_pos, int from) {
	cp_fluid = new ControlP5(this);
	frequence = .3;
	viscosity = .3;
	diffusion = .3;

	cp_fluid.addSlider("frequence").setPosition(10,pos_slider_y(space, start_pos +0, from)).setWidth(sw).setRange(0,max);
  cp_fluid.addSlider("viscosity").setPosition(10,pos_slider_y(space, start_pos +2, from)).setWidth(sw).setRange(0,max);
  cp_fluid.addSlider("diffusion").setPosition(10,pos_slider_y(space, start_pos +4, from)).setWidth(sw).setRange(0,max);
}

/*
* mouse device
*/
void slider_mouse(int space, int max, int sw, int start_pos, int from){
	cp_mouse = new ControlP5(this);

	radius_mouse = .3;
	speed_mouse = 0.;
	angle_mouse = 0.;

	cp_mouse.addSlider("radius_mouse").setPosition(10,pos_slider_y(space, start_pos +0, from)).setWidth(sw).setRange(0,max);
  cp_mouse.addSlider("speed_mouse").setPosition(10,pos_slider_y(space, start_pos +2, from)).setWidth(sw).setRange(0,max);
  cp_mouse.addSlider("angle_mouse").setPosition(10,pos_slider_y(space, start_pos +4, from)).setWidth(sw).setRange(0,TAU);
}



















/**
update
*/
Vec4 rgba_channel ;
int tempo_display ;
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

	tempo_display = ceil(tempo_refresh);
  
  int size = ceil(cell_force_field) +2;
  set_cell_grid_ff(size);
}



float movie_pos_normal ;
void interface_update() {
	cp_movie.getController("header_movie").setValue(movie_pos_normal);
}









/*
local method
*/
float pos_slider_y(int space, int start_pos, int from) {
	float pos_y = 0 ;
	if(from == DOWN) {
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
void interface_display(Vec2 pos, Vec2 size, boolean mouse_is) {
	pos_gui.set(pos);
	size_gui.set(size);
	if(!interface_is()) { 
		cp_main.hide();
		cp_fluid.hide();
		cp_mouse.hide();
		cp_movie.hide();
	} else {
		cp_main.show();
		if(movie_warp_is()) cp_movie.show(); else cp_movie.hide();
		if(get_type_ff() == r.FLUID) cp_fluid.show(); else cp_fluid.hide();
		if(!mouse_is) cp_mouse.show(); else cp_mouse.hide();
		fill(0,125);
		noStroke();
		rect(pos_gui,size_gui);
	}
}


Vec2 get_pos_interface() {
	return pos_gui;
}

Vec2 get_size_interface() {
	return size_gui;
}

// void controlEvent(ControlEvent theEvent) {
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