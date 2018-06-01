/**
MISC
v 0.4.0
*/
/**
set window display




BIG MESS REWORK ALL THE METHOD








*/
// MAIN
void set_window_on_main_display(iVec2 size) {
  iVec2 pos_screen = iVec2(0,0);
  iVec2 pos_display = iVec2(get_display_size()).sub(size).div(2);
  set_window(pos_screen,size,pos_display);
}

void set_window_on_main_display(iVec2 pos, iVec2 size) {
  set_window(pos,size);
}

void set_window_on_main_display(iVec2 pos, iVec2 size, int type) {
  iVec2 pos_display = iVec2();
  if(type == CENTER) {  
    pos_display = iVec2(get_display_size()).sub(size).div(2).add(pos);
  } else {
    pos_display.set(pos);
  }
  set_window(pos,size,pos_display);
}

// OTHER
void set_window_on_other_display(iVec2 size) {
  iVec2 pos = iVec2(get_display_size(1).x, 0);
  iVec2 pos_display = iVec2(get_display_size(1)).sub(size).div(2);
  set_window(pos,size,pos_display);

}

void set_window_on_other_display(iVec2 size, int target_display) {
  println("display",target_display,get_display_size(target_display));
  iVec2 pos = iVec2(get_display_size(target_display).x, 0);
  iVec2 pos_display = iVec2(get_display_size(target_display)).sub(size).div(2);
  set_window(pos,size,pos_display);
}


void set_window_on_other_display(iVec2 pos, iVec2 size) {
  iVec2 pos_display = iVec2(get_display_size(1).x, 0);
  set_window(pos,size,pos_display);
}

void set_window_on_other_display(iVec2 pos, iVec2 size, int type) {
  set_window_on_other_display(pos,size, 1, type);
}

void set_window_on_other_display(iVec2 pos, iVec2 size, int target_display, int type) {
  iVec2 pos_display = iVec2(get_display_size(target_display).x, 0);
  set_window_on_other_display(pos, size, pos_display, type);
}

void set_window_on_other_display(iVec2 pos, iVec2 size, iVec2 offset, int type) {
  //iVec2 pos_screen = iVec2(get_display_size(target_display).x, 0);
  iVec2 pos_display = iVec2();
  if(type == CENTER) {  
    pos_display = iVec2(get_display_size(1)).sub(size).div(2).add(pos);
  } else {
    pos_display.set(pos);
  }
  set_window(offset,size,pos_display);
}






































































/**
import file
v 0.0.1
*/
/**
 add file : media – movie & image – in the future shape
*/
void force_import_update() {
  if(import_refresh_is() || import_path_save_is()) {
    if(import_refresh_is()) {
      reset_key();
      import_refresh(false);
    }
    if(import_path_save_is()) {
      save_import_path();
      import_path_save(false);
    }   
  }
}

// file part
void force_import_input() {
  select_input();
  import_refresh(true);
  println("add input");
}



// folder part
void force_import_folder() {
  select_folder();
  import_refresh(true);
  println("add folder");
}


void force_clear_import() {
  reset_media_info();
  if(get_files() != null) {
    // part for img and movie
    warp_media_loaded(false);
    get_files().clear();
    warp.image_library_clear();
    movie_library_clear();

    file_path_clear();
  }
}











/**
SAVE / LOAD
v 0.0.4
*/
void save_force() {
  write_file_mask_mapping();
  selectOutput("Select a file to write to:", "selected_file_to_save"); 
}


void selected_file_to_save(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected",selection.getAbsolutePath(),"for save force file");
    save_file_mask_mapping(get_file_mask_mapping(),selection.getAbsolutePath()+".csv");
  }
}

// mask file
Table file_msk;
Table get_file_mask_mapping() {
  return file_msk;
}

void set_file_mask_mapping(Table t) {
  file_msk = t ;
}

void save_file_mask_mapping(Table s_msk, String path) {
  if(s_msk != null) {
    saveTable(s_msk, path);
  }
} 

void write_file_mask_mapping() {
  file_msk = new Table();
  file_msk.addColumn("name");
  file_msk.addColumn("num");
  file_msk.addColumn("is");
  file_msk.addColumn("x");
  file_msk.addColumn("y");

  TableRow newRow;
  newRow = file_msk.addRow();
  newRow = file_msk.addRow();
  newRow.setString("name", "Total_mask");
   newRow.setInt("num", num_mask);

  if(coord_connected != null) {
    for(int i = 0 ; i < coord_connected.length ;i++) {
      newRow = file_msk.addRow();
      newRow.setString("name", "coord_connected");
      newRow.setString("is", "true");
      newRow.setInt("x", coord_connected[i].x);
      newRow.setInt("y", coord_connected[i].y);
    }
  }
  
  if(coord_block_1 != null) {
    for(int i = 0 ; i < coord_block_1.length ;i++) {
      newRow = file_msk.addRow();
      newRow.setString("name", "coord_block_1");
      newRow.setString("is", "true");
      newRow.setInt("x", coord_block_1[i].x);
      newRow.setInt("y", coord_block_1[i].y);
    }
  }

  if(coord_block_2 != null) {
    for(int i = 0 ; i < coord_block_2.length ;i++) {
      newRow = file_msk.addRow();
      newRow.setString("name", "coord_block_2");
      newRow.setString("is", "true");
      newRow.setInt("x", coord_block_2[i].x);
      newRow.setInt("y", coord_block_2[i].y);
    }
  }

  if(coord_block_3 != null) {
    for(int i = 0 ; i < coord_block_3.length ;i++) {
      newRow = file_msk.addRow();
      newRow.setString("name", "coord_block_3");
      newRow.setString("is", "true");
      newRow.setInt("x", coord_block_3[i].x);
      newRow.setInt("y", coord_block_3[i].y);
    }
  }

  if(coord_block_4 != null) {
    for(int i = 0 ; i < coord_block_4.length ;i++) {
      newRow = file_msk.addRow();
      newRow.setString("name", "coord_block_4");
      newRow.setString("is", "true");
      newRow.setInt("x", coord_block_4[i].x);
      newRow.setInt("y", coord_block_4[i].y);
    }
  }

  // save block indépendant
  if(coord_mask != null && coord_mask.length > 0) {
    for(int i = 0 ; i < coord_mask.length ;i++) {
      if(coord_mask[i] != null) {
        newRow = file_msk.addRow();
        newRow.setString("name", "coord_mask_" +i);
        newRow.setInt("num", coord_mask[i].get().length);
        for(int k = 0 ; k < coord_mask[i].get().length ; k++) {
          newRow = file_msk.addRow();
          newRow.setString("name", "coord_mask_" +i);
          newRow.setString("is", "true");
          newRow.setInt("x", masks[i].get_coord()[k].x);
          newRow.setInt("y", masks[i].get_coord()[k].x);
        }
      }     
    }
  }
}





/**
save data dialogue with controller
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

void save_import_path() {
  println(ext_path_file);
  if(ext_path_file != null) {
    println("save import files");
    String [] s = split(ext_path_file, "///");
    saveStrings(sketchPath(1)+"/save/import_files.txt",s);
  } else {
    // println("save null import files");
  }
}


boolean import_path_save_is;
boolean import_path_save_is() {
  return import_path_save_is;
}

void import_path_save(boolean state){
  import_path_save_is = state;
}


boolean import_refresh_is ;
boolean import_refresh_is() {
  return import_refresh_is ;
}

void import_refresh(boolean state) {
  import_refresh_is = state;
}

/**
save dial file
*/
Table table_dial_force;
TableRow [] row;
void save_dial_force(int tempo) {
  if(frameCount%tempo == 0) {
    if(table_dial_force == null) {
      table_dial_force = new Table();
      table_dial_force.addColumn("name");
      table_dial_force.addColumn("value");
      int num_row = 30;
      row = new TableRow[num_row] ;
      for(int i = 0 ; i < row.length ; i++) {
        row[i] = table_dial_force.addRow();
      }    
    }
    
    row[0].setString("name", "movie position");
    row[0].setFloat("value", get_movie_pos_norm());
    // mode
    row[1].setString("name", "perlin");
    if(mode_perlin) row[1].setInt("value",1); else row[1].setInt("value",0);
    row[2].setString("name", "chaos");
    if(mode_chaos) row[2].setInt("value",1); else row[2].setInt("value",0);
    row[3].setString("name", "equation");
    if(mode_equation) row[3].setInt("value",1); else row[3].setInt("value",0);
    row[4].setString("name", "image");
    if(mode_image) row[4].setInt("value",1); else row[4].setInt("value",0);
    row[5].setString("name", "gravity");
    if(mode_gravity) row[5].setInt("value",1); else row[5].setInt("value",0);
    row[6].setString("name", "magnetic");
    if(mode_magnetic) row[6].setInt("value",1); else row[6].setInt("value",0);
    row[7].setString("name", "fluid");
    if(mode_fluid) row[7].setInt("value",1); else row[7].setInt("value",0);

    // display
    row[8].setString("name", "background");
    if(display_background) row[8].setInt("value",1); else row[8].setInt("value",0);
    row[9].setString("name", "vehicle");
    if(display_vehicle) row[9].setInt("value",1); else row[9].setInt("value",0);
    row[10].setString("name", "warp");
    if(display_warp) row[10].setInt("value",1); else row[10].setInt("value",0);
    row[11].setString("name", "field");
    if(display_field) row[11].setInt("value",1); else row[11].setInt("value",0);
    row[12].setString("name", "spot");
    if(display_spot) row[12].setInt("value",1); else row[12].setInt("value",0);
    row[13].setString("name", "other");
    if(display_other) row[13].setInt("value",1); else row[13].setInt("value",0);
    /*
    row[14].setString("name", "curtain");
    if(curtain_is) row[14].setInt("value",1); else row[14].setInt("value",0);
    */
    
    // dropdown
    row[19].setString("name", "type spot");
    row[19].setInt("value",get_type_spot());

    row[20].setString("name", "type vehicle");
    row[20].setInt("value",get_type_vehicle());

    row[21].setString("name", "media");
    row[21].setInt("value",get_which_media());

    // misc
    row[22].setString("name", "resize widow");
    row[22].setInt("value",1); // not used at this time   
    row[23].setString("name", "full fit image");
    row[23].setInt("value",1); // not used at this time
    row[24].setString("name", "show must go on");
    row[24].setInt("value",1); // not used at this time  
    row[25].setString("name", "warp fx");
    if(warp_fx_is()) row[25].setInt("value",1); else row[25].setInt("value",0);
    row[26].setString("name", "shader fx");
    if(shader_fx_is()) row[26].setInt("value",1); else row[26].setInt("value",0);
    row[27].setString("name", "full reset field");
    if(full_reset_field_is) row[27].setInt("value",1); else row[27].setInt("value",0);
    row[28].setString("name", "curtain");
    if(curtain_is) row[28].setInt("value",1); else row[28].setInt("value",0);

    saveTable(table_dial_force,sketchPath(1)+"/save/dialogue_force.csv");
  }  
}















































/**
UPDATE VALUE
v 0.0.1
*/
Vec4 rgba_warp = Vec4(1);
float power_warp_max;
void update_rgba_warp(int t_count) {
  float cr = 1.;
  float cg = 1.;
  float cb = 1.;
  if(red_cycling != 0) {
    cr = sin(t_count *(red_cycling *red_cycling *.1)); 
  }
  if(green_cycling != 0) {
    cg = sin(t_count *(green_cycling *green_cycling *.1)); 
  }
  if(blue_cycling != 0) {
    cb = sin(t_count *(blue_cycling *blue_cycling *.1)); 
  }
  
  Vec4 sin_val = Vec4(1);
  sin_val.set(cr,cg,cb,1);

  rgba_warp.set(red_warp,green_warp,blue_warp,1);
  power_warp_max = (power_warp *power_warp) *10f;
  
  rgba_warp.mult(power_warp_max);
  
  float min_src = 0 ;
  float max_src = 1 ;
  float min_dst = .01 ;
  rgba_warp.set(sin_val.map_vec(Vec4(min_src), Vec4(max_src), Vec4(min_dst), rgba_warp));
}












































/**
RESET
v 0.3.0
*/
void global_reset() {
  if(vehicle_reset_gui_is || warp_reset_gui_is || field_reset_gui_is) {
    bVec3 reset = bVec3(vehicle_reset_gui_is,warp_reset_gui_is,field_reset_gui_is);
    vehicle_reset_gui_is = false;
    warp_reset_gui_is = false;
    field_reset_gui_is = false;
    reset(reset, force_field.get_type(), force_field.get_pattern(), force_field.get_super_type(), get_resolution_ff());
  } 
}

void reset(bVec3 reset, int type, int pattern, int super_type, int resolution) {
  force_field_init_is = false ;
  if(reset.x)reset_vehicle(get_num_vehicle(),get_ff());
  if(reset.y)warp.reset();
  if(reset.z)reset_field(type, pattern, super_type, resolution);
}

void reset_field(int type, int pattern, int super_type, int resolution) {
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
  }
}

void reset_mode() {
  for(int i = 0 ; i < mode.length ; i++) {
    mode[i] = false;
  }
}






























  

















/**
KEYPRESSED
v 0.5.0
*/

void keyPressed() {
  news_from_gui = true;
  keys[keyCode] = true;
  
  // Mask all the keypressed is in majuscule
  mask_keyPressed();

  force_keyPressed();
}




/**
the method is not with her family for bug reason...Java or Processing that's create an exception due of key_num_under_num[3] = '"';
problem to manage double quote assignation in char.
the char assignation must be write before the key and keyCode interrogation ?
*/
void enable_mask_is_on_top_for_bug_reason() {
  char [] key_num_under_num = {'0','1','2','3','4','5','6','7','8','9'};
  /*
  char [] key_num_under_num = new char[10];
  key_num_under_num[0] = '0';
  key_num_under_num[1] = '1';
  key_num_under_num[2] = '2';
  key_num_under_num[3] = '3';
  key_num_under_num[4] = '4';
  key_num_under_num[5] = '5';
  key_num_under_num[6] = '6';
  key_num_under_num[7] = '7';
  key_num_under_num[8] = '8';
  key_num_under_num[9] = '9'; 
  */

  for(int i = 0 ; i < display_mask.length && i < key_num_under_num.length ; i++) {
    if(key == key_num_under_num[i]) {
      display_mask[i] = !!((display_mask[i] == false));
      if(display_mask[i])  display_mask[0] = true;
      break;
    }
  } 
}


void key_pressed_change_mode() {
  /*
  if(key == 'w') {
    next_mode_ff(-1);
  }
  if(key == 'x') {
    next_mode_ff(+1);
  }
  */
  char [] key_num = {'à','&','é','"','\'','(','§','è','!','ç'};
  /*
  char [] key_num = new char[10];
  key_num[0] = 'à';
  key_num[1] = '&';
  key_num[2] = 'é';
  key_num[3] = '"';
  key_num[4] = '\'';
  key_num[5] = '(';
  key_num[6] = '§';
  key_num[7] = 'è';
  key_num[8] = '!';
  key_num[9] = 'ç'; 
  */



  for(int i = 0 ; i < num_mode ; i++) {
    if(key == key_num[i+1]) {
      reset_mode();
      mode[i] = true;
    }
  }
}



void mask_keyPressed() {
  // MAJUSCULE
  if(key == 'M') {
    set_mask();
  }
  // hide mask
  enable_mask();
  
  // MAJUSCULE
  if(key == 'S') {
    save_force();
  }
  
  // MAJUSCULE
  if(key == 'L') {
    selectInput("Select a file to load data mask:", "load_save_mask");
  }
}






void force_keyPressed() {
  // for information
  // MAPPING KEYBOARD PROBLEM AZERTY >< QWERTY
  // Q for A I don't how map AZERTY layout keyboard
  key_pressed_import();
  /**
  if(key == 'a')
  that control with advanced method see below, 
  because the azerty keymap is not recognized with multikey
  */

  // BACKGROUND REFRESH
  if(key == 'q') display_background();
    // CURTAIN 
  if(key == 'Q') {
    curtain();
  }

  /**
  display 
  */
  if(key == 'a') display_vehicle();

  if(key == 'z') display_warp();

  if(key == 'e') display_field();

  if(key == 'r') display_spot();

  if(key == 't') display_other();

  /**
  effect
  */

  if(key == 'y') {
    misc_warp_fx = !!((misc_warp_fx == false));
  }

  if(key == 'u') {
    misc_shader_fx = !!((misc_shader_fx == false));
  }

  if(key == 's') {
    use_sound();
  }


  /**
  refresh
  */
  // total reset
  if(key == 'N') {
    vehicle_reset_gui_is = true;
    warp_reset_gui_is = true;
    field_reset_gui_is = true;
    global_reset();
  }

  // partial reset
  if(key == 'n') {
    vehicle_reset_gui_is = false;
    warp_reset_gui_is = true;
    field_reset_gui_is = true;
    global_reset();
  }



  key_pressed_change_mode();
  /**  
  info with SHIFT
  */
  if(key == 'b') manage_border();

  if(key == 'c') hide_interface();

  if(key == 'd') diaporama_is();

  if(key == 'g') display_grid();

  if(key == 'i') display_info();
  
  if(key == 'k') {
    display_cursor();
    // change_cursor_controller(); // switch between mouse or leap motion
  }
  
  

  /**
  MISC
  */
  if(key == 'p') {
    println("export jpg");
    saveFrame();   
  }

  // width SHIFT / MAJ
  if(key == 'V') {
    if(use_video_cam) play_video_switch();
  }


  if(key == ' ') {
    pause_is = !!((pause_is == false));
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



















void key_pressed_import() {
  if(os_system.equals("Mac OS X")) {
    import_folder(157, SHIFT, KeyEvent.VK_O); 
    import_file(157, SHIFT, KeyEvent.VK_O);
  } 
  if(keyCode == DELETE || keyCode == BACKSPACE) {
    manage_clear_import_list();
  }
}




void manage_clear_import_list() {
  int confirmation = popup_confirm("CLEAR IMPORT LIST", "Are you sure you wish clear the import file list?");
  if(confirmation == 0) {
    println("the import list is empty now");
    force_clear_import();
    project_import_shape();
    save_import_path();
  } else {
    println("the import list is safe, you've cancel your action");
  }
}

import javax.swing.JOptionPane;
int popup_confirm(String message_1, String message_2) {    
  JOptionPane jop = new JOptionPane();
  return jop.showConfirmDialog(null, message_2, message_1, JOptionPane.YES_NO_OPTION);
}



void import_folder(int a, int b, int c) {
  // true-true-true
  if(checkKey(a) && checkKey(b) && checkKey(c)) {
    display_warp(true);
    force_import_folder();
    play_video(false);
  }
}


void import_file(int a, int b, int c) {
  // true-false-true
  if(checkKey(a) && !checkKey(b) && checkKey(c)) {
    display_warp(true);
    force_import_input();
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
DATA CONTROL
v 0.1.0
SET and RETURN / boolean, int...

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

boolean display_mask_is(int target) {
  if(target < display_mask.length && target >= 0) {
    return display_mask[target];
  } else return false;
}

void enable_mask() {
  enable_mask_is_on_top_for_bug_reason();

/**
the method is not with her family for bug reason...Java or Processing that's create an exception due of key_num_under_num[3] = '"';
problem to manage double quote assignation in char.
the char assignation must be write before the key and keyCode interrogation ?
*/
  /*
  char [] key_num_under_num = new char[10];
  key_num_under_num[0] = 'à'; 
  key_num_under_num[1] = '&';
  key_num_under_num[2] = 'é';
  key_num_under_num[3] = '"';
  key_num_under_num[4] = '\'';
  key_num_under_num[5] = '(';
  key_num_under_num[6] = '§';
  key_num_under_num[7] = 'è';
  key_num_under_num[8] = '!';
  key_num_under_num[9] = 'ç';
  for(int i = 0 ; i < display_mask.length && i < key_num_under_num.length ; i++) {
    if(key == key_num_under_num[i]) {
      display_mask[i] = !!((display_mask[i] == false)); 
      break;
    }
  } 
  */
}









/**
display curtain
*/
boolean curtain_is() {
  return curtain_is;
}

void curtain_is(boolean is) {
  curtain_is = is;
}

void curtain() {
  curtain_is = !!((curtain_is == false));
}


/**
use_sound_is
*/
boolean use_sound_is() {
  return use_sound_is;
}

void use_sound_is(boolean is) {
  use_sound_is = is;
}

void use_sound() {
  use_sound_is = !!((use_sound_is == false));
}





/**
cursor
*/
boolean display_cursor_is() {
  return display_cursor;
}

void display_cursor(boolean is) {
  display_cursor = is;
}

// method to set the gui back
void display_cursor() {
  display_cursor = !!((display_cursor == false));
}

/**
display
*/
void display_info() {
  display_info = !!((display_info == false));
  set_info(display_info) ;
}


void display_grid() {
  display_grid = !!((display_grid == false));
  if(!display_grid) display_info = false ;
}


/**
display other
*/
boolean display_other_is() {
  return display_other;
}

void display_other(boolean is) {
  display_other = is;
}

// method to set the gui back
void display_other() {
  display_other = !!((display_other == false));
  // if(!display_other) display_info = false ;
}

/**
display spot
*/
boolean display_spot_is() {
  return display_spot;
}

void display_spot(boolean is) {
  display_spot = is;
}

// method to set the gui back
void display_spot() {
  display_spot = !!((display_spot == false));
  if(!display_spot) display_info = false ;
}

/**
display field
*/
boolean display_field_is() {
  return display_field;
}

void display_field(boolean is) {
  display_field = is;
}

// method to set the gui back
void display_field() {
  display_field = !!((display_field == false));
}

/**
display vehilcle
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
}


/**
display warp
*/
boolean display_warp_is() {
  return display_warp;
}

void display_warp(boolean is) {
  display_warp = is;
}

// method to set the gui back
void display_warp() {
  display_warp = !!((display_warp == false));
}

/** 
warp fx
*/
boolean warp_fx_is() {
  return misc_warp_fx;
}

void set_warp_fx_is(boolean state) {
  misc_warp_fx = state;
}

/**
shader fx
*/
boolean shader_fx_is() {
  return misc_shader_fx;
}

void set_shader_fx_is(boolean state) {
  misc_shader_fx = state;
}

/**
display background
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
}

/**
movie setting
*/
float movie_pos_normal;
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
get shape
*/
int get_type_vehicle() {
  return type_vehicle;
}

int get_type_spot() {
  return type_spot;
}

/**
get media
*/
int get_which_media() {
  return which_media;
}


/**
diaporama control
*/
boolean diaporama_is ;
void diaporama_is() {
  diaporama_is = (true)? !diaporama_is : diaporama_is ;
}

/**
fit image control
*/
void set_fit_image(boolean state) {
  fullfit_image_is = state;
}

/**
reset field control
*/
void set_full_reset_field(boolean state) {
  full_reset_field_is = state;
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
info
v 0.2.0
*/
void info() {
  noFill() ;
  stroke(g.colorModeA *.6f);
  strokeWeight(.5);

  // INFO FIELD
  float scale = 5 ;
  int c = r.HUE;
  float min_c = .0; // red
  float max_c = .7; // blue
  boolean reverse_c = false;
  float alpha = 1;
  set_show_field(scale,c,alpha,min_c,max_c,reverse_c);
  show_field(get_ff());

  // GRID
  if(display_grid) {
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
  
  // SPOT
  if(display_info) {
    strokeWeight(2) ;
    noFill() ;
    stroke(255);
    show_spot(POINT);
  }
}

/**
info
*/
boolean display_grid = false;
boolean display_info = false ;
void set_info(boolean display_info) {
  this.display_info = display_info;
  if(display_info) {
    // display_field = true ;
    display_grid = true ;
  } else {
    //display_field = false;
    display_grid = false;
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
  // saveFrame(path, filename, compression, get_canvas());
  saveFrame(path, filename, compression);
}










/**
cursor manager
*/
void cursor_manager() {
  boolean display = false;
  if(set_mask_is() || interface_is() || display_cursor_is()) display = true;
  if(display) {
    cursor(CROSS);
  } else {
    noCursor();
  }
}

















/**
info system
*/
String os_system ;
void info_system() {
  println("java Version Name:",javaVersionName);
  os_system = System.getProperty("os.name");
  println("os.name:",os_system);
  println("os.version:",System.getProperty("os.version"));
  println("force.version:",force_version);
}








