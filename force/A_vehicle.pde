/**
Vehicule example
v 0.1.0
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




void show_vehicle(Vec3 colour_rgb, float alpha) {
  Vec3 temp = map_vec(colour_rgb,0,1,0,g.colorModeX);
  int c = color(temp.x,temp.y,temp.z,alpha);
  // 

  if(vehicle_pixel_is()) {
    display_vehicle_pixel_on_PGraphics(c);
  } else {
    int max_vehicles = 10_000;
    display_vehicle_with_shape(c, max_vehicles);
  }
}



// local display method
// Pixel method
PGraphics pg_vehicles ;
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
void display_vehicle_with_shape(int c, int max) {
  float size = 3;
  float thickness = 1 ;
  if(vehicles.size() > max) {
    for(int i = 0 ; i < max ; i++) {
      Vehicle v = vehicles.get(i);
      display_vehicle_triangle(v, c, c, thickness,size) ;
    }
  } else {
    for (Vehicle v : vehicles) {
      display_vehicle_triangle(v, c, c, thickness,size) ;
    }
  }     
}

void display_vehicle_triangle(Vehicle v, int fill, int stroke, float thickness, float size) {
  // Draw a triangle rotated in the direction of velocity
  float theta = v.get_direction() + radians(90);
  v.set_radius(size);
  float r = v.radius ;
  aspect_rope(fill,stroke,thickness);
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




