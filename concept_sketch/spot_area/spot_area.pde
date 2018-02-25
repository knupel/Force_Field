int [][] field ;
int cols, rows;
int cell_size = 5 ;

Spot spot ;


void setup() {
  // fullScreen();
  size(800,800);
  int radius = 10 ;
  spot = new Spot(radius);
  println(spot.area.size());
  
  cols = width /cell_size;
  rows = height /cell_size;
  field = new int[cols][rows];
  for(int x = 0 ; x < cols ; x++) {
    for(int y = 0 ; y < rows ; y++) {
      field [x][y] = color(random(g.colorModeX),random(g.colorModeX),random(g.colorModeX));
      fill(field [x][y]);
      noStroke();
      rect(x *cell_size,y *cell_size,cell_size,cell_size);
    }
  }
}



void draw() {
  println("frameRate",(int)frameRate);
  spot.update(mouseX/cell_size,mouseY/cell_size);
  float radius = abs(sin(frameCount *.01))*50 ;
  println("radius",(int)radius);
  spot.area(ceil(radius));

  // draw area spot
  for(iVec iv : spot.area ) {
    fill(g.colorModeX,abs(sin(frameCount *.02)) *g.colorModeX,0, 5);
    noStroke();
    int temp_x = iv.x +spot.get_x() ;
    int temp_y = iv.y +spot.get_y() ;
    rect(temp_x *cell_size,temp_y *cell_size,cell_size,cell_size);
  }
  
    

  // draw spot
 fill(255);
 noStroke();
 rect(spot.get_x() *cell_size,spot.get_y() *cell_size,cell_size,cell_size);


  if(mousePressed) {
    for(int x = 0 ; x < cols ; x++) {
      for(int y = 0 ; y < rows ; y++) {
        fill(field [x][y]);
        noStroke();
        rect(x *cell_size,y *cell_size,cell_size,cell_size);
      }
    }
  }
}







class Spot {
  int x, y ;
  ArrayList<iVec2> area ;
  Spot(int radius) {
    area(radius);
  }

  void area(int radius) {
    if(area == null) {
      area = new ArrayList<iVec2>(); 
      add(radius);
    } else {
      println("clear");
      area.clear();
      println(area.size());
      add(radius);
    }
    
  }

  void add(int radius) {
    for(int x = -radius ; x <= radius ; x++) {
      for(int y = -radius ; y <= radius ; y++) {
        if(inside(Vec2(0), Vec2(radius), Vec2(x,y), ELLIPSE)) {
          iVec2 in = iVec2(x,y);
          area.add(in);
        }  
      }
    }
  }

  void update(int x, int y) {
    this.x = x;
    this.y = y;
  }

  int get_x() {
    return x ;
  }
  int get_y() {
    return y ;
  }
}