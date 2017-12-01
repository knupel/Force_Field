/**
Example
force field 
v 0.0.3
*/
Force_field force_field;

/**

BUILD
v 0.0.4
*/

/**
type_force_field CHAOS, PERLIN or FLUID
*/
/**
* classic build
*/
void build_force_field(int type, int resolution) {
  build_force_field(type, resolution, null);
}

void build_force_field(int type, int resolution, PImage src) {
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

  if(type == r.GRAVITY) {
    build_force_field_hole(resolution, canvas_pos, canvas);  
  } else if (type == r.MAGNETIC) {
    build_force_field_magnetic(resolution, canvas_pos, canvas);
  } else if (type == r.FLUID) {
    build_force_field_fluid(resolution, canvas_pos, canvas);
  } else {
    build_force_field_classic(type, resolution, canvas_pos, canvas);
  }
}




/**
Diffent mode to build force field
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
  force_field.add_spot(1);
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
void build_force_field_hole(int resolution, iVec2 canvas_pos, iVec2 canvas) {
  force_field = new Force_field(resolution, canvas_pos, canvas, r.GRAVITY);
  force_field.add_spot(3);
}
/**
* build force field magnetic
*/
void build_force_field_magnetic(int resolution, iVec2 canvas_pos, iVec2 canvas) {
  force_field = new Force_field(resolution, canvas_pos, canvas, r.MAGNETIC);
  force_field.add_spot(2);
}











/**
UPDATE
v 0.0.3
*/
void update_force_field() {
  if(keyPressed) {
    if(key == ' ') force_field.reverse_is(true);
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
  Vec2 target = Vec2(mouseX,mouseY);

  force_field.set_frequence(2/frameRate);
  force_field.set_viscosity(.001); // back to normal
  force_field.set_diffusion(1.);
  
  /*
  if(target.y < 0 || target.y > width) {
    if(target.x < 0) {
      target.x = 0 ;
      target.y = 0 ;
    }
    if(target.x > width) {
      target.x = width;
      target.y = width;
      println(target.x, target.y);
    }
  }
  */

  if(mousePressed) {
    force_field.set_spot_pos(target);
  } else {
    force_field.ref_spot();
    force_field.set_spot_pos(target);
  }

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

RESET

*/
/*
void reset_force_field() {
  force_field.reset() ;
}
*/






























