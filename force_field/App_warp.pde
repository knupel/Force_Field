Warp warp = new Warp();

boolean effect_is ;
boolean shader_filter_is = false;
boolean init_warp_is = false;
String surface_g = "";


void warp_setup() {
  surface_g = "movie";
  warp.load_shader();
  warp_instruction(); 
}

void warp_add_media() {
  select_folder();
}

void warp_change_media() {
  if(get_files() != null) {
    warp_media_loaded(false);
    get_files().clear();
    warp.image_library_clear();
    movie_library_clear();
  }
  select_folder();
}



void warp_init(int type_field, int size_cell) {
  /**
  media warp
  */
  if(folder_selected_is()) {
    movie_warp_is(false);
    if(warp.library() != null && warp.library_size() > 0 ) {
      if(warp.get_name(0).equals(surface_g)) {
        // nothing happen don't add a g surface, this security is necessary in case we add more media
      } else {
        warp.add_image(g, surface_g);
      }
    } else {
      warp.add_image(g, surface_g); // take the first place in the list, "0" so when the list is used you must jump the "0"
    }
    load_medias(true, "jpg", "JPG", "mp4", "avi", "mov");   
  }
  

  // pg = createGraphics(width,height,P2D);
  // warp.add_image(pg, "truc");
 // warp.select_image("alien");


  if(warp_media_loaded_is()) {
    int w = 1 ;
    int h = 1 ;
    if(movie_warp_is() && get_movie_warp(which_movie) != null && get_movie_warp(which_movie).width != 0 && get_movie_warp(which_movie).height != 0) {
      w = get_movie_warp(which_movie).width;
      h = get_movie_warp(which_movie).height;
    } else {
      w = warp.get_width();
      h = warp.get_height(); 
    }
    if(width != w || height != h) {
      println("warp initialization");
      init_warp_is = true ;
      set_size(w,h);
      warp.reset(); 
      build_force_field(type_field,size_cell, warp.get_image());
    }
  } else {
    build_force_field(type_field,size_cell);
  }
}


void warp_draw() {
  if(warp_media_loaded_is()) {
    if(movie_warp_is()) {
      warp.select_image(surface_g);
      display_movie();   
    } else {
      warp.select_image(which_img);
    }

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

    /**
    SHOW IMAGE WARPED via FORCE FIELD
    */
    refresh_warp();
   // warp_effect_test();
   
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
    init_warp_is = false ;
  }
  // end of security loaded media
  
}



/**
effect test
*/
void warp_effect_test() {
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
  text("PRESS 'N' TO SELECT MEDIA FOLDER", width/2, height/2);
}



void refresh_warp() {
  
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

  rgba.set(rgba_slider);
  rgba.mult(power_max);
  warp.refresh(rgba);
  
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







// load media statement
boolean warp_media_loaded_is ;

boolean warp_media_loaded_is() {
  return warp_media_loaded_is ;
}


void warp_media_loaded(boolean state) {
  warp_media_loaded_is = state ;
}
