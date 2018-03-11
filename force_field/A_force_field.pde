/**
Example
force field 
v 0.2.0
*/
Force_field force_field;
boolean force_field_init_is;

float freq_ff;
float visc_ff;
float diff_ff;

int [] sorting_img_ff_2D = new int[3] ;







/**
init
*/
void init_ff(int type, int pattern, int resolution, PImage src) {
  if(!force_field_init_is) {
    build_ff(type, pattern, resolution, src);
    force_field_init_is = true ;
  }
}

boolean build_ff_is() {
  if(force_field != null) {
    return force_field.is() ;
  } else return false;
}

boolean ff_is() {
  return force_field_init_is ;
}









/**
change type
*/
int mode_ff = 0 ;
void change_mode_ff(int step) {
  mode_ff += step;
  int num_mode = 6;
  if(mode_ff > num_mode) mode_ff = 0 ;
  if(mode_ff < 0) mode_ff = num_mode; 
  mode_ff();
}

void mode_ff() {
  if(mode_ff == 0) {
    type_field = r.STATIC; 
    pattern_field = r.PERLIN; 
  } else if(mode_ff == 1) {
    type_field = r.STATIC; 
    pattern_field = r.EQUATION; 
  } else if(mode_ff == 2) {
    type_field = r.STATIC; 
    pattern_field = r.CHAOS; 
  } else if(mode_ff == 3) {
    if(warp.library() != null && warp.library_size() > 0) {
      type_field = r.STATIC; 
      pattern_field = IMAGE ;
    } else {
      println("The library is empty, load media before use this mode/n instead the pattern CHAOS is used");
      type_field = r.STATIC; 
      pattern_field = r.CHAOS;
    }
  } else if(mode_ff == 4) {
    type_field = r.MAGNETIC; 
    pattern_field = r.BLANK; 
  } else if(mode_ff == 5) {
    type_field = r.GRAVITY; 
    pattern_field = r.BLANK; 
  } else if(mode_ff == 6) {
    type_field = r.FLUID; 
    pattern_field = r.BLANK; 
  }
  int super_type_field = r.STATIC ;
  if(type_field != r.STATIC) super_type_field = r.DYNAMIC;
  global_reset(type_field, pattern_field, super_type_field, get_resolution_ff()); 
}










/**
channel sorting for image
*/
void set_sorting_channel_ff_2D(int dx_sort_channel, int dy_sort_channel, int vel_sort_channel) {
  sorting_img_ff_2D[0] = get_channel_component(dx_sort_channel) ;
  sorting_img_ff_2D[1] = get_channel_component(dy_sort_channel) ;
  sorting_img_ff_2D[2] = get_channel_component(vel_sort_channel) ;
}

int [] get_sorting_channel_ff_2D() {
  return sorting_img_ff_2D ;
}

int get_channel_component(int value) {
  int i = r.RED;
  switch(value) {
    case 0: i = r.RED; break;
    case 1: i = r.GREEN; break;
    case 2: i = r.BLUE; break;
    case 3: i = r.HUE; break;
    case 4: i = r.SATURATION; break;
    case 5: i = r.BRIGHTNESS; break;
    case 6: i = r.ALPHA; break;
    default : i = r.RED;
  }
  return i;
}





/**
cell size
*/
int size_cell_ff_ref;
int size_cell_ff;
void set_cell_grid_ff(int size) {
  size_cell_ff = size;
  if(size_cell_ff_ref != size_cell_ff) {
    force_field_init_is = false;
  }
  size_cell_ff_ref = size;
}

int get_size_cell_ff() {
  return size_cell_ff ;
}






/**
BUILD
v 0.1.0
*/
/** 
add spot
* it's use for force field GRAVITY, MAGNETIC and FLUID
*/
int num_spot_ff_ref ;
int area_level_spot_ff_ref ;
void num_spot_ff(int num, int level) {
  if(force_field != null) {
    if(force_field.get_super_type() == r.DYNAMIC) {
      if(num != num_spot_ff_ref || area_level_spot_ff_ref != level) {
        force_field.clear_spot();
      }
      num_spot_ff_ref = num ;
      area_level_spot_ff_ref = level;
      if(force_field != null && num > force_field.get_spot_num()) {
        println("add", num, "spot to force field");
        force_field.add_spot(num);
        force_field.set_spot_area_level(level);

      } else if(force_field == null) {
        if(frameCount < 3) { 
          printErr("num_spot_force_field() must be place after method build_force_field()");
        } else {
          printErrTempo(180, "num_spot_force_field() must be place after method build_force_field()");
        }
      }
    } 
  }   
}


/**
type_force_field CHAOS, PERLIN or FLUID
*/
void build_ff(int type_ff, int pattern_ff, int resolution) {
  build_ff(type_ff, pattern_ff, resolution, null);
}

void build_ff(int type_ff, int pattern_ff, int resolution, PImage src, int... sorting_channel) {
  iVec2 canvas = iVec2();
  iVec2 canvas_pos = iVec2();
  if(src != null) {
    int offset = resolution;
    canvas = iVec2(src.width +offset, src.height +offset);
    canvas_pos = iVec2(0 -offset/2);
  } else {
    int offset = resolution;
    canvas = iVec2(width +offset, height +offset);
    canvas_pos = iVec2(0 -offset/2);
  }

  if(type_ff == r.GRAVITY) {
    build_ff_gravity(resolution, canvas_pos, canvas);
    check_for_available_spot();
  } else if (type_ff == r.MAGNETIC) {
    build_ff_magnetic(resolution, canvas_pos, canvas);
    check_for_available_spot();
  } else if (type_ff == r.FLUID) {
    build_ff_fluid(resolution, canvas_pos, canvas);
    // default fluid value
    freq_ff = 2/frameRate;
    visc_ff = .001;;
    diff_ff = 1.;   
    check_for_available_spot();
  } else if(pattern_ff == IMAGE) {
    if(src != null && src.pixels != null) {
        build_ff_img(resolution, canvas_pos, src, sorting_channel);
    } else {
      printErr("PImage src is null, Force field cannot be build");
    }
  } else  {
    build_ff_classic(type_ff, pattern_ff, resolution, canvas_pos, canvas);
  }
  set_cell_grid_ff(resolution);
  // force_field.set_spot_area(1);
}

/*
warning
*/
void check_for_available_spot() {
  if(force_field.get_spot_num() < 1 ) {
    printErr("void build_force_field() There is no spot added for your force Field, this force field need one to work") ;
  }
}
/**
Different mode to build force field
v 0.0.2
*/
/**
* build classic
*/
void build_ff_classic(int type_force_field, int pattern_force_field, int resolution, iVec2 canvas_pos, iVec2 canvas) {
  force_field = new Force_field(resolution, canvas_pos, canvas, type_force_field, pattern_force_field);
  force_field_init_is = true ;
}
/**
* buid force field FLUID
*/
void build_ff_fluid(int resolution, iVec2 canvas_pos, iVec2 canvas) {
  force_field = new Force_field(resolution, canvas_pos, canvas, r.FLUID, r.BLANK);
  force_field_init_is = true ;
  
}
/**
* build force field image source to generate the vector field
*/
void build_ff_img(int resolution, iVec2 canvas_pos, PImage img, int... sorting_channel) {
  force_field = new Force_field(resolution, canvas_pos, img, sorting_channel);
  force_field_init_is = true ;
}
/**
* build force field gravity
*/
void build_ff_gravity(int resolution, iVec2 canvas_pos, iVec2 canvas) {
  force_field = new Force_field(resolution, canvas_pos, canvas, r.GRAVITY, r.BLANK);
  force_field_init_is = true ;
}
/**
* build force field magnetic
*/
void build_ff_magnetic(int resolution, iVec2 canvas_pos, iVec2 canvas) {
  force_field = new Force_field(resolution, canvas_pos, canvas, r.MAGNETIC, r.BLANK);
  // Force_field(int resolution, iVec2 canvas_pos, iVec2 canvas, int type, int pattern)
  force_field_init_is = true ;
}














/**
UPDATE
v 0.1.0
*/
void update_ff() {
  // update spot if there is no coord in the list
  if(spot_list_coord == null) {
    update_spot_ff_coord(Vec2(width/2,height/2));
  }
  if(spot_list_is == null) { 
    update_spot_ff_is(true);
  }
  
  // update spot
  if(force_field != null) {
    if(force_field.get_type() == r.FLUID) {
      update_ff_fluid();
    } else if(force_field.get_type() == r.GRAVITY) {
      update_ff_gravity();
    } else if(force_field.get_type() == r.MAGNETIC) {
      update_ff_magnetic();
    } 
    
    // update field
    if(force_field.activity_is()) {
      if(full_reset_field_is) {
        force_field.reset() ;
      } else {
        force_field.reset_spot_area();
      }
      force_field.update();
    }
  } else {
    printErrTempo(240, "the force field is not init, maybe the media is not loaded ?");
  } 
}







/**
FLUID CASE
*/
void update_ff_fluid() {
  force_field.set_frequence(freq_ff);
  force_field.set_viscosity(visc_ff); // back to normal
  force_field.set_diffusion(diff_ff);
  
  for(int i = 0 ; i < force_field.spot_list.size() && i < spot_list_coord.size() ; i++) {
    if(i < spot_list_is.size()) {
      if(spot_list_is.get(i)) {
        force_field.set_spot_pos(spot_list_coord.get(i),i);
      } else {
        // this two lines are specifics to fluid system
        force_field.ref_spot(i);
        force_field.set_spot_pos(spot_list_coord.get(i),i);
      }
    } else {
      force_field.set_spot_pos(spot_list_coord.get(i),i);
    }
  }
}

/**
MAGNETIC CASE
*/
void update_ff_magnetic() {
  for(int i = 0 ; i < force_field.spot_list.size() && i < spot_list_coord.size() && i < spot_list_tesla.size(); i++) {
    force_field.set_spot_tesla(spot_list_tesla.get(i),i);
    force_field.set_spot_diam(spot_list_diam.get(i),i);

    if(i < spot_list_is.size()) {
      if(spot_list_is.get(i)) {
        force_field.set_spot_pos(spot_list_coord.get(i),i);
      } 
    } else {
      force_field.set_spot_pos(spot_list_coord.get(i),i);
    }
  }
}

/**
GRAVITY CASE
*/
void update_ff_gravity() {
  for(int i = 0 ; i < force_field.spot_list.size() && i < spot_list_coord.size() ; i++) {
    if(i < spot_list_mass.size()) {
      force_field.set_spot_mass(spot_list_mass.get(i),i);
      force_field.set_spot_diam(spot_list_diam.get(i),i);
      if(i < spot_list_is.size()) {
        if(spot_list_is.get(i)) {
          force_field.set_spot_pos(spot_list_coord.get(i),i);
        } 
      } else {
        force_field.set_spot_pos(spot_list_coord.get(i),i);
      }
    }   
  }
}





/**
update value
*/
float ref_freq_norm, ref_visc_norm, ref_diff_norm ;
void update_value_ff_fluid(float freq_norm, float visc_norm, float diff_norm, boolean update_is) {
  if(ref_freq_norm != freq_norm || ref_visc_norm != visc_norm || ref_diff_norm != diff_norm || update_is) {
    freq_ff = freq_norm *.05 ;
    visc_ff = visc_norm *visc_norm *visc_norm *visc_norm;
    diff_ff = diff_norm;

    ref_freq_norm = freq_norm;
    ref_visc_norm = visc_norm;
    ref_diff_norm = diff_norm;
  }
}


float ref_range_min, ref_range_max, ref_power ;
void update_value_ff_generative(float range_min, float range_max, float power, boolean update_is) {
  if(ref_range_min != range_min || ref_range_max != range_max || ref_power != power || update_is) {
    force_field.preserve_field();
    force_field.map_velocity(0.3,0.6,range_min,range_max);
    ref_range_min = range_min;
    ref_range_max = range_max;
    force_field.mult_velocity(power);
    ref_power = power;
  } 
}


/**
Update spot
--
spot manager
position 
condition 
tesla
size
*/
ArrayList<Vec2> spot_list_coord;
void update_spot_ff_coord(Vec2... spot_xy) {
  if(spot_list_coord == null) {
    spot_list_coord = new ArrayList<Vec2>();
    for(int i = 0 ; i < spot_xy.length ; i++) {
      Vec2 coord = spot_xy[i] ;
      spot_list_coord.add(coord);
    }
  } else {
    if(spot_list_coord.size() < spot_xy.length) {
      for(int i = spot_xy.length - spot_list_coord.size() ; i < spot_xy.length ; i++) {
        Vec2 coord = spot_xy[i] ;
        spot_list_coord.add(coord);
      }
    } else {
      for(int i = 0 ; i < spot_xy.length ; i++) {
        if(spot_list_coord.get(i) != null) spot_list_coord.get(i).set(spot_xy[i]);
      }
    }
  }
}


ArrayList<Boolean> spot_list_is;
void update_spot_ff_is(boolean... spot_is) {
  if(spot_list_is == null) {
    spot_list_is = new ArrayList<Boolean>();
    for(int i = 0 ; i < spot_is.length ; i++) {
      boolean bool_is = spot_is[i] ;
      spot_list_is.add(bool_is);
    }
  } else {
    if(spot_list_is.size() < spot_is.length) {
      for(int i = spot_is.length - spot_list_is.size() ; i < spot_is.length ; i++) {
        boolean bool_is = spot_is[i] ;
        spot_list_is.add(bool_is);
      }
    } else {
      for(int i = 0 ; i < spot_is.length ; i++) {
        spot_list_is.set(i,spot_is[i]);
      }
    }
  }
}

ArrayList<Integer> spot_list_tesla;
void update_spot_ff_tesla(int... tesla) {
  if(spot_list_tesla == null) {
    spot_list_tesla = new ArrayList<Integer>();
    for(int i = 0 ; i < tesla.length ; i++) {
      int t = tesla[i] ;
      spot_list_tesla.add(t);
    }
  } else {
    if(spot_list_tesla.size() < tesla.length) {
      for(int i = tesla.length - spot_list_tesla.size() ; i < tesla.length ; i++) {
        int t = tesla[i] ;
        spot_list_tesla.add(t);
      }
    } else {
      for(int i = 0 ; i < tesla.length ; i++) {
        spot_list_tesla.set(i,tesla[i]);
      }
    }
  }
}

ArrayList<Integer> spot_list_diam;
void update_spot_ff_diam(int... diam) {
  if(spot_list_diam == null) {
    spot_list_diam = new ArrayList<Integer>();
    for(int i = 0 ; i < diam.length ; i++) {
      int d = diam[i] ;
      spot_list_diam.add(d);
    }
  } else {
    if(spot_list_diam.size() < diam.length) {
      for(int i = diam.length - spot_list_diam.size() ; i < diam.length ; i++) {
        int d = diam[i] ;
        spot_list_diam.add(d);
      }
    } else {
      for(int i = 0 ; i < diam.length ; i++) {
        spot_list_diam.set(i,diam[i]);
      }
    }
  }
}


ArrayList<Integer> spot_list_mass;
void update_spot_ff_mass(int... mass) {
  if(spot_list_mass == null) {
    spot_list_mass = new ArrayList<Integer>();
    for(int i = 0 ; i < mass.length ; i++) {
      int m = mass[i] ;
      spot_list_mass.add(m);
    }
  } else {
    if(spot_list_mass.size() < mass.length) {
      for(int i = mass.length - spot_list_mass.size() ; i < mass.length ; i++) {
        int m = mass[i] ;
        spot_list_mass.add(m);
      }
    } else {
      for(int i = 0 ; i < mass.length ; i++) {
        spot_list_mass.set(i,mass[i]);
      }
    }
  }
}
























/**
get
*/
Force_field get_ff() {
  return force_field ;
}

PImage get_img_velocity_ff() {
  return force_field.get_tex_velocity();
}

PImage get_img_direction_ff() {
  return force_field.get_tex_direction();
}

int get_type_ff() {
  if(force_field != null ) {
    return force_field.get_type();
  } else return r.STATIC;
}

int get_super_type_ff() {
  if(force_field != null ) {
    return force_field.get_super_type();
  } else return r.STATIC;
}

int get_pattern_ff() {
  if(force_field != null ) {
    return force_field.get_pattern();
  } else return r.BLANK;
}

int get_resolution_ff() {
  if(force_field != null ) {
    return force_field.get_resolution();
  } else return -1;
}

int get_spot_num_ff() {
  if(force_field != null) {
    return force_field.get_spot_num();
  } else return -1;
}

int get_spot_area_level_ff() {
  if(force_field != null) {
    return force_field.get_spot_area_level();
  } else return -1;
}