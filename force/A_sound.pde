Sounda sounda;
/**
STOP
*/
void stop() {
  sounda.stop();
  super.stop();
}


/**
setup
*/
float [] radius;
void sound_system_setup() {


  int length_analyze = 512 ;
	sounda = new Sounda(length_analyze);

  int num_spectrum_bands = 128;
  float scale_spectrum_sound = .11 ;
  sounda.set_spectrum(num_spectrum_bands, scale_spectrum_sound) ;

  int num_section = 4 ;
  iVec2 [] section_in_out = new iVec2[num_section];
  section_in_out[0] = iVec2(0,5);
  section_in_out[1] = iVec2(5,30);
  section_in_out[2] = iVec2(30,85);
  section_in_out[3] = iVec2(85,128);
  sounda.set_section(section_in_out);


  int [] beat_section_id = new int[section_in_out.length] ;
  beat_section_id[0] = 0;
  beat_section_id[1] = 1;
  beat_section_id[2] = 2;
  beat_section_id[3] = 3;

  float [] beat_part_threshold = new float[section_in_out.length];
  beat_part_threshold[0] = 4.5;
  beat_part_threshold[1] = 3.5;
  beat_part_threshold[2] = 1.5;
  beat_part_threshold[3] = .6;

  sounda.set_beat(beat_section_id, beat_part_threshold);
  // set_beat(beat_part_threshold); // this method don't need to set section

  radius = new float[beat_part_threshold.length];

  float [] tempo_threshold = new float[section_in_out.length];
  tempo_threshold[0] = 4.5;
  tempo_threshold[1] = 3.5;
  tempo_threshold[2] = 2.5;
  tempo_threshold[3] = .5;
  sounda.set_tempo(tempo_threshold);
  // set_tempo();

}




void sound_system_update() {
	sounda.update();
}

void sound_system_draw() {
	show_beat();
	show_spectrum();
}







void show_beat() {
  for(int i = 0 ; i < radius.length ;i++) {
    if(sounda.beat_is(i)) {
      radius[i] = height *.75 ;
    }
    radius[i] *= .95;
  }
  float dist = width /5;
  textAlign(CENTER);
  float min_text_size = 1.;
  for(int i = 0 ; i < radius.length ;i++) {
    int step = (i+1);
    noStroke();
    fill(r.YELLOW,125);
    ellipse(dist *step,height/2,radius[i],radius[i]);
  }
}







void show_spectrum() {
  noStroke();

  sounda.audio_buffer(RIGHT) ;
  fill(r.BLOOD);
  show_spectrum_level(Vec2(0),height/2);

  sounda.audio_buffer(LEFT);
  fill(r.BLOOD);
  show_spectrum_level(Vec2(0),-height/2);

}

void show_spectrum_level(Vec2 pos, int size) {
	float band_width = width /  sounda.band_num() ;
  for(int i = 0; i < sounda.band_num(); i++) {
    float pos_x = i * band_width +pos.x;
    float pos_y = pos.y + abs(size) ;
    float size_x = band_width ;
    float size_y = -(sounda.get_spectrum(i) *size) ;
    rect(pos_x, pos_y, size_x, size_y) ;
  }
}

void show_beat_spectrum_level(Vec2 pos, int size) {
	float band_width = width /  sounda.band_num() ;
  for(int i = 0 ; i < sounda.section_num() ; i++) {
    for(int k = 0; k < sounda.band_num() ; k++) {
      if(sounda.beat_band_is(i,k)) {
        float pos_x = k *band_width +pos.x;
        float pos_y = pos.y +abs(size);
        float size_x = band_width;
        float size_y = -size;
        rect (pos_x, pos_y, size_x, size_y);
      }
    }
  }
}