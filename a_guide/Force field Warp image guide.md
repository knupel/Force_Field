Force field warp image
v 0.0.1
--

WARP IMAGE
--
Warp is a class to manage a warping effect from the class Force Field

first creat a the class

Warp warp = new Warp() ;


to load the picture used method

void loadImage(String... path);
>used this method in Processing setup()

void select_image(int which_img);

PImage get_image();
>return the current image used to make a warpep effect

String get_name();
>return String name of the current warp image

String get_name(int target);
>return String name of the target warp image

int image_bank_length() 


Warp method 
--

Show image
--
void show(float intensity);
>float intensity is the strenght apply to warp from the Force Field



Change image
--
void reset();
>When you change image from image bank, if 'shader_warp_filter()'' is active you must used it, to refresh totaly your image








shader method
--
void shader_init();
>you need to use this method to work with shader

void shader_filter(true);
>optional method
if you want filter your work, by default the filter is false

void shader_mode(int mode);
>optional method
>at this moment you have '3' mode available the mode 'O' is the normal one.



refresh background
--
the value used must be from 0 to 1

void refresh(Vec4 rgba);

void refresh(float... value);
