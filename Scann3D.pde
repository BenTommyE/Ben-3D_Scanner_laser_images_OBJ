class scann3D {
  exportObj myExportObj = new exportObj();
  PImage Img;                // Img object
  String imgName;            // Img name with out 0000.jpg
  int imgNr = 0;             // Start number serie 
  int nrOffDigitsInName = 4; // Number of digits f.eks. 0001 give 4
  float gCodeY = 0;
  int z = 0;
  int PointNr3D = 0;
  int scannCollom = 0;
  int zIncrement = -10;
  
  boolean EOF = false;
  
  void name(String _imgName, int _nrOffDigitsInName) {
    nrOffDigitsInName = _nrOffDigitsInName;
    imgName = _imgName;
    
    String fullImagesName = imgName + nf(imgNr, nrOffDigitsInName) + ".jpg";
    println(fullImagesName);
    
    if(this.imgExist(fullImagesName)) {
      Img = loadImage(fullImagesName);
      loadPixels();
      //mygCode.writeHeader();
    }
  }
  
  void nextImg(){
    
    String fullImagesName = imgName + nf(++imgNr, nrOffDigitsInName) + ".jpg";
    if(this.imgExist(fullImagesName)) {
      Img = loadImage(fullImagesName);
      loadPixels(); 
    }else{
      //myExportObj.writeFooter(PointNr3D,scannCollom);
      EOF = true;
    }
  }
  
  void display() {
    image(Img, 0, 0);
  }
  
  void scann() {
    
    //Scanning for brightest point one column at a time
    
    if(!EOF) {
      float PixelNow;
      float PixelMax;
      int yMaxFirst = 0;
      int yMaxLast = 0;
      int yMax = 0;

      for (int x = 0; x < width; x++) {
      
        // Loop through every pixel row
        PixelMax = 0;
        
        for (int y = 0; y < height; y++) {
          // Use the formula to find the 1D location
          int pixelArrID = x + y * width;
          
          PixelNow = red(Img.pixels[pixelArrID]);
          
          //Check if this pixel is brighter than the last. When it is the first pixel.
          if(PixelNow>PixelMax) {
            PixelMax = PixelNow;
            yMaxFirst = y;
          }
          
          //Check if this pixel is brighter or as bright. When is the last pixel of the brightest.
          if(PixelNow>=PixelMax) {
            PixelMax = PixelNow;
            yMaxLast = y;
          }
          
        }
        
        PointNr3D++;
        yMax = (yMaxFirst + yMaxLast) / 2;          // Calculate the average pixel.
        point(x,yMax);                              // draw point on screen
        myExportObj.addLinePoint(x, yMax , z);      // add point to ojb-file
        
      }
      z = z + zIncrement;
      scannCollom++;
    }
  }
  
  boolean imgExist(String _fullImagesName) {
    //Check the last image is reached

    File f = new File(dataPath(_fullImagesName));
    
    if (f.exists())
    {
      return true;
    }else{
      EOF = true;
      myExportObj.writeFooter(PointNr3D,scannCollom);    // Make polygon off all points
      return false;
    }
  }
  
  
}
