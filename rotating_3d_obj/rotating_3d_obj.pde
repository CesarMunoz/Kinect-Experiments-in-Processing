import processing.opengl.*;
import SimpleOpenNI.*;
import saito.objloader.*;

SimpleOpenNI kinect;
OBJModel model;

void setup(){
  size(1028, 768, OPENGL);
  
  model = new OBJModel(this, "kinect.obj", "relative", TRIANGLES);
  model.translateToCenter();
  
  // translate model so its origin is at it left side
  BoundingBox box = new BoundingBox(this, model);
  model.translate(box.getMin());
  
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);
  kinect.setMirror(true);
}

void draw(){
  kinect.update();
  background(255);
  
  translate(width/2, height/2, 0);
  rotateX(radians(180));
  
  IntVector userList = new IntVector();
  kinect.getUsers(userList);
  if(userList.size() > 0){
   int userID = userList.get(0);
   
   if(kinect.isTrackingSkeleton(userID)){
    PVector leftHand = new PVector();
    kinect.getJointPositionSkeleton(userID, SimpleOpenNI.SKEL_LEFT_HAND, leftHand);
    
    PVector rightHand = new PVector();
    kinect.getJointPositionSkeleton(userID, SimpleOpenNI.SKEL_RIGHT_HAND, rightHand);
    
    //subtract right from left to turn left hand into a vector representing
    //the difference between them
    leftHand.sub(rightHand);
    //convert leftHand to unit vector
    leftHand.normalize();
    
    //model is rotated so "up" is the x-axis
    PVector modelOrientation = new PVector(1, 0, 0);
    
    //calculate angle and axis
    float angle = acos(modelOrientation.dot(leftHand));
    PVector axis = modelOrientation.cross(leftHand);
    
    stroke(255, 0, 0);
    strokeWeight(5);
    drawSkeleton(userID);
    
    pushMatrix();
    lights();
    stroke(175);
    strokeWeight(1);
    fill(250);
    
    translate(rightHand.x, rightHand.y, rightHand.z);
    
    //rotate angle amount around axis
    rotate(angle, axis.x, axis.y, axis.z);
    model.draw();
    popMatrix();
   } 
  }
}

void drawSkeleton(int userID){
  drawLimb(userID, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);
  
  drawLimb(userID, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  drawLimb(userID, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
  drawLimb(userID, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);
  
  drawLimb(userID, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  drawLimb(userID, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  drawLimb(userID, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);
  
  drawLimb(userID, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  drawLimb(userID, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  
  drawLimb(userID, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
  drawLimb(userID, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
  drawLimb(userID, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);
  
  drawLimb(userID, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
  drawLimb(userID, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
  drawLimb(userID, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);
  
  drawLimb(userID, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_LEFT_HIP);
}

void drawLimb(int userID, int jointType1, int jointType2){
  PVector jointPos1 = new PVector();
  PVector jointPos2 = new PVector();
  float confidence; //confidence
  
  confidence = kinect.getJointPositionSkeleton(userID, jointType1, jointPos1);
  confidence = kinect.getJointPositionSkeleton(userID, jointType2, jointPos2);
  
  //stroke(100);
  //strokeWeight(5);
  //if(confidence > 1){
   line(jointPos1.x, jointPos1.y, jointPos1.z, jointPos2.x, jointPos2.y, jointPos2.z); 
  //}
}

//user-tracking callbacks
void onNewUser(int userID){
  println("start pose detection");
  kinect.startPoseDetection("Psi", userID);
}

void onEndCalibration(int userID, boolean successful){
  if(successful)
  {
    println("  User calibrated!!!");
    kinect.startTrackingSkeleton(userID);
  }else{
    println("  Failed to calibrate user!!!");
    kinect.startPoseDetection("Psi", userID);
  }
}

void onStartPose(String pose, int userID){
  println("Started pose for user");
  kinect.stopPoseDetection(userID);
  kinect.requestCalibrationSkeleton(userID, true);
}
