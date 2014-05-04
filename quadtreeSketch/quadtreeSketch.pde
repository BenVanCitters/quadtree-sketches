QuadTree myTree;
void setup()
{
  size(500,500);
  myTree = new QuadTree(new float[]{width/2,height/2});
}

void draw()
{
  background(0);
  myTree.draw();
  if(mousePressed)
  myTree.addChild(new QuadTree(new float[]{mouseX,mouseY}));
}

void mousePressed()
{
  println(millis());
  
}
