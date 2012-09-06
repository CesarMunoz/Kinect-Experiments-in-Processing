import saito.objloader.*;
import processing.opengl.*;

OBJModel model;

float rotateX;
float rotateY;

void setup()
{
  size(1024, 768, OPENGL);
  
  // load model, uses triangles as basic geometry
  model = new OBJModel(this, "kinect.obj", "relative", TRIANGLES);
  //center at 0,0
  model.translateToCenter();
  noStroke();
}

void draw()
{
  background(255);
  lights();
  
  translate(width/2, height/2, 0);
  rotateY(rotateY);
  rotateX(rotateX);
  
  model.draw();
}

void mouseDragged()
{
  rotateX += (mouseX - pmouseX) * 0.001;
  rotateY += (mouseY - pmouseY) * 0.001;
}

boolean drawLines = false;

void keyPressed()
{
  if(drawLines){
    model.shapeMode(LINES);
    stroke(0);
  }else{
    model.shapeMode(TRIANGLES);
    noStroke();
  }
  drawLines = !drawLines;
}
