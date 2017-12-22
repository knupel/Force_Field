/**
common method media, video and camera
*/
// load media statement
boolean warp_media_loaded_is ;

boolean warp_media_is() {
  return warp_media_loaded_is ;
}

void warp_media_loaded(boolean state) {
  warp_media_loaded_is = state ;
}




/**
movie
*/
import processing.video.*;
// movie
ArrayList<Movie> movie_warp_list;
boolean play_movie_warp_is = true ;



void play_movie_warp_is(boolean state) {
  play_movie_warp_is = state;
}

boolean play_movie_warp_is() {
  return play_movie_warp_is;
}

boolean movie_warp_is;
void movie_warp_is(boolean state) {
  movie_warp_is = state;
}

boolean movie_warp_is() {
  return movie_warp_is;
}

void movie_library_clear() {
  if(movie_warp_list != null) {
    play_movie_warp_is(false);
    movie_warp_is(false);
    if(get_movie_warp(which_movie) != null) get_movie_warp(which_movie).stop();
    movie_warp_list.clear();
  }
}


void load_movie(String movie_path) {
  if(movie_warp_list == null) {
    movie_warp_list = new ArrayList<Movie>();
    Movie new_movie = new Movie(this, movie_path);
    movie_warp_list.add(new_movie);
    movie_warp_is(true);
  } else {
    Movie new_movie = new Movie(this, movie_path);
    movie_warp_list.add(new_movie);
    movie_warp_is(true);
  }
}

float ratio_display_video = 1. ;
void warp_video_window(PGraphics pg) {
  if(get_movie_warp(which_movie) != null) ratio_display_video = pg.width / (float)get_movie_warp(which_movie).width ;
}

int ref_movie ;
void display_movie(PGraphics pg) {
  if(movie_warp_list != null && get_movie_warp(which_movie) != null) {
    if(ref_movie != which_movie) {
      get_movie_warp(which_movie).stop();
    }
    ref_movie = which_movie ;
    get_movie_warp(which_movie).read();
    get_movie_warp(which_movie).loop();
    if(ratio_display_video != 1.) {
      int w = ceil(get_movie_warp(which_movie).width *ratio_display_video);
      int h = ceil(get_movie_warp(which_movie).height *ratio_display_video);
      float y = (pg.height /2 )- (h/2);
      background(0);
      image(get_movie_warp(which_movie),0,y,w,h);
    } else {
      image(get_movie_warp(which_movie),0,0);
    }   
  } 
}


float speed_movie_warp_ref = 1 ;
void update_movie_warp_interface() {
  if(get_movie_warp(which_movie) != null && header_movie != get_pos_movie_norm_gui()) {
    float header = get_movie_warp(which_movie).duration() *header_movie;
    get_movie_warp(which_movie).jump(header);
  }

  if(get_movie_warp(which_movie) != null) {
    float norm_pos = get_movie_warp(which_movie).time() / get_movie_warp(which_movie).duration();
    set_pos_movie_norm_gui(norm_pos);
    if(speed_movie_warp_ref != get_speed_movie_gui()) {
      speed_movie_warp_ref = get_speed_movie_gui() ;
      if(speed_movie_warp_ref == 0) {
        get_movie_warp(which_movie).pause() ;
      } else {
        get_movie_warp(which_movie).read() ;
        get_movie_warp(which_movie).speed(speed_movie_warp_ref);
      }   
    }
  }
}






// Called every time a new frame is available to read
void movieEvent(Movie m) {
  if(play_movie_warp_is) m.read();
}

Movie get_movie_warp(int target) {
  if(movie_warp_list != null && target < movie_warp_list.size() && target >= 0) {
    return movie_warp_list.get(target);
  } else return null ;
}





/*
we don't use 0 to the first element of the array because this one is use for G / surface
see void warp_init(int type_field, int size_cell) 
*/
int which_img = 1 ;
int which_movie = 0 ;
/**
image
*/



void load_medias(boolean sub_folder, String... type) {
  String path = selected_path_folder();
  explore_folder(path, sub_folder, type);
  String [] ext_img = {"jpg", "JPG", "JPEG", "jpeg", "tif", "TIF", "tiff", "TIFF", "bmp", "BMP", "png", "PNG", "gif", "GIF"};
  String [] ext_movie = {"mov", "MOV", "avi", "AVI", "mp4", "MP4", "mkv", "MKV", "mpg", "MPG"};

  if(get_files() != null && get_files().size() > 0) {
    for(File f : get_files()) {
      String ext = extension(f.getName());
      // add image to library
      for(String s : ext_img) {
        if(ext.equals(s)) {
          warp.load_image(f.getAbsolutePath());
          warp_media_loaded(true);
          break;
        }
      }
      // add video to library
      for(String s : ext_movie) {
        if(ext.equals(s)) {
          load_movie(f.getAbsolutePath());
          warp_media_loaded(true);
          break;
        }
      }    
    }
  }
}










/**
video
*/
Capture video;
iVec2 video_size ;

void init_video(int w, int h, int which_cam) {
  if(video == null ) {
    // printArray(Capture.list());
    video = new Capture(this,Capture.list()[which_cam]);
   // video = new Capture(this,width,height);
    video_size = iVec2(width,height);
  } 
}


void display_video() {
  if (video_warp_is()) {
    if(video != null && video_warp_is()) {
      warp_media_loaded(true);
      video.start(); 
    }  else {
      video.stop();
    }
    
    if (video.available()) {
      warp_media_loaded(true);
      video.read();
      // classic_video();
      mirror_video(2);

    } else {
      //
    }    
  }
}

void classic_video() {
  PImage temp = video.get().copy();
  if(video_size.x != width && video_size.y != height) {
    video_size.set(width,height);
  }
  temp.resize(video_size.x,video_size.y);
  image(temp);
}

void mirror_video(int cellSize) {

  
  /*
  if(video_size.x != width && video_size.y != height) {
    video_size.set(width,height);
  }
  temp.resize(video_size.x,video_size.y);
  */

  int cols = video.width / cellSize;
  int rows = video.height / cellSize;
  PImage temp = createImage(cols,rows,RGB);
  video.loadPixels();
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      // Where are we, pixel-wise?
      int x = i *cellSize;
      int y = j *cellSize;
      int loc = (video.width - x - 1) + y *video.width; // Reversing x to mirror the image

      float r = red(video.pixels[loc]);
      float g = green(video.pixels[loc]);
      float b = blue(video.pixels[loc]);
      // Make a new color with an alpha component
      // int target = (i*temp.width) + j ;
      int target = (j*temp.width) + i ;

      if(target < temp.pixels.length) temp.pixels[target] = color(r,g,b);
    }
  }
  temp.updatePixels();
  if(video_size.x != width && video_size.y != height) {
    video_size.set(width,height);
  }
  temp.resize(video_size.x,video_size.y);
  image(temp);
}

boolean video_available() {
  if(video != null) {
    return video.available();
  } else return false;
  
}

void play_video(boolean play) {
  video_play_is = play ;
}


boolean video_play_is = false;
void play_video_switch() {
  if(video_play_is) video_play_is = false ; else video_play_is = true ;
}


boolean video_warp_is() {
  return video_play_is;
}


