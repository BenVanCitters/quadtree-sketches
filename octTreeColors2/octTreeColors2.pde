MyOctTree octTree = new MyOctTree();

void setup()
{
  size(900,900,P3D);
  PImage img = loadImage("never.jpg");
  img.resize(4096,4096);
  println("imageLoaded/resized");
  PGraphics p = createGraphics(4096,4096,P2D);
  
//insertRandomPos();
  insertAllColors();
  octTree.countAllNodes();
  /////
  
  ArrayList<Integer> indexList = new ArrayList<Integer>();
  for(int i = 0; i < img.pixels.length; i++)
    indexList.add(i);
  
  java.util.Collections.shuffle(indexList);
  
  p.beginDraw();
  p.loadPixels();
  img.loadPixels();
  for(int i =0; i < img.pixels.length; i++)
  {
    int myIndex = indexList.get(i);
    Integer myCurrColor = img.pixels[myIndex];
    float cRed = red(myCurrColor);
    float cGreen = green(myCurrColor);
    float cBlue = blue(myCurrColor);
    float newColor[] = octTree.findAndRemoveNearestNode(new float[]{cRed,cGreen,cBlue});
    if(newColor != null)
      p.pixels[myIndex] = color(newColor[0],newColor[1],newColor[2]);
    else
      println("cRed,cGreen,cBlue: " + cRed + ","+cGreen+ ","+cBlue + " - i: " + i + " myindex: " + myIndex); 
    if(i%(p.pixels.length/5000)==0)
      println("working on current pixel " + i  + " curMillis: " + millis());
  }
  p.updatePixels();
  p.endDraw();
  println("finished pixels + tm:" + millis() + "printing to screen");
  image(p,0,0,width,height);
  println("saving image to disk + tm:" + millis());
  p.save("myImage.png");
  println("done + tm:" + millis());
}

void insertAllColors()
{
  long startTime = millis();
  for(int i = 0; i < 256; i++)
  {
    for(int j = 0; j < 256; j++)
    {
      for(int k = 0; k < 256; k++)
      {
        float pos[] =new float[]{(int)i,(int)j,(int)k};
        octTree.insertData(pos);
      }
    }
    println("I:" + i + " curMillis: " + millis());
  }
  println("Insertion duration (millis): " + (millis()-startTime));
}


void draw()
{
//  pushMatrix();
//  float tm = millis()/1000.f;
//  
//  
//  background(0);
//  fill(255,50);
//  translate(width/2,height/2,-200);
//  scale(2);
////  rotateY(mouseX*TWO_PI/width);
//  octTree.renderTree();
//  
//  nearestPos = octTree.getNearestNodePos(queryPos);
//  
//  translate(-127,-127,-127);
//  pushMatrix();
//  translate(nearestPos[0],nearestPos[1],nearestPos[2]);
//  hint(DISABLE_DEPTH_TEST);
//  fill(255,255,0);stroke(255,255,0);
//  box(7);
//  popMatrix();
//  
//  translate(queryPos[0],queryPos[1],queryPos[2]);
//  fill(255,255,0,100);
//  box(7);
//  hint(ENABLE_DEPTH_TEST);
// 
//  popMatrix();

}



