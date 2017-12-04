import controlP5.*;
ControlP5 cp5;

float red_channel ;
float green_channel ;
float blue_channel ;

float red_cycling ;
float green_cycling ;
float blue_cycling ;

boolean abs_cycling = true ;

float tempo_refresh;

float power_channel;


float power_channel_max ;

int slider_width = 100 ;


void interface_setup() {
	rgba_channel = Vec4(1);
	red_channel = .15;
	green_channel = .15;
	blue_channel = .15;

	red_cycling = 0;
	green_cycling = 0;
	blue_cycling = 0;

	power_channel = .1;
	int space = 8;
	int max = 1;
	cp5 = new ControlP5(this);
	cp5.addSlider("red_channel").setPosition(10,space).setWidth(slider_width).setRange(0,max);
	cp5.addSlider("green_channel").setPosition(10,space*3).setWidth(slider_width).setRange(0,max);
	cp5.addSlider("blue_channel").setPosition(10,space*5).setWidth(slider_width).setRange(0,max);

	cp5.addSlider("power_channel").setPosition(10,space*7).setWidth(slider_width).setRange(0,max);

	cp5.addSlider("red_cycling").setPosition(10,space*10).setWidth(slider_width).setRange(0,max);
	cp5.addSlider("green_cycling").setPosition(10,space*12).setWidth(slider_width).setRange(0,max);
	cp5.addSlider("blue_cycling").setPosition(10,space*14).setWidth(slider_width).setRange(0,max);
	cp5.addButton("absolute_cycling").setValue(0).setPosition(10,space*16).setSize(slider_width,10);

	cp5.addSlider("tempo_refresh").setPosition(10,space*19).setWidth(slider_width).setRange(0,max).setNumberOfTickMarks(20);
}



Vec4 rgba_channel ;
int tempo_display ;
void interface_value() {
  float cr = 1.;
  float cg = 1.;
  float cb = 1.;
  if(red_cycling != 0) {
  	cr = sin(frameCount *(red_cycling *red_cycling *.1)); 
  } else red_cycling = 1. ;
  if(green_cycling != 0) {
  	cg = sin(frameCount *(green_cycling *green_cycling *.1)); 
  } else green_cycling = 1. ;
  if(blue_cycling != 0) {
  	cb = sin(frameCount *(blue_cycling *blue_cycling *.1)); 
  } else blue_cycling = 1. ;

  if(abs_cycling) {
  	cr = abs(cr) ;
  	cg = abs(cg) ;
  	cb = abs(cb) ;
  }

  Vec4 sin_val = Vec4(1);
  sin_val.set(cr,cg,cb,1);


	rgba_channel.set(red_channel,green_channel,blue_channel,1);
	power_channel_max = (power_channel *power_channel)  *10f;
  
	rgba_channel.mult(power_channel_max);
	
	rgba_channel.set(sin_val.map_vec(Vec4(0), Vec4(1), Vec4(.01), rgba_channel));
	// rgba_channel.mult(red_cycling,green_cycling,blue_cycling,1);
	// println(rgba_channel);




	tempo_display = int(tempo_refresh *10 +1);


	if(!interface_is()) { 
		cp5.hide() ; 
	} else {
		cp5.show();
		fill(0,125);
		noStroke();
		rect(0,0,200,height);
	}
}


public void controlEvent(ControlEvent theEvent) {
  if(theEvent.getController().getName().equals("absolute_cycling")){
  	if(abs_cycling) {
  		abs_cycling = false ; 
  	} else {
  		abs_cycling = true ;
  	}
  	println(abs_cycling);
  }
}





void hide_interface() {
	if(interface_is) interface_is = false ; else interface_is = true;
}


boolean interface_is = false;
boolean interface_is() {
	return interface_is ;
}




