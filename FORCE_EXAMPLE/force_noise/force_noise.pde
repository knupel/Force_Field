/**
* Force Noise
* v 0.0.2
* Copyleft (c) 2019-2019
* @author @stanlepunk
* @see https://github.com/StanLepunK/Force_Field
* Processing 3.5.3
* Rope library 0.8.1.26
*/

/**
* see other example of flow field from Daniel Shiffmann
* Exercise_6_07_FlowField3DNoise from Nature of Code example
*/ 
Force_field field;
Vehicle vehicle;

void setup() {
	size(500,500,P2D);
	// field
	int type = r.STATIC;
	int pattern = r.PERLIN;
	field = new Force_field(10,type,pattern);
	println("cols",field.get_cols());
	println("rows",field.get_rows());
	println("resolution",field.get_resolution());
	println("field", field.get_field()[0][0]);
	//vehicle
	float x = random(width);
	float y = random(height);
	vec2 pos = vec2(x,y);
	float max_speed = 10;
	float max_force = 10;

	vehicle = new Vehicle(pos,max_speed,max_force);
}

void draw() {
	background(0);
	show_field();
	show_vehicle();
}


void show_vehicle() {
	vehicle.update(field);
	vehicle.follow();
	vehicle.swap();
	fill(r.BLOOD);
	noStroke();
	ellipse(vehicle.get_position(),vec2(20));
}


void show_field() {
	stroke(255);
	strokeWeight(1);

	if(mousePressed) {
		field.set_field(r.PERLIN);
	}

	float scale = field.get_resolution();
	vec2 offset = vec2(field.get_resolution()).div(2);
	for(int x = 0 ; x < field.get_cols() ; x++) {
		for(int y = 0 ; y < field.get_rows() ; y++) {
			vec2 dir = vec2(field.get_field()[x][y].x(),field.get_field()[x][y].y());
			float mag = field.get_field()[x][y].w();
			float len = mag *scale;
			vec2 pos = vec2(x,y).mult(field.get_resolution());

      push();
      translate(pos.add(offset));
      rotate(dir.angle());
			line(0,0,len,0);
			pop();
		}
	}
}




