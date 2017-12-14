/**
show vector
v 0.0.3
*/
void show_force_field() {
  float scale = 5 ;
  boolean show_intensity_is = true;
  show_force_field(force_field, scale, show_intensity_is);
}


void show_force_field(Force_field ff, float scale, boolean show_intensity_is) {
  if(ff != null) {
    Vec2 offset = Vec2(ff.get_canvas_pos()) ;
    offset.sub(ff.get_resolution()/2);
    //
    for (int x = 0; x < ff.cols; x++) {
      for (int y = 0; y < ff.rows; y++) {
        Vec2 pos = Vec2(x *ff.get_resolution(), y *ff.get_resolution());
        pos.add(offset);
        pattern_force_field(ff.field[x][y], pos, ff.resolution *scale, show_intensity_is);
      }
    }
  }  
}

// Renders a vector object 'v' as an arrow and a position 'x,y'
void pattern_force_field(Vec2 dir, Vec2 pos, float scale, boolean show_intensity_is) {
  Vec5 colorMode = Vec5(getColorMode());
  colorMode(HSB,1);

  pushMatrix();
  // Translate to position to render vector
  translate(pos);
  // Call vector heading function to get direction (note that pointing to the right is a heading of 0) and rotate
  rotate(dir.angle());
  // Calculate length of vector & scale it to be dir_vector or smaller if dir_vector
  float mag = (float)Math.sqrt(dir.x*dir.x + dir.y*dir.y + dir.z*dir.z);
  float len = dir.mag() *scale;
  float blue = .7 ;
  float red = 0 ;
  float hue = map(abs(len), 0, scale,blue,red);
  stroke(hue, 1,1,1);
  // Draw three lines to make an arrow (draw pointing up since we've rotate to the proper direction)
  line(0,0,len,0);

  popMatrix();

  colorMode(colorMode);
}