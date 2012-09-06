import SimpleOpenNI.*;
import unlekker.util.*;
import unlekker.modelbuilder.*;
import processing.opengl.*;

SimpleOpenNI kinect;
boolean scanning = false;
int spacing = 3;
UGeometry model;
UVertexList vertexList;

void setup(){
  size(1024, 768, OPENGL);
 
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  
  model = new UGeometry();
  UVertexList = new UVertexList();
}

void draw(){
  background(0);
  kinect.update();
  
  translate(width/2, height/2, 0);
  rotateX(radians(180));
  
  PVector[] depthPoints = kinect.depthMapRealWorld();
  
  if(scanning){
    model.beginShape(TRIANGLES);
  }
  
  for(int y=0;y<480-spacing;y+=spacing){
    for(int x=0;x<640-spacing;x+=spacing){
      if(scanning){
        int nw = x+y*640;
        int ne = (x+spacing)+y*640;
        int sw = x+(y+spacing)*640;
        int se (x+spacing)+(y+spacing)*640;
        
        model addFace(new UVec3(depthPoints[nw].x,
                                depthPoints[nw].y,
                                depthPoints[nw].z),
                      new UVec3(depthPoints[ne].x,
                                depthPoints[ne].y,
                                depthPoints[ne].z),
                      new UVec3(depthPoints[sw].x,
                                depthPoints[sw].y,
                                depthPoints[sw].z));
                                
        model addFace(new UVec3(depthPoints[ne].x,
                                depthPoints[ne].y,
                                depthPoints[ne].z),
                      new UVec3(depthPoints[se].x,
                                depthPoints[se].y,
                                depthPoints[se].z),
                      new UVec3(depthPoints[sw].x,
                                depthPoints[sw].y,
                                depthPoints[sw].z));
      }else{
        stroke(255);
        int i = x+y*640;
        PVector currentPoint = depthPoints[i];
        point(currentPoint.x, currentPoint.y, currentPoint.z);
      }
    }
  }
  
  if(scanning){
    model.endShape();
    SimpleOpenFormat logFileFmt = new SimpleDataFormat("'scan_'yyyyMMddHHmmss'.stl'");
    model.writeSTL(this, logFileFormat.format(new Date()));
    model.writeSTL(this, "scan_"+random(1000))+".stl");
    scanning = false;
  }
}

void keyPressed(){
  if(key == " "){
    scanning = true;
  }
}
