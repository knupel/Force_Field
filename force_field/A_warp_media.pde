

/**
video
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
  if(movie_warp_list != null) movie_warp_list.clear();
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


int ref_movie ;
void display_movie() {
  if(movie_warp_list != null && get_movie_warp(which_movie) != null) {
    if(ref_movie != which_movie) {
      get_movie_warp(which_movie).stop();
    }
    ref_movie = which_movie ;
    get_movie_warp(which_movie).loop();
    image(get_movie_warp(which_movie),0,0);
    /*
    if(keyPressed || mousePressed) {
      start_movie_is = true ;
    }
    */
  }
  
}

// Called every time a new frame is available to read
void movieEvent(Movie m) {
  if(play_movie_warp_is) m.read();
}

Movie get_movie_warp(int target) {
  if(target < movie_warp_list.size()) {
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


