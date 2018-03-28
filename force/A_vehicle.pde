/**
Vehicule example
v 0.2.0
*/
ArrayList<Vehicle> vehicles;
int n_ve ;
void set_vehicle(int num) {
  n_ve = num;
}


boolean vehicle_is = false ;
void init_vehicle(Force_field ff) {
  if(ff != null && !vehicle_is) {
    build_vehicle(n_ve,ff);
    vehicle_is = true ;
  } 
}




void build_vehicle(int num, Force_field ff) {
  if(vehicles == null) vehicles = new ArrayList<Vehicle>();
  int w = ff.get_canvas().x ;
  int h = ff.get_canvas().y ;
      Vec2 range_speed = Vec2(1., 2.);
    Vec2 range_force = Vec2(.2, 1.);

  for (int i = 0; i < num; i++) {
    float max_speed = +range_speed.x + random_next_gaussian(range_speed.y, 3) ;
    float max_force = +range_force.x + random_next_gaussian(range_force.y, 3) ;
    Vec2 pos = Vec2(r.RANDOM_ZERO, w, h);
    vehicles.add(new Vehicle(pos, max_speed, max_force));
  }
}





void reset_vehicle(int num, Force_field ff) {
  if(vehicles != null) {
    vehicles.clear();
    build_vehicle(num, ff);
  }
}




boolean manage_border_is;
void manage_border() {
  manage_border_is = (manage_border_is == true) ? false:true;
}

void update_vehicle(Force_field ff, float speed) {
  if(ff != null) {
    for (Vehicle v : vehicles) {
      v.mult_speed(speed);
      v.update(ff);
      v.follow();   
      v.swap();
      v.manage_border(manage_border_is);
    }
  }
}




void show_vehicle(Vec3 colour, float alpha) {
  int c = color(colour.x,colour.y,colour.z,alpha);
  int shape_type = 0 ;
  if(get_type_vehicle() == r.PIXEL) {
    display_vehicle_pixel_on_PGraphics(c);
  } else if(get_type_vehicle() != r.PIXEL){
    int size = ceil(get_size_vehicle());
    display_vehicle_with_shape(c, size, get_type_vehicle());
  }
}



// local display method
// Pixel method
PGraphics pg_vehicles;
void display_vehicle_pixel_on_PGraphics(int c) {
  if(pg_vehicles == null || pg_vehicles.width != width || pg_vehicles.height != height) {
    pg_vehicles = createGraphics(width,height,P2D);
  } 
  if(pg_vehicles != null) {
    pg_vehicles.beginDraw();
    pg_vehicles.clear();
    for (Vehicle v : vehicles) {
      vehicle_set(pg_vehicles,v, c);  
    }
    pg_vehicles.endDraw();
    image(pg_vehicles);
  }
}

void vehicle_set(PGraphics pg, Vehicle v, int c) {
  int x = (int)v.get_position().x ;
  int y = (int)v.get_position().y;
  if(x < pg.width && y < pg.height) {
     pg.set(x,y,c);
  }
}






// shape method
void display_vehicle_with_shape(int c, int size, int type) {
  float thickness = 1 ;
  for (Vehicle v : vehicles) {
    if(type == POINT) display_vehicle_point(v,c,c,thickness,size);
    else if(type == TRIANGLE) display_vehicle_triangle(v,c,size);
    else if(type == SHAPE) {
      display_vehicle_custom_shape(v,c,size);
    }
  }  
}


// triangle
void display_vehicle_triangle(Vehicle v, int c, float size) {
  // Draw a triangle rotated in the direction of velocity
  float theta = v.get_direction() + radians(90);
  v.set_radius(size);
  float r = v.radius ;
  fill(c);
  noStroke();
  pushMatrix();
  translate(v.get_position());
  rotate(theta);
  beginShape(TRIANGLES);
  vertex(0, -r *2);
  vertex(-r, r *2);
  vertex(r, r *2);
  endShape();
  popMatrix();
}


// triangle
void display_vehicle_point(Vehicle v, int fill, int stroke, float thickness, float size) {
  aspect_rope(fill,stroke,size);
  point(v.get_position());
}

// custom shape
void display_vehicle_custom_shape(Vehicle v, int c, float size) {
  shape_vehicle.fill(c);
  shape_vehicle.noStroke();
  shape_vehicle.scaling(size);
  shape_vehicle.mode(CENTER);
  shape_vehicle.pos(v.get_position());
  shape_vehicle.draw() ; 
}





ROPE_svg shape_vehicle; 
void set_vehicle_shape(String path) {
  if(shape_vehicle == null) {
    shape_vehicle = new ROPE_svg(this,path);
    shape_vehicle.build();
  }
}



