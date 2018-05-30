String [] path_project_shape;
void project_setup() {
	project_import_shape();
}

void project_import_shape() {
	String path = sketchPath(1)+"/import/shape/";
	youngtimer_import_shape(path);
	// algorave_setup(path);

	for(int i = 0 ; i < path_project_shape.length ;i++) {
		file_path("shape",path_project_shape[i]);
	}


}
void youngtimer_import_shape(String path) {
	path_project_shape = new String[1];
  path_project_shape[0] = (path+"corbeau.svg");

}

void algorave_import_shape(String path) {
  path_project_shape = new String[3];
  path_project_shape[0] = (path+"algorave_typo.svg");
  path_project_shape[1] = (path+"algorave_picto.svg");
  path_project_shape[2] = (path+"algorave_logo.svg");
}


