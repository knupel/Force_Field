/**
MISC
v 0.3.1
*/
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






/**
MASK MAPPING
v 0.0.1
*/


Mask_mapping [] masks;
void mask_mapping(boolean change_is) {
  if(masks == null) {
    int h = 40;
    iVec2 [] coord_mask_0 = {iVec2(0,0),iVec2(width,0),iVec2(width,h),iVec2(0,h)};
    iVec2 [] coord_mask_1 = {iVec2(0,height-h),iVec2(width,height-h),iVec2(width,height),iVec2(0,height)};
    int num_mask = 2;
    masks = new Mask_mapping[num_mask];
    masks[0] = new Mask_mapping(coord_mask_0);
    masks[1] = new Mask_mapping(coord_mask_1);
  }

  masks[0].draw(change_is);
  masks[1].draw(change_is);
}





public class Mask_mapping {
  private int num;
  private iVec3 [] coord;
  private boolean init;
  private int c = r.BLACK;
  private int range = 10;

  public Mask_mapping(iVec2 [] list) {
    this.num = list.length;
    coord = new iVec3[num];
    for(int i = 0 ; i < coord.length ;i++) {
      coord[i] = iVec3(list[i].x,list[i].y,0);
    }
    init = true;
  }
  /*
  public setup() {
    init = true;
  }
  */
  public void set_fill(int c) {
    this.c = c;
  }



  public void draw(boolean modify_is) {
    if(init) {
      if(modify_is) {
        fill(r.RED);
      } else {
        fill(c);
      }
      noStroke();
      draw_shape(coord);
      if(modify_is) {
        show_point(coord);
        move_point(coord);
      }
    } else {
      printErr("class Mask_mapping(), must be iniatilized with an array list iVec2 [] coord)");
    }
  }
  private void show_point(iVec3 [] list) {
    for(iVec3 iv : list) {
      // fill(255);
      stroke(r.WHITE);
      strokeWeight(range);
      point(iv);
    }
  }
  private boolean drag_is = false ;
  private void move_point(iVec3 [] list) {
    if(!drag_is) {
      for(iVec3 iv : list) {
        iVec2 drag = iVec2(mouseX,mouseY);
        iVec2 area = iVec2(range);
        if(inside(drag,area,iVec2(iv.x,iv.y)) && iv.z == 0) {
          if(mousePressed) {
            iv.set(iv.x,iv.y,1);
            drag_is = true ;
          } else {
            // border magnetism
            if(iv.x < 0 + range) iv.x = 0 ;
            if(iv.x > width -range) iv.x = width;
            if(iv.y < 0 + range) iv.y = 0 ;
            if(iv.y > height -range) iv.y = height;
          }
        }
      }
    }
    
    for(iVec3 iv : list) {
      if(iv.z == 1) iv.set(mouseX,mouseY,1);
    }

    if(!mousePressed) {
      drag_is = false;
      for(iVec3 iv : list) {
        iv.set(iv.x,iv.y,0);
      }
    }
  }

  private void draw_shape(iVec3 [] list) {
    beginShape();
    for(int i = 0 ; i < list.length ; i++) {
      vertex(list[i]);
    }
    endShape(CLOSE);
  }
}








































/**
SAVE / LOAD
v 0.0.1
*/
/**
* local method
*/
String ext_path_file = null;
void file_path_clear() {
  ext_path_file = null;
}

void file_path(String type,String path) {
  if(path != null && type != null) {
    ext_path_file += ("///"+type+path);
  }
}

void save_media_path() {
  if(ext_path_file != null) {
    println("save file txt");
    String [] s = split(ext_path_file, "///");
    saveStrings(sketchPath(1)+"/save/path_media.txt",s);
  }
}


boolean media_path_save_is;
boolean media_path_save_is() {
  return media_path_save_is;
}

void media_path_save(boolean state){
  media_path_save_is = state;
}


boolean media_add_is ;
boolean media_add_is() {
  return media_add_is ;
}

void media_add(boolean state) {
  media_add_is = state;
}


Table value_app_force;
TableRow [] row;
void save_value_app_too_controller(int tempo) {
  if(frameCount%tempo == 0) {
    if(value_app_force == null) {
      value_app_force = new Table();
      value_app_force.addColumn("variable");
      value_app_force.addColumn("value");
      int num_row = 1 ;
      row = new TableRow[num_row] ;
      for(int i = 0 ; i < row.length ; i++) {
        row[i] = value_app_force.addRow();
      }    
    }
    
    row[0].setString("variable", "movie position");
    row[0].setFloat("value", get_movie_pos_norm());
    // println()
    saveTable(value_app_force,sketchPath(1)+"/save/value_app_force.csv");
  }  
}































/**
RESET
v 0.2.0
*/
void global_reset() {
  global_reset(force_field.get_type(), force_field.get_pattern(), force_field.get_super_type(), get_resolution_ff());
}


void global_reset(int type, int pattern, int super_type, int resolution) {
  force_field_init_is = false ;
  reset_vehicle(get_num_vehicle_gui(),get_ff());
  warp.reset();
  if(force_field != null) force_field.reset();

  if(pattern == r.EQUATION) {
    init_eq();
    float x = random(-1,1);
    float y = random(-1,1);

    eq_center_dir(x,y);
    x = random(-1,1);
    y = random(-1,1);
    eq_center_len(x,y);

    eq_reverse_len(false);
    int swap_rand = floor(random(4));
    if(swap_rand == 0) eq_swap_xy("x","y");
    else if(swap_rand == 1) eq_swap_xy("y","x");
    else if(swap_rand == 2) eq_swap_xy("y","y");
    else if(swap_rand == 3) eq_swap_xy("x","x");
    else eq_swap_xy("x","y");
    // eq_swap_xy("x","y");
    // eq_swap_xy("y","y");
    int pow_x_rand = floor(random(-5,5));
    int pow_y_rand = floor(random(-5,5));
    if(pow_x_rand == 0) pow_x_rand = 1 ;
    if(pow_y_rand == 0) pow_y_rand = 1 ;
    eq_pow(pow_x_rand,pow_y_rand);
    float mult_x_rand = random(-5,5);
    float mult_y_rand = random(-5,5);
    if(mult_x_rand == 0) mult_x_rand = 1 ;
    if(mult_y_rand == 0) mult_y_rand = 1 ;
    eq_mult(mult_x_rand,mult_x_rand);
  }

  if(pattern == IMAGE) {
    build_ff(type,pattern,resolution, warp.get_image(), get_sorting_channel_ff_2D());
  } else {
    build_ff(type,pattern,resolution);
    num_spot_ff(get_spot_num_ff(), get_spot_area_level_ff());
  }

  if(type == r.FLUID) {
    set_full_reset_field(false);
    if(!external_gui_is) {
      /**
      Why check something for gravity or magnetic field in Fluid system ?????
      */
      set_check_gui_dynamic_mag_grav(get_full_reset_field_is_gui());
    } else {

    }
  }
  /*
  the method line cause a bug with dynamic mode when this one is refresh from selected mode by target, keyboard or external GUI
  if(super_type == r.DYNAMIC){
    update_gui_value(true,time_count_ff);
  }
  */
}



void reset_mode() {
  for(int i = 0 ; i < mode.length ; i++) {
    mode[i] = false;
  }
}






























  

















/**
KEYPRESSED
*/
void keyPressed() {
  news_from_gui = true;
  keys[keyCode] = true;
  
  key_pressed_add_media() ;

  /**
  if(key == 'a')
  that control with advenced method see below
  */

  if(key == 'b') manage_border();

  if(key == 'c') hide_interface();

  if(key == 'd') diaporama_is();

  if(key == 'f') display_field();

  if(key == 'g') display_grid();

  if(key == 'h') display_spot();

  if(key == 'i') display_info();
  
  if(!checkKey(CONTROL) && !checkKey(157) && !checkKey(SHIFT) && checkKey(KeyEvent.VK_Q)) { 
    // Q for a
    display_vehicle();
    reset_key();
  } 
  if(key == 'z') display_warp();
  if(key == 'e') display_background();

  if(key == 'l') change_cursor_controller();

  if(key == 'm') set_mask();

  if(key == 'p') {
    println("export jpg");
    saveFrame();   
  }

  if(key == 'r') {
    global_reset();
  }

  if(key == 'v') play_video_switch();

  if(key == 's') {
    if(shader_filter_is) shader_filter_is = false ; else shader_filter_is = true ;
  }

  key_pressed_change_mode();


  if(key == ' ') {
    if(pause_is) pause_is = false ; else pause_is = true ;
  }
  
  // navigation in the media movie or picture
  if(keyCode == UP) {
    which_media--;
    if(which_media < 0) which_media = media_info.size() -1;
    select_media_to_display(); 
  }

  if(keyCode == DOWN) { 
    which_media++;
    if(which_media >= media_info.size()) which_media = 0 ;
    select_media_to_display(); 
  }
}





void key_pressed_change_mode() {
  if(key == 'w') next_mode_ff(-1);
  if(key == 'x') next_mode_ff(+1);

  char [] key_num = {'1','2','3','4','5','6','7','8','9','0'};
  
  for(int i = 0 ; i < num_mode ; i++) {
    if(key == key_num[i]) {
      reset_mode();
      mode[i] = true;
    }
  }
}






void key_pressed_add_media() {
  if(os_system.equals("Mac OS X")) {
    add_media_folder(157, SHIFT, KeyEvent.VK_Q); // Q for A I don't how map AZERTY layout keyboard
    add_media_file(157, SHIFT, KeyEvent.VK_Q); // Q for A I don't how map AZERTY layout keyboard
    replace_media_file(157, SHIFT, KeyEvent.VK_O);
    replace_media_folder(157, SHIFT, KeyEvent.VK_O);
  } else {
    add_media_folder(CONTROL, SHIFT, KeyEvent.VK_Q); // Q for A I don't how map AZERTY layout keyboard
    add_media_file(CONTROL, SHIFT, KeyEvent.VK_Q); // Q for A I don't how map AZERTY layout keyboard
    replace_media_file(CONTROL, SHIFT, KeyEvent.VK_O);
    replace_media_folder(CONTROL, SHIFT, KeyEvent.VK_O);
  }
}


void add_media_folder(int a, int b, int c) {
  // true-true-true
  if(checkKey(a) && checkKey(b) && checkKey(c)) {
    display_warp(true);
    warp_add_media_folder();
    play_video(false);
  }
}


void add_media_file(int a, int b, int c) {
  // true-false-true
  if(checkKey(a) && !checkKey(b) && checkKey(c)) {
    display_warp(true);
    warp_add_media_input();
    play_video(false);
  }
}


void replace_media_folder(int a, int b, int c) {
  // true-true-true
  if(checkKey(a) && checkKey(b) && checkKey(c)) {
    display_warp(true);
    warp_change_media_folder();
    play_video(false);
  }
}


void replace_media_file(int a, int b, int c) {
  // true-false-true
  if(checkKey(a) && !checkKey(b) && checkKey(c)) {
    display_warp(true);
    warp_change_media_input();
    play_video(false);
  }
}




// key event
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

float set_alpha(float norm_f) {
  float mult_f = norm_f *norm_f ;
  return map(mult_f,0,1,0.,g.colorModeA);
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














/**
DATA CONTROL
use to dial between the keyboard, the controller and the user


the mess


*/
boolean set_mask_is;
void set_mask() {
  set_mask_is = !!((set_mask_is == false));
}

boolean set_mask_is() {
  return set_mask_is;
}

/**
display
*/
/*
* display vehilcle
*/
boolean display_vehicle_is() {
  return display_vehicle ;
}

void display_vehicle(boolean is) {
  display_vehicle = is;
}

// method to set the gui back
void display_vehicle() {
  display_vehicle = !!((display_vehicle == false));
  if(display_vehicle_is() && !external_gui_is) set_check_gui_main_display(display_background_is());
}

/*
* display warp
*/
boolean display_warp_is() {
  return display_warp ;
}

void display_warp(boolean is) {
  display_warp = is;
}

// method to set the gui back
void display_warp() {
  display_warp = !!((display_warp == false));
  if(display_warp_is() && !external_gui_is) set_check_gui_main_display(display_background_is());
}

/*
* display result
*/
void display_background(boolean is) {
  display_background = is;
}

boolean display_background_is() {
  return display_background;
}

// method to set the gui back
void display_background() {
  display_background = !!((display_background == false));
  if(!external_gui_is) set_check_gui_main_display(display_background_is());
}

/**
Show must go on
*/
void show_must_go_on(boolean is) {
  show_must_go_on = is;
}

boolean show_must_go_on_is() {
  return show_must_go_on;
}

// method to set the gui back
void show_must_go_on() {
  show_must_go_on = !!((show_must_go_on == false));
  if(!external_gui_is) set_check_gui_main_display(display_background_is());
}

/**
choice vehicle shape or pixel
*/
void set_vehicle_pixel_is(boolean is) {
  vehicle_pixel_is = is ;
}

boolean vehicle_pixel_is() {
  return vehicle_pixel_is;
}


/**
movie setting
*/
float get_movie_pos_norm() {
  return movie_pos_normal ;
}

void set_movie_pos_norm(float normal_f) {
  movie_pos_normal = normal_f;
}

float get_movie_speed() {
  return speed_movie ;
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


void set_full_reset_field(boolean state) {
  full_reset_field_is = state;
}


void set_warp_is(boolean state) {
  warp_is = state;
}




/**
cursor manager
*/
void cursor_manager() {
  boolean display = false;
  if(set_mask_is() || interface_is()) display = true;
  if(display) {
    cursor(CROSS);
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
void info(boolean display_force_field_is,  boolean display_grid_is, boolean display_spot_is) {
  noFill() ;
  stroke(g.colorModeA *.6f);
  strokeWeight(.5);

  if (display_force_field_is) {
    float scale = 5 ;
    int c = r.HUE;
    float min_c = .0; // red
    float max_c = .7; // blue
    boolean reverse_c = false;
    set_show_field(scale,c,min_c,max_c,reverse_c);
    show_field(get_ff());
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
  if(display_spot_is) {
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
boolean display_spot = false;
boolean display_info = false ;
void set_info(boolean display_info) {
  this.display_info = display_info;
  if(display_info) {
    display_field = true ;
    display_grid = true ;
    display_spot = true;
  } else {
    display_field = false;
    display_grid = false;
    display_spot = false;
  }
}



void display_info() {
  display_info = !display_info ;
  set_info(display_info) ;
}

void display_spot(){
  display_spot = !display_spot;
  if(!display_spot) display_info = false ;
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
  String path = sketchPath(1) +"/screenshot";
  // path += "/screenshot";
  // saveFrame(path, filename, compression, get_canvas());
  saveFrame(path, filename, compression);
}
























/**
show vector field
v 0.1.0
*/
float scale_show_field = 5;
int colour_field;
boolean reverse_value_colour_field;
float min_range_colour_field = 0.;
float max_range_colour_field = .7;

void set_show_field(float scale, int colour_constant, float min, float max, boolean reverse_colour) {
  scale_show_field = scale;
  set_range_colour_field(min,max);
  colour_field(colour_constant);
  reverse_color_field(reverse_colour);
}


void colour_field(int c) {
  colour_field = c;
}

void set_range_colour_field(float min, float max) {
  min_range_colour_field = min;
  max_range_colour_field = max;
}


void reverse_color_field(boolean state) {
  reverse_value_colour_field = state;
}

void show_field(Force_field ff) {
  float scale = scale_show_field ;

  if(ff != null) {
    Vec2 offset = Vec2(ff.get_canvas_pos()) ;
    offset.sub(ff.get_resolution()/2);
    //
    for (int x = 0; x < ff.cols; x++) {
      for (int y = 0; y < ff.rows; y++) {
        Vec2 pos = Vec2(x *ff.get_resolution(), y *ff.get_resolution());
        Vec2 dir = Vec2(ff.field[x][y].x,ff.field[x][y].y);
        if(ff.get_super_type() == r.STATIC) {
          float mag = ff.field[x][y].w;
          pattern_field(dir, mag, pos, ff.resolution *scale);
        } else {
          pos.add(offset);
          float mag = (float)Math.sqrt(dir.x*dir.x + dir.y*dir.y + dir.z*dir.z); ;
          pattern_field(dir, mag, pos, ff.resolution *scale);
        }
      }
    }
  }  
}

// Renders a vector object 'v' as an arrow and a position 'x,y'
void pattern_field(Vec2 dir, float mag, Vec2 pos, float scale) {
  Vec5 colorMode = Vec5(getColorMode());
  colorMode(HSB,1);

  pushMatrix();
  // Translate to position to render vector
  translate(pos);
  // Call vector heading function to get direction (note that pointing to the right is a heading of 0) and rotate
  rotate(dir.angle());
  // Calculate length of vector & scale it to be dir_vector or smaller if dir_vector
  float len = mag *scale;
  float min = min_range_colour_field;
  float max = max_range_colour_field;

  float value = map(abs(len), 0, scale,max,min);
  if(reverse_value_colour_field) {
    value = 1-value ;
  }

  if(colour_field == r.HUE) {
    stroke(value,1,1,1);
  } else if(colour_field == r.RED) {
    stroke(0,1,value,1);
  } else if(colour_field == r.ORANGE) {
    stroke(0.08,1,value,1);
  } else if(colour_field == r.YELLOW) {
    stroke(0.2,1,value,1);
  } else if(colour_field == r.GREEN) {
    stroke(0.4,1,value,1);
  } else if(colour_field == r.BLUE) {
    stroke(0.65,1,value,1);
  } else if(colour_field == r.PURPLE) {
    stroke(0.75,1,value,1);
  } else if(colour_field == r.WHITE) {
    stroke(0,0,value,1);
  } else if(colour_field == r.BLACK) {
    stroke(0,value,0,1);
  } else {
    stroke(value,1,1,1);
  }
  if(len > scale) len = scale ;
  line(0,0,len,0);

  popMatrix();

  colorMode(colorMode);
}






















