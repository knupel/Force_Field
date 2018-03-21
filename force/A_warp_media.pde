/**
WARP media manager
v 0.3.0
*/


/**
common method media, video and camera
*/
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
    new_movie_is = true ;
    if(get_movie_warp() != null) get_movie_warp().stop();
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
boolean new_movie_is = true ;
void warp_video_window_ratio(PGraphics pg, int target) {
  if(new_movie_is && get_movie_warp(target) != null && pg.width > 0 && get_movie_warp(target).width > 0) {
    ratio_display_video = pg.width /(float)get_movie_warp(target).width ;
    new_movie_is = false ;
  }
}

int ref_movie = -1;
void display_movie(PGraphics pg, int target) {
  if(movie_warp_list != null && get_movie_warp(target) != null) {
    if(ref_movie != target) {
      new_movie_is = true ;
      get_movie_warp(target).stop();
    }
    warp_video_window_ratio(pg, target);
    ref_movie = target ;
    get_movie_warp(target).read();
    get_movie_warp(target).loop();

    if(ratio_display_video != 1.) {
      int w = ceil(get_movie_warp(target).width *ratio_display_video);
      int h = ceil(get_movie_warp(target).height *ratio_display_video);
      float y = (pg.height /2) -(h /2);

      image(get_movie_warp(target),0,y,w,h);
    } else {
      image(get_movie_warp(target),0,0);
    }   
  } 
}


float speed_movie_warp_ref = 1 ;
void update_movie_warp_interface() { 
  if(controller_news_is() || !external_gui_is) {
   //  println("update_movie_warp_interface()",controller_news_is(), header_movie);
    if(get_movie_warp(which_movie) != null && header_movie != get_movie_pos_norm()) {
      float header = get_movie_warp().duration() *header_movie;
      get_movie_warp().jump(header);
    }
  }

  

  if(get_movie_warp(which_movie) != null) {
    float norm_pos = get_movie_warp().time() / get_movie_warp().duration();
    set_movie_pos_norm(norm_pos);
    if(speed_movie_warp_ref != get_movie_speed()) {
      speed_movie_warp_ref = get_movie_speed() ;
      if(speed_movie_warp_ref == 0) {
        get_movie_warp().pause() ;
      } else {
        get_movie_warp().read();
        get_movie_warp().speed(speed_movie_warp_ref);
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

Movie get_movie_warp() {
  return get_movie_warp(which_movie);
}

void select_media_to_display() {
  Info_int i = media_info.get(which_media);
  if(i.get_name().equals("Movie")) {
    movie_warp_is(true);
    which_movie = i.get(1);
  }
  if(i.get_name().equals("Image")) {
    movie_warp_is(false);
    which_img = i.get(1) +1;
  }
}





/**
we don't use 0 to the first element of the array because this one is use for G / surface
see void warp_init(int type_field, int size_cell) 
*/
int which_img = 1 ;

int which_movie = 0;

Info_int_dict media_info;
int rank_media;
int rank_img;
int rank_movie;
void set_media_info() {
  if(media_info == null) media_info = new Info_int_dict();
}

void reset_media_info() {
  media_info.clear();
  rank_media = 0;
  rank_img = 0;
  rank_movie = 0;
}

























/**
image
*/
void load_media_folder(boolean sub_folder, String... type) {
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
          media_info.add("Image",rank_media,rank_img);
          rank_img++;
          rank_media++;
          file_path("Image",f.getAbsolutePath());
          warp.load_image(f.getAbsolutePath());
          media_path_save(true);
          warp_media_loaded(true);
          break;
        }
      }
      // add video to library
      for(String s : ext_movie) {
        if(ext.equals(s)) {
          media_info.add("Movie",rank_media,rank_movie);
          rank_movie++;
          rank_media++;
          file_path("Movie",f.getAbsolutePath());
          load_movie(f.getAbsolutePath());
          media_path_save(true);
          warp_media_loaded(true);
          break;
        }
      }    
    }
  }
}


void load_media_input(String... type) {
  String path = selected_path_input();
  explore_folder(path, false, type);
  String [] ext_img = {"jpg", "JPG", "JPEG", "jpeg", "tif", "TIF", "tiff", "TIFF", "bmp", "BMP", "png", "PNG", "gif", "GIF"};
  String [] ext_movie = {"mov", "MOV", "avi", "AVI", "mp4", "MP4", "mkv", "MKV", "mpg", "MPG"};
  if(get_files() != null && get_files().size() > 0) {
    for(File f : get_files()) {
      String ext = extension(f.getName());
      // add image to library
      for(String s : ext_img) {
        if(ext.equals(s)) {
          media_info.add("Image",rank_media,rank_img);
          rank_img++;
          rank_media++;
          file_path("Image",f.getAbsolutePath());
          warp.load_image(f.getAbsolutePath());
          media_path_save(true);
          warp_media_loaded(true);
          break;
        }
      }
      // add video to library
      for(String s : ext_movie) {
        if(ext.equals(s)) {
          media_info.add("Movie",rank_media,rank_movie);
          rank_movie++;
          rank_media++;
          file_path("Movie",f.getAbsolutePath());
          load_movie(f.getAbsolutePath());
          media_path_save(true);
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


