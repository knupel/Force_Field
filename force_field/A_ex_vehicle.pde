/**
Vehicule example
v 0.0.3.2
*/
ArrayList<Vehicle> vehicles;

void build_vehicle(int num) {
  if(vehicles == null) vehicles = new ArrayList<Vehicle>();
  int w = force_field.get_canvas().x ;
  int h = force_field.get_canvas().y ;
  float max_speed = 1. ;
  float max_force = 1. ;
  // Make a whole bunch of vehicles with random maxspeed and maxforce values
  for (int i = 0; i < num; i++) {
    // float max_speed = random(2, 10);
    // float max_force = random(0.1, 0.5);


    Vec2 pos = Vec2(r.RANDOM_ZERO, w, h);
    vehicles.add(new Vehicle(pos, max_speed, max_force));
  }

}





void reset_vehicle() {
  if(vehicles != null) {
    int num = vehicles.size();
    vehicles.clear();
    build_vehicle(num);
  }
}




boolean manage_border_is;

void manage_border() {
  manage_border_is = (manage_border_is == true) ? false:true;

}

void update_vehicle(Force_field ff) {
  for (Vehicle v : vehicles) {
    v.update(ff);
    v.follow();   
    v.swap();
    v.manage_border(manage_border_is);
  }
}

void show_vehicle() {
  int c = color(255,0,0) ;
  for (Vehicle v : vehicles) {
    Vec2 temp_pos = v.get_position().copy();
    set(temp_pos, c);
  }
}





void display_vehicle(Vehicle v) {
  // Draw a triangle rotated in the direction of velocity
  float theta = v.get_direction() + radians(90);
  v.set_radius(10.);
  float r = v.radius ;
  fill(255,0,0);
  strokeWeight(1);
  stroke(255);

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