import SimpleOpenNI.*;
import processing.opengl.*;

SimpleOpenNI kinect;
SkeletonRecorder recorder;
boolean recording = false;
float offByDistance = 0.0;

void setup(){
  size(1028, 768, OPENGL);
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);
  kinect.setMirror(true);
  //initialize recorder & track left hand
  recorder = new SkeletonRecorder(kinect, SimpleOpenNI.SKEL_LEFT_HAND);
  
  //load font
  PFont font = createFont("Verdana", 40);
  textFont(font);
}

void draw(){
  background(0);
  kinect.update();
  
  lights();
  noStroke();
  
  //creat HUD
  fill(255);
  text("total frames: "+ recorder.frames.size(), 5, 50);
  text("recording: "+recording, 5, 100);
  text("current frame: "+ recorder.currentFrame, 5, 150);
  
  //set text color as gradient from red to green based
  //on distance between hands
  float c = map(offByDistance, 0, 1000, 0, 255);
  fill(c, 255-c, 0);
  text("off by: "+offByDistance, 5, 200);
  
  translate(width/2, height/2, 0);
  rotateX(radians(180));
  
  IntVector userList = new IntVector();
  kinect.getUsers(userList);
  if(userList.size() > 0){
    int userID = userList.get(0);
    recorder.setUser(userID);
    if(kinect.isTrackingSkeleton(userID)){
      PVector currentPosition = new PVector();
      kinect.getJointPositionSkeleton(userID, SimpleOpenNI.SKEL_LEFT_HAND, currentPosition);
      
      //display sphere for current limb
      pushMatrix();
        fill(255, 0, 0);
        translate(currentPosition.x, currentPosition.y, currentPosition.z);
        sphere(80);
      popMatrix();
      
      //if we're recording, capture frame
      if(recording){
        recorder.recordFrame();
      }else{
        //if user is playing, access recorded joint position
        PVector recordedPosition = recorder.getPosition();
        //display the recorded joint position
        pushMatrix();
          fill(255, 0, 0);
          translate(recordedPosition.x, recordedPosition.y, recordedPosition.z);
          sphere(80);
        popMatrix();
        
        //draw line between current position and recorded position
        //set color based on distance between them
        stroke(c, 255-c, 0);
        strokeWeight(20);
        line(currentPosition.x, currentPosition.y, currentPosition.z, recordedPosition.x, recordedPosition.y, recordedPosition.z);
        
        //calculate vector between the current and recorded positions with vector subtraction
        currentPosition.sub(recordedPosition);
        
        //store the magnitude of the vector as the off-by distance for display
        offByDistance = currentPosition.mag();
        
        //tell the recorder to load up the next frame
        recorder.nextFrame();
      }
    }
  }
}
void keyPressed(){
  recording = false;
}

//user-tracking callbacks
void onNewUser(int userID){
  println("start pose detection");
  kinect.startPoseDetection("Psi", userID);
}

void onEndCalibration(int userID, boolean successful){
  if(successful)  {
    println("  User calibrated!!!");
    kinect.startTrackingSkeleton(userID);
    recording = true;
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
