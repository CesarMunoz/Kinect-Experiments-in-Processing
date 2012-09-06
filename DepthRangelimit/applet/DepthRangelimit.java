import processing.core.*; 
import processing.xml.*; 

import SimpleOpenNI.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class DepthRangelimit extends PApplet {


SimpleOpenNI kinect;

PImage depthImage;

float closestVal = 450;
float furthestVal = 1450;

public void setup()
{
  size(640, 480);
  
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
}

public void draw()
{
  kinect.update();
  
  int[] depthValues = kinect.depthMap();
  depthImage = kinect.depthImage();
  for(int x=0; x<640; x++)
  {
    for(int y=0; y<480; y++)
    {
      int i = x+y*640;
      int currentDepthVal = depthValues[i];
      if(currentDepthVal<closestVal || currentDepthVal>furthestVal)
      {
        depthImage.pixels[i] = 0;
      }
    }
  }
  
  image(depthImage,0,0);
}
  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#FFFFFF", "DepthRangelimit" });
  }
}
