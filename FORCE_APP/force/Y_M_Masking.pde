/**
class Mask_mapping
v 0.0.2
2018-2018
*/
public class Masking {
  private ivec3 [] coord;
  private ivec3 [] coord_block_1, coord_block_2, coord_block_3, coord_block_4;
  private boolean init;
  private boolean block_is;
  private int c = r.BLACK;
  private int range = 10;

  public Masking(ivec2 [] list) {
    coord = new ivec3[list.length];
    for(int i = 0 ; i < coord.length ;i++) {
      coord[i] = ivec3(list[i].x,list[i].y,0);
    }
    init = true;
  }
  
  public ivec2 [] get_coord() {
    return ivec3_coord_to_ivec2_coord(coord) ;
  }

  public ivec2 [] get_coord_block_1() {
    return ivec3_coord_to_ivec2_coord(coord_block_1) ;
  }

  public ivec2 [] get_coord_block_2() {
    return ivec3_coord_to_ivec2_coord(coord_block_2) ;
  }

  public ivec2 [] get_coord_block_3() {
    return ivec3_coord_to_ivec2_coord(coord_block_3) ;
  }

  public ivec2 [] get_coord_block_4() {
    return ivec3_coord_to_ivec2_coord(coord_block_4) ;
  }

  private ivec2 [] ivec3_coord_to_ivec2_coord(ivec3 [] target) {
    if(target != null) {
      ivec2 [] list = new ivec2[target.length];
      for(int i = 0 ; i < list.length ; i++) {
        list[i] = ivec2(target[i].x,target[i].y);
      }
      return list;
    } else return null;
  }

  public Masking(ivec2 [] list, ivec2 [] list_block_1, ivec2 [] list_block_2, ivec2 [] list_block_3, ivec2 [] list_block_4) {
    if(list.length != 8) {
      printErr("class Mask_mapping need exactly 8 points to create a block, no more no less, there is",list.length,"in the list, no mask can be create");
    } else {
      block_is = true ;
      coord = new ivec3[list.length];
      for(int i = 0 ; i < coord.length ;i++) {
        coord[i] = ivec3(list[i].x,list[i].y,0);
      }
      // block 1
      if(list_block_1 != null && list_block_1.length > 0) {
        coord_block_1 = new ivec3[list_block_1.length];
        for(int i = 0 ; i < coord_block_1.length ;i++) {
          coord_block_1[i] = ivec3(list_block_1[i].x,list_block_1[i].y,0);
        }
      }
      // block 2
      if(list_block_2 != null && list_block_2.length > 0) {
        coord_block_2 = new ivec3[list_block_2.length];
        for(int i = 0 ; i < coord_block_2.length ;i++) {
          coord_block_2[i] = ivec3(list_block_2[i].x,list_block_2[i].y,0);
        }
      }
      // block 3
      if(list_block_3 != null && list_block_3.length > 0) {
        coord_block_3 = new ivec3[list_block_3.length];
        for(int i = 0 ; i < coord_block_3.length ;i++) {
          coord_block_3[i] = ivec3(list_block_3[i].x,list_block_3[i].y,0);
        }
      }
      // block 4
      if(list_block_4 != null && list_block_3.length > 0) {
        coord_block_4 = new ivec3[list_block_4.length];
        for(int i = 0 ; i < coord_block_4.length ;i++) {
          coord_block_4[i] = ivec3(list_block_3[i].x,list_block_4[i].y,0);
        }
      }
    }
    init = true;
  }

  public void set_fill(int c) {
    this.c = c;
  }



  public void draw(boolean modify_is) {
    if(init) {
      if(modify_is) {
        fill(r.RED);
      } else {
        fill(c);
      }
      noStroke();
      if(block_is) {
        draw_shape(coord, coord_block_1, coord_block_2, coord_block_3, coord_block_4);
        if(modify_is) {
          show_point(coord);
          move_point(coord);
          if(coord_block_1 != null) {
            show_point(coord_block_1);
            move_point(coord_block_1);
          }
          if(coord_block_2 != null) {
            show_point(coord_block_2);
            move_point(coord_block_2);
          }
          if(coord_block_3 != null) {
            show_point(coord_block_3);
            move_point(coord_block_3);
          }
          if(coord_block_4 != null) {
            show_point(coord_block_4);
            move_point(coord_block_4);
          }
        }
      } else {
        draw_shape(coord);
        if(modify_is) {
          show_point(coord);
          move_point(coord);
        }
      }
      
    } else {
      printErr("class Mask_mapping(), must be iniatilized with an array list ivec2 [] coord)");
    }
  }
  private void show_point(ivec3 [] list) {
    for(ivec3 iv : list) {
      stroke(r.WHITE);
      strokeWeight(range);
      point(iv);
    }
  }
  private boolean drag_is = false ;
  private void move_point(ivec3 [] list) {
    if(!drag_is) {
      for(ivec3 iv : list) {
        ivec2 drag = ivec2(mouseX,mouseY);
        ivec2 area = ivec2(range);
        if(inside(drag,area,ivec2(iv.x,iv.y)) && iv.z == 0) {
          if(mousePressed) {
            iv.set(iv.x,iv.y,1);
            drag_is = true ;
          } else {
            // border magnetism
            if(iv.x < 0 + range) iv.x = 0 ;
            if(iv.x > width -range) iv.x = width;
            if(iv.y < 0 + range) iv.y = 0 ;
            if(iv.y > height -range) iv.y = height;
          }
        }
      }
    }
    
    for(ivec3 iv : list) {
      if(iv.z == 1) iv.set(mouseX,mouseY,1);
    }

    if(!mousePressed) {
      drag_is = false;
      for(ivec3 iv : list) {
        iv.set(iv.x,iv.y,0);
      }
    }
  }

  private void draw_shape(ivec3 [] list) {
    beginShape();
    for(int i = 0 ; i < list.length ; i++) {
      vertex(list[i]);
    }
    endShape(CLOSE);
  }

  private void draw_shape(ivec3 [] list, ivec3 [] list_b_1, ivec3 [] list_b_2, ivec3 [] list_b_3, ivec3 [] list_b_4) {
    // block 1
    beginShape();
    vertex(list[0]);
    vertex(list[1]);
    vertex(list[5]);
    if(list_b_1 != null) {
      for(int i = 0 ; i < list_b_1.length ; i++) {
        vertex(list_b_1[i]);
      }
    }
    vertex(list[4]);
    endShape(CLOSE);

    // block 2
    beginShape();
    vertex(list[1]);
    vertex(list[2]);
    vertex(list[6]);
    if(list_b_2 != null) {
      for(int i = 0 ; i < list_b_2.length ; i++) {
        vertex(list_b_2[i]);
      }
    }
    vertex(list[5]);
    endShape(CLOSE);

    // block 3
    beginShape();
    vertex(list[2]);
    vertex(list[3]);
    vertex(list[7]);
    if(list_b_3 != null) {
      for(int i = 0 ; i < list_b_3.length ; i++) {
        vertex(list_b_3[i]);
      }
    }
    vertex(list[6]);
    endShape(CLOSE);

    // block 4
    beginShape();
    vertex(list[3]);
    vertex(list[0]);
    vertex(list[4]);
    if(list_b_4 != null) {
      for(int i = 0 ; i < list_b_4.length ; i++) {
        vertex(list_b_4[i]);
      }
    }
    vertex(list[7]);
    endShape(CLOSE);
  }
}