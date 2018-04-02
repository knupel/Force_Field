/**
send
v 0.0.3
*/

float sum_slider() {
	float sum = 0;
	// BACKGROUND
	sum += alpha_background;
	// VECTOR FIELD
	sum += cell_force_field;
	// MISC
	sum += tempo_refresh;
	// SPOT
	sum += size_spot;
	sum += alpha_spot;
	sum += red_spot;
	sum += green_spot;
	sum += blue_spot;
	// VEHICLE
	sum += size_vehicle;
	sum += alpha_vehicle;
	sum += red_vehicle;
	sum += green_vehicle;
	sum += blue_vehicle;
	sum += num_vehicle;
	sum += velocity_vehicle;
	// WARP IMAGE
	sum += alpha_warp;
	sum += red_warp;
	sum += green_warp;
	sum += blue_warp;
	sum += power_warp;
	sum += red_cycling;
	sum += green_cycling;
	sum += blue_cycling;
	sum += power_cycling;
	// MOVIE
	sum += header_target_movie;
	sum += speed_movie;
	// FLUID
	sum += frequence ;
	sum += viscosity;
	sum += diffusion;;
	// generative seting for CHAOS and PERLIN field
	sum += range_min_gen;
	sum += range_max_gen;
	sum += power_gen;
	// SORT IMAGE
	sum += vel_sort;
	sum += x_sort;
	sum += y_sort;
	sum += z_sort;
	// SPOT
	sum += spot_num;
	sum += spot_range;
	sum += radius_spot;
	sum += min_radius_spot;
	sum += max_radius_spot;
	sum += speed_spot;
	sum += distribution_spot;
	sum += spiral_spot;
	sum += beat_spot;
	sum += motion_spot;
	
	return sum;

}


boolean state_button ;
boolean state_button_is() {
	return state_button ;
}

void state_button(boolean state) {
	state_button = state;
}

/*
void send_button() {
	OscMessage message_button = new OscMessage("FORCE BUTTON");
  for(int i = 0 ; i < mode.length ; i++) {
  	if(mode[i]) message_button.add(1); else message_button.add(0);
  }
	if(display_background) message_button.add(1); else message_button.add(0);
	if(display_vehicle) message_button.add(1); else message_button.add(0);
	if(display_warp) message_button.add(1); else message_button.add(0);
	osc_button.send(message_button,dest_button);
}
*/

void send() {
	OscMessage message = new OscMessage("FORCE CONTROL");
	// GUI STATE
	//message.add(gui_is());
	// BACKGROUND
	message.add(alpha_background);
	// VECTOR FIELD
	message.add(cell_force_field);
	// MISC
	message.add(tempo_refresh);
	// SPOT
	message.add(size_spot);
	message.add(alpha_spot);
	message.add(red_spot);
	message.add(green_spot);
	message.add(blue_spot);
	// VEHICLE
	message.add(size_vehicle);
	message.add(alpha_vehicle);
	message.add(red_vehicle);
	message.add(green_vehicle);
	message.add(blue_vehicle);
	message.add(num_vehicle);
	message.add(velocity_vehicle);
	// WARP IMAGE
	message.add(alpha_warp);
	message.add(red_warp);
	message.add(green_warp);
	message.add(blue_warp);
	message.add(power_warp);
	message.add(red_cycling);
	message.add(green_cycling);
	message.add(blue_cycling);
	message.add(power_cycling);
	// MOVIE
	message.add(header_target_movie);
	message.add(speed_movie);
	// FLUID
	message.add(frequence);
	message.add(viscosity);
	message.add(diffusion);
	// generative seting for CHAOS and PERLIN field
	message.add(range_min_gen);
	message.add(range_max_gen);
	message.add(power_gen);
	// SORT IMAGE
	message.add(vel_sort);
	message.add(x_sort);
	message.add(y_sort);
	message.add(z_sort);
	// SPOT
	message.add(spot_num);
	message.add(spot_range);
	message.add(radius_spot);
	message.add(min_radius_spot);
	message.add(max_radius_spot);
	message.add(speed_spot);
	message.add(distribution_spot);
	message.add(spiral_spot);
	message.add(beat_spot);
	message.add(motion_spot);

	for(int i = 0 ; i < mode.length ; i++) {
  	if(mode[i]) message.add(1); else message.add(0);
  } 
  // DISPLAY	
  if(display_background) message.add(1); else message.add(0);
	if(display_vehicle) message.add(1); else message.add(0);
	if(display_warp) message.add(1); else message.add(0);
	if(display_field) message.add(1); else message.add(0);
	if(display_spot) message.add(1); else message.add(0);
  // MISC BUTTON
	if(change_size_window_is) message.add(1); else message.add(0);
	if(fullfit_image_is) message.add(1); else message.add(0);
	if(show_must_go_on) message.add(1); else message.add(0);
	if(misc_warp_fx) message.add(1); else message.add(0);
	if(full_reset_field_is) message.add(1); else message.add(0);
	// DROPDOWN MENU
	message.add(type_vehicle);
	message.add(type_spot);
	message.add(which_media);

  // SEND RESULT
	osc.send(message,destination);
}