void show_other() {
	if(get_renderer() == P3D) {
    // fill(r.BLOOD, 10);
    noFill();
    strokeWeight(1);
    stroke(r.BLOOD,100);
		cloud_3D_orientation_angle_behavior_costume();
	} else {
	  printErrTempo(60,"This method exist only in P3D renderer");
	}
}


Cloud_3D cloud_3D ;
void cloud_3D_orientation_angle_behavior_costume() {
  int num = 200 ;
  if(cloud_3D == null) cloud_3D = new Cloud_3D(this,num, P3D, r.ORDER, r.POLAR);
  // if(mousePressed) p.polar(true) ; else p.polar(false);
  // float red_val = abs ( sin(frameCount *.01) *50) ;
  // cloud_3D.aspect(r.ORANGE, vec4(0)) ;

  if(mousePressed) {
    cloud_3D.rotation_x(map(mouseX, 0,width, -PI, PI), true);
    cloud_3D.rotation_z(map(mouseY, 0,height, -PI, PI), true);
  } else {
    cloud_3D.rotation_y(.01, false);
    cloud_3D.rotation_z(.005, false);
  }

  // cloud_3D.rotation_fx_x(.005, false); // not interesting
  cloud_3D.ring(.01, false);
  // cloud_3D.helmet(.005, false);

  cloud_3D.size((height/4) *abs(sin(frameCount *.01)));
  // cloud_3D.orientation_y(map(mouseY,0,height,-PI,PI)) ;
  // cloud_3D.angle(frameCount *.01);
  // cloud_3D.set_transient(8);
  //cloud_3D.behavior("SIN");
  //cloud_3D.behavior("SIN_TAN_POW_SIN");
  // cloud_3D.behavior("POW_SIN_PI");
  cloud_3D.set_behavior("SIN_POW_SIN");

  int radius = height;
  vec3 pos = vec3(width/2, height/2,-(height/2));
  cloud_3D.set_radius(radius);
  cloud_3D.pos(pos);
  cloud_3D.update();

  cloud_3D.costume(PENTAGON_ROPE) ;
  cloud_3D.show() ;
}