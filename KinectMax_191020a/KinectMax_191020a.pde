//much of this code borrowed from shiffaman's tutorial at https://shiffman.net/p5/kinect/

import org.openkinect.processing.*;

Kinect kinect;

void setup() {
  kinect = new Kinect(this);
  kinect.initDepth();
  kinect.initVideo();
  
}

void draw(){
