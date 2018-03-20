/**
variable global share with the main sketch
v 0.0.4

In the future those values must be write in an external file to be read by the main and gui sketche
*/
/**
BUTTON variable
*/

boolean use_leapmotion = false;

/**
the variable is in the order send or receive OSC data
* perlin, chaos, equation, image;
* gravity, magnetic, fluid;
*/
int num_mode = 7;
boolean [] mode = new boolean[num_mode];

boolean display_bg = true; 
boolean display_warp = false;
boolean display_vehicle = false;

boolean change_size_window_is = true; 
boolean fullfit_image_is = true;
boolean show_must_go_on = true; 
boolean warp_is = true; 
boolean full_reset_field_is = true; 
boolean vehicle_pixel_is = true; 








/**
SLIDER variable
*/
// BACKGROUND
float alpha_bg = 1.;

// VECTOR FIELD
float cell_force_field = 25.;

// MISC
float tempo_refresh = 1.;

// VEHICLE
float alpha_vehicle = 1.;
float red_vehicle = .9;
float green_vehicle = 0;
float blue_vehicle = 0;

float num_vehicle = .1;
float velocity_vehicle = 5;
int max_vehicle_ff = 100_000;

// WARP IMAGE
float alpha_warp = 1.;
float red_warp = .9;
float green_warp = .9;
float blue_warp = .9;

float power_warp = .37;

float red_cycling = 0;
float green_cycling = 0;
float blue_cycling = 0;
float power_cycling = .35;

// MOVIE
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
float spot_num = 1.;
float spot_range = 3.;

float radius_spot = .3;
float min_radius_spot= .0;
float max_radius_spot = 1.; 
float speed_spot = 0.;
float distribution_spot= 0.;
float spiral_spot = 0.;
float beat_spot = 0.;
float motion_spot = 0.;












