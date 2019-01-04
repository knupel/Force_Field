/**
Adapted from:
<a href="http://callumhay.blogspot.com/2010/09/gaussian-blur-shader-glsl.html" target="_blank" rel="nofollow">http://callumhay.blogspot.com/2010/09/gaussian-blur-shader-glsl.html</a>

Blur v 0.0.3
*/

#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif
 
#define PROCESSING_TEXTURE_SHADER

#define PI 3.1415926535897932384626433832795
 
uniform sampler2D texture;
 
// The inverse of the texture dimensions along X and Y
/*
there is no value passed, so what happen with that, if I remove that's don't work
*/
uniform vec2 texOffset;
 
// varying vec4 vertColor;
varying vec4 vertTexCoord;
 
uniform int blurSize;       
uniform bool horizontalPass; // 0 or 1 to indicate vertical or horizontal pass
uniform float sigma;        // The sigma value for the gaussian function: higher value means more blur
                            // A good value for 9x9 is around 3 to 5
                            // A good value for 7x7 is around 2.5 to 4
                            // A good value for 5x5 is around 2 to 3.5
                            // ... play around with this based on what you need <span class="Emoticon Emoticon1"><span>:)</span></span>

 
void main() {
  float numBlurPixelsPerSide = float(blurSize / 2); 
 
  vec2 blurMultiplyVec = horizontalPass? vec2(1.0, 0.0) : vec2(0.0, 1.0);
 
  // Incremental Gaussian Coefficent Calculation (See GPU Gems 3 pp. 877 - 889)
  vec3 incrementalGaussian;
  incrementalGaussian.x = 1.0 / (sqrt(2.0 * PI) * sigma);
  incrementalGaussian.y = exp(-0.5 / (sigma * sigma));
  incrementalGaussian.z = incrementalGaussian.y * incrementalGaussian.y;
 
  vec4 avgValue = vec4(0.0, 0.0, 0.0, 0.0);
  float coefficientSum = 0.0;
 
  // Take the central sample first...
  avgValue += texture2D(texture, vertTexCoord.st) * incrementalGaussian.x;
  coefficientSum += incrementalGaussian.x;
  incrementalGaussian.xy *= incrementalGaussian.yz;
 
  // Go through the remaining 8 vertical samples (4 on each side of the center)
  for (float i = 1.0; i <= numBlurPixelsPerSide; i++) { 
    avgValue += texture2D(texture, vertTexCoord.st - i * texOffset * 
                          blurMultiplyVec) * incrementalGaussian.x;         
    avgValue += texture2D(texture, vertTexCoord.st + i * texOffset * 
                          blurMultiplyVec) * incrementalGaussian.x;         
    coefficientSum += 2.0 * incrementalGaussian.x;
    incrementalGaussian.xy *= incrementalGaussian.yz;
  }

  gl_FragColor = avgValue / coefficientSum ;
}