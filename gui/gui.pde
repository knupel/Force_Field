/**
external GUI Force
2017-2018
http://stanlepunk.xyz/
v 0.1.0
*/
import oscP5.*;
import netP5.*;

OscP5 osc ;
NetAddress destination;
int port = 12_000;

boolean use_leapmotion = false;


void setup() {
	size(500,600,P2D);
	surface.setLocation(30,30);
	osc = new OscP5(this,port);
	destination = new NetAddress("127.0.0.1",port);

	mode = new boolean[num_mode];
	gui_setup(Vec2(0), Vec2(250,height));
}

void draw() {
	background(0);
	send_value_controller();
	show_gui();
	set_controller_from_outside();
	if(mousePressed) update_import_list();
	load_data_from_app_force(240, !mousePressed);

	if(misc_curtain_is()) {
		set_state_button(gui_button, display_method_name[0], true);
		for(int i = 1 ; i < display_method_name.length ; i++) {
			set_state_button(gui_button, display_method_name[i], false);
		} 		
	}
}




void update_import_list() {
	String[] files = loadStrings(sketchPath(1)+"/save/import_files.txt");
	if(files != null) {
		String[] type = new String[files.length];
	  for(int i = 0 ; i < files.length ; i++) {
	  	String [] s = split(files[i], "/");
	  	type[i] = s[0];
	  	files[i] = s[s.length -1];

	  }
		if(files != null) {
			media.clear();
			spot.clear();
			vehicle.clear();
			for(int i = 0 ; i < menu_basic_shape.length ; i++) {
				spot.addItem(menu_basic_shape[i],i);
				vehicle.addItem(menu_basic_shape[i],i);
			}

			println("file imported",files.length);
			for(int i = 1 ; i < files.length ;i++) {
				if(type[i].equals("movie") || type[i].equals("image")) {
					media.addItem(files[i],i-1);
				}

				if(type[i].equals("shape")) {
					int target = i-1 +menu_basic_shape.length;
					spot.addItem(files[i],target);
					vehicle.addItem(files[i],target);
				}
				
			}
		} else {
			printErr("method update_media_list() don't find a file to update");
		}
	} else {
		printErr("method update_media_list() : String [] files import is null");
	}
}








float ref_value_slider ;
void send_value_controller() {
	float current_value_slider = sum_slider();
	if(!misc_curtain_is() && (current_value_slider != ref_value_slider || state_button_is()) ) {
		state_button(false);
		send();
		ref_value_slider = current_value_slider ;
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


