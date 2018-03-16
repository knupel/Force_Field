/**
GUI update
v 0.1.0
*/

boolean reset_authorization_from_gui ;
int ref_cell_size;
int ref_num_vehicle;
int ref_sort_channel;
void update_gui_value(boolean update_is, int t_count) {
	int size = ceil(cell_force_field) +2;
	int sort_channel_sum = int(x_sort + y_sort +vel_sort);
	if(ref_cell_size != size || ref_num_vehicle != get_num_vehicle_gui() || sort_channel_sum != ref_sort_channel) {
		set_cell_grid_ff(size);
		ref_cell_size = size;
		ref_num_vehicle = get_num_vehicle_gui();
		ref_sort_channel = sort_channel_sum;
    reset_authorization_from_gui = true;
	}

	update_value_ff_fluid(frequence,viscosity,diffusion,update_is);
	update_value_ff_generative(range_min_gen,range_max_gen,power_gen,update_is);

  set_alpha_background(alpha_bg);
  
  set_alpha_vehicle(alpha_vehicle);
  // nothing special at this time
  update_rgb_vehicle();
  

  set_alpha_warp(alpha_warp);
	update_rgba_warp(t_count);
  
  set_sorting_channel_ff_2D(floor(x_sort), floor(y_sort), floor(vel_sort));

  set_resize_window(gui_change_size_window_is);
  set_full_reset_field(gui_fullreset_field_is);
  set_fit_image(gui_fullfit_image_is);
  set_vehicle_pixel_is(gui_vehicle_pixel_is);

  display_bg(gui_display_bg);
  show_must_go_on(gui_show_must_go_on);
}

void update_rgb_vehicle() {
	// nothing special at this time
}

void update_rgba_warp(int t_count) {
	float cr = 1.;
  float cg = 1.;
  float cb = 1.;
  if(red_cycling != 0) {
  	cr = sin(t_count *(red_cycling *red_cycling *.1)); 
  }
  if(green_cycling != 0) {
  	cg = sin(t_count *(green_cycling *green_cycling *.1)); 
  }
  if(blue_cycling != 0) {
  	cb = sin(t_count *(blue_cycling *blue_cycling *.1)); 
  }
  

  Vec4 sin_val = Vec4(1);
  sin_val.set(cr,cg,cb,1);

	rgba_warp.set(red_warp,green_warp,blue_warp,1);
	power_warp_max = (power_warp *power_warp) *10f;
  
	rgba_warp.mult(power_warp_max);
	
	float min_src = 0 ;
	float max_src = 1 ;
	float min_dst = .01 ;
	rgba_warp.set(sin_val.map_vec(Vec4(min_src), Vec4(max_src), Vec4(min_dst), rgba_warp));
}
