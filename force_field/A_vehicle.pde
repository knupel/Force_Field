/**
Vehicule example
v 0.1.0
*/
ArrayList<Vehicle> vehicles;
int n_ve ;
float vel_ve ;
float fo_ve ;
void set_vehicle(int num, float velocity, float force) {
  n_ve = num;
  vel_ve = velocity;
  fo_ve = force;
}


boolean vehicle_is = false ;
void init_vehicle(Force_field ff) {
  if(ff != null && !vehicle_is) {
    build_vehicle(n_ve,ff,vel_ve,fo_ve);
    vehicle_is = true ;
  } 
}




void build_vehicle(int num, Force_field ff, float velocity, float force) {
  if(vehicles == null) vehicles = new ArrayList<Vehicle>();
  int w = ff.get_canvas().x ;
  int h = ff.get_canvas().y ;
  float max_speed = velocity;
  float max_force = force ;
  // Make a whole bunch of vehicles with random maxspeed and maxforce values
  for (int i = 0; i < num; i++) {
    // float max_speed = random(2, 10);
    // float max_force = random(0.1, 0.5);
    Vec2 pos = Vec2(r.RANDOM_ZERO, w, h);
    vehicles.add(new Vehicle(pos, max_speed, max_force));
  }
}





void reset_vehicle(int num, Force_field ff, float velocity, float force) {
  if(vehicles != null) {
    vehicles.clear();
    build_vehicle(num, ff,velocity,force);
  }
}




boolean manage_border_is;

void manage_border() {
  manage_border_is = (manage_border_is == true) ? false:true;

}

void update_vehicle(Force_field ff) {
  if(ff != null) {
    for (Vehicle v : vehicles) {
      v.update(ff);
      v.follow();   
      v.swap();
      v.manage_border(manage_border_is);
    }
  }
}

void show_vehicle(Vec3 colour_rgb, float alpha) {
  Vec3 temp = map_vec(colour_rgb,0,1,0,g.colorModeX);
  int c = color(temp.x,temp.y,temp.z,alpha) ;
  for (Vehicle v : vehicles) {
    display_vehicle_pix(v, c);  
    // display_vehicle_triangle(v, c,c,1) ;
  }
}


/*
*local display method
*/
void display_vehicle_pix(Vehicle v, int c) {
  set(v.get_position(), c);
}




void display_vehicle_triangle(Vehicle v, int fill, int stroke, float thickness) {
  // Draw a triangle rotated in the direction of velocity
  float theta = v.get_direction() + radians(90);
  v.set_radius(10.);
  float r = v.radius ;
  fill(fill);
  strokeWeight(thickness);
  stroke(stroke);

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