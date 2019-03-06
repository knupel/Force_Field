/**
APP WARP FORCE
v 0.2.0
*/
Warp_Force warp_force ;
// boolean shader_filter_is = false;
boolean init_warp_is = false;
String surface_g = "";
int ref_warp_w, ref_warp_h ;
void warp_setup() {
  warp_force = new Warp_Force();
  set_size_ref(width, height);
  surface_g = "surface g";
  set_media_info();
}









/**
 init for media or camera
 */
void warp_init(int type_f, int pattern_f, int size_cell, int which_cam, boolean change_canvas_is, boolean fullfit) {
  if((folder_selected_is() || !init_warp_is) && !video_warp_is() ) {
    warp_init_media(type_f, pattern_f, size_cell, change_canvas_is, fullfit);
  } else if(video_warp_is()) {
    warp_init_video(type_f, pattern_f, size_cell, which_cam);
  } else if(!warp_media_is()){
    build_ff(type_f, pattern_f, size_cell);
  }
}

boolean init_video_is = false ;
void warp_init_video(int type_f, int pattern_f, int size_cell, int which_cam) {
  init_video(width,height, which_cam);
  add_g_surface();
  if(!init_video_is) {
    println("warp_force init video");
    build_ff(type_f, pattern_f, size_cell, warp_force.get_image());
    init_video_is = true ;
    warp_media_loaded(true);
  } 
}

void warp_init_media(int type_f, int pattern_f,  int size_cell, boolean change_canvas_is, boolean fullfit) {
  if(folder_selected_is()) {
    movie_warp_is(false);
    add_g_surface();
    boolean explore_sub_folder = false;
    load_media_folder(explore_sub_folder, "jpg", "JPG", "mp4", "avi", "mov");   
    if(!change_canvas_is) {
      warp_force.image_library_fit(g, fullfit);
      warp_force.image_library_crop(g);
    }
  } else if(input_selected_is()) {
    movie_warp_is(false);
    add_g_surface();
    load_media_input("jpg", "JPG", "mp4", "avi", "mov");  
    if(!change_canvas_is) {
      warp_force.image_library_fit(g, fullfit);
      warp_force.image_library_crop(g);
    }
  }

  if(movie_warp_is() && get_movie_warp(which_movie) != null && get_movie_warp(which_movie).width != 0 && get_movie_warp(which_movie).height != 0) {    
    if(change_canvas_is) {
      ivec2 temp_size_window = def_window_size(get_movie_warp(which_movie).width, get_movie_warp(which_movie).height);
      set_size_ref(temp_size_window.x,temp_size_window.y);
    } else {
      set_size_ref(get_movie_warp(which_movie).width, get_movie_warp(which_movie).height);
    }
  } else if(warp_force.get_width() > 0 && warp_force.get_height() > 0) {
    if(!def_window_size(warp_force.get_width(), warp_force.get_height()).equals(get_size_ref())) {
      set_size_ref(warp_force.get_width(), warp_force.get_height());
    }
  } 

  if(change_canvas_is && (width != ref_warp_w || height != ref_warp_h)) {
    println("warp_force init media");
    init_warp_is = true ;
    set_size(ref_warp_w,ref_warp_h);
    warp_force.reset(); 
    build_ff(type_f, pattern_f, size_cell, warp_force.get_image());

  } else if(!change_canvas_is && !build_ff_is()) {
    println("warp_force init classic");
    build_ff(type_f, pattern_f, size_cell, warp_force.get_image());
  }
}


// local method
void add_g_surface() {
  if(warp_force.library() != null && warp_force.library_size() > 0 ) {
    if(warp_force.get_name(0).equals(surface_g)) {
      // nothing happen don't add a g surface, this security is necessary in case we add more media
    } else {
      println("add g surface");
      warp_force.add(g, surface_g);
    }
  } else {
    println("add g surface");
    warp_force.add(g, surface_g); // take the first place in the list, "0" so when the list is used you must jump the "0"
  }
}


































/**
warp draw
v 0.2.3
*/
void warp_draw(int tempo, vec3 rgba_mapped, float intensity, boolean refresh) {
  if(warp_media_is()) {
    if(frameCount%tempo == 0 ) warp_media_display();
    if(warp_force.library_size() > 0 && force_field != null) {
      warp_show(rgba_mapped,intensity,refresh);
      check_current_img_size_against_display();
    }
  }
  init_warp_is = false ;
}

// follower method
void warp_media_display() {
  if (video_warp_is()) {
    movie_warp_is(false);
    warp_force.select(surface_g);
    display_video(); 
  } else if(movie_warp_is()) {
    warp_force.select(surface_g);
    update_movie_warp_interface();
    play_video(false);
    display_movie(g,which_movie);
  } else {
    warp_force.select(which_img);
    play_video(false);
    movie_warp_is(false);
  }
}

vec3 ref_rgb_mapped ;
void warp_show(vec3 channel_warp_rgb_mapped, float intensity_warp, boolean keep) {
  boolean new_channel_values = false ;
  if(ref_rgb_mapped == null || !ref_rgb_mapped.equals(channel_warp_rgb_mapped)) {
    new_channel_values = true;
    if(ref_rgb_mapped == null) ref_rgb_mapped = channel_warp_rgb_mapped.copy();
    else ref_rgb_mapped.set(channel_warp_rgb_mapped);
  }
  if(!keep || new_channel_values) {
    warp_force.refresh(channel_warp_rgb_mapped);
    warp_force.shader_init();
    warp_force.shader_filter(shader_fx_is());
    warp_force.shader_mode(0);
  }



  // SHADER ENGINE
  if(!init_warp_is) {
    // here we need a full round without display to charge pixel "g / surface 
    warp_force.shader_mode(0);
    warp_force.show(force_field,intensity_warp);
  }
}












int ellipse_pos_x, ellipse_pos_y;
void animation_PGraphics(PGraphics target) {
  target.beginDraw();

  target.background(0);

  int rect_width = width ;  
  float marge = height / 6 ;
  float rect_height = (height-(marge*2)) *(sin(frameCount *.01)) ;
  float pos_rect_y = (height/2) + (height *(sin(frameCount *.1))) ;
  target.fill(255);
  target.rect(0,pos_rect_y, rect_width,rect_height );

  target.fill(255,0,0);
  target.noStroke();
  float size = abs(sin(frameCount *.1)) *(width *.9) + 50 ;
  if(mousePressed && mouseButton == RIGHT) {
    ellipse_pos_x = mouseX ;
    ellipse_pos_y = mouseY;
  }
  target.ellipse(ellipse_pos_x,ellipse_pos_y ,size, size);

  target.endDraw();
  // target.loadPixels();
  // target.updatePixels();
}

void animation() {
  background(0);

  int rect_width = width ; 
  float marge = height / 6 ;
  float rect_height = (height-(marge*2)) *(sin(frameCount *.01)) ;
  float pos_rect_y = (height/2) + (height *(sin(frameCount *.1))) ;
  fill(255);
  rect(0,pos_rect_y, rect_width,rect_height );

  fill(255,0,0);
  noStroke();
  float size = abs(sin(frameCount *.1)) *(width *.9) + 50 ;
  if(mousePressed && mouseButton == RIGHT) {
    ellipse_pos_x = mouseX ;
    ellipse_pos_y = mouseY;
  }
  ellipse(ellipse_pos_x,ellipse_pos_y ,size, size);
}








