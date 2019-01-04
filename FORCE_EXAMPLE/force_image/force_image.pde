/**
* FORCE by Stan le Punk
* 2017-2019
* @see https://github.com/StanLepunK/Force_Field
* @see http://stanlepunk.xyz/
* Processing 3.4
* Inspiration
Force Field is a deep refactoring Flow field from The Nature of Code by Daniel Shiffman
* @see http://natureofcode.com
* Flow Field Following / Force Field / Vector field 
* the link below is not up to date
* Via Reynolds:
* @see http://www.red3d.com/cwr/steer/FlowFollow.html
* Stable fluids from Jos Stam's work on the Navier-Stokes equation
*/


/**
Warp is the way to use the force field to change the pixel place
*/
PImage img;
Force_field force_field;

void setup() {
  size(125,125,P3D);
  img = loadImage("small_puros_girl.jpg");
  surface.setSize(img.width,img.height);
  iVec2 canvas_pos = iVec2(0);

  force_field = new Force_field(5,canvas_pos,img,r.HUE);

}



void draw() {
  // println((int)frameRate);
  // SHOW
  background(0);
  image(img); // image loading by default
  
  show_force_field(3);
}













/**
SHOW FORCE FIELD
*/
void show_force_field(int size_vector) {
  float range_colour_vector = .5; // normal value
  int colour = r.RED;
  float stroke_weight = 1;
  show_field(force_field,size_vector,range_colour_vector,colour,stroke_weight);
}


private void show_field(Force_field ff, float scale, float range_colour, int colour, float thickness) {
  if(ff != null) {
    Vec2 offset = Vec2(ff.get_resolution());
    offset.sub(ff.get_resolution()/2);
    //
    for (int x = 0; x < ff.cols; x++) {
      for (int y = 0; y < ff.rows; y++) {
        Vec2 pos = Vec2(x *ff.get_resolution(), y *ff.get_resolution());
        Vec2 dir = Vec2(ff.field[x][y].x,ff.field[x][y].y);
        if(ff.get_super_type() == r.STATIC) {
          float mag = ff.field[x][y].w;
          pattern_field(dir, mag, pos, ff.resolution *scale,range_colour,colour,thickness);
        } else {
          pos.add(offset);
          float mag = (float)Math.sqrt(dir.x*dir.x + dir.y*dir.y + dir.z*dir.z); ;
          pattern_field(dir, mag, pos, ff.resolution *scale,range_colour,colour,thickness);
        }
      }
    }
  }  
}

// Renders a vector object 'v' as an arrow and a position 'x,y'
private void pattern_field(Vec2 dir, float mag, Vec2 pos, float scale, float range_colour, int c,float thickness) {
  Vec5 colorMode = Vec5(getColorMode());
  colorMode(HSB,1);

  pushMatrix();
  // Translate to position to render vector
  translate(pos);
  // Call vector heading function to get direction (note that pointing to the right is a heading of 0) and rotate
  rotate(dir.angle());
  // Calculate length of vector & scale it to be dir_vector or smaller if dir_vector
  float len = mag *scale;

  float max = range_colour *mag;

  float hue = hue(c)+max;
  if(hue >= g.colorModeX) hue -= g.colorModeX;
  if(hue < 0) hue = (g.colorModeX +hue);
  float sat = saturation(c);
  float bright = brightness(c);
  float alpha = alpha(c);
  
  strokeWeight(thickness);
  noFill();
  stroke(hue,sat,bright,alpha);

  if(len > scale) len = scale ;
  line(0,0,len,0);

  popMatrix();

  colorMode(colorMode);
}






































