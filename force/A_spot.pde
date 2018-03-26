/**
SPOT
v 0.0.1
*/
/**
Spot display
v 0.0.2
*/
void show_spot() {
  show_spot(true);
}




void show_spot(boolean shape_is) {
  for(int i = 0 ; i < force_field.get_spot_num() ; i++) {
    if(shape_is) {
      spot_shape(force_field.get_spot_pos(i), get_rgb_spot(),get_alpha_spot());
    } else {
      point(force_field.get_spot_pos(i));
    }
  }
}


ROPE_svg shape_spot; 
void spot_shape(Vec2 pos, Vec3 fill, float alpha) {
  if(shape_spot == null) {
    shape_spot = new ROPE_svg(this, sketchPath(1)+"/import/corbeau.svg");
    shape_spot.build();
  }
  shape_spot.fill(get_rgb_spot().x,get_rgb_spot().y,get_rgb_spot().z,get_alpha_spot());
  shape_spot.noStroke();
  shape_spot.scaling(get_size_spot() *.01);
  shape_spot.mode(CENTER);
  shape_spot.pos(pos);
  shape_spot.draw() ; 
}




/**
spot coord
v 0.2.1
*/
float distance ;
iVec2 ref_lead_pos ;

void force_field_spot_coord(iVec2 lead_pos, boolean is, boolean keep_structure) {
  if(ref_lead_pos == null) {
    ref_lead_pos = iVec2(width/2,height/2);
  }
  // case 1 : one spot
  if(get_spot_num_ff() > 0) {
    Vec2 [] pos = new Vec2[get_spot_num_ff()];
    // case 1
    if(get_spot_num_ff() == 1) {
      if(is) {
        pos[0] = Vec2(lead_pos.x, lead_pos.y);
        ref_lead_pos.set(lead_pos);
      } else {
        pos[0] = Vec2(ref_lead_pos);
      }
    }
    // case 2 : Two spot
    if(get_spot_num_ff() == 2) {
      if(is) {
        pos[0] = Vec2(lead_pos.x, lead_pos.y);
        pos[1] = Vec2(width -lead_pos.x, height -lead_pos.y);
        ref_lead_pos.set(lead_pos);
      } else {
        pos[0] = Vec2(ref_lead_pos.x, ref_lead_pos.y);
        pos[1] = Vec2(width -ref_lead_pos.x, height -ref_lead_pos.y);
      }
      
    }
    // case 3: cloud spot
    if(get_spot_num_ff() > 2) {
    	multi_coord_cloud(pos,lead_pos,is,keep_structure);
    }
    // finalize
    update_spot_ff_coord(pos);
  }
}


Cloud_2D cloud_2D;
Vec2 ref_pos ;
boolean reset_cloud_coord = true;
int num_multi_coord ;
float angle_step_ref;
int time_count_spot;
float ref_sum_spot_param ;
float ref_growth_spot ;
void multi_coord_cloud(Vec2 [] pos, iVec2 lead_pos, boolean is, boolean keep_structure) {
  // reset cloud
	if(num_multi_coord != pos.length) {
		num_multi_coord = pos.length;
		reset_cloud_coord = true;
	}
  if(!keep_structure && get_distribution_spot() != angle_step_ref) {
    angle_step_ref = get_distribution_spot();
    reset_cloud_coord = true;
  }
  if(cloud_2D == null || reset_cloud_coord) {
    cloud_2D = new Cloud_2D(num_multi_coord,r.ORDER,angle_step_ref);
    reset_cloud_coord = false;
  }
  




  // check gui
  boolean gui_param_spot_is = false ;
  float sum_param = sum_spot_param();
  if(ref_sum_spot_param != sum_param){
    gui_param_spot_is = true;
    ref_sum_spot_param = sum_param;
  }

	if(is) {
    if(ref_pos == null) {
      ref_pos = Vec2(lead_pos.x,lead_pos.y);
    } else {
      ref_pos.set(lead_pos.x,lead_pos.y);
    }
  }

  if(gui_param_spot_is || !keep_structure) {
    float speed = get_speed_spot();
    cloud_2D.rotation(speed,false);
    if(get_spiral_spot()>0) cloud_2D.spiral(get_spiral_spot());
    cloud_2D.range(get_min_radius_spot(), get_max_radius_spot());

    if(get_motion_spot() > 0) {
      cloud_2D.growth(get_motion_spot());
    }
    ref_growth_spot = cloud_2D.get_growth();
    
    time_count_spot++;
    cloud_2D.time_count(time_count_spot);
    cloud_2D.beat(get_beat_spot());
    cloud_2D.behavior("SIN");
    cloud_2D.radius(get_radius_spot());
  }

  if(keep_structure){
    cloud_2D.growth_size(ref_growth_spot);
  }

	cloud_2D.update(ref_pos);

	Vec3 [] temp = cloud_2D.list();
	for(int i = 0 ; i <pos.length ; i++) {
		pos[i] = Vec2(temp[i].x,temp[i].y);
	}
}

float sum_spot_param() {
  return get_distribution_spot() 
         +get_speed_spot() 
         +get_motion_spot() 
         +get_beat_spot() 
         +get_spiral_spot() 
         +get_radius_spot()
         +get_min_radius_spot()
         +get_max_radius_spot() ;
}



/*
    growth system
    final_angle += step_angle ; 
    final_angle += distance;
    Vec2 proj = projection(final_angle, get_radius_mouse());
*/










void force_field_spot_condition(boolean is) {
  if(get_spot_num_ff() > 0) {
    boolean [] bool = new boolean[get_spot_num_ff()];
    for(int i = 0 ; i < bool.length ; i++) {
      bool[i] = false ;
    }
    // if(mousePressed && mouseButton == LEFT) bool_1 = true ;
    // if(mousePressed && mouseButton == RIGHT) bool_2 = true ;
    if(is) {
      for(int i = 0 ; i < bool.length ; i++) {
        bool[i] = true ;
      }
    }
    update_spot_ff_is(bool);
  }
}


void force_field_spot_diam() {
  int diam_spot = get_resolution_ff()/2 ;
  if(get_spot_num_ff() > 0) {
    int [] diam = new int[get_spot_num_ff()];
    for(int i = 0 ; i < diam.length ; i++) {
      diam[i] = diam_spot ; 
    }
    update_spot_ff_diam(diam);
  }
}

void force_field_spot_tesla() {
  int charge_tesla = 10 ;
  if(get_spot_num_ff() > 0) {
    int [] tsl = new int[get_spot_num_ff()];
    for(int i = 0 ; i < tsl.length ; i++) {
      if(i%2 == 0) tsl[i] = charge_tesla ; else tsl[i] = -charge_tesla;
    }
    update_spot_ff_tesla(tsl);
  }
}

void force_field_spot_mass() {
  int mass = 10 ;
  if(get_spot_num_ff() > 0) {
    int [] m = new int[get_spot_num_ff()];
    for(int i = 0 ; i < m.length ; i++) {
      if(i%2 == 0) m[i] = mass ; else m[i] = mass *3;
    }
    update_spot_ff_mass(m);
  }
}
















/**
coord leapmotion
v 0.2.1
*/
Vec2 [] pos_finger ;
void force_field_spot_coord_leapmotion() {
  // init var
  boolean init_finger = false ;
  if(pos_finger == null || pos_finger.length != get_spot_num_ff()) init_finger = true ;
  if(init_finger  && get_spot_num_ff() > 0) {
    pos_finger = new Vec2[get_spot_num_ff()];
    for(int i = 0 ; i < pos_finger.length ; i++) {
      pos_finger[i] = Vec2(width/2,height/2);
    }
  }

  if(finger.is() && pos_finger != null) {
    /*
    for(int i = 0 ; i < get_spot_num_ff() ; i++) {
      if(finger.visible()[i]) {
        float x = finger.get_pos()[i].x;
        float y = finger.get_pos()[i].y;
        y = map(y,0,1,1,0);
        pos_finger[i] = Vec2(x,y);
        pos_finger[i].mult(width,height);
      } else {
        // pos_finger[i] = Vec2(-width,-height);
      }
    }
    */
    for(int i = 0 ; i < finger.get_num() && i < get_spot_num_ff() && i < pos_finger.length; i++) {
      if(finger.visible()[i]) {
        float x = finger.get_pos()[i].x;
        float y = finger.get_pos()[i].y;
        y = map(y,0,1,1,0);
        pos_finger[i] = Vec2(x,y);
        pos_finger[i].mult(width,height);
      }
    }
    
    update_spot_ff_coord(pos_finger);
  }
}


void force_field_spot_condition_leapmotion() {
  if(get_spot_num_ff() > 0) {
    boolean [] bool = new boolean[get_spot_num_ff()];
    for(int i = 0 ; i < bool.length ; i++) {
      bool[i] = false ;
    }
    if(finger.is()) {
      for(int i = 0 ; i < finger.get_num() && i < get_spot_num_ff() ; i++) {
        if(finger.visible()[i]) bool[i] = true ; else bool[i] = false ;
      }
    }
    update_spot_ff_is(bool);
  }
}

