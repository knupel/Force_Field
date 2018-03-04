Force field guide
v 0.2.0
--

FORCE FIELD class
--
Constructor
--
Force_field(int resolution, iVec2 canvas_pos, iVec2 canvas, int type, int pattern);

Force_field(int resolution, iVec2 canvas_pos, PImage img, int component_sorting_color_velocity);
component_sorting_color_velocity can be RED, GREEN, BLUE, HUE, SATURATION, BRIGHTNESS or ALPHA

constructor arguments
--
to define the type of force field, you must use constants : FLUID, CHAOS, PERLIN, GRAVITY, MAGNETIC



void ref_spot();
>make the reference position of the spot is updated, before using, can be util in case the spot make jump move !

void add_spot(int num);

void add_spot();


GET
--
Vec4 [][] get_field()
>return force_field

boolean border_is();

int get_spot_num();
>return the num of spot available

Vec2 [] get_spot_pos();

Vec2 get_spot_pos(int which_one);

Vec2 [] get_spot_size();

Vec2 get_spot_size(int which_one);

int [] get_spot_ion();

int get_spot_ion(int which_one);

float [] get_spot_mass() ;

float get_spot_mass(int which_one);
    
iVec2 get_canvas();

iVec2 get_canvas_pos();

int get_resolution();

int get_type();
>return the type of DYNAMIC of Force_field : MAGNETIC, FLUID, if it's not a DYNAMIC one type returned is STATIC like the the super_type

int get_super_type();
>return if the Force_field is from STATIC or DYNAMIC 

int get_pattern();
>return the pattern, like BLANK, PERLIN...

PImage get_tex_velocity();
>return black and white image of the velocity

PImage get_tex_direction();
>return black and white image of the direction


boolean activity_is(float threshold) {
>return true if the field has been changed
>parameter: float Threshold is step where the activity is true

boolean activity_is() {
>return true if the field has been changed

public float get_activity()
>return the sum of vector field for each frame count



SET
--
void reverse_flow(boolean state) ;
multiply the direction vector by `-1` the result : direction is opposite, this method must change the method reset() at the end of the draw() ?????


set mass field
--
set_mass_field(float mass_field);
>by default this value is '1', the value is used to caculte a field gravity for a specific object with a mass equal to '1'. because the field gravity can be different for each thing in the field, so that can be very hard to compute...this value is used with the mass spot to calculate the g_force() when the the type of field is 'HOLE'

set canvas
--
void set_canvas(iVec pos, iVec size);

void set_canvas_pos(iVec pos);

void set_canvas_size(iVec size);


set spot
--
void set_spot(iVec pos, iVec size);

void set_spot(iVec pos, iVec size, int which_one);

void set_spot(int pos_x, int pos_y, int size_x, int size_y);

void set_spot(int pos_x, int pos_y, int size_x, int size_y, int which_one);


set spot position
--
void set_spot_pos(iVec pos);

void set_spot_pos(iVec pos, int which_one);

void set_spot_pos(int x, int y);

void set_spot_pos(int x, int y, int which_one);


set spot size
--
void set_spot_diam(iVec size);

void set_spot_diam(iVec size, int which_one);

void set_spot_diam(int x, int y);

void set_spot_diam(nt x, int y, int which_one);



RESET
--
void reset();
>reset the force field

void reset_spot_area()();
>reset the force field where spots is active










WORK AROUND THE FIELD
--
Preserve
--
void preserve_field()
>use this method to save you data field at specific moment, useful when method to change field like add, mult, map method is used.

Change the field methods
--
map field
--
void map_velocity(float start1, float stop1, float start2, float stop2);
>map all the field

void map_velocity(int x, int y, float start1, float stop1, float start2, float stop2);
>map target case in the field

void map_velocity(int x, int y, int z, float start1, float stop1, float start2, float stop2);
>map target case in the field, this method is not available

void map_velocity(iVec coord, float start1, float stop1, float start2, float stop2);
>map target case in the field

mult field
--
void mult_velocity(float mult);
>mult all the field

void mult_velocity(int x, int y, float mult);
>mult target case in the field,

void mult_velocity(int x, int y, int z, float mult);
>mult target case in the field, this method is not available

void mult_velocity(iVec coord, float mult);
>mult target case in the field




MISC
--

clear
--
clear_spot()
> clear all the spot list


refresh
--
void refresh(PImage img, int component_sorting_color_direction, int component_sorting_color_velocity);
>rebuild the vector field of type IMAGE
component_sorting_color_velocity can be RED, GREEN, BLUE, HUE, SATURATION, BRIGHTNESS or ALPHA







VEHICLE class
--
>this class work with the Force Field, so give this class is an obligation.

Constructor
--
Vehicle(Vec2 position, float speed, float force);
>parameter 
>Vec position: define the starting position of vehicle
>float speed define the velocity maximum of your agent
>float force ???

method
--
void set_radius(float radius);

void set_position(Vec2 position);

void set_speed(float speed);
>set the original speed

void mult_speed(float mult);
>multiply origial speed

void add_speed(float add);
>add speed to original speed


void update(Force_field ff);
>update the vehicle
>parameteres 
>Force_field ff update the the cell of the force field


void follow();
> The vehicle follow the vector field sent


    
void swap();
> The vehicle swap position when this one is out of vector field, like border or hole

void manage_border(boolean manage_border_is);
> If the value is true, each vehicle when this one go out of the canvas, rebirth in a symetric position, if it's false it rebirth in a random position around the canvas, by default this value is false.


Get
--
Vec2 get_position();
> return position corrected by the canvas position of the Force Field

Vec2 get_absolute_position();
> return the absolute position, not corrected by canvas position







