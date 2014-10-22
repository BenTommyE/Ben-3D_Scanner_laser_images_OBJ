import java.io.BufferedWriter;
import java.io.FileWriter;

scann3D scannObj = new scann3D();

void setup() {

  scannObj.name("GOPR2435",4);  // img name f.eks. "img" and processing will add inn "0000.jpg" = "img0000.jpg"
  scannObj.display();
  scannObj.scann();
  scannObj.zIncrement = 10;
  
  size(1920,1080,OPENGL);
  stroke(0,255,0);
}

void draw() {
  background(0);
  
  if(scannObj.EOF) {    // End of file
    noLoop();
  }else{
    scannObj.nextImg();  // load "img0001.jpg"  0003 0004...
    scannObj.display();
    scannObj.scann();
  }

}

