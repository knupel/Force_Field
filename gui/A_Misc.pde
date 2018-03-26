/**
load data
*/

void load_data_from_app_force(int tempo, boolean authorization) {
	if(frameCount%tempo == 0 || authorization) {
		Table data_from_app = loadTable(sketchPath(1)+"/save/value_app_force.csv","header");
		if(data_from_app.getRowCount() > 0) {
			TableRow row = data_from_app.getRow(0);
			gui_main_movie.getController("header_movie").setValue(row.getFloat("value"));
		} else {
			// printErr("There is no Row available is the Table, maybe a save is on progress");
		}

	}
}








boolean display_spot_is() {
  return display_spot;
}

boolean display_vehicle_is() {
  return display_vehicle ;
}

boolean display_warp_is() {
  return display_warp;
}

boolean movie_warp_is = true ;
boolean movie_warp_is() {
  return movie_warp_is;
}


// button is
boolean mode_perlin_is() {
	return mode_perlin;
}

boolean mode_chaos_is() {
	return mode_chaos;
}

boolean mode_equation_is() {
	return mode_equation;
}

boolean mode_image_is() {
	return mode_image;
}

boolean mode_gravity_is() {
	return mode_gravity;
}

boolean mode_magnetic_is() {
	return mode_magnetic;
}

boolean mode_fluid_is() {
	return mode_fluid;
}