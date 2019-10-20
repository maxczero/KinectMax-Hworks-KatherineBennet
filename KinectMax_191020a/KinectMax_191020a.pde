
//oscP5 for networked communication with max
import netP5.*;
import oscP5.*;

//oscP5 library objects
OscP5 oscP5;
NetAddress myRemoteLocation;




//much of this code borrowed from shiffaman's tutorial at https://shiffman.net/p5/kinect/

//kinect library 
import org.openkinect.processing.*;

//kinect library object
Kinect kinect;




void setup() {
  frameRate(50);
  //OscP5 setup 
  oscP5 = new OscP5(this,12000);
  myRemoteLocation = new NetAddress("127.0.0.1",12000);
  
  //Kinect Setup
  size(640,480,P3D);
  kinect = new Kinect(this);
  kinect.initDepth();
  //kinect.initVideo();
}

void draw(){
  background(0);
  
  //Translate and Rotate
  pushMatrix();
  translate(width/2, height/2, -50);
  
  // We're just going to calculate and draw every 2nd pixel
  int skip = 4;
  
  // Get the raw depth as array of integers
  int[] depth = kinect.getRawDepth();
  
  stroke(255);
  strokeWeight(2);
  beginShape(POINTS);
  for (int x = 0; x < kinect.width; x+=skip) {
    for (int y = 0; y < kinect.height; y+=skip) {
      int offset = x + y * kinect.width;
      int d = depth[offset];
      //calculte the x, y, z camera position based on the depth information
      PVector point = depthToPointCloudPos(x, y, d);
      
      OscMessage myMessage = new OscMessage("/point");
      
      myMessage.add(point.x);
      myMessage.add(point.y);
      myMessage.add(point.z);


      oscP5.send(myMessage, myRemoteLocation); 
      // Draw a point
      vertex(point.x, point.y, point.z);
    }
  }
  endShape();

  popMatrix();

  fill(255);
  text(frameRate, 50, 50);


}
  
 //calculte the xyz camera position based on the depth data
PVector depthToPointCloudPos(int x, int y, float depthValue) {
  PVector point = new PVector();
  point.z = (depthValue);// / (1.0f); // Convert from mm to meters
  point.x = (x - CameraParams.cx) * point.z / CameraParams.fx;
  point.y = (y - CameraParams.cy) * point.z / CameraParams.fy;
  return point;
}

//Osc p5 test method
void mousePressed() {
  /* in the following different ways of creating osc messages are shown by example */
  OscMessage myMessage = new OscMessage("/test");
  
  myMessage.add(123); /* add an int to the osc message */

  /* send the message */
  oscP5.send(myMessage, myRemoteLocation); 
}

/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());
}
