/**
setting for different kind of project, fullscreen, other screen...
*/

String [] path_project_shape;
void project_setup() {
	project_import_shape();
}

void project_import_shape() {
	String path = sketchPath(1)+"/import/shape/";
	youngtimer_import_shape(path);
	// algorave_setup(path);

	for(int i = 0 ; i < path_project_shape.length ;i++) {
		file_path("shape",path_project_shape[i]);
	}


}
void youngtimer_import_shape(String path) {
	path_project_shape = new String[2];
  path_project_shape[0] = (path+"corbeau.svg");
  path_project_shape[1] = (path+"fleur_1.svg");

}

void algorave_import_shape(String path) {
  path_project_shape = new String[3];
  path_project_shape[0] = (path+"algorave_typo.svg");
  path_project_shape[1] = (path+"algorave_picto.svg");
  path_project_shape[2] = (path+"algorave_logo.svg");
}


/**
init display
*/
void init_display_home() {
  int target_display = 0 ;
  iVec2 offset_display = iVec2(0, -get_display_size(target_display).y);

  if(get_display_num() > 1) {
    // other
    set_window_on_other_display(pos_window,size,offset_display,CENTER);
  } else {
    // main
    set_window_on_main_display(pos_window,size,CENTER);
  }
}


void init_display_mac_etienne() {
  iVec2 offset_display = iVec2(0, -get_display_size(1).y);
  int adj_y = (get_display_size(1).y - get_display_size(0).y)/2;
  int target_display_size = 0;
  size.set(get_display_size(0));
  offset_display.set(offset_display.x, offset_display.y +adj_y);
  for(int i = 0 ; i < get_display_num(); i++){
    println(i,get_display_size(i));
  }

  if(get_display_num() > 1) {
  	set_window_on_other_display(pos_window,size,offset_display,CENTER);
    println(width,height);
  } else {
    // main
    set_window_on_main_display(pos_window,size,CENTER);
  }
}


