
/**
CLASS PIX 
v 0.6.1
2016-2018
* @author Stan le Punk
* @see https://github.com/StanLepunK/Pixel
*/


abstract class Pix implements Rope_Constants {
  // P3D mode
  Vec3 pos, new_pos ;
  Vec3 size  ;
  
  // in cartesian mode
  Vec3 dir = null ;

  Vec3 grid_position ;
  int ID, rank ;
  int costume_ID = 0 ; // 0 is for point
  float costume_angle = 0 ;
  Vec4 colour, new_colour  ;
  
  // use for the motion
  float field = 1.0 ;


  void init_mother_arg() {
    pos = Vec3(width/2, height/2,0) ;
    if(new_pos == null) {
      new_pos = pos.copy();
    } else {
      new_pos.set(pos);
    }
    if(size == null) {
      size = Vec3(1) ;
    } else {
      size.set(1);
    }
    if(grid_position == null) {
      grid_position = pos.copy();
    } else {
      grid_position.set(pos);
    }
    // give a WHITE color to the pixel
    if(colour == null) {
      if(g.colorMode == 3 ) {
        colour = Vec4(0, 0, g.colorModeZ, g.colorModeA) ; 
      } else {
        colour = Vec4(g.colorModeX, g.colorModeY, g.colorModeZ, g.colorModeA) ;
      }
    } else {
      if(g.colorMode == 3 ) {
        colour.set(0, 0, g.colorModeZ, g.colorModeA) ; 
      } else {
        colour.set(g.colorModeX, g.colorModeY, g.colorModeZ, g.colorModeA) ;
      }
    }
   
    if(new_colour == null) {
      new_colour = colour.copy() ;
    } else {
      new_colour.set(colour) ;
    }

    int ID = 0 ;
    int rank = -1 ;
  }
  
  
  // RETURN color in Vec4
  // test the color mode to return the good data for each component
  Vec4 int_color_to_vec4_color(int c) {
    Vec4 color_temp = Vec4() ;
    if(g.colorMode == 3 ) color_temp = Vec4(hue(c),saturation(c),brightness(c),alpha(c)) ;
    else color_temp = Vec4(red(c),green(c),blue(c),alpha(c)) ;
    return Vec4(color_temp) ;
  }






  /** 
  SETTING
  */
  // ID
  public void set_ID(int ID) {  
    this.ID = ID ; 
  }

  public void costume_angle(float costume_angle) {
    if(costume_ID == POINT_ROPE) {
      printErrTempo(180, "class Pix method costume_angle() cannot be used with costume_ID POINT_ROPE");
    }
    this.costume_angle = costume_angle ;
  }


  // set costume
  public void costume(int costume_ID) {
    this.costume_ID = costume_ID ;
  }
  



  // size
  public void size(float x) {
    size(x,x,1) ;
  }
  public void size(float x, float y) {
    size(x,y,1) ;
  }

  public void size(Vec size) {
    if(size.z == 0) {
      size(size.x, size.y, 1);
    } else {
      size(size.x,size.y,size.z);
    }
  }

  public void size(iVec size) {
    if(size.z == 0) {
      size(size.x, size.y, 1);
    } else {
      size(size.x,size.y,size.z);
    }
  }

  public void size(float x, float y, float z) {
    if(size == null) {
      size = Vec3(x,y,z) ;
    } else {
      size.set(x,y,z);
    }
  }

 
  // normal direction
  @Deprecated
  public void direction(Vec3 d) {
    dir(d.x,d.y,d.z);
  }
  @Deprecated
  public void direction(float x, float y, float z) {
    dir(x,y,z);
  }
  
  @Deprecated
  public void direction_x(float x) {
    dir.x = x ;
  }
  
  @Deprecated
  public void direction_y(float y) {
    dir.y = y ;
  }

  @Deprecated
  public void direction_z(float z) {
    dir.z = z ;
  }
  

  public void dir_x(float x) {
    if(this.dir != null) {
      dir.x = x ;
    } else {
      this.dir = Vec3(x,0,0);
    }
  }
  
  public void dir_y(float y) {
    if(this.dir != null) {
      dir.y = y ;
    } else {
      this.dir = Vec3(0,y,0);
    }
  }

  public void dir_z(float z) {
    if(this.dir != null) {
      dir.z = z;
    } else {
      this.dir = Vec3(0,0,z);
    }
  }

  public void dir(Vec d) {
    if(d != null) {
      dir(d.x,d.y,d.z);
    } else {
      printErr("class Pix method dir() cannot set vector because the arg vector pass is null");
    }

    
  }

  public void dir(float x, float y, float z) {
    if(this.dir == null) {
      this.dir = Vec3(x,y,z);
    } else {
      this.dir.set(x,y,z);
    }
  }



  // position
  @Deprecated
  public void position(Vec pos) {
    this.pos.set(pos);
  }
  
  @Deprecated
  public void position(int x, int y){
    this.pos.set(x,y,0);
  }
  
  @Deprecated
  public void position(int x, int y, int z){
    this.pos.set(x,y,z);
  }
  
  public void pos(iVec pos) {
    if(pos != null) {
      pos(pos.x,pos.y,pos.z);
    } else {
      printErr("class Pix method pos() cannot set vector because the vector arg pass is null");
    }
  }

  public void pos(Vec pos) {
    if(pos != null) {
      pos(pos.x,pos.y,pos.z);
    } else {
      printErr("class Pix method pos() cannot set vector because the vector arg pass is null");
    }
  }

  public void pos(float x, float y){
    pos(x,y,0);
  }
  
  public void pos(float x, float y, float z){
    this.pos.set(x,y,z);
  }















  /**
  ASPECT
  v 0.2.0
  */
  /**
  improve methode to check if the stroke must be Stroke or noStroke()
  */
  public void aspect() {
    float thickness = 1 ;
    aspect_rope(colour,colour,thickness);
  }

  public void aspect(boolean new_colour_choice) {
    float thickness = 1 ;
    Vec4 color_choice = Vec4();
    if(new_colour_choice) {
      color_choice.set(new_colour); 
    } else {
      color_choice.set(colour);
    }
    aspect_rope(color_choice,color_choice,thickness) ;
  }

  public void aspect(boolean new_colour_choice, float thickness) {
    Vec4 color_choice = Vec4() ;
    if(new_colour_choice) {
      color_choice.set(new_colour) ; 
    } else {
      color_choice.set(colour);
    }
    aspect_rope(color_choice,color_choice,thickness);
  }

  public void aspect(float thickness) {
    aspect_rope(colour,colour,thickness);
  }

  public void aspect(int c) {
    float thickness = 1 ;
    Vec4 color_pix = int_color_to_vec4_color(c).copy() ;
    aspect_rope(color_pix, color_pix, thickness);
  }

  public void aspect(Vec4 color_pix) {
    float thickness = 1 ;
    aspect_rope(color_pix, color_pix, thickness) ;
  }

  public void aspect(Vec4 color_pix, float thickness) {
    aspect_rope(color_pix, color_pix, thickness) ;
  }
  
  public void aspect(Vec4 color_fill, Vec4 color_stroke, float thickness) {
    aspect_rope(color_fill,color_stroke,thickness);
  }
  




  //with effect
  /**
  Methode must be refactoring, very weird
  */
  /*
  void aspect(int diam, PVector effectColor) {
    strokeWeight(diam) ;
    stroke(new_colour.r, effectColor.x *new_colour.g, effectColor.y *new_colour.b, effectColor.z *new_colour.a) ;
  }
  */  
  
  
  
  
  /**
  CHANGE COLOR
  */
  //direct change HSB
  void set_hue(int new_hue, int target_color, boolean use_new_colour) {
    set_hue(new_hue, target_color, target_color +1, use_new_colour) ;
  }
  void set_saturation(int new_sat, int target_color, boolean use_new_colour) {
    set_saturation(new_sat, target_color, target_color +1, use_new_colour) ;
  }
  void set_brightness(int new_bright, int target_color, boolean use_new_colour) {
    set_brightness(new_bright, target_color, target_color +1, use_new_colour) ;
  }
  //direct change RGB
  void set_red(int new_red, int target_color, boolean use_new_colour) {
    set_red(new_red, target_color, target_color +1, use_new_colour) ;
  }
  void set_green(int new_green, int target_color, boolean use_new_colour) {
    set_green(new_green, target_color, target_color +1, use_new_colour) ;
  }
  void set_blue(int new_blue, int target_color, boolean use_new_colour) {
    set_blue(new_blue, target_color, target_color +1, use_new_colour) ;
  }
  //direct change ALPHA
  void set_alpha(int new_alpha, int target_color, boolean use_new_colour) {
    set_alpha(new_alpha, target_color, target_color +1, use_new_colour) ;
  }
  
  // change with range
  // HSB change
  void set_hue(int new_hue, int start, int end, boolean use_new_colour) {
    float hue_temp ; ;
    if(!use_new_colour) hue_temp = set_color_component_from_specific_component("hue", colour.r, new_hue, start, end) ; 
    else hue_temp = set_color_component_from_specific_component("hue", new_colour.r, new_hue, start, end) ;
    new_colour = Vec4(hue_temp, new_colour.y, new_colour.z, new_colour.w)  ;
  }
  void set_saturation(int new_saturation, int start, int end, boolean use_new_colour) {
    float saturation_temp ;
    if(!use_new_colour) saturation_temp = set_color_component_from_specific_component("saturation", colour.g, new_saturation, start, end) ;
    else saturation_temp = set_color_component_from_specific_component("saturation", new_colour.g, new_saturation, start, end) ;
    new_colour = Vec4(new_colour.x, saturation_temp, new_colour.z, new_colour.w)  ;
  }
  void set_brightness(int new_brightness, int start, int end, boolean use_new_colour) {
    float brightness_temp ;
    if(!use_new_colour) brightness_temp = set_color_component_from_specific_component("brightness", colour.b, new_brightness, start, end) ;
    else brightness_temp = set_color_component_from_specific_component("brightness", new_colour.b, new_brightness, start, end) ;
    new_colour = Vec4(new_colour.x, new_colour.y, brightness_temp, new_colour.w)  ;
  }
  // RGB change
  void set_red(int new_red, int start, int end, boolean use_new_colour) {
    float red_temp ;
    if(!use_new_colour) red_temp = set_color_component_from_specific_component("red", colour.r, new_red, start, end) ;
    else red_temp = set_color_component_from_specific_component("red", new_colour.r, new_red, start, end) ;
    new_colour = Vec4(red_temp, new_colour.y, new_colour.z, new_colour.w)  ;
  }
  void set_green(int new_green, int start, int end, boolean use_new_colour) {
    float green_temp ;
    if(!use_new_colour) green_temp = set_color_component_from_specific_component("green", colour.g, new_green, start, end) ;
    else green_temp = set_color_component_from_specific_component("green", new_colour.g, new_green, start, end) ;
    new_colour = Vec4(new_colour.x, green_temp, new_colour.z, new_colour.w)  ;
  }
  void set_blue(int new_blue, int start, int end, boolean use_new_colour) {
    float blue_temp ;
    if(!use_new_colour) blue_temp = set_color_component_from_specific_component("blue", colour.b, new_blue, start, end) ;
    else blue_temp = set_color_component_from_specific_component("blue", new_colour.b, new_blue, start, end) ;
    new_colour = Vec4(new_colour.x, new_colour.y, blue_temp, new_colour.w)  ;
  }

  // ALPHA change
  void set_alpha(int new_alpha, int start, int end, boolean use_new_colour) {
    float alpha_temp ;
    if(!use_new_colour) alpha_temp = set_color_component_from_specific_component("alpha", colour.a, new_alpha, start, end) ;
    else alpha_temp = set_color_component_from_specific_component("alpha", new_colour.a, new_alpha, start, end) ;
    new_colour = Vec4(new_colour.x, new_colour.y, new_colour.z, alpha_temp)  ;
  }



  // INTERNAL method to change color
  float set_color_component_from_specific_component (String which_component, float original_component, int new_component, int start_range, int end_range) {
    if (start_range < end_range ) {
      if(original_component >= start_range && original_component <= end_range) original_component = new_component ; 
    } else if (start_range > end_range) {
      if( (original_component >= start_range && original_component <= roof(which_component)) || original_component <= end_range) { 
        original_component = new_component ;
      }
    }        
    return original_component ;
  }
  
  //
  float roof(String which_component) {
    float roof = 1 ;
    switch(which_component) {
      case "HUE" : roof = g.colorModeX ; break ; 
      case "SATURATION" : roof = g.colorModeY ; break ; 
      case "BRIGHTNESS" : roof = g.colorModeZ ; break ; 
      case "RED" : roof = g.colorModeX ; break ; 
      case "GREEN" : roof = g.colorModeY ; break ; 
      case "BLUE" :  roof = g.colorModeZ ; break ;
      case "ALPHA" :  roof = g.colorModeA ; break ; 

      case "hue" :  roof = g.colorModeX ; break ; 
      case "saturation" :  roof = g.colorModeY ; break ; 
      case "brightness" :  roof = g.colorModeZ ; break ;  
      case "red" :  roof = g.colorModeX ; break ; 
      case "green" :  roof = g.colorModeY ; break ; 
      case "blue" :  roof = g.colorModeZ ; break ;
      case "alpha" :  roof = g.colorModeA ; break ; 

      case "Hue" :  roof = g.colorModeX ; break ;  
      case "Saturation" :  roof = g.colorModeY ; break ;  
      case "Brightness" :  roof = g.colorModeZ ; break ; 
      case "Red" :  roof = g.colorModeX ; break ; 
      case "Green" :  roof = g.colorModeY ; break ; 
      case "Blue" :  roof = g.colorModeZ ; break ; 
      case "Alpha" :  roof = g.colorModeA ; break ;
    }
    return roof ;
  }
}
// END MOTHER CLASS
//////////////////////
















/**
CLOUD
v 0.3.0
*/
class Cloud extends Pix implements Rope_Constants {
  int num ;
  int time_count = Integer.MIN_VALUE;
  float beat_ref = .001 ;
  float beat = .001 ;
  String behavior = "RADIUS";
  Vec3 [] coord;
  int type = r.CARTESIAN ;
  int distribution;
  String renderer_dimension;
  float radius = 1;
  Vec3 orientation;

  float angle_growth;
  float dist_growth ;

  boolean polar_is;
  float dist;
  int spiral_rounds;

  Vec2 range;


  public Cloud(int num, String renderer_dimension) {
    init_mother_arg();
    this.num = num ;
    coord = new Vec3[num];
    choice_renderer_dimension(renderer_dimension);
  }

  protected void init() {
    if(renderer_dimension == P2D) {
      cartesian_pos_2D(dist) ; 
    } else {
      if(polar_is) {
        polar_pos_3D(); 
      } else {
        cartesian_pos_3D(); 
      }
    }
  }
  

  
  float angle_step ;
  protected void angle_step(float angle_step) {
    if(distribution == ORDER && !polar_is) {
      this.angle_step = angle_step;
    } else {
      printErrTempo(180, "class Cloud, method angle_step() must be used in Cartesian rendering and with ORDER distribution");
    }
  }







  protected void growth(float angle_growth) {
    if(this.type == r.CARTESIAN && this.distribution == r.ORDER && this.renderer_dimension.equals(P2D)) {
      this.angle_growth = angle_growth ;
    } else {
      printErrTempo(180, "class CLOUD method growth() work only int type == r.CARTESIAN & int distribution = r.ORDER & String renderer_dimension P2D");
    }
  }

  public float get_growth() {
    return dist_growth;
  }


  public void growth_size(float dist) {
    dist_growth = dist ;
  }


  protected void cartesian_pos_2D(float dist) {
    float angle = TAU / num ;
    if(angle_step != 0) {
      angle = angle_step / num ;
    }

    if(angle_growth != 0) {
      dist_growth += angle_growth;
      angle += dist_growth;
    }

    float tetha ;
    for(int i = 0 ; i < num ; i++ ) {
      if(distribution == r.ORDER) {
        tetha = dist +(angle *i);
        coord[i] = Vec3(cos(tetha),sin(tetha), 0 ) ; 
      } else {
        tetha = dist + random(-PI, PI) ;
        coord[i] = Vec3(cos(tetha),sin(tetha), 0 ) ;
      }
    }
  }

  protected void cartesian_pos_3D() {
    if(distribution == ORDER) {
      // step and root maybe must be define somewhere ????
      float step = PI * (3 - sqrt(5.)) ; 
      float root = PI ;
      if(angle_step != 0) {
        step = angle_step * (3 - sqrt(5.)) ;
        root = angle_step;
      }
      coord = list_cartesian_fibonacci_sphere(num, step, root);
    } else {
      for(int i = 0 ; i < coord.length ; i++ ) {
        float tetha  = random(-PI, PI) ;
        float phi  = random(-TAU, TAU) ;
        coord[i] = Vec3(cos(tetha) *cos(phi),
                        cos(tetha) *sin(phi), 
                        sin(tetha) ) ; 
      }
    }
  }


  protected void polar_pos_3D() {
    float step = TAU ;
    if(distribution == ORDER) {
      for (int i = 0; i < coord.length ; i++) {      
        coord[i] = Vec3() ;
        coord[i].x = distribution_polar_fibonacci_sphere(i, num, step).x ;
        coord[i].y = distribution_polar_fibonacci_sphere(i, num, step).y ;
        coord[i].z = 0  ;
      }
    } else {
      for (int i = 0; i < coord.length ; i++) {
        int which = floor(random(num)) ;
        coord[i] = Vec3() ;
        coord[i].x = distribution_polar_fibonacci_sphere(which, num, step).x ;
        coord[i].y = distribution_polar_fibonacci_sphere(which, num, step).y ;
        coord[i].z = 0  ;
      }
    }
  }






  
  protected void rotation(float rotation, boolean static_rot) {
    if(!polar_is && this.renderer_dimension == P2D) {
      if(static_rot) {
        dist = rotation ; 
      } else {
        dist += rotation;
      }
    } else {
      printErrTempo(180, "Class Pix method rotation() is available only in P2D rendering and for sub Class Cloud_2D, for Cloud_3D use rotation_x(), rotation_y() or rotation_z()");
    }
  }


  public float get_rotation() {
    return dist ;
  }



  protected void choice_renderer_dimension(String dimension) {
    if(dimension == P3D) {
      this.renderer_dimension = P3D ;
    } else {
      this.renderer_dimension = P2D ;
    }
  }


  protected void give_points_to_costume_2D() {
    for(int i  = 0 ; i < coord.length ;i++) {
      costume_rope(coord[i], size, costume_angle, costume_ID) ;
    }
  }

  public void radius(float radius) {
    this.radius = radius;
  }

  public void beat(int n) {
    this.beat = beat_ref *n ;
  }

  public void time_count(int count) {
    time_count = count;
  }

  public Vec3 [] list() {
    return coord;   
  }

  public void behavior(String behavior) {
    this.behavior = behavior ;
  }
  
  public void spiral(int spiral_rounds) {
    this.spiral_rounds = spiral_rounds;
    if(type != r.CARTESIAN) {
      printErrTempo(180, "class Cloud method spiral() is available only for type r.CARTESIAN, not for type r.POLAR");
    }
  }
  public void range(float min, float max) {
    if(range == null) {
      range = Vec2(min, max);
    } else {
      range.set(min,max);
    }
  }

  // distribution surface polar
  protected void distribution_surface_polar() {
    if(behavior != "RADIUS") {
      radius = abs(distribution_behavior(range,radius,behavior)) ;
    }
  }

 // distribution surface cartesian
 protected void distribution_surface_cartesian() {
    float radius_temp = radius;
    
    if(spiral_rounds > 0) {
      int round = 0 ;
      if(range == null) {
        range = Vec2(0,1);
      }
      float height_step = ((range.y -range.x) /coord.length) /spiral_rounds;
      float floor = (range.y -range.x) / spiral_rounds;
      for (int i = 0 ; i < coord.length ; i++) {       
        float range_in = range.x + (height_step *i) + (floor *round) ;
        
        if(behavior != "RADIUS") {
          Vec2 temp_range = range.copy();
          temp_range.set(range_in,range.y);
          radius_temp = distribution_behavior(temp_range,radius,behavior);
        } else {
          radius_temp = radius;
          radius_temp *= range_in ;
        }
        coord[i].mult(radius_temp) ;
        coord[i].add(pos) ;
        round ++ ;
        if(round >= spiral_rounds) round = 0 ;
      }   
    } else {
      for (int i = 0 ; i < coord.length ; i++) {
        if(behavior != "RADIUS") {
          radius_temp = distribution_behavior(range,radius,behavior);
        }
        coord[i].mult(radius_temp) ;
        coord[i].add(pos) ;
      }
    }
  }
  
  /**
  distribution behavior
  */
  // internal method
  private float distribution_behavior(Vec2 range, float radius, String behavior_distribution) {
    float normal_distribution = 1 ;
    
    // rules
    float root_1 = 0 ;
    float root_2 = 0 ;
    float root_3 = 0 ;
    float root_4 = 0 ;
     if(behavior_distribution.contains(RANDOM)) {
      root_1 = random(1) ;
      if(behavior_distribution.contains("2") || behavior_distribution.contains("3") || behavior_distribution.contains("4")|| behavior_distribution.contains("SPECIAL")) {
        root_2 = random(1) ;
        root_3 = random(1) ;
        root_4 = random(1) ;
      }
    }

    float t = 0 ;
    if(behavior_distribution.contains(SIN) || behavior_distribution.contains(COS)) {
      if(time_count == Integer.MIN_VALUE) {
        t = frameCount *beat; 
      } else t = time_count *beat;   
    }

    float factor_1_2 = 1.2;
    float factor_0_5 = .5;
    float factor_12_0 = 12.;
    float factor_10_0 = 10.;
    
    // distribution
    if(behavior_distribution == RANDOM) normal_distribution = root_1;
    else if(behavior_distribution == RANDOM_ROOT) normal_distribution = sqrt(root_1);
    else if(behavior_distribution == RANDOM_QUARTER) normal_distribution = 1 -(.25 *root_1);
    
    else if(behavior_distribution == RANDOM_2) normal_distribution = root_1 *root_2;

    else if(behavior_distribution == RANDOM_3) normal_distribution = root_1 *root_2 *root_3;

    else if(behavior_distribution == RANDOM_4) normal_distribution = root_1 *root_2 *root_3 *root_4;
    else if(behavior_distribution == RANDOM_X_A) normal_distribution = .25 *(root_1 +root_2 +root_3 +root_4);
    else if(behavior_distribution == RANDOM_X_B) {
      float temp = root_1 -root_2 +root_3 -root_4;
      if(temp < 0) temp += 4 ;
      normal_distribution = .25 *temp;
    }

    else if(behavior_distribution == SIN) normal_distribution = sin(t);
    else if(behavior_distribution == COS) normal_distribution = cos(t);
    else if(behavior_distribution == "SIN_TAN") normal_distribution = sin(tan(t)*factor_0_5);
    else if(behavior_distribution == "SIN_TAN_COS") normal_distribution = sin(tan(cos(t) *factor_1_2));
    else if(behavior_distribution == "SIN_POW_SIN") normal_distribution = sin(pow(8.,sin(t)));
    else if(behavior_distribution == "POW_SIN_PI") normal_distribution = pow(sin((t) *PI), factor_12_0);
    else if(behavior_distribution == "SIN_TAN_POW_SIN") normal_distribution = sin(tan(t) *pow(sin(t),factor_10_0));

    // result
    if(range != null) {
      //return radius *(map(normal_distribution,-1,1,range.x,range.y)); // classic

      float max = map(normal_distribution, -1, 1,-range.y,range.y);
      return radius *(map(max,-1,1,range.x,1));

      // return radius *(map(normal_distribution,-range.x,range.x,range.x,range.y)); // interesting
    } else  {
      return radius *normal_distribution;
    }
  }  
}



/**
CLOUD 2D
*/
class Cloud_2D extends Cloud {
 
  public Cloud_2D(int num) {
    super(num,P3D);
    // choice_renderer_dimension(renderer_dimension);
    this.distribution = ORDER;
    orientation = Vec3(0,PI/2,0); 
    init() ;
  }

  public Cloud_2D(int num, int distribution) {
    super(num,P2D);
    this.distribution = distribution ;
    init();
  }

  public Cloud_2D(int num, int distribution, float angle_step) {
    super(num,P2D);
    this.distribution = distribution ;
    angle_step(angle_step);
    init();
  }


  
  public void update() {
    cartesian_pos_2D(dist);
    distribution_surface_cartesian();
  }
  


  public void show() {
    give_points_to_costume_2D();
  }
}











/**
CLOUD 3D
*/
class Cloud_3D extends Cloud {

  boolean rotation_x, rotation_y, rotation_z;
  float dist_x, dist_y, dist_z;

  boolean rotation_fx_x, rotation_fx_y, rotation_fx_z;
  float dist_fx_x, dist_fx_y, dist_fx_z;
 
  public Cloud_3D(int num) {
    super(num,P3D);
    // choice_renderer_dimension(renderer_dimension);
    this.distribution = ORDER;
    this.orientation = Vec3(0,PI/2,0); 
    init() ;
  }

  /*
  Use this constructor if you want build a cartesian sphere with a real coord in the 3D space, you must ask a "POINT" costume
  */
  public Cloud_3D(int num, String renderer_dimension, int distribution) {
    super(num, renderer_dimension);
    this.distribution = distribution ;
    this.orientation = Vec3(0,PI/2,0); 
    init();
  }

  public Cloud_3D(int num, String renderer_dimension, int distribution, int type) {
    super(num, renderer_dimension);
    this.type = type ;
    if(renderer_dimension == P2D && type == r.POLAR) {
      printErr("class Cloud_3D cannot work good with 2D String renderer_dimension and type int r.POLAR");
    }

    this.distribution = distribution ;
    this.orientation = Vec3(0,PI/2,0);
    if(this.type == r.POLAR) {
      polar(true);
    } else {
      polar(false);
    }
    init() ;
  }

  public Cloud_3D(int num, String renderer_dimension, float step_angle) {
    super(num, renderer_dimension);
    polar(false);
    this.distribution = r.ORDER ;
    this.orientation = Vec3(0,PI/2,0);
    angle_step(step_angle);
    /*
    if(type == r.POLAR) {
      polar(true);
    } else {
      polar(false);
    }
    */
    init() ;
  }



  // change orientation
  public void orientation(Vec3 orientation) {
    orientation(orientation.x, orientation.y, orientation.z);
  }

  public void orientation_x(float orientation_x) {
    orientation(orientation.x, 0,0);
  }

  public void orientation_y(float orientation_y) {
    orientation(0, orientation.y,0);
  }

  public void orientation_z(float orientation_z) {
    orientation(0,0,orientation.z);
  }

  public void orientation(float x, float y, float z) {
     if(!polar_is) {
      printErrTempo(180, "void orientation() class Cloud work only with type r.POLAR");
    }
    this.orientation = Vec3(x,y,z) ;
  }


  // rotation
  public void rotation_x(float rot, boolean static_rot) {
    if(!polar_is) {
      printErrTempo(180, "class Cloud_3D method rotation_x() is not available for cartesian_2D distribution, only in polar distribution");
    } else {
      rotation_x = true ;
      if(static_rot) dist_x = rot ; else dist_x += rot ;
    }
  }

  public void rotation_y(float rot, boolean static_rot) {
    if(!polar_is) {
      printErrTempo(180, "class Cloud_3D method rotation_y() is not available for cartesian_2D distribution, only in polar distribution");
    } else {
      rotation_y = true ;
      if(static_rot) dist_y = rot ; else dist_y += rot ;
    }
  }

  public void rotation_z(float rot, boolean static_rot) {
    if(!polar_is) {
      printErrTempo(180, "class Cloud_3D method rotation_z() is not available for cartesian_2D distribution, only in polar distribution");
    } else {
      rotation_z = true ;
      if(static_rot) dist_z = rot ; else dist_z += rot ;
    }
  }

  // rotation FX
  public void rotation_fx_x(float rot, boolean static_rot) {
    if(!polar_is) {
      printErrTempo(180, "class Cloud_3D method rotation_fx_x() is not available for cartesian_2D distribution, only in polar distribution");
    } else {
      rotation_fx_x = true ;
      if(static_rot) dist_fx_x = rot ; else dist_fx_x += rot ;
    }
  }
  


  public void rotation_fx_y(float rot, boolean static_rot) {
    if(!polar_is) {
      printErrTempo(180, "class Cloud_3D method rotation_fx_y() is not available for cartesian_2D distribution, only in polar distribution");
    } else {
      rotation_fx_y = true ;
      if(static_rot) dist_fx_y = rot ; else dist_fx_y += rot ;
    }
  }

  public void rotation_fx_z(float rot, boolean static_rot) {
    if(!polar_is) {
      printErrTempo(180, "class Cloud_3D method rotation_fx_z() is not available for cartesian_2D distribution, only in polar distribution");
    } else {
      rotation_fx_z = true ;
      if(static_rot) dist_fx_z = rot ; else dist_fx_z += rot ;
    }
  }


  public void ring(float rot, boolean static_rot) {
    rotation_fx_y(rot, static_rot);
  }

  public void helmet(float rot, boolean static_rot) {
    rotation_fx_z(rot, static_rot);
  }





  /**
  * distribution_surface
  */

  public void polar(boolean polar_is) {
    this.polar_is = polar_is;
  }

  public void update() {
    if(polar_is) {
      distribution_surface_polar() ; 
    } else {
      cartesian_pos_3D();
      distribution_surface_cartesian() ;
    }
  }
  


  /**
  * Show
  */
  public void show() {
    if (renderer_P3D() && renderer_dimension == P3D && polar_is) {
      give_points_to_costume_3D(); 
    } else {
      give_points_to_costume_2D();
    }
  }

  protected void give_points_to_costume_3D() {
    if(!polar_is) {
      for(int i  = 0 ; i < coord.length ;i++) {
        // method from mother class need pass info arg
        costume_rope(coord[i], size, costume_angle, costume_ID) ;
      }
    } else {
      // method from here don't need to pass info about arg
      costume_3D_polar(dist) ;
    }
  }
  
  // internal
  protected void costume_3D_polar(float dist) {
   start_matrix() ;
   translate(pos) ;
    for(int i = 0 ; i < num ;i++) {
      start_matrix() ;
      /**
      super effect
      float rot = (map(mouseX,0,width,-PI,PI)) ;
      dir_pol[i].y += rot ;
      */
      if(rotation_x) rotateX(dist_x); 
      if(rotation_y) rotateY(dist_y); 
      if(rotation_z) rotateZ(dist_z); 
      // Vec2 coord_temp = Vec2(coord[i].x,coord[i].y).add(dist);
      Vec2 coord_temp = Vec2(coord[i].x,coord[i].y);
      rotateYZ(coord_temp) ;
      
      if(rotation_fx_x) rotateX(dist_fx_x); // interesting
      if(rotation_fx_y) rotateY(dist_fx_y); // interesting
      if(rotation_fx_z) rotateZ(dist_fx_z); // interesting

      Vec3 pos_primitive = Vec3(radius,0,0) ;
      translate(pos_primitive) ;

      start_matrix();
      rotateXYZ(orientation) ;
      Vec3 pos_local_primitive = Vec3() ;
      Vec2 orientation_polar = Vec2() ;
      costume_rope(pos_local_primitive, size, costume_angle, orientation_polar, costume_ID) ;
      stop_matrix() ;
      stop_matrix() ;
    }
    stop_matrix() ;
  }
}



















/**
Class pixel Basic
v 0.0.2
*/
class Pixel extends Pix  {
  // CONSTRUCTOR
  
  // PIXEL 2D
  public Pixel(Vec2 pos_2D) {
    init_mother_arg() ;
    this.pos = new Vec3(pos_2D.x,pos_2D.y, 0)  ;
  }

  public Pixel(Vec2 pos_2D, Vec2 size_2D) {
    init_mother_arg() ;
    this.pos = new Vec3(pos_2D.x,pos_2D.y, 0)  ;
    this.size = new Vec3(size_2D.x,size_2D.y,0) ; ;
  }
  
  // Constructor plus color components
  public Pixel(Vec2 pos_2D, Vec4 color_vec) {
    init_mother_arg() ;
    this.pos = new Vec3(pos_2D.x,pos_2D.y, 0)  ;
    colour = Vec4(color_vec) ;
    new_colour = Vec4(colour) ;
    
  }

  public Pixel(Vec2 pos_2D, Vec2 size_2D, Vec4 color_vec) {
    init_mother_arg() ;
    this.pos = new Vec3(pos_2D.x,pos_2D.y, 0)  ;
    this.size = new Vec3(size_2D.x,size_2D.y,0) ;
    colour = Vec4(color_vec) ;
    new_colour = Vec4(colour) ;
  }

  // Constructor with costume indication
  public Pixel(Vec2 pos_2D, Vec2 size_2D, int costume_ID) {
    init_mother_arg() ;
    this.costume_ID = costume_ID ;
    this.pos = new Vec3(pos_2D.x,pos_2D.y, 0)  ;
    this.size = new Vec3(size_2D.x,size_2D.y,0) ; ;
  }
  
  // Constructor plus color components
  public Pixel(Vec2 pos_2D, Vec4 color_vec, int costume_ID) {
    init_mother_arg() ;
    this.costume_ID = costume_ID ;
    this.pos = new Vec3(pos_2D.x,pos_2D.y, 0)  ;
    colour = color_vec.copy() ;
    new_colour = colour.copy() ;
    
  }

  public Pixel(Vec2 pos_2D, Vec2 size_2D, Vec4 color_vec, int costume_ID) {
    init_mother_arg() ;
    this.costume_ID = costume_ID ;
    this.pos = new Vec3(pos_2D.x,pos_2D.y, 0)  ;
    this.size = new Vec3(size_2D.x,size_2D.y,0) ;
    colour = color_vec.copy() ;
    new_colour = colour.copy() ;
  }

  // Constructor plus color components
  public Pixel(Vec2 pos_2D, int colour_int, int costume_ID) {
    init_mother_arg() ;
    this.costume_ID = costume_ID ;
    this.pos = new Vec3(pos_2D.x,pos_2D.y, 0)  ;
    colour = int_color_to_vec4_color(colour_int) ;
    new_colour = Vec4(colour) ;
  }

  public Pixel(Vec2 pos_2D, Vec2 size_2D, int colour_int, int costume_ID) {
    init_mother_arg() ;
    this.costume_ID = costume_ID ;
    this.pos = new Vec3(pos_2D.x,pos_2D.y, 0)  ;
    this.size = new Vec3(size_2D.x,size_2D.y,0) ;
    colour = int_color_to_vec4_color(colour_int) ;
    new_colour = Vec4(colour) ;
  }



  //PIXEL 3D
  public Pixel(Vec3 pos_3D) {
    init_mother_arg() ;
    this.pos = pos_3D  ;
  }

  public Pixel(Vec3 pos_3D, Vec3 size_3D) {
    init_mother_arg() ;
    this.pos = pos_3D ;
    this.size = size_3D ;
  }
  // constructor plus color component
  public Pixel(Vec3 pos_3D,  Vec4 color_vec) {
    init_mother_arg() ;
    this.pos = pos_3D ;
    colour = color_vec.copy() ;
    new_colour = colour.copy() ;
  }
  
  public Pixel(Vec3 pos_3D, Vec3 size_3D, Vec4 color_vec) {
    init_mother_arg() ;
    this.pos = pos_3D ;
    this.size = size_3D ;
    colour = color_vec.copy() ;
    new_colour = colour.copy() ;
  }

  // with costume indication
  public Pixel(Vec3 pos_3D, Vec3 size_3D, int costume_ID) {
    init_mother_arg() ;
    this.costume_ID = costume_ID ;
    this.pos = pos_3D ;
    this.size = size_3D ;
  }
  // constructor plus color component
  public Pixel(Vec3 pos_3D,  Vec4 color_vec, int costume_ID) {
    init_mother_arg() ;
    this.costume_ID = costume_ID ;
    this.pos = pos_3D ;
    colour = color_vec.copy() ;
    new_colour = colour.copy() ;
  }
  
  public Pixel(Vec3 pos_3D, Vec3 size_3D, Vec4 color_vec, int costume_ID) {
    init_mother_arg() ;
    this.costume_ID = costume_ID ;
    this.pos = pos_3D ;
    this.size = size_3D ;
    colour = color_vec.copy() ;
    new_colour = colour.copy() ;
  }

  
  //RANK PIXEL CONSTRUCTOR
  public Pixel(int rank) {
    init_mother_arg() ;
    this.rank = rank ;
  }
  
  public Pixel(int rank, Vec2 grid_position_2D) {
    init_mother_arg() ;
    this.rank = rank ;
    this.grid_position = new Vec3(grid_position_2D.x,grid_position_2D.y,0) ;
  }
  public Pixel(int rank, Vec3 grid_position) {
    init_mother_arg() ;
    this.rank = rank ;
    this.grid_position = grid_position ;
  }
  
  // METHOD

  // set summit
  private void set_summits(int summits) {
    if(summits == 1) this.costume_ID = POINT_ROPE ;
    else if(summits == 2) this.costume_ID  = LINE_ROPE ;
    else if(summits == 3) this.costume_ID  = TRIANGLE_ROPE ;
    else if(summits == 4) this.costume_ID  = SQUARE_ROPE ;
    else if(summits == 5) this.costume_ID  = PENTAGON_ROPE ;
    else if(summits == 6) this.costume_ID  = HEXAGON_ROPE ;
    else if(summits == 7) this.costume_ID  = HEPTAGON_ROPE ;
    else if(summits == 8) this.costume_ID  = OCTOGON_ROPE ;
    else if(summits == 9) this.costume_ID  = NONAGON_ROPE ;
    else if(summits == 10) this.costume_ID  = DECAGON_ROPE ;
    else if(summits == 11) this.costume_ID  = HENDECAGON_ROPE ;
    else if(summits == 12) this.costume_ID  = DODECAGON_ROPE ;
    else if(summits > 12) this.costume_ID  = ELLIPSE_ROPE ;
  }



  // show
  public void show() {
    if (renderer_P3D()) {
      costume_rope(pos, size, costume_angle, dir, costume_ID) ;
    } else {
      costume_rope(pos, size, costume_angle, costume_ID) ;
    }
  }
}




























/**
PIXEL MOTION 0.0.2
*/
class Pixel_motion extends Pix  {
    /**
    Not sure I must keep the arg field and life
  */
  float field = 1.0 ;
  float life = 1.0 ;

  // CONSTRUCTOR 2D
  Pixel_motion(Vec2 pos_2D, float field, int colour_int) {
    init_mother_arg() ;
    this.pos = Vec3(pos_2D) ;
    this.field = field ;
    colour = int_color_to_vec4_color(colour_int) ;
    new_colour = Vec4(colour) ;
  }

  Pixel_motion(Vec2 pos_2D, float field, Vec4 colour_vec) {
    init_mother_arg() ;
    this.pos = Vec3(pos_2D) ;
    this.field = field ;
    colour = Vec4(colour_vec) ;
    new_colour = Vec4(colour) ;
  }

  Pixel_motion(Vec2 pos_2D, float field) {
    init_mother_arg() ;
    this.pos = Vec3(pos_2D) ;
    this.field = field ;
  }
  
  // CONSTRUCTOR 3D
  Pixel_motion(Vec3 pos, float field, int colour_int) {
    init_mother_arg() ;
    this.pos = Vec3(pos) ;
    this.field = field ;
    colour = int_color_to_vec4_color(colour_int) ;
    new_colour = Vec4(colour) ;
  }

  Pixel_motion(Vec3 pos, float field, Vec4 colour_vec) {
    init_mother_arg() ;
    this.pos = Vec3(pos) ;
    this.field = field ;
    colour = Vec4(colour_vec) ;
    new_colour = Vec4(colour) ;
  }

  Pixel_motion(Vec3 pos, float field) {
    init_mother_arg() ;
    this.pos = Vec3(pos) ;
    this.field = field ;
  }


  


  /**
  Motion ink
  */
  void motion_ink_2D() {
    int size_field = 1 ;
    float speed_dry = 0 ;
    motion_ink_2D(size_field, speed_dry) ;
  }

  void motion_ink_2D(float speed_dry) {
    int size_field = 1 ;
    motion_ink_2D(size_field, speed_dry) ;
  }

  void motion_ink_2D(int size_field) {
    float speed_dry = 0 ;
    motion_ink_2D(size_field, speed_dry) ;
  }


  // with external var
  void motion_ink_2D(int size_field, float speed_dry) {
    if (field > 0 ) { 
      if(speed_dry != 0 ) field -= abs(speed_dry) ;
      float rad;
      float angle;
      rad = random(-1,1) *field *size_field;
      angle = random(-1,1) *TAU;
      pos.x += rad * cos(angle);
      pos.y += rad * sin(angle);
    }
  }



  // 3D
  void motion_ink_3D() {
    int size_field = 1 ;
    float speed_dry = 0 ;
    motion_ink_3D(size_field, speed_dry) ;
  }

  void motion_ink_3D(float speed_dry) {
    int size_field = 1 ;
    motion_ink_3D(size_field, speed_dry) ;
  }

  void motion_ink_3D(int size_field) {
    float speed_dry = 0 ;
    motion_ink_3D(size_field, speed_dry) ;
  }

  // with external var
  void motion_ink_3D(int size_field, float speed_dry) {
    if (field > 0 ) { 
      if(speed_dry != 0 ) field -= abs(speed_dry) ;
      float rad;
      float angle;
      rad = random(-1,1) *field *size_field;
      angle = random(-1,1) *TAU;
      pos.x += rad * cos(angle);
      pos.y += rad * sin(angle);
      pos.z += rad * cos(angle);
    }
  }




  


  
  
  
  /**
  This part must be refactoring, is really a confusing way to code
  For example why we use PImage ????
  Why do we use 'wind', can't we use 'motion' instead ????
  
  //UPDATE POSITION with the wind
  void update_position_2D(PVector effectPosition, PImage pic) {
    Vec2 dir_2D = norm_dir("DEG",effectPosition.x) ;
    
    velocity_2D = Vec2 (  1.0 *dir_2D.x *effectPosition.y  + random(-effectPosition.z) ,
                      1.0 *dir_2D.y *effectPosition.y  + random(-effectPosition.z))   ;
    pos_2D.add(wind_2D) ;
    //keep the pixel in the scene
    if (pos_2D.x< 0)          pos_2D.x= pic.width;
    if (pos_2D.x> pic.width)  pos_2D.x=0;
    if (pos_2D.y< 0)          pos_2D.y= pic.height;
    if (pos_2D.y> pic.height) pos_2D.y=0;
  }
  
  
  
  //return position with display size
  Vec2 position_2D(PVector effectPosition, PImage pic) {
    Vec2 dir_2D = norm_dir("DEG",effectPosition.x) ;

    new_pos_2D = pos_2D.copy() ;
    
    direction_2D = Vec2 (  1.0 *dir_2D.x *effectPosition.y  + random(-effectPosition.z, effectPosition.z) ,
                      1.0 *dir_2D.y *effectPosition.y  + random(-effectPosition.z, effectPosition.z))   ;
                  
    new_pos_2D.add(wind_2D) ;
    //keep the pixel in the scene
    if (new_pos_2D.x< 0)          new_pos_2D.x= pic.width;
    if (new_pos_2D.x> pic.width)  new_pos_2D.x=0;
    if (new_pos_2D.y< 0)          new_pos_2D.y= pic.height;
    if (new_pos_2D.y> pic.height) new_pos_2D.y=0;
    
    return new_pos_2D ;
  }
  */
  /**
  End of method who must be refactoring
  */
}