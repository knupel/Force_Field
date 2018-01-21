/**
spot coord
v 0.2.0
*/
float distance ;

void force_field_spot_coord(iVec2 lead_pos, boolean is) {
  if(get_spot_num_ff() > 0) {
    Vec2 [] pos = new Vec2[get_spot_num_ff()];
    // case 1
    if(get_spot_num_ff() == 1 && is) {
      pos[0] = Vec2(lead_pos.x, lead_pos.y);
    }
    // case 2
    if(get_spot_num_ff() == 2 && is) {
      pos[0] = Vec2(lead_pos.x, lead_pos.y);
      pos[1] = Vec2(width -lead_pos.x, height -lead_pos.y);
    }
    // case 3
    if(get_spot_num_ff() > 2) {
    	multi_ccord(pos,lead_pos,is);
    }
    update_spot_ff_coord(pos);
  }
}

iVec2 ref_pos ;
void multi_ccord(Vec2 [] pos, iVec2 lead_pos, boolean is) {
	// int num_spot = num;
  float range_angle = TAU - get_angle_mouse();
  float step_angle = range_angle /pos.length;

  distance += get_speed_mouse(); 
  float final_angle = 0 ;
  for(int i = 0 ; i < pos.length ; i++) {
    /*
    growth system
    final_angle += step_angle ; 
    final_angle += distance;
    Vec2 proj = projection(final_angle, get_radius_mouse());
    */
    final_angle = step_angle *i ; 
    final_angle += distance;
    Vec2 proj = projection(final_angle, get_radius_mouse());
   
    pos[i] = Vec2(proj);
    if(is) {
      if(ref_pos == null) {
        ref_pos = iVec2(lead_pos.x,lead_pos.y);
      } else {
        ref_pos.set(lead_pos.x,lead_pos.y);
      }
    }
    pos[i].add(ref_pos);        
  }
}











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
  int diam_spot = get_resultion_ff()/2 ;
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
*/
Vec2 [] pos_finger ;
void force_field_spot_coord_leapmotion() {
  // init var
  if(pos_finger == null && get_spot_num_ff() > 0) {
    pos_finger = new Vec2[get_spot_num_ff()];
    for(int i = 0 ; i < pos_finger.length ; i++) {
      pos_finger[i] = Vec2(width/2,height/2);
    }
  }

  if(finger.is() && pos_finger != null) {
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
    /*
    for(int i = 0 ; i < finger.get_num() && i < get_spot_num_ff() && i < pos_finger.length; i++) {
      if(finger.visible()[i]) {
        float x = finger.get_pos()[i].x;
        float y = finger.get_pos()[i].y;
        y = map(y,0,1,1,0);
        pos_finger[i] = Vec2(x,y);
        pos_finger[i].mult(width,height);
      }
    }
    */
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

