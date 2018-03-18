float sum_controller() {
	float sum = 0;
	// BACKGROUND
	sum += alpha_bg;
	// VECTOR FIELD
	sum += cell_force_field;
	// MISC
	sum += tempo_refresh;
	// VEHICLE
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
	sum += header_movie;
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

void send() {
	OscMessage message = new OscMessage("FORCE CONTROL");
	// BACKGROUND
	message.add(alpha_bg);
	// VECTOR FIELD
	message.add(cell_force_field);
	// MISC
	message.add(tempo_refresh);
	// VEHICLE
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
	message.add(header_movie);
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
  // SEND RESULT
	oscP5.send(message,destination);
}