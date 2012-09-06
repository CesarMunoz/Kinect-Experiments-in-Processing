import SimpleOpenNI.*;
import processing.opengl.*;

SimpleOpenNI kinect;

void setup(){
  size(640, 480, OPENGL);
  
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableScene();
}

void draw(){
  background(0);
  kinect.update();
  image(kinect.sceneImage(), 0, 0);
}
