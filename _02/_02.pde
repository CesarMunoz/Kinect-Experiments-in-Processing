import SimpleOpenNI.*;
SimpleOpenNI kinect;

void setup()
{
  size (640, 480);
  kinect =  new SimpleOpenNI(this);

  kinect.enableDepth();
}

void draw()
{
 kinect.update();

// PImage depthImage = kinect.depthImage();
// PImage rgbImage = kinect.rgbImage();
//image(depthImage(),0,0);
//image(rgbImage(), 640, 0);

image(kinect.depthImage(),0,0);
}

void mousePressed()
{
int[] depthValues = kinect.depthMap();
int clickPosition = mouseX+(mouseY*640);
int clickedDepth = depthValues[clickPosition];

float inches = clickedDepth/25.4;
println("depthValues["+clickPosition+"]: "+ depthValues[clickPosition]+"mm; inches: "+inches);
}
