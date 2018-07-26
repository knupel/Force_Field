/**
Leap motion implementation
* Copyleft (c) 2014-2017 
* @see http://stanlepunk.xyz/
2014 – 2017
v 1.0.1
*/
import com.leapmotion.leap.*; 
com.leapmotion.leap.Controller leap;


class FingerLeap {
  //global
  private float speed = .05 ;
  // Minimum value to accept finger in the count. The value must be between 0 to 1 ;
  private float minValueToCountFinger = .95 ; 
  // range value around the first finger to accepted in the finger count 
  private float rangeAroundTheFirstFinger = .2 ;
  //check if the fingers is present or no
  private boolean fingerCheck ;
  private boolean [] fingerVisible ;
  //for each finger
  private int num ;
  private int activefingers ;
  private int [] ID ;
  private int [] IDleap ;
  private Vec3 [] pos ;
  private Vec3 [] dir ;
  private float [] magnitude, roll, pitch, yaw ;
  
  // average data
  private Vec3 average_pos, average_dir ;
  private Vec3 add_pos ;
  private float rangeMin = 0 ; 
  private float rangeMax = 0 ;
  private Vec3 findAveragePos = Vec3() ;
  
  FingerLeap() {
    leap = new com.leapmotion.leap.Controller();
    init_var();
  }

  private void init_var() {
    if(average_pos == null) average_pos = Vec3() ;
    if(average_dir == null) average_dir = Vec3() ;
    if(add_pos == null) add_pos = Vec3() ;
  }
  
  
  public void update() {
    InteractionBox iBox = leap.frame().interactionBox();
    PointableList objectNum = leap.frame().pointables();
    //check finger
    fingerCheck = !objectNum.isEmpty() ;
    // create and init var ;
    num = objectNum.count() ;
    IDleap = new int[num] ;
    ID = new int[num] ;
    activefingers = 0 ;
    fingerVisible = new boolean [num] ;
    pos = new Vec3[num] ;
    dir = new Vec3[num] ;
    magnitude = new float [num] ; 
    roll= new float [num] ; 
    pitch= new float [num] ; 
    yaw = new float [num] ;
    
    // give info to variables for each finger display or not
    for (int i = 0; i < objectNum.count(); i++) {
      
      //initialization
      Pointable object = objectNum.get(i);
      com.leapmotion.leap.Vector normalPos = iBox.normalizePoint(object.stabilizedTipPosition());
      fingerVisible[i] = false ;
      
      // catch info
      IDleap[i] = object.id() ;
      ID[i] = i  ;
      // return normal position value between 0 to 1 
      pos[i] = Vec3(normalPos.getX(),normalPos.getY(),normalPos.getZ()) ;
      // return normal direction between - 1 to 1
      dir[i] = Vec3(normalPos.getX() *2 -1.0, normalPos.getY() *2 -1.0, normalPos.getZ() *2 -1.0 ) ;
      
      // misc value
      magnitude[i] = normalPos.magnitude() ; 
      roll[i] = normalPos.roll() ; 
      pitch[i] = normalPos.pitch() ; 
      yaw[i] = normalPos.yaw() ;
      
      
      //Find average position of all visible fingers
      find_average_position(pos[i], i) ; 
    }
    // write the result
    average_pos.set(average_pos(add_pos)) ;
    average_dir = Vec3(average_pos.x *2 -1.0, average_pos.y *2 -1.0,average_pos.z *2 -1.0) ;
  }
  
  
  
  // ANNEXE
  
  //check if the finger is visible or not
  private void find_average_position(Vec3 norm_pos, int whichOne) {
    if(activefingers < 1) {
      if(norm_pos.z < minValueToCountFinger) {
        add_pos = norm_pos.copy() ;
        rangeMin = add_pos.z -rangeAroundTheFirstFinger ; 
        rangeMax = add_pos.z +rangeAroundTheFirstFinger ;
        activefingers += 1 ;
        fingerVisible[whichOne] = true ;
      }
    // if there is one finger, we compare if the others are close of the firsts fingers  
    } else {
      // check if the next finger is in the range
      if(norm_pos.z > rangeMin && norm_pos.z < rangeMax) {
        // create a range from the average position Z
        rangeMin = add_pos.z -rangeAroundTheFirstFinger ; 
        rangeMax = add_pos.z +rangeAroundTheFirstFinger ;
        // check if the finger detected is in the range or not, we must do that because the detection of the finger is not perfect and add finger when the hand is deepness in detector
        // if it's ok we add a visible finger in the count
        // check if the finger detected is in the range or not, we must do that because the detection of the finger is not perfect and add finger when the hand is deepness in detector
        activefingers += 1 ;
        // if it's ok we add value
        add_pos.add(norm_pos.x,norm_pos.y,norm_pos.z) ;
        // after we divide by 2 because we've added a value at the end of this checking.
        add_pos.div(2) ;
        fingerVisible[whichOne] = true ;
      }
    } 
  }
  /**
  set
  */
  void set_speed(float speed) {
    this.speed = speed;
  }

  /**
  get
  */

  public int [] get_ID() {
    return ID;
  }
  public boolean is() {
    return fingerCheck ;
  }

  public boolean [] visible() {
    return fingerVisible;
  }

  public Vec3 [] get_pos() {
    return pos;
  }

  public Vec3 [] get_dir() {
    return dir;
  }

  public float [] get_mag() {
    return magnitude;
  }

  public float [] get_roll() {
    return roll;
  }

  public float [] get_pitch() {
    return pitch;
  }

  public float [] get_yaw() {
    return yaw;
  }

  public Vec3 get_average_pos() {
    return average_pos;
  }

  public Vec3 get_average_dir() {
    return average_dir;
  }

  public int get_num() {
    return num ;
  }


  
  
  // Function to calcul the average position and smooth this one
  private Vec3 average_pos(Vec3 target) {
    /*
    Average position of all visible fingers
    Finalize the calcule, and dodge the bad value
    */
    if(target.x > 1.0) target.x /= 2.0 ;
    if(target.y > 1.0) target.y /= 2.0 ;
    if(target.z > 1.0) target.z /= 2.0 ;
    //smooth the result
    return follow(target, speed) ;
  }
}