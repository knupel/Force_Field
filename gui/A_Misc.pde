/**
load data
v 0.0.1
*/
void load_data_from_app_force(int tempo, boolean authorization) {
	if(frameCount%tempo == 0 || authorization) {
		
		Table data_from_app = loadTable(sketchPath(1)+"/save/dialogue_force.csv","header");
		int rank = 0;
		if(data_from_app.getRowCount() > 0) {
			TableRow row = data_from_app.getRow(rank);
			gui_main_movie.getController("header_movie").setValue(row.getFloat("value"));
			rank++;
      // radio mode
      for(int i = 0 ; i < mode.length ; i++) {
      //for(int i = 0 ; i < radio_mode.getItems().size() ; i++) {
      	row = data_from_app.getRow(rank);
        if(row.getFloat("value") == 1) radio_mode.activate(i);
      	rank++;
      	
      }

      // display mode     
      for(int i = 0 ; i < display_ref.length ; i++) {
      	if(gui_button.getController(display_method_name[i]) instanceof Toggle) {
      		Toggle t = (Toggle) gui_button.getController(display_method_name[i]);
      		row = data_from_app.getRow(rank);
          boolean state = false;
          if(row.getFloat("value") == 1) state = true ;
          if(state != display_ref[i]) {
            display_ref[i] = state;
            if(state) t.setState(true); else t.setState(false);
          }
      		rank++;	
      	}
      }

      // dropdown
      rank += 3;

      // misc mode         
      for(int i = 0 ; i < misc_ref.length ; i++) {
        if(gui_button.getController(misc_method_name[i]) instanceof Toggle) {
          Toggle t = (Toggle) gui_button.getController(misc_method_name[i]);
          row = data_from_app.getRow(rank);
          boolean state = false;
          if(row.getFloat("value") == 1) state = true ;
          if(state != misc_ref[i]) {
            misc_ref[i] = state;
            if(state) t.setState(true); else t.setState(false);
          }
          rank++; 
        }
      }
        
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