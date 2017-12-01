Force field guide
v 0.0.2
--

FORCE FIELD class
--
Constructor
--
Force_field(int resolution, iVec2 canvas_pos, iVec2 canvas, int type);

Force_field(int resolution, iVec2 canvas_pos, PImage img, int component_sorting);

constructor arguments
--
to define the type of force field, you must use constants : FLUID, CHAOS, PERLIN, HOLE, MAGNETIC



void ref_spot();
>make the reference position of the spot is updated, before using, can be util in case the spot make jump move !

void add_spot(int num);

void add_spot();


Get
--
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



Set
--
void reverse_is(boolean state) ;
multiply the direction vector by `-1` the resulte is the direction is opposite, this method must change the method reset() at the end of the draw()


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
void set_spot_size(iVec size);

void set_spot_size(iVec size, int which_one);

void set_spot_size(int x, int y);

void set_spot_size(nt x, int y, int which_one);


set calm down
--
void set_calm(float calm);
>use this method to calm down the force field when this one is under the influence of any spots. the value has to be between 0 and 1 


Change direction
--
void wind(float angle, float force);
>you can add a global 'wind' to your field, the argument angle is in radian





Reset
--
void reset();
>reset the force field




void refresh();
>rebuild the vector field, not available for the Force field of type FLUID, HOLE and IMAGE

void refresh(PImage img, int component_sorting);
>rebuild the vector field of type IMAGE







VEHICLE class
--
>this class work with the Force Field, so give this class is an obligation.

Constructor
--
Vehicle(Vec2 position, float max_speed, float max_force);

method
--
void update(Force_field ff);
>update the vehicle


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







