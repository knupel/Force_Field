/**
Example
force field 
v 0.1.0
*/
Force_field force_field;

/**
init
*/
boolean force_field_init_is ;
void init_force_field(int type, int resolution, PImage src) {
  if(!force_field_init_is) {
    build_force_field(type, resolution, src);
    force_field_init_is = true ;
  }
}






/**
BUILD
v 0.0.5
*/
/** 
add spot
* it's use for force field GRAVITY, MAGNETIC and FLUID
*/
void num_spot_force_field(int num) {
  if(force_field != null && num > force_field.get_spot_num() ) {
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
void build_force_field(int type_force_field, int resolution) {
  build_force_field(type_force_field, resolution, null);
}

void build_force_field(int type_force_field, int resolution, PImage src) {
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
    build_force_field_gravity(resolution, canvas_pos, canvas);
    if(force_field.get_spot_num() < 1) printErr("void build_force_field() There is no spot added for your force Field, this force field need one to work") ;  
  } else if (type_force_field == r.MAGNETIC) {
    build_force_field_magnetic(resolution, canvas_pos, canvas);
    if(force_field.get_spot_num() < 1) printErr("void build_force_field() There is no spot added for your force Field, this force field need one to work") ;
  } else if (type_force_field == r.FLUID) {
    build_force_field_fluid(resolution, canvas_pos, canvas);
    if(force_field.get_spot_num() < 1) printErr("void build_force_field() There is no spot added for your force Field, this force field need one to work") ;
  } else {
    build_force_field_classic(type_force_field, resolution, canvas_pos, canvas);
  }
}
/**
Different mode to build force field
v 0.0.2
*/
/**
* build classic
*/
void build_force_field_classic(int type_force_field, int resolution, iVec2 canvas_pos, iVec2 canvas) {
  force_field = new Force_field(resolution, canvas_pos, canvas, type_force_field);
}
/**
* buid force field FLUID
*/
void build_force_field_fluid(int resolution, iVec2 canvas_pos, iVec2 canvas) {
  force_field = new Force_field(resolution, canvas_pos, canvas, r.FLUID);
  
}
/**
* build force field image source to generate the vector field
*/
void build_force_field_img(PImage img) {
  int resolution = 20 ;
  iVec2 canvas_pos = iVec2() ;
  force_field = new Force_field(resolution, canvas_pos, img, r.BLUE);
}
/**
* build force field gravity
*/
void build_force_field_gravity(int resolution, iVec2 canvas_pos, iVec2 canvas) {
  force_field = new Force_field(resolution, canvas_pos, canvas, r.GRAVITY);
}
/**
* build force field magnetic
*/
void build_force_field_magnetic(int resolution, iVec2 canvas_pos, iVec2 canvas) {
  force_field = new Force_field(resolution, canvas_pos, canvas, r.MAGNETIC);
}











/**
UPDATE
v 0.1.0
*/
/**
spot manager
position 
condition 
tesla
size
*/
ArrayList<Vec2> spot_list_coord;
void update_force_field_spot_coord(Vec2... spot_xy) {
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
        spot_list_coord.get(i).set(spot_xy[i]);
      }
    }
  }
}


ArrayList<Boolean> spot_list_is;
void update_force_field_spot_is(boolean... spot_is) {
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
void update_force_field_spot_tesla(int... tesla) {
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

ArrayList<Integer> spot_list_radius;
void update_force_field_spot_radius(int... radius) {
  if(spot_list_radius == null) {
    spot_list_radius = new ArrayList<Integer>();
    for(int i = 0 ; i < radius.length ; i++) {
      int rad = radius[i] ;
      spot_list_radius.add(rad);
    }
  } else {
    if(spot_list_radius.size() < radius.length) {
      for(int i = radius.length - spot_list_radius.size() ; i < radius.length ; i++) {
        int rad = radius[i] ;
        spot_list_radius.add(rad);
      }
    } else {
      for(int i = 0 ; i < radius.length ; i++) {
        spot_list_radius.set(i,radius[i]);
      }
    }
  }
}


ArrayList<Integer> spot_list_mass;
void update_force_field_spot_mass(int... mass) {
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








void update_force_field() {
  /**
  WHAT IS IT ??????

  */
  if(keyPressed) {
    if(key == ' ') force_field.reverse_is(true);
  }
  
  // update spot if there is no coord in the list
  if(spot_list_coord == null) {
    update_force_field_spot_coord(Vec2(width/2,height/2));
  }
  if(spot_list_is == null) { 
    update_force_field_spot_is(true);
  }




  if(force_field != null) {
    if(force_field.get_type() == r.FLUID) {
      update_ff_fluid();
    } else if(force_field.get_type() == r.GRAVITY) {
      update_ff_gravity();
    } else if(force_field.get_type() == r.MAGNETIC) {
      update_ff_magnetic();
    } else {
      update_field() ;
    }
  } else {
    printErrTempo(180, "the force field is not init, maybe the media is not loaded ?");
  }

  
}
/**
CLASSIC FIELD, like CHAOS, PERLIN
*/
void update_field() {
  force_field.update();

  float angle = map(mouseY, 0,height, -PI, PI) ;
  float force = map(mouseX, 0,width, 0, 4) ;
  force_field.wind(angle,force);
}






/**
FLUID CASE
*/
void update_ff_fluid() {

  force_field.set_frequence(2/frameRate);
  force_field.set_viscosity(.001); // back to normal
  force_field.set_diffusion(1.);
  
  for(int i = 0 ; i < force_field.spot_list.size() && i < spot_list_coord.size() ; i++) {
    if(i < spot_list_is.size()) {
      if(spot_list_is.get(i)) {
        force_field.set_spot_pos(spot_list_coord.get(i),i);
      } else {
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
Vec2 pole_pos_A, pole_pos_B ;
void update_ff_magnetic() {
  if(pole_pos_A == null) pole_pos_A = Vec2(random(width),random(height));
  if(pole_pos_B == null) pole_pos_B = Vec2(random(width),random(height));
  // Vec2 target = Vec2(mouseX,mouseY);
  
  if(mousePressed && mouseButton == LEFT) pole_pos_A.set(mouseX,mouseY);
  if(mousePressed && mouseButton == RIGHT) pole_pos_B.set(mouseX,mouseY);
   
  /*
  Vec2 pole_pos_A = Vec2(width/2,height/3);
  Vec2 pole_pos_B = Vec2(width/2,height -(height/3));
  */

  int max = force_field.get_resolution() /2;
  Vec2 size = Vec2(max);

 
  // int charge = (int)abs((sin(frameCount *.0001)*MAX_INT));
  int charge = 10;
  force_field.set_spot_tesla(charge,0);
  force_field.set_spot_tesla(-charge,1);
   
  force_field.set_spot_size(size,0);
  force_field.set_spot_size(size,1);

  force_field.set_spot_pos(pole_pos_A,0);
  force_field.set_spot_pos(pole_pos_B,1);

  // force_field.change_dir() ;
  force_field.update();

}












/**
GRAVITY CASE
*/
Vec2 pole_pos_C ;
void update_ff_gravity() {
  Vec2 target = Vec2(mouseX,mouseY);
  Vec2 pole_pos_A = target.copy();

  // pos B revolution around the center canvas
  float x = sin(frameCount *.001) *height/2 ;
  float y = cos(frameCount *.001) *height/2 ;
  Vec2 pole_pos_B = Vec2(x,y).add(width/2,height/2);

  // randomize position of the third pole
  if(pole_pos_C == null) pole_pos_C = Vec2(r.RANDOM_ZERO,width,height);
  int when = (int)random(20,1600) ;
  if(frameCount%when == 0) {
    pole_pos_C.set(Vec2(r.RANDOM_ZERO,width,height));
  }

  /*
  Vec2 pole_pos_A = Vec2(width/2,height/3);
  Vec2 pole_pos_B = Vec2(width/2,height -(height/3));
  */

  /*
  int min = 2 ;
  int max = force_field.get_resolution();
  float s_x = random(min,max);
  float s_y = random(min,max);
  Vec2 size = Vec2(s_x,s_y);
  */

  Vec2 size = Vec2(10);

  force_field.set_calm(.5);

  force_field.set_spot_pos(pole_pos_A, 0) ;
  force_field.set_spot_pos(pole_pos_B, 1) ;
  force_field.set_spot_pos(pole_pos_C, 2) ;

  force_field.set_spot_size(size, 0);
  force_field.set_spot_size(size, 1);
  force_field.set_spot_size(size, 2);
   
  // int diam = abs(int(height *sin(frameCount *.001)))/2;
  int mass_1 = 50 ;
  int mass_2 = 10 ;
  int mass_3 = 200;
  force_field.set_spot_mass(mass_1, 0);
  force_field.set_spot_mass(mass_2, 1);
  force_field.set_spot_mass(mass_3, 2);

  force_field.update() ;
}








/**

RESET

*/
/*
void reset_force_field() {
  force_field.reset() ;
}
*/






























