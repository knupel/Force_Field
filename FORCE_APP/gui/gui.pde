/**
GUI Force
2017-2019
http://stanlepunk.xyz/
v 0.3.0
Processing 3.5.2
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
	gui_setup(vec2(0), vec2(250,height));
}

void draw() {
	background(0);
	send_value_controller();
	show_gui();
	set_controller_from_outside();
	if(mousePressed) update_import_list();
	load_data_from_app_force(240, !mousePressed);
}



String [] ext_img = {"jpg", "JPG", "JPEG", "jpeg", "tif", "TIF", "tiff", "TIFF", "bmp", "BMP", "png", "PNG", "gif", "GIF"};
String [] ext_movie = {"mov", "MOV", "avi", "AVI", "mp4", "MP4", "mkv", "MKV", "mpg", "MPG"};
String [] ext_shape = {"svg", "SVG"};

void update_import_list() {
	String[] file_path = loadStrings(sketchPath(1)+"/save/import_files.txt");
	if(file_path != null) {
		if(file_path != null) {
			media.clear();
			spot.clear();
			vehicle.clear();
			for(int i = 0 ; i < menu_basic_shape.length ; i++) {
				spot.addItem(menu_basic_shape[i],i);
				vehicle.addItem(menu_basic_shape[i],i);
			}


      
			for(int i = 1 ; i < file_path.length ;i++) {
				String ext = extension(file_path[i]);
				boolean dead_link = false;
				File f = new File(file_path[i]);
				String dead = "*** ";
				if(!f.exists()) dead_link = true;
				String [] s = split(file_path[i], "/");
				for(String str : ext_img) {
					if(ext.equals(str)) {
						String file_name = s[s.length -1];
						if(!dead_link) {
							media.addItem(file_name,i-1);
						} else {
							media.addItem(dead+file_name,i-1);
						}
					}
				}

				for(String str : ext_movie) {
					if(ext.equals(str)) {
						String file_name = s[s.length -1];
						if(!dead_link) {
							media.addItem(file_name,i-1);
						} else {
							media.addItem(dead+file_name,i-1);
						}
					}
				}

				for(String str : ext_shape) {
					if(ext.equals(str)) {
						String file_name = s[s.length -1];
						if(!dead_link) {
							spot.addItem(file_name,i-1);
							vehicle.addItem(file_name,i-1);
						} else {
							spot.addItem(dead+file_name,i-1);
							vehicle.addItem(dead+file_name,i-1);
						}
					}
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
	if(current_value_slider != ref_value_slider || state_button_is()) {
	// if(!misc_curtain_is() && (current_value_slider != ref_value_slider || state_button_is()) ) {
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


