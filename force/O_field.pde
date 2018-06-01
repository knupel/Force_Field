/**
show vector field
v 0.2.1
*/
void show_custom_field() {
  float scale = (height/10) *get_length_field();
  int c = r.RED;
  if(colour_field == 0) c = r.HUE;
  else if (colour_field == 1) c = r.WHITE;
  else if (colour_field == 2) c = r.BLACK;
  else if (colour_field == 3) c = r.RED;
  else if (colour_field == 4) c = r.ORANGE;
  else if (colour_field == 5) c = r.YELLOW;
  else if (colour_field == 6) c = r.GREEN;
  else if (colour_field == 7) c = r.CYAN;
  else if (colour_field == 8) c = r.BLUE;
  else if (colour_field == 9) c = r.PURPLE;
  else if (colour_field == 10) c = r.MAGENTA;
  else if (colour_field == 11) c = r.HUE;
 
  float min_c = colour_field_min; 
  float max_c = colour_field_max; 
  boolean reverse_c = false;
  strokeWeight(get_thickness_field());
  set_show_field(scale,c,get_alpha_field(),min_c,max_c,reverse_c);
  show_field(get_ff());
}



float scale_show_vff = 5;
int colour_vff;
float alpha_vff;
boolean reverse_value_colour_vff;
float min_range_colour_vff = 0.;
float max_range_colour_vff = .7;

void set_show_field(float scale, int colour_constant, float alpha,float min, float max, boolean reverse_colour) {
  scale_show_vff = scale;
  set_range_colour_field(min,max);
  colour_field(colour_constant,alpha);
  reverse_color_field(reverse_colour);
}


void colour_field(int c, float a) {
  colour_vff = c;
  alpha_vff = a;
}

void set_range_colour_field(float min, float max) {
  min_range_colour_vff = min;
  max_range_colour_vff = max;
}


void reverse_color_field(boolean state) {
  reverse_value_colour_vff = state;
}

void show_field(Force_field ff) {
  float scale = scale_show_vff;
  if(ff != null) {
    Vec2 offset = Vec2(ff.get_canvas_pos()) ;
    offset.sub(ff.get_resolution()/2);
    //
    for (int x = 0; x < ff.cols; x++) {
      for (int y = 0; y < ff.rows; y++) {
        Vec2 pos = Vec2(x *ff.get_resolution(), y *ff.get_resolution());
        Vec2 dir = Vec2(ff.field[x][y].x,ff.field[x][y].y);
        if(ff.get_super_type() == r.STATIC) {
          float mag = ff.field[x][y].w;
          pattern_field(dir, mag, pos, ff.resolution *scale);
        } else {
          pos.add(offset);
          float mag = (float)Math.sqrt(dir.x*dir.x + dir.y*dir.y + dir.z*dir.z); ;
          pattern_field(dir, mag, pos, ff.resolution *scale);
        }
      }
    }
  }  
}

// Renders a vector object 'v' as an arrow and a position 'x,y'
void pattern_field(Vec2 dir, float mag, Vec2 pos, float scale) {
  Vec5 colorMode = Vec5(getColorMode());
  colorMode(HSB,1);

  pushMatrix();
  // Translate to position to render vector
  translate(pos);
  // Call vector heading function to get direction (note that pointing to the right is a heading of 0) and rotate
  rotate(dir.angle());
  // Calculate length of vector & scale it to be dir_vector or smaller if dir_vector
  float len = mag *scale;
  float min = min_range_colour_vff;
  float max = max_range_colour_vff;

  float value = map(abs(len), 0, scale,max,min);
  if(reverse_value_colour_vff) {
    value = 1-value ;
  }

  

  if(colour_vff == r.HUE) {
    stroke(value,1,1,alpha_vff);
  } else if(colour_vff == r.WHITE) {
    stroke(0,0,value,alpha_vff);
  } else if(colour_vff == r.BLACK) {
    stroke(0,value,0,alpha_vff);
  } else {
    float hue_val = hue(colour_vff);
    stroke(hue_val,1,value,alpha_vff);
  }

  if(len > scale) len = scale ;
  line(0,0,len,0);

  popMatrix();

  colorMode(colorMode);
}