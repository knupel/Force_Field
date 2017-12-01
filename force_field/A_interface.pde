import controlP5.*;
ControlP5 cp5;

float red_channel ;
float green_channel ;
float blue_channel ;
float alpha_channel ;

float power_channel;

Vec4 rgba_slider ;
float power_max ;

int slider_width = 100 ;


void interface_setup() {
	rgba_slider = Vec4(1);
	red_channel = 25;
	green_channel = 25;
	blue_channel = 25;
	int space = 8;
	int max = 1;
	cp5 = new ControlP5(this);
	cp5.addSlider("red_channel").setPosition(10,space).setWidth(slider_width).setRange(0,max);
	cp5.addSlider("green_channel").setPosition(10,space*3).setWidth(slider_width).setRange(0,max);
	cp5.addSlider("blue_channel").setPosition(10,space*5).setWidth(slider_width).setRange(0,max);

	cp5.addSlider("power_channel").setPosition(10,space*9).setWidth(slider_width).setRange(0,max);
}

void slider_value() {

	float r = red_channel;
	float g = green_channel ;
	float b = blue_channel;
	rgba_slider.set(red_channel,green_channel,blue_channel,1);

	power_max = power_channel  *10f;

	if(!interface_is()) cp5.hide() ; else cp5.show();
}





void hide_interface() {
	if(interface_is) interface_is = false ; else interface_is = true;
}


boolean interface_is = false;
boolean interface_is() {
	return interface_is ;
}




