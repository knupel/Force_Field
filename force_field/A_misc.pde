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





/**
cursor manager
*/
void cursor_manager(boolean display) {
  if(display) {
    Vec2 pos = Vec2(mouseX,mouseY);
    Vec2 size = Vec2(7);
    int summits = 5 ;
    fill(255);
    stroke(0);
    strokeWeight(.5);
    star(pos, size, summits) ;
    // cursor(CROSS);
  } else {
    noCursor();
  }
}


/**
change size window
*/
void set_size(int w, int h) {
  if(change_size_window_is && (width != w || height != h)) {
    surface.setSize(w,h);
  }
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