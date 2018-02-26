/**
info system
*/
String os_system ;
void info_system() {
  println("java Version Name:",javaVersionName);
  os_system = System.getProperty("os.name");
  println("os.name:",os_system);
  println("os.version:",System.getProperty("os.version"));
}



void global_reset() {
  println("global reset");
  reset_vehicle(get_num_vehicle_gui(),get_ff());
  warp.reset();
  if(force_field.get_type() == IMAGE) {
    force_field_init_is = false ;
    build_ff(force_field.get_type(), get_resultion_ff(), warp.get_image(), get_sorting_channel_ff_2D());
  }
  force_field.refresh();
  update_gui_value(true);
}




/**
KEYPRESSED

*/
void keyPressed() {
  keys[keyCode] = true;
  
  keypressed_add_media() ;

  if(key == 'b') manage_border();

  if(key == 'c') hide_interface();

  if(key == 'd') diaporama_is();

  if(key == 'f') display_field();

  if(key == 'g') display_grid();

  if(key == 'h') display_pole();

  if(key == 'i') display_info();

  if(key == 'a') display_vehicle();
  if(key == 'z') display_warp();
  if(key == 'e') display_bg();

  if(key == 'l') change_cursor_controller();

  
  if(key == 'p') {
    println("export jpg");
    saveFrame();   
  }

  if(key == 'r') {
    global_reset();
  }


  if(key == 'v') play_video_switch();

  if(key == 'w') {
    if(shader_filter_is) shader_filter_is = false ; else shader_filter_is = true ;
  }

  if(key == 'x') change_type_ff() ;



  if(key == ' ') {
    if(pause_is) pause_is = false ; else pause_is = true ;
  }
  
  // navigation in the media movie or picture
  if(keyCode == UP) { 
    which_img--;
    // we don't use 0 to the first element of the array because this one is use for G / surface
    // see void warp_init(int type_field, int size_cell) 
    if(which_img < 1) which_img = warp.library_size() -1 ;
    if(movie_warp_list != null) {
      which_movie--;
      if(which_movie < 0) which_movie = movie_warp_list.size() -1 ;
    }   
  }

  if(keyCode == DOWN) { 
    which_img++; 
    // we don't use 0 to the first element of the array because this one is use for G / surface
    // see void warp_init(int type_field, int size_cell) 
    if(which_img >= warp.library_size()) which_img = 1 ;
    if(movie_warp_list != null) {
      which_movie++;
      if(which_movie >= movie_warp_list.size()) which_movie = 0 ;
    }    
  }
}





void keypressed_add_media() {
  // add media folder
  if(os_system.equals("Mac OS X")) {
    // A use Q
    // Q or q is for A because I don't find a solution to map AZERTY layout
    if(checkKey(157) && checkKey(SHIFT) && checkKey(KeyEvent.VK_Q)) {
      display_warp(true);
      // @see if(key == 'o')
      warp_add_media_folder();
      play_video(false);
    }
  } else {
    // Q or q is for A because I don't find a solution to map AZERTY layout
    if(checkKey(CONTROL) && checkKey(SHIFT) && checkKey(KeyEvent.VK_Q)) {
      display_warp(true);
      // @see if(key == 'o')
      warp_add_media_folder();
      play_video(false);
    }
  }
  // add media file
  if(os_system.equals("Mac OS X")) {
    // A use Q
    // Q or q is for A because I don't find a solution to map AZERTY layout
    if(checkKey(157) && !checkKey(SHIFT) && checkKey(KeyEvent.VK_Q)) {
      display_warp(true);
      // @see if(key == 'o')
      warp_add_media_input();
      play_video(false);
    }
  } else {
    // Q or q is for A because I don't find a solution to map AZERTY layout
    if(checkKey(CONTROL) && !checkKey(SHIFT) && checkKey(KeyEvent.VK_Q)) {
      display_warp(true);
      // @see if(key == 'o')
      warp_add_media_input();
      play_video(false);
    }
  }

  // replace media folder
  if(os_system.equals("Mac OS X")) {
    if(checkKey(157) && checkKey(SHIFT) && checkKey(KeyEvent.VK_O)) {
      display_warp(true);
      // @see if(key == 'a')
      warp_change_media_folder();
      play_video(false);
    }
  } else {
    if(checkKey(CONTROL) && checkKey(SHIFT) && checkKey(KeyEvent.VK_O)) {
      display_warp(true);
      // @see if(key == 'a')
      warp_change_media_folder();
      play_video(false);
    }
  }

  // replace media file
  if(os_system.equals("Mac OS X")) {
    if(checkKey(157) && !checkKey(SHIFT) && checkKey(KeyEvent.VK_O)) {
      display_warp(true);
      // @see if(key == 'a')
      warp_change_media_input();
      play_video(false);
    }
  } else {
    if(checkKey(CONTROL) && !checkKey(SHIFT) && checkKey(KeyEvent.VK_O)) {
      display_warp(true);
      // @see if(key == 'a')
      warp_change_media_input();
      play_video(false);
    }
  }
}

/*
key event
*/
import java.awt.event.KeyEvent;
boolean[] keys = new boolean[526];

boolean checkKey(int k) {
  if (keys.length >= k) return keys[k]; return false;
}


void reset_key() { 
  for(int i = 0 ; i < keys.length ; i++) {
    if(keys[i]) keys[i] = false ;
  }
}















/**
alpha
*/
float a_bg;
float a_warp;
float a_vehicle;

void set_alpha_background(float norm_f){
  a_bg = set_alpha(norm_f);
}

void set_alpha_warp(float norm_f){
  a_warp = set_alpha(norm_f);
}

void set_alpha_vehicle(float norm_f){
  a_vehicle = set_alpha(norm_f);
}


float get_alpha_warp() {
  return a_warp;
}

float get_alpha_vehicle() {
  return a_vehicle;
}

float get_alpha_bg() {
  return a_bg;
}

/*
* local method
*/
float set_alpha(float norm_f) {
  float mult_f = norm_f *norm_f ;
  return map(mult_f,0,1,0.,g.colorModeA);
}












/**
display
*/
/*
* display vehilcle
*/
void display_vehicle() {
  display_result_vehicle = !!((display_result_vehicle == false));
  if(display_vehicle_is()) {
    get_check_gui_main_display();
  }
}

boolean display_vehicle_is() {
  return display_result_vehicle ;
}

void display_vehicle(boolean is) {
  display_result_vehicle = is;
}

/*
* display warp
*/
void display_warp() {
  display_result_warp = !!((display_result_warp == false));
  if(display_warp_is()) {
    get_check_gui_main_display();
  }
}

boolean display_warp_is() {
  return display_result_warp ;
}

void display_warp(boolean is) {
  display_result_warp = is;
}

/*
* display result
*/
void display_bg(boolean is) {
  display_bg = is;
}

boolean display_bg_is() {
  return display_bg;
}

void display_bg() {
  display_bg = !!((display_bg == false));
  get_check_gui_main_display();
}
















/**
image thread
*/
void diaporama(int tempo_diaporama) {
  diaporama(Integer.MAX_VALUE, tempo_diaporama);
}

void diaporama(int type, int tempo_diaporama) {
  if(warp.library_size() > 1 && diaporama_is) {
    if(frameCount%tempo_diaporama == 0) {
      tempo_diaporama = int(random(240,1200));
      if(type == r.CHAOS) {
        which_img = floor(random(warp.library_size()));
        if(which_img >= warp.library_size()) {
          // 0 is the surface g, not a media loaded
          which_img = 1; 
        }
      } else{
        which_img++;
        if(which_img >= warp.library_size()) {
          // 0 is the surface g, not a media loaded
          which_img = 1; 
        }
      }
    }
  }  
}

boolean diaporama_is ;
void diaporama_is() {
  diaporama_is = (true)? !diaporama_is : diaporama_is ;
}


void set_fit_image(boolean state) {
  fullfit_image_is = state;
}





/**
cursor manager
*/
void cursor_manager(boolean display) {
  if(display) {
    iVec2 pos = iVec2(mouseX,mouseY);

    fill(255);
    stroke(0);
    strokeWeight(1);
    cross_rect(pos, 3,7) ;
    // cursor(CROSS);
  } else {
    noCursor();
  }
}


/**
change size window
*/
void set_size(int w, int h) {
  iVec2 s = def_window_size(w,h);
  set_size_ref(s.x,s.y);
  if(s.x != width || s.y != height) {
    surface.setSize(s.x,s.y);   
    iVec2 display = get_display_size();
    int pos_window_x = (display.x - width)/2;
    int pos_window_y = (display.y - height)/2 -pos_y_window_alway_on_top();
    surface.setLocation(pos_window_x,pos_window_y);
    /*
    int [] location = {pos_window_x,pos_window_y} ;
    int [] editorLocation = {0,0};
    surface.placeWindow(location, editorLocation);
    */
  }
}

void set_size_ref(int w, int h) {
  ref_warp_w = w; 
  ref_warp_h = h;
}

iVec2 get_size_ref() {
  return iVec2(ref_warp_w,ref_warp_h);
}

void set_resize_window(boolean state) {
  change_size_window_is = state;
}

void check_current_img_size_against_display() {
  iVec2 display = get_display_size();
  if(warp.get_image().width > display.x || warp.get_image().height > display.y) {
    iVec2 new_size_img = def_window_size(warp.get_image().width, warp.get_image().height);
    warp.get_image().resize(new_size_img.x,new_size_img.y);
  }
}

iVec2 def_window_size(int w, int h) {
  iVec2 ds = get_display_size();
  ds.y -= pos_y_window_alway_on_top();

  if(w > ds.x || h > ds.y) {
    float ratio_x = (float)w / (float)ds.x ;
    float ratio_y = (float)h / (float)ds.y ;
    if(ratio_x > ratio_y) {
      w /= ratio_x ;
      h /= ratio_x ;
    } else {
      w /= ratio_y ;
      h /= ratio_y ;
    }
  }
  return iVec2(w,h);
}

int pos_y_window_alway_on_top() {
  int size_height_bar = 22;
  if(!hide_menu_bar) size_height_bar += 22;
  return size_height_bar;
}













/**
leap motion
*/
FingerLeap finger ;

void leap_setup() {
  finger = new FingerLeap() ;
}

void leap_update() {
  if(finger == null) leap_setup() ;
  finger.update();
}

void change_cursor_controller() {
  if(use_leapmotion) use_leapmotion = false ; else use_leapmotion = true ;
}








/**
info

*/
void info(boolean display_force_field_is,  boolean display_grid_is, boolean display_pole_is) {
  noFill() ;
  stroke(g.colorModeA *.6f);
  strokeWeight(.5);

  if (display_force_field_is) {
    show_force_field();
  }

  if(display_grid_is) {
    // center
    stroke(g.colorModeA *.6f);
    line(0, height/2, width, height/2);
    line(width/2, 0, width/2, height);
    
    stroke(g.colorModeA *.3f);
    int num_x = force_field.get_canvas().x /force_field.get_resolution();
    int num_y =  force_field.get_canvas().y /force_field.get_resolution();
    
    for(int x = 0 ; x < num_x ; x++) {
      for(int y = 0 ; y < num_y ; y++) {
        int pos_x = x *force_field.get_resolution() +force_field.get_canvas_pos().x;
        int pos_y = y *force_field.get_resolution() +force_field.get_canvas_pos().y;
        line(pos_x, 0, pos_x, height);
        line(0, pos_y, width, pos_y);
      }
    }  
  }
  
  // show pole
  if(display_pole_is) {
    for(int i = 0 ; i < force_field.get_spot_num() ; i++) {
      show_pole(force_field.get_spot_pos(i));
    }
  }
  
}








void show_pole(Vec2 pos) {
  strokeWeight(10) ;
  noFill() ;
  stroke(255);
  point(pos);
}



/**
info
*/
boolean display_field = false;
boolean display_grid = false;
boolean display_pole = false;
boolean display_info = false ;

void set_info(boolean display_info) {
  this.display_info = display_info;
  if(display_info) {
    display_field = true ;
    display_grid = true ;
    display_pole = true;
  } else {
    display_field = false;
    display_grid = false;
    display_pole = false;
  }
}



void display_info() {
  display_info = !display_info ;
  set_info(display_info) ;
}

void display_pole(){
  display_pole = !display_pole;
  if(!display_pole) display_info = false ;
}

void display_field(){
  display_field = !display_field;
  if(!display_field) display_info = false ;
}

void display_grid() {
  display_grid = !display_grid;
  if(!display_grid) display_info = false ;
}



/**
save frame
*/
void saveFrame() {
  float compression = 0.9 ;
  save_frame_jpg(compression);
}

/**
save jpg
*/
void save_frame_jpg(float compression) {
  String filename = "image_" +year()+"_"+month()+"_"+day()+"_"+hour() + "_" +minute() + "_" + second() + ".jpg" ; 
 // String path = sketchPath()+"/bmp/";
  String path = sketchPath();
  path += "/jpg" ;
  // saveFrame(path, filename, compression, get_canvas());
  saveFrame(path, filename, compression);
}
























/**
show vector field
v 0.0.5
*/
void show_force_field() {
  float scale = 5 ;
  boolean show_intensity_is = true;
  show_force_field(force_field, scale, show_intensity_is);
}


void show_force_field(Force_field ff, float scale, boolean show_intensity_is) {
  if(ff != null) {
    Vec2 offset = Vec2(ff.get_canvas_pos()) ;
    offset.sub(ff.get_resolution()/2);
    //
    for (int x = 0; x < ff.cols; x++) {
      for (int y = 0; y < ff.rows; y++) {
        Vec2 pos = Vec2(x *ff.get_resolution(), y *ff.get_resolution());
        // pos.add(offset);
        Vec2 dir = Vec2(ff.field[x][y].x,ff.field[x][y].y);
        if(ff.type != r.MAGNETIC && ff.type != r.FLUID && ff.type != r.GRAVITY) {
          dir.mult(ff.field[x][y].w);
          // pos.sub(offset);
        } else {
          pos.add(offset);
        }
        pattern_force_field(dir, pos, ff.resolution *scale, show_intensity_is);
      }
    }
  }  
}

// Renders a vector object 'v' as an arrow and a position 'x,y'
void pattern_force_field(Vec2 dir, Vec2 pos, float scale, boolean show_intensity_is) {
  Vec5 colorMode = Vec5(getColorMode());
  colorMode(HSB,1);

  pushMatrix();
  // Translate to position to render vector
  translate(pos);
  // Call vector heading function to get direction (note that pointing to the right is a heading of 0) and rotate
  rotate(dir.angle());
  // Calculate length of vector & scale it to be dir_vector or smaller if dir_vector
  float mag = (float)Math.sqrt(dir.x*dir.x + dir.y*dir.y + dir.z*dir.z);
  float len = dir.mag() *scale;
  float blue = .7 ;
  float red = 0 ;
  float hue = map(abs(len), 0, scale,blue,red);
  stroke(hue, 1,1,1);
  // Draw three lines to make an arrow (draw pointing up since we've rotate to the proper direction)
  line(0,0,len,0);

  popMatrix();

  colorMode(colorMode);
}






















