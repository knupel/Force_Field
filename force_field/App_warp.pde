Warp warp = new Warp();

boolean shader_filter_is = false;
boolean init_warp_is = false;
String surface_g = "";
int ref_warp_w, ref_warp_h ;



void warp_setup() {
  ref_warp_w = width; 
  ref_warp_h = height;
  surface_g = "surface g";
  warp.load_shader();
  warp_instruction(); 
}

/**
 add or changer folder or file
*/
/*
file part
*/
void warp_add_media_file() {
  select_file();
}

void warp_change_media_file() {
  if(get_files() != null) {
    warp_media_loaded(false);
    get_files().clear();
    warp.image_library_clear();
    movie_library_clear();
  }
  select_file();
}
/*
folder part
*/
void warp_add_media_folder() {
  select_folder();
}

void warp_change_media_folder() {
  if(get_files() != null) {
    warp_media_loaded(false);
    get_files().clear();
    warp.image_library_clear();
    movie_library_clear();
  }
  select_folder();
}




/**
 init for media or camera
 */
void warp_init(int type_field, int size_cell, int which_cam, boolean change_size_is) {
  if((folder_selected_is() || !init_warp_is) && !video_warp_is() ) {
    warp_init_media(type_field, size_cell, change_size_is);
  } else if(video_warp_is()) {
    warp_init_video(type_field, size_cell, which_cam);
  } else if(!warp_media_is()){
    build_ff(type_field,size_cell);
  }
}



boolean init_video_is = false ;
void warp_init_video(int type_field, int size_cell, int which_cam) {
  init_video(width,height, which_cam);
  add_g_surface();
  if(!init_video_is) {
    println("warp init video");
    build_ff(type_field,size_cell, warp.get_image());
    init_video_is = true ;
    warp_media_loaded(true);
  } 
}


void warp_init_media(int type_field, int size_cell, boolean change_size_is) {
  if(folder_selected_is()) {
    movie_warp_is(false);
    add_g_surface();
    load_medias(true, "jpg", "JPG", "mp4", "avi", "mov");   
    if(!change_size_is) {
      warp.image_library_fit(g);
      warp.image_library_crop(g);
    }
  }
  
  // pg = createGraphics(width,height,P2D);
  // warp.add_image(pg, "truc");
 // warp.select_image("alien");

  if(movie_warp_is() && get_movie_warp(which_movie) != null && get_movie_warp(which_movie).width != 0 && get_movie_warp(which_movie).height != 0) {
    ref_warp_w = get_movie_warp(which_movie).width;
    ref_warp_h = get_movie_warp(which_movie).height;
  } else if(warp.get_width() > 0 && warp.get_height() > 0) {
    ref_warp_w = warp.get_width();
    ref_warp_h = warp.get_height(); 
  }
  if(movie_warp_is() && !change_size_is) {
    warp_video_window(g);
  }   

  if(change_size_is && (width != ref_warp_w || height != ref_warp_h)) {
    println("warp init media");
    init_warp_is = true ;
    set_size(ref_warp_w,ref_warp_h);
    warp.reset(); 
    build_ff(type_field,size_cell, warp.get_image());

  } else if(!change_size_is && !build_ff_is()) {
    println("warp init classic");
    build_ff(type_field,size_cell, warp.get_image());
  }
}

/*
local method
*/
void add_g_surface() {
  if(warp.library() != null && warp.library_size() > 0 ) {
    if(warp.get_name(0).equals(surface_g)) {
      // nothing happen don't add a g surface, this security is necessary in case we add more media
    } else {
      println("add g surface");
      warp.add_image(g, surface_g);
    }
  } else {
    println("add g surface");
    warp.add_image(g, surface_g); // take the first place in the list, "0" so when the list is used you must jump the "0"
  }
}





/**
warp draw
*/
/*
main method
*/
void warp_draw(int tempo, Vec4 channel_rgba) {
  if(warp_media_is()) {
    if(frameCount%tempo == 0 ) warp_media_display();
    if(warp.library_size() > 0 && force_field != null) warp_show(channel_rgba);

    /**
    animation
    */
    // set_size(myMovie.width, myMovie.height);
    // animation_PGraphics(pg) ;
    // animation() ;

    // warp.set_image(pg, "truc"); 
    /**
    SHOW FORCE FIELD
     */
    /*
    update_vehicle(force_field);
    show_vehicle();
    */    
    // init_warp_is = false ;
  }
  init_warp_is = false ;
  // end of security loaded media 
}

/*
follower method
*/
void warp_media_display() {
  if (video_warp_is()) {
    movie_warp_is(false);
    warp.select_image(surface_g);
    display_video(); 
  } else if(movie_warp_is()) {
    warp.select_image(surface_g);
    update_movie_warp_interface();
    play_video(false);
    display_movie(g);
  } else {
    play_video(false);
    movie_warp_is(false);
    warp.select_image(which_img);
  }
}


void warp_show(Vec4 channel_rgba) {
  /**
  SHOW IMAGE WARPED via FORCE FIELD
  */
  warp.refresh(channel_rgba);
  // refresh_warp(channel_rgba);
 // warp_post_effect_test();
 
  /**
  SHADER ENGINE
  */
  warp.shader_init();
  warp.shader_filter(shader_filter_is);
  warp.shader_mode(0);

  float intensity = 0.9 ;
  if(!init_warp_is) {
    // here we need to have a full turn without display to charge pixel "g / surface 
    warp.show(force_field, intensity);
  }
}






/**

post effect test

*/
boolean effect_is ;
void warp_post_effect_test() {
  Vec4 fx = Vec4(1);
  if(effect_is) warp.effect_multiply(true, fx.x,fx.y,fx.z,fx.w); else warp.effect_multiply(false);
  if(effect_is) warp.effect_overlay(true, fx.x,fx.y,fx.z,fx.w); else warp.effect_overlay(false);

  if(keyPressed && key == 'x') {
    effect_is = true ;
  } else {
    effect_is = false;
  }
}






/**
instruction
*/
void warp_instruction() {
  textAlign(CENTER);
  background(255);
  fill(0) ;
  int text_size = 12 ;
  textSize(text_size);
  text("PRESS 'N' TO SELECT MEDIA FOLDER", width/2, height/2);
  text("PRESS 'V' TO SELECT CAMERA", width/2, height/2 +(text_size *1.5));
}



void refresh_warp(Vec4 channel_rgba) {
  
  Vec4 rgba = Vec4();
  /*
  float rgba_x = abs(sin(frameCount * .001));
  float rgba_y = abs(cos(frameCount * .002));
  float rgba_z = abs(sin(frameCount * .005));
  float rgba_w = abs(sin(frameCount * .001));
  */
  /*
  rgba.x = abs(sin(frameCount * .001));
  rgba.y = abs(cos(frameCount * .002));
  rgba.z = abs(sin(frameCount * .005));
  rgba.w = abs(sin(frameCount * .001));
  */
   
   /*
  rgba.x = sin(frameCount * .001);
  rgba.y = cos(frameCount * .002);
  rgba.z = sin(frameCount * .005);
  rgba.w = sin(frameCount * .001);
  */

  //rgba.set(channel_rgba);
  //rgba.mult(power_channel_max);
  warp.refresh(channel_rgba);
  
  /**
  refresh value simple
  */
  /*
  float value = 2;
  warp.refresh(value);
  */
   // warp.refresh_mix(true);
   /*
   Vec4 fx = Vec4();
  float fx_x = abs(sin(frameCount * .001));
  float fx_y = abs(cos(frameCount * .01));
  float fx_z = abs(sin(frameCount * .004));
  float fx_w = abs(sin(frameCount * .3));
  fx.set(fx_x,fx_y,fx_z,fx_w);
  // fx.set(.1,1,1,1);
  // fx.set(.25);
  // warp.refresh_mix(true);
  warp.refresh_multiply(true, fx.x,fx.y,fx.z,fx.w);
  */
  //if(effect_is) warp.refresh_overlay(true, fx.x,fx.y,fx.z,fx.w); else warp.refresh_overlay(false);
  //if(effect_is) warp.refresh_multiply(true, fx.x,fx.y,fx.z,fx.w); else warp.refresh_multiply(false);

  //if(effect_is) warp.refresh_overlay(true); else warp.refresh_overlay(false);
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








