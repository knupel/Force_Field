   /**
Force Field
2017-2018
http://stanlepunk.xyz/
v 1.5.1
*/
/**
Run on Processing 3.3.6
*/
/**
Force Field
work based on the code traduction of Daniel Shiffman from Reynolds Study algorithm
and Jos Stam work for the Navier-Stokes adaptation
about Daniel Shiffmann
http://natureofcode.com
http://natureofcode.com/book/chapter-6-autonomous-agents/
About Craig Reynolds 
http://www.red3d.com/cwr/
About Jos Stam work
http://www.dgp.toronto.edu/people/stam/reality/Research/pdf/GDC03.pdf 
*/
/**
CONSTANT used by the class Force_field
int FLUID, CHAOS, PERLIN, HOLE, MAGNETIC, IMAGE
*/
/**
At this moment the force field is available only in 2D mode
*/

public class Force_field implements Rope_Constants {

  private Vec4[][] field;
  private PImage src;
  private PImage texture_velocity;
  private PImage texture_direction;

  private float mass_field = 1.;

  private ArrayList<Vec> spot_fluid_pos_ref;
  private ArrayList<Boolean> reset_ref_spot_pos_list_is;
  private ArrayList<Spot> spot_list;

  private ArrayList<Spot> spot_mag_north_list;
  private ArrayList<Spot> spot_mag_south_list;
  private ArrayList<Spot> spot_mag_neutral_list;

  private iVec2 canvas, canvas_pos;
  private int cols, rows; // Columns and Rows
  private int resolution; // How large is each "cell" of the flow field

  private Navier_Stokes_2D ns_2D;
  private Navier_Stokes_3D ns_3D;
  // private int N ;
  private int NX, NY, NZ;

  private float frequence = .01;
  private float viscosity = .0001;
  private float diffusion = .01;
  private float limit_vel = 100.;

  private int type = PERLIN;
  private boolean border_is = false;

  private float calm = 1;

  private boolean reverse_is;

  private float sum_activities;

  private iVec4 sort;

  boolean is;



  




  /**
  CONSTRUCTOR
  v 0.1.0
  */
  /**
  constructor CLASSIC
  */
  public Force_field(int resolution, iVec2 canvas_pos, iVec2 canvas, int type) {
    if(resolution == 0) {
      printErr("Contructor Force_field: resolution =", resolution, "instead the value 20 is used");
      this.resolution = 20 ;
    } else {
      this.resolution = resolution;
    }
    
    this.type = type ;
    this.is = true ;
    set_canvas(iVec2(this.resolution/2 +canvas_pos.x, this.resolution/2 +canvas_pos.y), iVec2(canvas.x,canvas.y));

    cols = NX = canvas.x/this.resolution;
    rows = NY = canvas.y/this.resolution +1;

    init_field();
    init_spot();
    init_texture(cols,rows);

    // Determine the number of columns and rows based on sketch's width and height
    if(type == FLUID) {
      // FLUID
      System.err.print("FLUID have square or cube canvas, the HEIGHT be used for the canvas side");
      int iteration = 20 ;
      ns_2D = new Navier_Stokes_2D(iVec2(NX,NY), iteration);
    } else if(type == MAGNETIC) {
      this.calm = 0 ;
    } else {
      border_is = true ;
      set_field(type);
    }
  }
  

  
  /**
  constructor PImage
  */
  public Force_field(int resolution, iVec2 canvas_pos, PImage src, int... component_sorting) {
    this.resolution = resolution;
    this.type = IMAGE ;
    this.is = true ;
    sorting_channel(component_sorting);
    
    if(this.src == null ) {
      this.src = createImage(src.width,src.height,ARGB);
      src.loadPixels() ;
      this.src.pixels = src.pixels ;
      this.src.updatePixels(); 
    } else {
      this.src.resize(src.width,src.height);
      src.loadPixels() ;
      this.src.pixels = src.pixels ;
      this.src.updatePixels(); 
    }
    // Determine the number of columns and rows based on sketch's width and height
    set_canvas(iVec2(resolution/2 +canvas_pos.x, resolution/2 +canvas_pos.y), iVec2(this.src.width,this.src.height));
    cols = canvas.x/resolution;
    rows = canvas.y/resolution;
    field = new Vec4[cols][rows];

    init_texture(cols,rows);

    border_is = true ;
    set_field_img_2D(this.src);
  }

  private void sorting_channel(int... sorting) {
    if(sorting.length == 1) {
      this.sort = iVec4(sorting[0],sorting[0],sorting[0],sorting[0]);
    } else if(sorting.length == 2) {
      this.sort = iVec4(sorting[0],sorting[0],sorting[0],sorting[1]);
    } else if(sorting.length == 3) {
      this.sort = iVec4(sorting[0],sorting[1],-1,sorting[2]);
    } else if(sorting.length == 4){
      this.sort = iVec4(sorting[0],sorting[1],sorting[2],sorting[3]);
    } else if(sorting.length > 4){
      this.sort = iVec4(sorting[0],sorting[1],sorting[2],sorting[3]);
      printErr("void sorting_channel(): Too much channel to sort, the first 4 is used");
    } else {
      this.sort = iVec4(1) ;
      printErr("void sorting_channel(): No channel available to sort, the value 1 is used for all component");
    }
  }

  /**
  initialisation
  v 0.0.2
  */

  private void init_texture(int w, int h) {
    texture_velocity = createImage(w,h,RGB);
    texture_direction = createImage(w,h,RGB);
  }

  private void init_field() {
    field = new Vec4[cols][rows];
    set_field(CHAOS);
  }

  private void init_spot() {
    spot_list = new ArrayList<Spot>();
    reset_ref_spot_pos_list_is = new ArrayList<Boolean>();

    if(this.type == MAGNETIC) {
      spot_mag_north_list = new ArrayList<Spot>();
      spot_mag_south_list = new ArrayList<Spot>();
      spot_mag_neutral_list = new ArrayList<Spot>();
    }
  }

  public void add_spot(int num) {
    if(spot_list != null) {
      for(int i = 0 ; i < num ; i++) {
        Spot spot = new Spot() ;
        spot_list.add(spot);
        boolean bool = false ;
        reset_ref_spot_pos_list_is.add(bool);
      }
    } else {
      printErr("ArrayList spot_list is null");
    }  
  }

  public void add_spot() {
    Spot spot = new Spot() ;
    spot_list.add(spot) ;
    boolean bool = false ;
    reset_ref_spot_pos_list_is.add(bool);
  }





    /**
  set field
  v 0.1.1
  */
    // set field classic
  private void set_field(int type) {
    // Reseed noise so we get a new flow field every time
    if(type == PERLIN) {
      noiseSeed((int)random(10000));
    }

    float xoff = 0 ;
    sum_activities = 0 ;
    for (int x = 0 ; x < cols ; x++) {
      float yoff = 0;
      float woff = 0;
      for (int y = 0 ; y < rows ; y++) {
        float theta = 0;
        float dist = 0 ;
        if(type == PERLIN) {
          theta = map(noise(xoff,yoff),0,1,0,TWO_PI);
          dist = noise(woff);
        } if(type == CHAOS) {
          theta = random(TAU);
          dist = random(1);
        } if(type == GRAVITY) {
          for(Spot s : spot_list) {
            theta = theta_2D(Vec2(x,y),Vec2(s.get_pos()));
          }          
        }
        // Polar to cartesian coordinate
        field[x][y] = Vec4(cos(theta),sin(theta),0,dist); 
        sum_activities += field[x][y].sum() ;     
        yoff += .1;
        woff += .1;
      }
      xoff += .1;
    }
  }



  // set field image
  /*
  set field for image in 2D
  */
  private void set_field_img_2D(PImage img) {
    img.loadPixels();
    sum_activities = 0;
    for(int x = 0 ; x < cols ; x++) {
      for(int y = 0 ; y < rows ; y++) {
        int pix = img.get(x *resolution, y *resolution);

        float theta_x = map_pix(sort.x,pix,0,TAU);
        float theta_y = map_pix(sort.y,pix,0,TAU);
        float vel = map_pix(sort.w,pix,0,1);

        // Polar to cartesian coordinate
        field[x][y] = Vec4(cos(theta_x),sin(theta_y),0,vel);  
        sum_activities += field[x][y].sum() ;
      }
    }
  }


  private float map_pix(int component_color, int pix, float min, float max) {
    float f = 0;
    if(component_color == RED) {
      f = red(pix);
      return map(f,0, g.colorModeX,min,max);
    } else if(component_color == GREEN) {
      f = green(pix);
      return map(f,0, g.colorModeY,min,max);
    } else if(component_color == BLUE) {
      f = blue(pix);
      return map(f,0, g.colorModeZ,min,max);
    } else if(component_color == HUE) {
      f = hue(pix);
      return map(f,0, g.colorModeX,min,max);
    } else if(component_color == SATURATION) {
      f = saturation(pix);
      return map(f,0, g.colorModeY,min,max);
    } else if(component_color == BRIGHTNESS) {
      f = brightness(pix);
      return map(f,0, g.colorModeZ,min,max);
    } else {
      f = alpha(pix);
      return map(f,0, g.colorModeA,min,max);
    }
  }












  /**
  public set
  v 0.0.6
  */
  public void set_border_is(boolean state) {
    border_is = state ;
  }


  /**
  public set spot
  v 0.1.0
  */

  public void set_spot(float pos_x, float pos_y, float size_x, float size_y) {
    for(int i = 0 ; i < spot_list.size() ; i++) {
      set_spot(pos_x,pos_y,size_x,size_y,i);
    }
  }

  public void set_spot(Vec2 pos, Vec2 size) {
    for(int i = 0 ; i < spot_list.size() ; i++) {
      set_spot(pos.x,pos.y,size.x,size.y,i);
    }
  }

  public void set_spot(float pos_x, float pos_y, float size_x, float size_y, int which_one) {
    set_spot(Vec2(pos_x,pos_y), Vec2(size_x,size_y),which_one);
  }

  public void set_spot(Vec2 pos, Vec2 size, int which_one) {
    set_spot_pos(pos.x,pos.y,which_one);
    set_spot_diam(size.x,size.y,which_one);
  }

  /*
  * spot position
  */
  public void set_spot_pos(float x, float y) {
    for(int i = 0 ; i < spot_list.size() ; i++) {
      set_spot_pos(x,y,i);
    } 
  }

  public void set_spot_pos(Vec2 pos) {
    for(int i = 0 ; i < spot_list.size() ; i++) {
      set_spot_pos(pos.x,pos.y, i);  
    }
  }

  public void set_spot_pos(float x, float y, int which_one) {
    set_spot_pos(Vec2(x,y),which_one);  
  }
// main method set pos
  public void set_spot_pos(Vec2 pos, int which_one) {
    /**
    emergency fix, not enought but stop the bleeding

    */
    if(canvas.x < canvas.y) {
      if(pos.y > canvas.x -resolution) {
        if(pos.x < 0) {
          pos.x = 0 ;
          pos.y = 0 ;
        }
        if(pos.x > canvas.x -resolution) {
          pos.x = canvas.x -resolution;
          pos.y = canvas.x -resolution;
        }
      }
    }

    Vec2 spot_pos = pos.copy();
    Vec2 spot_raw_pos = pos.copy();

    spot_pos.sub(Vec2(canvas_pos));
    if(which_one < spot_list.size()) {
      Spot spot = spot_list.get(which_one);
      spot.set_raw_pos(spot_raw_pos);
      spot.set_pos(spot_pos);
    } else {
      System.err.println("void set_spot_pos(): No Spot match with your target, you must add new spot in the list before set it");
    }
  }

  /*
  * spot size
  */
  public void set_spot_diam(float x, float y) {
    for(int i = 0 ; i < spot_list.size() ; i++) {
      set_spot_diam(x,y,i);  
    }
  }

  public void set_spot_diam(Vec2 size) {
    for(int i = 0 ; i <spot_list.size() ; i++) {
      set_spot_diam(size.x,size.y,i);
    }
  }

  public void set_spot_diam(float x, float y, int which_one) {
    set_spot_diam(Vec2(x,y),which_one);  
  }
  /*
  * main method set size
  */
  public void set_spot_diam(Vec2 size, int which_one) {
    Vec2 final_size = size.copy();
    if(which_one < spot_list.size()) {
      Spot spot = spot_list.get(which_one);
      spot.set_size(final_size);
    } else {
      System.err.println("void set_spot_diam(): No Spot match with your target, you must add new spot in the list before set it");
    }  
  }

  /*
  * spot mass
  */
  public void set_spot_mass(int mass) {
    for(int i = 0 ; i < spot_list.size() ; i++) {
       set_spot_mass(mass,i);
    }  
  }

  public void set_spot_mass(int mass, int which_one) {
    if(which_one < spot_list.size()) {
      Spot spot = spot_list.get(which_one);
      spot.set_mass(mass);
    } else {
      System.err.println("void set_spot_mass():No Spot match with your target, you must add new spot in the list before set it");
    }  
  }

  /*
  * spot tesla
  */
  public void set_spot_tesla(int tesla) {
    for(int i = 0 ; i <spot_list.size() ; i++) {
      set_spot_tesla(tesla,i);
    }
  }

  public void set_spot_tesla(int tesla, int which_one) {
    if(which_one < spot_list.size()) {
      Spot spot = spot_list.get(which_one);
      spot.set_tesla(tesla);
    } else {
      System.err.println("void set_spot_tesla(): No Spot match with your target, you must add new spot in the list before set it");
    }
  }
  




  /**
  set canvas
  v 0.0.2
  */
  public void set_canvas(iVec2 pos, iVec2 size) {
    set_canvas_pos(pos);
    set_canvas_size(size);
  }

  public void set_canvas_pos(iVec2 canvas_pos) {
    if(this.canvas_pos != null) {
      this.canvas_pos.set(canvas_pos);
    } else {
      this.canvas_pos = iVec2(canvas_pos);
    }
  }

  public void set_canvas_size(iVec2 canvas) {
    if(this.canvas != null) {
      this.canvas.set(canvas);
    } else {
      this.canvas = iVec2(canvas);
    }
  }

  public void set_frequence(float frequence) {
    this.frequence = frequence ;
  } 
  public void set_viscosity(float viscosity) {
    this.viscosity = viscosity ;
  }
  public void set_diffusion(float diffusion) {
    this.diffusion = diffusion ;
  }

  public void reverse_flow(boolean reverse_is) {
    this.reverse_is = reverse_is ;
  }

  /**
  set calm down
  v 0.0.1
  */
  public void set_calm(float calm) {
    if(calm < 0 || calm > 1) {
      String value = Float.toString(calm) ;
      calm = constrain(calm, 0, 1) ;
      String result = Float.toString(calm) ;
      String mess = "the float value 'calm' is equal " + value + " this one must be between '0' and '1', so the value will be constrain to " + result;
      System.err.println(mess);
    }
    this.calm = calm;
  }

  /**
  set mass field
  */
  public void set_mass_field(float mass_field) {
    this.mass_field = mass_field ;
  }








  /**
  reset
  v 0.1.0
  */
  public void clear_spot() {
    if(reset_ref_spot_pos_list_is != null) reset_ref_spot_pos_list_is.clear();
    if(spot_list != null) spot_list.clear();
    if(spot_mag_north_list != null) spot_mag_north_list.clear();
    if(spot_mag_south_list != null) spot_mag_south_list.clear();
    if(spot_mag_neutral_list != null) spot_mag_neutral_list.clear();

  }

  public void ref_spot(int which_one) {
    reset_ref_spot_pos_list_is.set(which_one,true);
  }

  public void ref_spot() {
    reset_ref_spot_pos_list_is.set(0,true);
  }


  public void reset() {
    reset_force_field();
  }

  /**
  * reset force field and the Navier_strokr stable fuild if this one is active
  */
  private void reset_force_field() {
    for (int x = 0; x < cols ; x++) {
      for (int y = 0; y < rows ; y++) {
        //field[x][y] = Vec2(0);
        field[x][y] = Vec4(0);
        if(type == FLUID) {
          ns_2D.set_dx(x,y,0);
          ns_2D.set_dy(x,y,0);
        }
      }
    }
  }

  /**
  refresh
  v 0.0.1
  */
  public void refresh() {
    if(type == FLUID) {
      System.err.println("void refresh() is not available with Force field FLUID");
    } else if(type == GRAVITY) {
      System.err.println("void refresh() is not available with Force field GRAVITY");
    } else if(type == IMAGE) {
      set_field_img_2D(this.src);
    } else {
      set_field(this.type);
    }
   
  }

  public void refresh_sorting_channel(int... sorting_channel) {
    sorting_channel(sorting_channel);
    set_field_img_2D(this.src);
  }
  




  /**
  update
  v 0.1.0.2
  */
  public void update() {
    if(type == FLUID) {
      manage_spot_fluid();
      ns_2D.update(frequence, viscosity, diffusion) ;
      update_fluid_field(ns_2D);
    } else if(type == GRAVITY) {
      update_gravity_field();
    } else if(type == MAGNETIC) {
      manage_spot_mag();
      update_magnetic_field();
    } else {
      update_classic_field();
    }  
  }
  
  // update classic field texture
  private void update_classic_field() {
    sum_activities = 0 ;
    for (int x = 0; x < cols ; x++) {
      for (int y = 0; y < rows ; y++) {
        Vec2 flow = Vec2(field[x][y].x,field[x][y].y).mult(field[x][y].w);
        convert_force_field_to_texture(x,y,flow.x,flow.y);
        sum_activities += field[x][y].sum() ;
      }
    }
  }


  // update stable fluid
  private void update_fluid_field(Navier_Stokes n) {
    if(n instanceof Navier_Stokes_2D) {
      Navier_Stokes_2D ns = (Navier_Stokes_2D)n ;
      sum_activities = 0;

      for(int x = 0 ; x < ns.get_NX() ; x++) {
        for(int y = 0 ; y < ns.get_NY() ; y++) {
          float dx = ns.get_dx(x,y);
          float dy = ns.get_dy(x,y);
          // dz and dw serve to nothing in this case
          float dz = 0 ;
          float dw = 0 ;
          field[x][y] = Vec4(dx,dy,dz,dw);
          convert_force_field_to_texture(x,y,dx,dy);
          sum_activities += field[x][y].sum() ;
        }
      }
    }
  }

  /**
  * gravity
  */
  private void update_gravity_field() {
    // by default we create a gravity field for external bodies who have for mass '1'
    sum_activities = 0 ;
    for (int x = 0; x < cols ; x++) {
      for (int y = 0; y < rows ; y++) {
        Vec2 flow = flow(Vec2(x,y), Vec2(field[x][y].x,field[x][y].y), spot_list);
        field[x][y] = Vec4(flow.x,flow.y,0,0);
        convert_force_field_to_texture(x,y,field[x][y].x,field[x][y].y);
        sum_activities += field[x][y].sum() ;
      }
    }
  }
  /**
  * magnetic
  */
  private void update_magnetic_field() {
    sum_activities = 0 ;
    for (int x = 0; x < cols ; x++) {
      for (int y = 0; y < rows ; y++) {
        Vec2 flow = flow(Vec2(x,y), Vec2(field[x][y].x,field[x][y].y), spot_list);
        field[x][y] = Vec4(flow.x,flow.y,0,0);
        convert_force_field_to_texture(x,y,field[x][y].x,field[x][y].y);
        sum_activities += field[x][y].sum();        
      }
    }
  }

  /**
  * local method to convert vector to texture
  */
  void convert_force_field_to_texture (int x, int y, float vx, float vy) {
    // velocity
    float velocity = (float)Math.sqrt(vx*vx + vy*vy);
    velocity = map(velocity, 0, 1, 0,g.colorModeX);
    int colour_vel = color(velocity);
    texture_velocity.set(x,y,colour_vel);
    // direction
    float dir_rad = atan2(vx,vy) ;
    float direction = map(dir_rad, -PI, PI, 0, g.colorModeX);
    int colour_dir = color(direction);
    texture_direction.set(x,y,colour_dir);
  }
  
  /**
  flow
  v 0.0.4
  */
  /**
  * flow 
  */
  private Vec2 flow(Vec2 coord, Vec2 field_dir, ArrayList<Spot> list) {
    if(type == GRAVITY) return gravity(coord, field_dir, list);
    else if(type == MAGNETIC) return magnetism(coord, field_dir, list);
    else return null ;
  }
  /**
  gravity 
  v 0.0.3
  */
  /**
  * gravity
  * @return Vec2
  */
  private Vec2 gravity(Vec2 coord, Vec2 field_dir, ArrayList<Spot> list) {
    Vec2 pos_cell = mult(coord, resolution);
    field_dir.set(0) ;
    for(Spot s : list) {
      s.reverse_emitter(reverse_is);
      float theta = theta_2D(pos_cell,Vec2(s.get_pos()));
      Vec2 temp_field = Vec2(cos(theta),sin(theta));
      float force = spot_gravity_force(s, pos_cell);
      temp_field.mult(force);
      field_dir.add(temp_field);
    }
    return field_dir ;
  }
  /**
  magnetism 
  v 0.1.2
  */
  /**
  * magnetism
  * @return Vec2
  * That work like a monopol, so it's very very far os the real world !
  */
  private Vec2 magnetism(Vec2 coord, Vec2 field_dir, ArrayList<Spot> list) {
    Vec2 pos_cell = mult(coord, resolution);
    field_dir.set(0) ;
    for(Spot s : list) {
      s.reverse_charge(reverse_is);
      float theta = theta_2D(pos_cell,Vec2(s.get_pos()));
      Vec2 temp_field = Vec2(cos(theta),sin(theta));
      float force =  spot_magnetic_force(s, pos_cell);
      temp_field.mult(force);
      field_dir.add(temp_field);
    }
    return field_dir ;
  }




  /**
  get velocity and direction texture
  get texture can be used externaly
  */
  public PImage get_tex_velocity() {
    return texture_velocity;
  }

  public PImage get_tex_direction() {
    return texture_direction;
  }




  /**
  get activity
  v 0.0.5
  */
  /**
  * activity, return true if the Force field is not equal to 0
  * @return boolean
  * @param float threshold is tolerance to start if there is an activity who can interest the rest of the world !
  */
  public boolean activity_is(float threshold) {
    if(sum_activities < threshold && sum_activities > -threshold) return false ; else return true ;
  }
  /**
  * get_activity(), return true if the Force field is not equal to 0
  * @return float
  */
  public float get_activity() {
    return sum_activities ;
  }
  /**
  get grid
  v 0.1.0
  */
  /**
  * @return the cell num side's
  */
  public int get_NX() {
    return NX;
  }

  public int get_NY() {
    return NY;
  }

  public int get_NZ() {
    return NZ;
  }


  public int get_cols() {
    return cols;
  }
  public int get_rows() {
    return rows ;
  }

  /**
  get border
  */
  /**
  * return true if the border is active, false if it's not
  * @return boolean
  */
  public boolean border_is() {
    return border_is ;
  }
  /**
  get spot
  v 0.1.0
  */
  public int get_spot_num() {
    if(spot_list != null) return spot_list.size();
    else return -1;
  }

  public int get_spot_south_num() {
    if(spot_mag_south_list != null) return spot_mag_south_list.size();
    else return -1;
  }

  public int get_spot_north_num() {
    if(spot_mag_north_list != null) return spot_mag_north_list.size();
    else return -1;
  }
  /**
  * get spot position
  */
  public Vec2 [] get_spot_pos() {
    Vec2 [] pos = new Vec2[spot_list.size()] ;
    for(int i = 0 ; i < spot_list.size() ; i++) {
      Spot s = spot_list.get(i) ;
      pos[i] = Vec2(s.get_pos()).copy();
      pos[i].add(Vec2(canvas_pos));
    }
    return pos;  
  }

  public Vec2 get_spot_pos(int which_one) {
    if(spot_list != null && spot_list.size() > which_one) {
      Spot spot = spot_list.get(which_one);
      return Vec2(spot.get_pos()).add(Vec2(canvas_pos));
    } else return null ;
  }
  /**
  * get raw spot posotion
  */
  public Vec2 [] get_spot_raw_pos() {
    Vec2 [] pos = new Vec2[spot_list.size()] ;
    for(int i = 0 ; i < spot_list.size() ; i++) {
      Spot s = spot_list.get(i) ;
      pos[i] = Vec2(s.get_raw_pos()).copy();
    }
    return pos;  
  }

  public Vec2 get_spot_raw_pos(int which_one) {
    if(spot_list != null && spot_list.size() > which_one) {
      Spot spot = spot_list.get(which_one);
      return Vec2(spot.get_raw_pos()).copy();
    } else return null ;
  }


  /**
  * get spot size
  */
  public Vec2 [] get_spot_size() {
    Vec2 [] size = new Vec2[spot_list.size()] ;
    for(int i = 0 ; i < spot_list.size() ; i++) {
      Spot s = spot_list.get(i) ;
      size[i] = Vec2(s.get_size()).copy() ;
    }
    return size;
  }

  public Vec2 get_spot_size(int which_one) {
    if(spot_list != null && spot_list.size() > which_one) {
      Spot spot = spot_list.get(which_one);
      return Vec2(spot.get_size());
    } else return null ;
  }

  /**
  * get spot tesla
  */
  public int [] get_spot_tesla() {
    int [] tesla = new int[spot_list.size()] ;
    for(int i = 0 ; i < spot_list.size() ; i++) {
      Spot s = spot_list.get(i) ;
      tesla[i] = s.get_tesla() ;
    }
    return tesla;
  }

  public int get_spot_tesla(int which_one) {
    if(spot_list != null && spot_list.size() > which_one) {
      Spot spot = spot_list.get(which_one);
      return spot.get_tesla();
    } else {
      System.err.println("No Spot match with your target, try another one! charge '0' is used");
      return 0 ;
    }
  }

  /**
  * get spot ion
  */
  public float [] get_spot_mass() {
    float [] mass = new float[spot_list.size()] ;
    for(int i = 0 ; i < spot_list.size() ; i++) {
      Spot s = spot_list.get(i) ;
      mass[i] = s.get_mass() ;
    }
    return mass;
  }

  public float get_spot_mass(int which_one) {
    if(spot_list != null && spot_list.size() > which_one) {
      Spot spot = spot_list.get(which_one);
      return spot.get_mass();
    } else {
      System.err.println("No Spot match with your target, try another one! mass '1' is used");
      return 1 ;
    }
  }
  
  /**
  * return arraylist spot$
  * @return ArrayList
  */
  public ArrayList<Spot> get_list() {
    if(spot_list != null) return spot_list ; else return null;
  }

  public ArrayList<Spot> get_list_south() {
    if(spot_mag_south_list != null) return spot_mag_south_list; else return null;
  }

  public ArrayList<Spot> get_list_north() {
    if(spot_mag_north_list != null) return spot_mag_north_list; else return null;
  }

  public ArrayList<Spot> get_list_neutral() {
     if(spot_mag_neutral_list != null) return spot_mag_neutral_list; else return null;
  }


  /**
  get canvas
  v 0.0.1
  */
  public iVec2 get_canvas() {
    return canvas;
  }

  public iVec2 get_canvas_pos() {
    if(canvas_pos == null) return iVec2(); else return canvas_pos;
  }

  public int get_resolution() {
    return resolution;
  }
  /**
  get type
  */
  /**
  * return the type of force field is used
  * @return int
  */
  public int get_type() {
    return type;
  }

  /**
  is 
  */
    /**
  * return is the force field are build or not
  * @return boolean
  */
  public boolean is() {
    return is;
  }




  


  

  /**
  direction from grid
  v 0.0.5
  */
  /**
  * add a global direction to the force field
  */
  Vec2 wind ;
  public void wind(float theta, float force) {
    if(wind == null) {
      wind = Vec2() ;
    }
    wind = projection(theta,force);
  }

  /**
  dir_in_grid
  v 0.1.1
  */
  /**
  * it's most important method, this one give the direction of the vehicle in according force field.
  * @return Vec2
  Here must improve the algorithm, when there is a spot in the cell, because in this case the precision direction need be very exact.
  */
  public Vec2 dir_in_grid(Vec2 vehicle_pos) {
    Vec2 dir = Vec2(0) ;
    int max_col = cols-1;
    int max_row = rows-1;

    int x = int(constrain(vehicle_pos.x /resolution, 0, max_col));
    int y = int(constrain(vehicle_pos.y /resolution, 0, max_row));

    if(field != null) {
      if(Double.isNaN(field[x][y].x) || Double.isNaN(field[x][y].y)) {
        dir = Vec2(1).copy() ;
      } else {
        /*
        * Need to check the position vehicle, in the case this one is in the last cell, where the spot is. 
        * If the the spot and the vehicle are in the same cell, it's necessary to return a direction very focus on spot.
        */
        /**
        this part must be improve, there is a check in list, and after there is catching pos in the list too
        may be there is solution to don't check in the list to increase the algo speed
        */
        if(check_spot(vehicle_pos)) {
          // find the good spot
          Spot s = get_spot(vehicle_pos);
          if(s.emitter_is()) {
            dir = null ;
          } else {
            Vec2 pos_cell = mult(Vec2(x,y),resolution);
            float theta = 0;
            // theta = theta(pos_cell,Vec2(s.get_pos()));
            vehicle_pos.sub(resolution *.5);
            theta = theta_2D(vehicle_pos,Vec2(s.get_pos()));

            Vec2 temp_field = Vec2(cos(theta),sin(theta));
            float force = 1 ;
            if(type == MAGNETIC) {
              force = spot_magnetic_force(s,pos_cell);
            } 

            if(type == GRAVITY) {
              force = spot_gravity_force(s,pos_cell);
            }

            temp_field.mult(force);
            dir.set(0);
            dir.add(temp_field);
          }        
        } else {
          // In most part of the cases
          // dir = field[x][y].copy();
          dir = Vec2(field[x][y].x,field[x][y].y);
        } 
      }
    }

    // reverse 
    /* 
    *the type MAGNETIC is not include because the way depend of the tesla
    */ 
    if(reverse_is && type != MAGNETIC && dir != null) {
      dir.mult(-1);
    }
    if(wind != null) dir.add(wind) ;
    return dir ;
  }



  private Spot get_spot(Vec2 vehicle_pos) {
    Spot spot = new Spot();
    if(spot_list != null) {
      for(Spot s : spot_list) {
        // check if the vehicle is in the range of the spot
        if(compare(vehicle_pos, (Vec2)s.get_pos(), Vec2(s.get_size().x, s.get_size().y).mult(2) ) ) {
          spot = s ;
          break;
        } 
      }
      return spot ;
    } else return spot;
  }


  /**
  field warp
  v 0.3.1
  Warp position
  */
  
  Vec2 field_warp(Vec2 uv, float scale) {

    int cell_x = (int) Math.floor(uv.x*NX);
    int cell_y = (int) Math.floor(uv.y*NY);

    float cell_u = (uv.x *NX -(cell_x)) *(1./NX);
    float cell_v = (uv.y *NY -(cell_y)) *(1./NY);

    // security ArrayIndexOutOfBoundsException
    // CX
    int cx = cell_x;
    int cx_sub = cell_x-1;
    int cx_add = cell_x+1;
    if(cx >= get_cols()) cx -= get_cols();
    if(cx_sub < 0) cx_sub = get_cols()+cx_sub;
    if(cx_add >= get_cols()) cx_add -= get_cols();
    
    // CY
    int cy = cell_y;
    int cy_sub = cell_y-1;
    int cy_add = cell_y+1;
    if(cy >= get_rows()) cy -= get_rows();
    if(cy_sub < 0) cy_sub = get_rows()+cy_sub;
    if(cy_add >= get_rows()) cy_add -= get_rows();

    // compute
    Vec2 result = Vec2();

    result.x = (cell_u > .5)? 
    lerp(field[cx][cy].x, field[cx_add][cy].x, cell_u-.5) : 
    lerp(field[cx_sub][cy].x, field[cx][cy].x, .5-cell_u);

    result.y = (cell_v > .5)? 
    lerp(field[cx][cy].y, field[cx][cy_add].y, cell_u) : 
    lerp(field[cx][cy].y, field[cx][cy_sub].y, .5-cell_v);

    result.mult(-scale).add(uv);

    return result;
  }
  





  /**
  update spot
  */
  private void manage_spot_mag() {
    int total_sub_list = spot_mag_north_list.size() + spot_mag_south_list.size() + spot_mag_neutral_list.size() ;
    if(total_sub_list < spot_list.size()) {
      for(Spot s : spot_list) {
        if(s.get_tesla() > 0 && total_sub_list < spot_list.size()) {
          spot_mag_north_list.add(s) ;
          total_sub_list++ ;
        }
        if(s.get_tesla() < 0 && total_sub_list < spot_list.size()) {
          spot_mag_south_list.add(s) ;
          total_sub_list++ ;
        }
      }
    }  
  }


  private void manage_spot_fluid() {
    int which_one = 0 ;
    for(Spot s : spot_list) {
      update_fluid_spot(ns_2D, s.get_pos(), which_one);
      update_fluid_spot_ref(ns_2D, s.get_pos(), which_one);
      which_one++;
    }
  }




  private void update_fluid_spot_ref(Navier_Stokes n, Vec pos_ref, int which_one) {
    // init
    if(spot_fluid_pos_ref == null) {
      spot_fluid_pos_ref = new ArrayList<Vec>();
    }
    // rebuilt ref list if necessary, in case the spot num change
    if(spot_fluid_pos_ref.size() != spot_list.size()) {
      spot_fluid_pos_ref.clear();
      for(Spot s : spot_list) {
        Vec pos = Vec2(s.get_pos());
        spot_fluid_pos_ref.add(pos);
      }
    }

    if(n instanceof Navier_Stokes_2D) {
      spot_fluid_pos_ref.set(which_one, Vec2(pos_ref));
    } else if(n instanceof Navier_Stokes_3D) {
      spot_fluid_pos_ref.set(which_one, Vec3(pos_ref));
    }   
  }


  private Vec get_spot_fluid_ref(int which_one) {
    return spot_fluid_pos_ref.get(which_one);
  }



  /**
  Navier-stokes method
  */
  /**
  update_fluid_spot
  v 0.2.1
  */
  private void update_fluid_spot(Navier_Stokes n, Vec spot_pos, int which_one) {
    if(n instanceof Navier_Stokes_2D) {
      Navier_Stokes_2D ns = (Navier_Stokes_2D)n;
      Vec2 c = Vec2(canvas);
      Vec2 c_pos = Vec2(canvas_pos);
      Vec2 target = Vec2(spot_pos);
      update_fluid_spot_2D(ns, target, c, c_pos, which_one);
    } else if(n instanceof Navier_Stokes_3D) {
      Navier_Stokes_3D ns = (Navier_Stokes_3D)n;
      Vec3 target = Vec3(spot_pos);
      Vec3 c = Vec3(canvas);
      Vec3 c_pos = Vec3(canvas_pos);
      update_fluid_spot_3D(ns, target, c, c_pos, which_one);     
    }
  }





  
  private void update_fluid_spot_2D(Navier_Stokes_2D ns, Vec2 target, Vec2 canvas, Vec2 canvas_pos, int which_one) {
    Vec2 pos_ref_2D = Vec2();
    if(spot_fluid_pos_ref != null || reset_ref_spot_pos_list_is.get(which_one)) {
      pos_ref_2D = Vec2(get_spot_fluid_ref(which_one));
      reset_ref_spot_pos_list_is.set(which_one,false);
    } 
    
    Vec2 vel = sub(target, pos_ref_2D);

    Vec2 cell = canvas.div(ns.get_NX(),ns.get_NY());
    iVec2 target_cell = floor(div(target,cell));

    vel.x = (abs(vel.x) > limit_vel)? 
    Math.signum(vel.x) *limit_vel : 
    vel.x;
    vel.y = (abs(vel.y) > limit_vel)? 
    Math.signum(vel.y) *limit_vel : 
    vel.y;
    ns.apply_force(target_cell.x, target_cell.y, vel.x, vel.y);
  }
  
  private void update_fluid_spot_3D(Navier_Stokes_3D ns, Vec3 target, Vec3 canvas, Vec3 canvas_pos, int which_one) {
    Vec3 pos_ref_3D = Vec3();
    /*
    if(pos_ref_3D == null || reset_ref_spot_pos_list_is.get(which_one)) {
      pos_fluid_spot_ref(target);
      reset_ref_spot_pos_list_is.set(which_one,false);
    } 
    */

    Vec3 cell = canvas.div(ns.get_N());
    Vec3 vel = sub(target, pos_ref_3D);
    iVec3 target_cell = floor(div(target,cell));

    vel.x = (abs(vel.x) > limit_vel)? 
    Math.signum(vel.x) *limit_vel : 
    vel.x;
    vel.y = (abs(vel.y) > limit_vel)? 
    Math.signum(vel.y) *limit_vel : 
    vel.y;
    vel.z = (abs(vel.z) > limit_vel)? 
    Math.signum(vel.z) *limit_vel : 
    vel.z;

    ns.apply_force(target_cell.x, target_cell.y, target_cell.z, vel.x, vel.y, vel.z);

    pos_ref_3D.set(target);
  }



  /**
  end Navier-stokes method
  */





  /**
  util v 0.0.3.1
  library private methods
  */
  /**
  magnetic force
  v 0.0.2
  */
  /**
  * spot_magnetic_force
  * @return float magnetic force
  */
  private float spot_magnetic_force(Spot s, Vec2 pos_cell) {
    Vec2 spot_pos = Vec2(s.get_pos());
    float dist = dist(spot_pos, pos_cell);
    int tesla_charge = s.get_tesla();
    return intensity(dist, tesla_charge);
  }
    /*
  * intensity
  * very simple formula, not real one :(
  */
  private float intensity(float dist, int tesla) {
    float l = sqrt((get_canvas().x *get_canvas().x) + (get_canvas().y * get_canvas().y));
    float d = constrain(dist, 1, 2 *l) ;
    float speed = .05;
    float distance = 1 /d *speed;
    return distance *tesla *l *.02;
  }

  /**
  gravity force
  v 0.0.1
  */
  /** 
  * spot_gravity_force
  * @return float gravity force
  */
  private float spot_gravity_force(Spot s, Vec2 pos_cell) {
    Vec2 spot_pos = Vec2(s.get_pos());
    float m_2 = s.get_mass() ;
    float m_1 = mass_field ;
    float dist = dist(spot_pos, pos_cell);
    double gravity = 1. / (g_force(dist, m_1, m_2) *1000000000L);
    return (float)gravity;
  }
  

  /**
  util misc
  */
  /*
  * theta v 0.3.0
  * compute angle to vectorial direction
  */
  private float theta_2D(Vec2 current_coord, Vec2 target) {
    Vec2 current_cell_pos = current_coord.copy() ;
    current_cell_pos.add(resolution *.5);
    Vec2 dir = look_at(current_cell_pos, target);
    // why multiply by '-1' it's a mistery
    return -1 *dir.angle();
  }


  /*
  used to know if the vehicle is the area of any spot
  */
  private boolean check_spot(Vec2 vehicle_pos) {
    Boolean in_area_spot = false ;
    if(spot_list != null) {
      for(Spot s : spot_list) {
        // check if the vehicle is in the range of the spot
        if(s.get_pos() != null && s.get_size() != null) {
          if(compare(vehicle_pos, (Vec2)s.get_pos(), Vec2(s.get_size().x, s.get_size().y).mult(2) ) ) {
            in_area_spot = true ;
            break;
          } 
        }
      }
    }
    return in_area_spot ;
  }
  
  /*
  * calm down
  * not used
  */
  /*
  private Vec2 calm_down(Vec2 state_vector) {
    state_vector.mult(calm);
    return state_vector;
  }
  */
  

/**
end
*/
}















/**
  SPOT private under-class
  v 0.1.3
  */
  public class Spot {
    private Vec pos, raw_pos, size;
    private boolean reverse_charge_is;
    private boolean emitter_is;

    private int tesla = 0;
    private int mass = 0;
    
    // constructor
    public Spot() {}



    // set
    public void set_pos(Vec pos) {
      if(pos instanceof Vec2) {
        this.pos = Vec2((Vec2)pos);
      } else if(pos instanceof Vec3) {
        this.pos = Vec3((Vec3)pos);
      }
    }


    public boolean emitter_is() {
      if(get_tesla() < 0 || emitter_is) return true ; else return false;
    }

    public void reverse_emitter(boolean state) {
      this.emitter_is = state ;
    }
    
    public void set_raw_pos(Vec raw_pos) {
      if(raw_pos instanceof Vec2) {
        this.raw_pos = Vec2((Vec2)raw_pos);
      } else if(pos instanceof Vec3) {
        this.raw_pos = Vec3((Vec3)raw_pos);
      }
    }

    public void set_size(Vec size) {
      if(size instanceof Vec2) {
        this.size = Vec2((Vec2)size);
      } else if(size instanceof Vec3) {
        this.size = Vec3((Vec3)size);
      }
    }

    public void reverse_charge(boolean reverse_is) {
      this.reverse_charge_is = reverse_is ;

    }

    public void set_tesla(int tesla) {
      this.tesla = tesla ;
    }

    public void set_mass(int mass) {
      this.mass = abs(mass) ;
    } 

    // get
    public int get_mass() {
      return mass;
    }

    public int get_tesla() {
      if(!reverse_charge_is) return tesla; else return -tesla ;
    }

    public Vec get_pos() {
      return pos;
    }

    public Vec get_raw_pos() {
      return raw_pos;
    }

    public Vec get_size() {
      return size;
    }

  }

























