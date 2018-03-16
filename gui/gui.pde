/**
external GUI Force
2017-2018
http://stanlepunk.xyz/
v 0.0.1
*/
import oscP5.*;
import netP5.*;

OscP5 oscP5 ;
NetAddress destination;

boolean use_leapmotion = false;
boolean warp_is = true; 
boolean full_reset_field_is = true ; 
boolean change_size_window_is = true ; 
boolean fullfit_image_is = true ; 
boolean display_bg = true ; 
boolean vehicle_pixel_is = true ; 
boolean show_must_go_on = true ; 

int max_vehicle_ff = 100_000;


void setup() {
	size(300,750);

	oscP5 = new OscP5(this,12000);
	destination = new NetAddress("127.0.0.1",12000);
	gui_setup(Vec2(0), Vec2(250,height));

}

void draw() {
	background(0);
	send_value_controller();
	//println(value);
}



void send() {
	OscMessage message = new OscMessage("courrier");
	/*
	message.add(f_1);
	message.add(f_2);
	message.add(i_1);
	*/
	oscP5.send(message,destination);
}


float ref_value_controller ;
void send_value_controller() {
	float current_value = 0 ;
	if(current_value == ref_value_controller) {

	} else {
		send();
		//println("on envoie du courrier");
		ref_value_controller = current_value ;
	}
}




float pos_slider_y(int space, float start_pos, int from) {
	float pos_y = 0 ;
	if(from == BOTTOM || from == DOWN) {
		pos_y = height -(space *start_pos);
	} else {
		pos_y = space *start_pos;
	}
	return pos_y ;
}


