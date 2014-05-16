import java.util.PriorityQueue;

class MyOctTree
{
  public enum OctIndex 
  {
    BottomLeftBack,BottomLeftFront,UpperLeftBack,UpperLeftFront,
    BottomRightBack, BottomRightFront,UpperRightBack, UpperRightFront
  }
  private final float offSetMults[][] = new float[][]{{-1,-1,-1},{-1,-1,1},{-1,1,-1},{-1,-1,1},
                                                      {1,-1,-1},{1,-1,1},{1,1,-1},{1,1,1}};
                                  
  private OctNode rootNode;
  private PriorityQueue<HeapNode> searchHeap = new PriorityQueue<HeapNode>(64,new HeapNodeComparator()); 
  int totalTreeWt = 255;
  int totalTreeHt = 255;
  int totalTreeDt = 255;
  
  public MyOctTree()
  {
    rootNode = new OctNode();
//    rootNode.bounds = new float[]{0,0,0,255,255,255};
    
    rootNode.position = new float[]{totalTreeWt/2,totalTreeHt/2,totalTreeDt/2};
  }
  
  public void insertData(float data[])
  {
    insertNode(data, rootNode,1,rootNode.position);
  }
  
  private void insertNode(float data[], OctNode currentNode,int level, float curPos[])
  {
    boolean isXGreater = (data[0] > currentNode.position[0]);
    boolean isYGreater = (data[1] > currentNode.position[1]);
    boolean isZGreater = (data[2] > currentNode.position[2]);
    //the index we build here cooresponds to the enum above 'OctIndex'
    int index = isZGreater ? 0:1;
    index = isYGreater ? index|2:index;
    index = isXGreater ? index|4:index;
    if(currentNode.children[index] == null)
    {
      currentNode.children[index] = new OctNode(data);
    }
    else
    {
      if(pow(totalTreeWt, 1.f/level) < 1 ||
         currentNode.position[0] == data[0] &&  
         currentNode.position[1] == data[1] &&  
         currentNode.position[2] == data[2])
      { 
         println("This tree cannot contain duplicate datum");
         return;
      }
      OctNode tmp = currentNode.children[index];
//        int totalTreeWt = 255;
//  int totalTreeHt = 255;
//  int totalTreeDt = 255;
  
      float newBranchPos[] = new float[]{(float)(curPos[0] + offSetMults[index][0]*totalTreeWt/pow(2, level)),
                                         (float)(curPos[1] + offSetMults[index][1]*totalTreeHt/pow(2, level)),
                                         (float)(curPos[2] + offSetMults[index][2]*totalTreeDt/pow(2, level))};
      println("splitting nodes; level: " +level+", newBPos: " + newBranchPos[0] + "," + newBranchPos[1] + "," + newBranchPos[2]);
      println(" currentNode.position: " + currentNode.position[0] + "," + currentNode.position[1] + "," + currentNode.position[2]);
      println(" tmp.position: " + tmp.position[0] + "," + tmp.position[1] + "," + tmp.position[2]);
      println(" data: " + data[0] + "," + data[1] + "," + data[2]);
      currentNode.children[index] = new OctNode(newBranchPos);
      insertNode(tmp.position, currentNode.children[index],level+1,newBranchPos);
      insertNode(data, currentNode.children[index],level+1,newBranchPos);
    }
    //cases
    //has 8 children - pick approp. child and recurse
    //is leaf & empty - enter data
    //is leaf & full - add new branch node with eight children and add the prev and new node  
  }
  
  public void removeNode()
  {
    
  }
  
  public float[] getNearestNodePos(float[] data)
  {
    searchHeap.clear();
    OctNode nearestNode = getNearestNode(data, rootNode);
    //remove the node
    return nearestNode.position; 
  }

  private OctNode getNearestNode(float data[], OctNode currentNode)
  {   
    if(isLeafNode(currentNode))
      return currentNode;
    
    for(int i = 0 ;i < currentNode.children.length; i++)
    {
      if(currentNode.children[i] != null)
      {
        float distToNode = dist(data[0],data[0],data[0],
                                currentNode.children[i].position[0],currentNode.children[i].position[1],currentNode.children[i].position[2]);
        searchHeap.add(new HeapNode(currentNode.children[i],distToNode));
      }                             
    }
    if(searchHeap.size() < 1)
       return null;
    return getNearestNode(data,searchHeap.poll().node);
  }
  
  private boolean isLeafNode(OctNode node)
  {
    for(int i = 0 ;i < node.children.length; i++)
      if(node.children[i] != null) return false; 
    return true;
  }

  public boolean containsNodeAtPos(float pos[])
  {
     OctNode tmp = getNodeAtPos(pos, rootNode);
     return tmp != null;
  }
  
  private OctNode getNodeAtPos(float data[], OctNode currentNode)
  { 
    if(isLeafNode(currentNode))
    {
      if(currentNode.position[0] == data[0] &&  
         currentNode.position[1] == data[1] &&  
         currentNode.position[2] == data[2])
        return currentNode;
      else
        return null;
    }
    boolean isXGreater = (data[0] > currentNode.position[0]);
    boolean isYGreater = (data[1] > currentNode.position[1]);
    boolean isZGreater = (data[2] > currentNode.position[2]);
    int index = isZGreater ? 0:1;
    index = isYGreater ? index|2:index;
    index = isXGreater ? index|4:index;
    if(currentNode.children[index] != null)
    {
      return getNodeAtPos(data,currentNode.children[index]); 
    }  
    return null;
    
  }

  public void getNearbyNodes()
  {
    
  }
  
  public void renderTree()
  {
    hint(DISABLE_DEPTH_TEST);
    renderTree(rootNode,0,rootNode.position);
    hint(ENABLE_DEPTH_TEST);
  }
  
  private void renderTree(OctNode currentNode, int level, float curPos[])
  {
    if(currentNode == null)
      return;


    

    if(isLeafNode(currentNode))
    {
      pushMatrix();
      translate(currentNode.position[0],currentNode.position[1],currentNode.position[2]);
      stroke(255,0,0);
      fill(255,0,0,100);
      box(15);      
      popMatrix();
    }
    else
    {
      pushMatrix();
//      translate(currentNode.position[0],currentNode.position[1],currentNode.position[2]);
translate(curPos[0],curPos[1],curPos[2]);

      fill(255,10);
      stroke(255,40);
      box(2*totalTreeWt/pow(2,level));      
      popMatrix();
      for(int i = 0 ;i < currentNode.children.length; i++)
      {
        float newBranchPos[] = new float[]{(float)(curPos[0] - offSetMults[i][0]*totalTreeWt/pow(2, level)),
                                           (float)(curPos[1] - offSetMults[i][1]*totalTreeHt/pow(2, level)),
                                           (float)(curPos[2] - offSetMults[i][2]*totalTreeDt/pow(2, level))};
        stroke(0,255,0);
        if(currentNode.children[i] != null)
        {
          
          line(currentNode.position[0],currentNode.position[1],currentNode.position[2],
          currentNode.children[i].position[0],currentNode.children[i].position[1],currentNode.children[i].position[2]);        
        }
        renderTree(currentNode.children[i],level+1,newBranchPos);
      }
    }
  }
  
  private class OctNode
  {
    float position[];
//    float bounds[];
    OctNode children[];
    public OctNode(float pos[]/*,float bounds[]*/)
    {
      children = new OctNode[8];
      position = pos;
      println("new node! @ " + pos[0]+"," + pos[1]+"," + pos[2]);
//      this.bounds = bounds;
    }
    public OctNode()
    {
      children = new OctNode[8];
      position = new float[3];
//      bounds = new float[3];
    }
  }
 
  private class HeapNode
  {
      OctNode node;
      float distance;
      public HeapNode(OctNode nd,float d)
      {
        node = nd;
        distance = d;
      }
  }
  
  public class HeapNodeComparator implements java.util.Comparator
{
  public int compare(Object o1, Object o2)
  {
    HeapNode s1 = (HeapNode)o1;
    HeapNode s2 = (HeapNode)o2;
    
    return (int)(s1.distance - s2.distance);
  }
}
}
