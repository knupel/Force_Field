/**
variable global share with the main sketch
v 0.0.28

In the future those values must be write in an external file to be read by the main and gui sketche
*/
/**
BUTTON variable
*/



/**
the variable is in the order send or receive OSC data
* perlin, chaos, equation, image;
* gravity, magnetic, fluid;
*/
int num_mode = 7;
boolean [] mode = {true,false,false,false,false,false,false};
boolean mode_perlin, mode_chaos, mode_equation, mode_image, mode_gravity, mode_magnetic, mode_fluid ;

int num_display = 5;
boolean [] display_ref = {true,false,false,false,false};

boolean display_background = true;
boolean display_vehicle = false;
boolean display_warp = false;
boolean display_field = false;
boolean display_spot = false;
boolean display_other = false;
// 
boolean curtain_is = true;

// not an interface button
boolean display_cursor = false;

boolean [] display_mask = {true,true,true,true,true,true,true,true,true,true};

int num_misc = 8;
boolean [] misc_ref = {false,false,true,true,false,false,false};

// maybe change name of variable below, like the variable display_...
boolean change_size_window_is = false;
boolean fullfit_image_is = false;
boolean misc_warp_fx = true; 
boolean misc_shader_fx = false;
boolean full_reset_field_is = false;
boolean show_must_go_on = false;

boolean use_sound_is;




// dropdown
int which_media;
int type_vehicle;
int type_spot;








/**
SLIDER variable
*/
// BACKGROUND
float alpha_background = 0.7;

// VECTOR FIELD
float cell_force_field = 15.;

// MISC
float tempo_refresh = 1.;

// SPOT
float size_spot = .4;
float alpha_spot = 0.5;
float red_spot = .9;
float green_spot = 0;
float blue_spot = 0;

// VEHICLE
float size_vehicle = .15;
float alpha_vehicle = .15;
float red_vehicle = .9;
float green_vehicle = .9;
float blue_vehicle = .9;
float num_vehicle = .4;
float velocity_vehicle = 1;
int max_vehicle_ff = 100_000;

// WARP IMAGE
float alpha_warp = 0.;
float red_warp = .9;
float green_warp = .9;
float blue_warp = .9;

float power_warp = .37;

float red_cycling = 0;
float green_cycling = 0;
float blue_cycling = 0;
float power_cycling = .35;

// MOVIE
float header_target_movie = 0;
float header_movie = 0 ;
float speed_movie = 1;

// FLUID
float frequence = .3;
float viscosity = .3;
float diffusion = .3;

// generative seting for CHAOS and PERLIN field
float range_min_gen = 0.;
float range_max_gen = 1.;
float power_gen = 1.;

// SORT IMAGE
float vel_sort = 1.;
float x_sort = 1.;
float y_sort = 1.;
float z_sort = 1.;

// SPOT
float spot_num = 11.;
float spot_range = 3.;

float radius_spot = .3;
float min_radius_spot= .25;
float max_radius_spot = 1.75; 

float distribution_spot= 0.75;
float spiral_spot = 2.;
float beat_spot = 50.;
float speed_spot = 0.22;
float motion_spot = 0.22;


//FIELD
float colour_field = 1;
float colour_field_min = 0.;
float colour_field_max = .7;
float length_field = .25;
float thickness_field = .05;
float alpha_field = .5;







