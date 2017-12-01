import controlP5.*;
ControlP5 cp5;

float red_channel ;
float green_channel ;
float blue_channel ;
float alpha_channel ;

float power_channel;

Vec4 rgba_slider ;
float power_max ;


float slider_width = 100 ;


void interface_setup() {
	rgba_slider = Vec4();
	red_channel = 25;
	green_channel = 25;
	blue_channel = 25;
	alpha_channel = 25;
	int space = 10;
	cp5 = new ControlP5(this);
	cp5.addSlider("red_channel").setPosition(10,space).setRange(0,slider_width);
	cp5.addSlider("green_channel").setPosition(10,space*3).setRange(0,slider_width);
	cp5.addSlider("blue_channel").setPosition(10,space*5).setRange(0,slider_width);
	cp5.addSlider("alpha_channel").setPosition(10,space*7).setRange(0,slider_width);

	cp5.addSlider("power_channel").setPosition(10,space*9).setRange(0,slider_width);
}

void catch_slider_value() {

	float r = red_channel / slider_width;
	float g = green_channel / slider_width;
	float b = blue_channel / slider_width;
	float a = alpha_channel / slider_width;
	rgba_slider.set(r,g,b,a);

	power_max = power_channel /slider_width *10f;
}


