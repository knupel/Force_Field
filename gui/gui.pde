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




void setup() {
	size(500,750,P2D);

	oscP5 = new OscP5(this,12000);
	destination = new NetAddress("127.0.0.1",12000);
	gui_setup(Vec2(0), Vec2(250,height));

}

void draw() {
	background(0);
	send_value_controller();
	//println(value);
}






float ref_value_controller ;
void send_value_controller() {
	float current_value = sum_controller();
	if(current_value != ref_value_controller) {
		send();
		// println("on envoie du courrier", frameCount);
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


