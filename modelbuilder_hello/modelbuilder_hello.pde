import unlekker.util.*;
import unlekker.modelbuilder.*;
import processing.opengl.*;

UGeometry model;

float x = 0;

void setup(){
  size(400, 400, OPENGL);
  stroke(255, 0, 0);
  strokeWeight(3);
  fill(255);
  
  model = new UGeometry();
  // set shape type to TRIANGLE and add geometry
  model.beginShape(TRIANGLES);
  
  // build triangle out of 3 vectors
  model.addFace(new UVec3(150, 150, 0), new UVec3(150, 150, -150), new UVec3(300, 150, 0));
  model.addFace(new UVec3(300, 150, 0), new UVec3(150, 150, -150), new UVec3(300, 150, -150));
  model.addFace(new UVec3(300, 150, -150), new UVec3(300, 300, 0), new UVec3(300, 150, 0));
  model.addFace(new UVec3(300, 300, -150), new UVec3(300, 300, 0), new UVec3(300, 150, -150));
  
  model.endShape();
}

void draw(){
  background(255);
  lights();
  
  translate(150, 150, -75);
  rotateY(x);
  x+=0.01;
  translate(-150, -150, 75);
  
  model.draw(this);
}

void keyPressed(){
  model.writeSTL(this, "part_cube.stl");
}
