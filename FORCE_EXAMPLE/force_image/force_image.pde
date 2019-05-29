/**
* FORCE by Stan le Punk
* 2017-2019
* @see https://github.com/StanLepunK/Force_Field
* @see http://stanlepunk.xyz/
* Processing 3.5.3
* Rope Library 0.8.1
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
  ivec2 canvas_pos = ivec2(0);

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
    vec2 offset = vec2(ff.get_resolution());
    offset.sub(ff.get_resolution()/2);
    //
    for (int x = 0; x < ff.cols; x++) {
      for (int y = 0; y < ff.rows; y++) {
        vec2 pos = vec2(x *ff.get_resolution(), y *ff.get_resolution());
        vec2 dir = vec2(ff.field[x][y].x,ff.field[x][y].y);
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
private void pattern_field(vec2 dir, float mag, vec2 pos, float scale, float range_colour, int c,float thickness) {
  int color_mode_ref = (int)getColorMode()[0];
  vec4 color_arg_ref = vec4(getColorMode()[1],getColorMode()[2],getColorMode()[3],getColorMode()[4]);
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

  colorMode(color_mode_ref,color_arg_ref.red(),color_arg_ref.gre(),color_arg_ref.blu(),color_arg_ref.alp());
}






































