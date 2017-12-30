/**
Example
force field 
v 0.1.0
*/
Force_field force_field;
boolean force_field_init_is;

float freq_ff;
float visc_ff;
float diff_ff;


int which_ff = 0 ;
void change_type_ff() {

  which_ff += 1 ;
  if(which_ff > 4) which_ff = 0 ;

  if(which_ff == 0 ) {
    type_field = r.PERLIN ;
  } else if(which_ff == 1) {
    type_field = r.CHAOS;
  } else if(which_ff == 2) {
    type_field = r.FLUID;
  } else if(which_ff == 3) {
    type_field = r.MAGNETIC;
  } else if(which_ff == 4) {
    type_field = r.GRAVITY;
  }

  // if(get_type_ff() == r.MAGNETIC) type_field = r.FLUID ; else type_field = r.MAGNETIC;
  force_field_init_is = false ;
  build_ff(type_field, get_resultion_ff());
  num_spot_ff(get_spot_num_ff());
}

/**
init
*/

void init_ff(int type, int resolution, PImage src) {
  if(!force_field_init_is) {
    build_ff(type, resolution, src);
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
v 0.0.5
*/
/** 
add spot
* it's use for force field GRAVITY, MAGNETIC and FLUID
*/
int num_spot_ff_ref ;
void num_spot_ff(int num) {
  if(num != num_spot_ff_ref) {
    force_field.clear_spot();
  }
  num_spot_ff_ref = num ;
  if(force_field != null && num > force_field.get_spot_num()) {
    println("add", num, "spot to force field");
    force_field.add_spot(num);

  } else if(force_field == null) {
    if(frameCount < 3) { 
      printErr("num_spot_force_field() must be place after method build_force_field()");
    } else {
      printErrTempo(180, "num_spot_force_field() must be place after method build_force_field()");
    }
  }
}


/**
type_force_field CHAOS, PERLIN or FLUID
*/
/**
* classic build
*/
void build_ff(int type_force_field, int resolution) {
  build_ff(type_force_field, resolution, null);
}

void build_ff(int type_force_field, int resolution, PImage src) {
  iVec2 canvas = iVec2();
  iVec2 canvas_pos = iVec2();
  if(src != null) {
    int offset = resolution;
    // int offset = 0;
    canvas = iVec2(src.width +offset, src.height +offset);
    canvas_pos = iVec2(0 -offset/2);
  } else {
    int offset = resolution;
    canvas = iVec2(width +offset, height +offset);
    canvas_pos = iVec2(0 -offset/2) ;
  }

  if(type_force_field == r.GRAVITY) {
    build_ff_gravity(resolution, canvas_pos, canvas);
    if(force_field.get_spot_num() < 1) printErr("void build_force_field() There is no spot added for your force Field, this force field need one to work") ;  
  } else if (type_force_field == r.MAGNETIC) {
    build_ff_magnetic(resolution, canvas_pos, canvas);
    if(force_field.get_spot_num() < 1) printErr("void build_force_field() There is no spot added for your force Field, this force field need one to work") ;
  } else if (type_force_field == r.FLUID) {
    build_ff_fluid(resolution, canvas_pos, canvas);
    // default fluid value
    freq_ff = 2/frameRate;
    visc_ff = .001;;
    diff_ff = 1.;
    
    if(force_field.get_spot_num() < 1) printErr("void build_force_field() There is no spot added for your force Field, this force field need one to work") ;
  } else {
    build_ff_classic(type_force_field, resolution, canvas_pos, canvas);
  }
  set_cell_grid_ff(resolution);
}
/**
Different mode to build force field
v 0.0.2
*/
/**
* build classic
*/
void build_ff_classic(int type_force_field, int resolution, iVec2 canvas_pos, iVec2 canvas) {
  force_field = new Force_field(resolution, canvas_pos, canvas, type_force_field);
  force_field_init_is = true ;
}
/**
* buid force field FLUID
*/
void build_ff_fluid(int resolution, iVec2 canvas_pos, iVec2 canvas) {
  force_field = new Force_field(resolution, canvas_pos, canvas, r.FLUID);
  force_field_init_is = true ;
  
}
/**
* build force field image source to generate the vector field
*/
void build_ff_img(PImage img) {
  int resolution = 20 ;
  iVec2 canvas_pos = iVec2() ;
  force_field = new Force_field(resolution, canvas_pos, img, r.BLUE);
  force_field_init_is = true ;
}
/**
* build force field gravity
*/
void build_ff_gravity(int resolution, iVec2 canvas_pos, iVec2 canvas) {
  force_field = new Force_field(resolution, canvas_pos, canvas, r.GRAVITY);
  force_field_init_is = true ;
}
/**
* build force field magnetic
*/
void build_ff_magnetic(int resolution, iVec2 canvas_pos, iVec2 canvas) {
  force_field = new Force_field(resolution, canvas_pos, canvas, r.MAGNETIC);
  force_field_init_is = true ;
}














/**
UPDATE
v 0.1.0
*/
void update_ff() {
  /**
  WHAT IS IT force_field.reverse_is(true) ??????

  */
  /*
  if(keyPressed) {
    if(key == ' ') force_field.reverse_is(true);
  }
  */
  

  // update spot if there is no coord in the list
  if(spot_list_coord == null) {
    update_spot_ff_coord(Vec2(width/2,height/2));
  }
  if(spot_list_is == null) { 
    update_spot_ff_is(true);
  }




  if(force_field != null) {
    if(force_field.get_type() == r.FLUID) {
      update_ff_fluid();
    } else if(force_field.get_type() == r.GRAVITY) {
      update_ff_gravity();
    } else if(force_field.get_type() == r.MAGNETIC) {
      update_ff_magnetic();
    } else {
      update_ff_classic() ;
    }
  } else {
    printErrTempo(240, "the force field is not init, maybe the media is not loaded ?");
  }

  
}
/**
CLASSIC FIELD, like CHAOS, PERLIN
*/
void update_ff_classic() {
  force_field.update();
/*
  float angle = map(mouseY, 0,height, -PI, PI) ;
  float force = map(mouseX, 0,width, 0, 4) ;
  force_field.wind(angle,force);
  */
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
  force_field.update();
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
  force_field.update();
}












/**
GRAVITY CASE
*/
void update_ff_gravity() {
  force_field.set_calm(.5);

  for(int i = 0 ; i < force_field.spot_list.size() && i < spot_list_coord.size() ; i++) {
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
  force_field.update();
}





/**
update value
*/
void update_value_ff_fluid(float freq_norm, float visc_norm, float diff_norm) {
  freq_ff = freq_norm *.05 ;
  visc_ff = visc_norm *visc_norm *visc_norm *visc_norm;
  diff_ff = diff_norm;
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

int get_type_ff() {
  if(force_field != null ) {
    return force_field.get_type();
  } else return -1;
}

int get_resultion_ff() {
  if(force_field != null ) {
    return force_field.get_resolution();
  } else return -1;
}

int get_spot_num_ff() {
  if(force_field != null) {
    return force_field.get_spot_num();
  } else return -1;
}