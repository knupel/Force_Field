void show_other() {
	if(get_renderer() == P3D) {
		cloud_3D_orientation_angle_behavior_costume();
	} else {
	  printErrTempo(60,"This method exist only in P3D renderer");
	}
}


Cloud_3D cloud_3D ;
void cloud_3D_orientation_angle_behavior_costume() {
  int num = 200 ;
  if(cloud_3D == null) cloud_3D = new Cloud_3D(num, P3D, r.ORDER, r.POLAR);
  // if(mousePressed) p.polar(true) ; else p.polar(false);
  float red_val = abs ( sin(frameCount *.01) *50) ;
  cloud_3D.aspect(Vec4(red_val,100,100,15), Vec4(0), .1) ;

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

  cloud_3D.size(width *abs(sin(frameCount *.01)));
  // cloud_3D.orientation_y(map(mouseY,0,height,-PI,PI)) ;
  // cloud_3D.angle(frameCount *.01);
  cloud_3D.beat(8);
  //cloud_3D.behavior("SIN");
  //cloud_3D.behavior("SIN_TAN_POW_SIN");
  // cloud_3D.behavior("POW_SIN_PI");
  cloud_3D.behavior("SIN_POW_SIN");

  int radius = int(height *.66);
  Vec3 pos = Vec3(width/2, height/2,0);
  cloud_3D.radius(radius);
  cloud_3D.pos(pos);
  cloud_3D.update();

  cloud_3D.costume(PENTAGON_ROPE) ;
  cloud_3D.show() ;
}