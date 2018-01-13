float alpha_bg ;
void set_alpha_background(float norm_f){
  float mult_f = norm_f *norm_f ;
  alpha_bg = map(mult_f,0,1,0.,g.colorModeA);
}

float get_alpha_bg() {
  return alpha_bg;
}

/**
display
*/
void display_result(boolean state) {
  display_result = state;
}

boolean get_display_is() {
  return display_result ;
}

void display_result() {
  display_result = !!((display_result == false));
  get_check_main_display();
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