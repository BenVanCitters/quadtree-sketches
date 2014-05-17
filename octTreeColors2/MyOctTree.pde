import java.util.PriorityQueue;

class MyOctTree
{
  public enum OctIndex 
  {
    BottomLeftBack,BottomLeftFront,UpperLeftBack,UpperLeftFront,
    BottomRightBack, BottomRightFront,UpperRightBack, UpperRightFront
  }
  private final float offSetMults[][] = new float[][]{{-1,-1,-1},{-1,-1,1},{-1,1,-1},{-1,1,1},
                                                      {1,-1,-1},{1,-1,1},{1,1,-1},{1,1,1}};
                                  
  private OctNode rootNode;
  private PriorityQueue<HeapNode> searchHeap = new PriorityQueue<HeapNode>(24,new HeapNodeComparator()); 
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
    boolean isXGreater = (data[0] > curPos[0]);
    boolean isYGreater = (data[1] > curPos[1]);
    boolean isZGreater = (data[2] > curPos[2]);
    //the index we build here cooresponds to the enum above 'OctIndex'
    int index = isZGreater ? 1:0;
        index = isYGreater ? index|2:index;
        index = isXGreater ? index|4:index;
//    println("attempting insert at index: ==" + index + "== data:" + data[0] + "," + data[1]+"," + data[2] + 
//            " curPos:"+ curPos[0] + "," + curPos[1]+"," + curPos[2]);
    if(currentNode.children[index] == null)
    { 
//      println("newNode!");
      currentNode.children[index] = new OctNode(data);
    }
    else
    {
      double denom = java.lang.Math.pow(2, level);
      float newBranchPos[] = new float[]{(float)(curPos[0] + .5*offSetMults[index][0]*totalTreeWt/denom),
                                         (float)(curPos[1] + .5*offSetMults[index][1]*totalTreeHt/denom),
                                         (float)(curPos[2] + .5*offSetMults[index][2]*totalTreeDt/denom)};
      if(isLeafNode(currentNode.children[index]))
      {
        if(currentNode.position[0] == data[0] &&  
           currentNode.position[1] == data[1] &&  
           currentNode.position[2] == data[2])
        { 
           println("This tree cannot contain duplicate datum-- data: " + data[0] + "," + data[1] + "," + data[2]);
           println("-currentNode.children: 0 " + currentNode.children[0] + ", 1" + currentNode.children[1] + ", 2 " + currentNode.children[2] + 
                                    ", 3 " + currentNode.children[3] + ", 4 " + currentNode.children[4] + ", 5 " + currentNode.children[5] + 
                                     ", 6 " + currentNode.children[6] + ", 7 " + currentNode.children[7]);
           return;
        }
        
//        OctNode tmp = currentNode.children[index];
        float replacedNodePos[] = new float[]{currentNode.children[index].position[0],
                                              currentNode.children[index].position[1],
                                              currentNode.children[index].position[2]}; 
//        println("splitting nodes; level: " +level+", newBPos: " + newBranchPos[0] + "," + newBranchPos[1] + "," + newBranchPos[2]);
//        println(" currentNode.position: " + currentNode.position[0] + "," + currentNode.position[1] + "," + currentNode.position[2] + 
//        " tmp.position: " + tmp.position[0] + "," + tmp.position[1] + "," + tmp.position[2]+
//        " data: " + data[0] + "," + data[1] + "," + data[2]+ 
//        " curPos: " + curPos[0] + "," + curPos[1] + "," + curPos[2] + 
//        " denom: " + denom);
//        println(" currentNode.position: " + currentNode.position[0] + "," + currentNode.position[1] + "," + currentNode.position[2]);
//        println(" tmp.position: " + tmp.position[0] + "," + tmp.position[1] + "," + tmp.position[2]);
//        println(" data: " + data[0] + "," + data[1] + "," + data[2]);
//        println(" curPos: " + curPos[0] + "," + curPos[1] + "," + curPos[2]);
//        println(" denom: " + denom); 
//        if(denom == Double.POSITIVE_INFINITY)
        if(level > 24)
        {
          println("whoa WTFFF?!? exceeded level " + level + " data: " + data[0] + "," + data[1] + "," + data[2]);  
          return;
        }
        currentNode.children[index] = new OctNode(newBranchPos);
        insertNode(replacedNodePos, currentNode.children[index],level+1,newBranchPos);
        insertNode(data, currentNode.children[index],level+1,newBranchPos);
      }
      else
      {
        insertNode(data, currentNode.children[index],level+1,newBranchPos);
      }
    }
    //cases
    //has 8 children - pick approp. child and recurse
    //is leaf & empty - enter data
    //is leaf & full - add new branch node with eight children and add the prev and new node  
  }
  
  public float[] findAndRemoveNearestNode(float[] data)
  {
    searchHeap.clear();
//    if(isLeafNode(rootNode))
//      return null; //cannot remove the root node!!!
    OctNode node = findAndRemoveNearestNode(data, rootNode);
    return node.position;
  }
  
  private OctNode findAndRemoveNearestNode(float data[], OctNode currentNode)
  { 
    if(isLeafNode(currentNode))//we found the node now delete it
    {
//      int childCount = 0;
//      for(int i = 0;i < currentNode.children.length; i++)
//      {
//       if(currentNode.children[i] != null)
//         childCount++;
//      }
//      println("removable node: " + currentNode+ "[" + 
//        currentNode.position[0]+ "," +currentNode.position[1]+ "," +currentNode.position[2] + "] childcount: " + childCount);
      return currentNode;
    }
//    println("HEAPSZ: " + searchHeap.size());
    for(int i = 0;i < currentNode.children.length; i++)
    {
      if(currentNode.children[i] != null)
      {
//        println("- child heap node: " + currentNode.children[i] + "[" + 
//                currentNode.children[i].position[0]+ "," +currentNode.children[i].position[1]+ "," +currentNode.children[i].position[2] + "]");
        float distToNode = dist(data[0],data[1],data[2],
                                currentNode.children[i].position[0], currentNode.children[i].position[1], currentNode.children[i].position[2]);
        searchHeap.add(new HeapNode(currentNode.children[i],distToNode));
      }                             
    }
//    println("HEAPSZ: " + searchHeap.size());
    if(searchHeap.size() < 1)
       return null;
    OctNode tmpNode =findAndRemoveNearestNode(data, searchHeap.poll().node);
    //now that we have the 'closest' node we need to think about some balancing
    int remainingChildCount = 0; 
    int lastChildIndex = -1;
    for(int i = 0 ;i < currentNode.children.length; i++)
    {
      if(currentNode.children[i] != null && currentNode.children[i] == tmpNode)
      {
        currentNode.children[i] = null; //actually 'delete'/'remove' the node
//        println("erased the child");
      }   
      if(currentNode.children[i] != null)
      {
        remainingChildCount++;
        lastChildIndex = i;
      }
    }
    if(remainingChildCount == 1 && isLeafNode(currentNode.children[lastChildIndex]))
    {
      currentNode.position[0] = currentNode.children[lastChildIndex].position[0];
      currentNode.position[1] = currentNode.children[lastChildIndex].position[1];
      currentNode.position[2] = currentNode.children[lastChildIndex].position[2];
      currentNode.children[lastChildIndex] = null;
    }  
    return tmpNode;
  }
  
  public float[] getNearestNodePos(float[] data)
  {
    long startTime = millis();
    searchHeap.clear();
    OctNode nearestNode = getNearestNode(data, rootNode);
    
//    pushMatrix();
//    hint(DISABLE_DEPTH_TEST);
//    translate(-rootNode.position[0],-rootNode.position[1],-rootNode.position[2]);
//    OctNode nearestNode = getNearestNodeRender(data, rootNode, 0);
//    hint(ENABLE_DEPTH_TEST);
//    popMatrix();
//    println("getNearestNodePos(float[] data) Duration (millis): " + (millis()-startTime)); 
    
    //remove the node
    return nearestNode.position; 
  }

 
  private OctNode getNearestNodeRender(float data[], OctNode currentNode, int level)
  {   
//    println("currentNode: " + currentNode + " level: " + level);
    if(isLeafNode(currentNode))
    {
      pushMatrix();
        translate(currentNode.position[0],currentNode.position[1],currentNode.position[2]);
        stroke(0,255,0);
        fill(0,0,255);
        box(17);      
      popMatrix();
      return currentNode;
    }
    for(int i = 0 ;i < currentNode.children.length; i++)
    {
      if(currentNode.children[i] != null)
      {
        float distToNode = dist(data[0],data[1],data[2],
                                currentNode.children[i].position[0], currentNode.children[i].position[1], currentNode.children[i].position[2]);
        pushMatrix();
        translate(currentNode.children[i].position[0],currentNode.children[i].position[1],currentNode.children[i].position[2]);
        stroke(255,0,255,100);
        fill(255,0,255,100);
        box(8);      
        popMatrix();
        searchHeap.add(new HeapNode(currentNode.children[i],distToNode));
      }                             
    }
    if(searchHeap.size() < 1)
       return null;
    return getNearestNodeRender(data,searchHeap.poll().node,level+1);
  }
 
  private OctNode getNearestNode(float data[], OctNode currentNode)
  {   
    if(isLeafNode(currentNode))
      return currentNode;
    
    for(int i = 0 ;i < currentNode.children.length; i++)
    {
      if(currentNode.children[i] != null)
      {
        float distToNode = dist(data[0],data[1],data[2],
                                currentNode.children[i].position[0], currentNode.children[i].position[1], currentNode.children[i].position[2]);
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
    pushMatrix();
    translate(-rootNode.position[0],-rootNode.position[1],-rootNode.position[2]);
    renderTree(rootNode,0,rootNode.position);
    popMatrix();
    hint(ENABLE_DEPTH_TEST);
  }
  
  private void renderTree(OctNode currentNode, int level, float curPos[])
  {
//    if(currentNode == null)
//      return;
      
    if(isLeafNode(currentNode))
    {
      pushMatrix();
      translate(currentNode.position[0],currentNode.position[1],currentNode.position[2]);
      stroke(255,0,0);
      fill(255,0,0,100);
      box(7);      
      popMatrix();
    }
    else
    {
      double denom = java.lang.Math.pow(2, level);
      pushMatrix();
//      translate(currentNode.position[0],currentNode.position[1],currentNode.position[2]);
      translate(curPos[0],curPos[1],curPos[2]);
      fill(255,10);
      stroke(255,40);
      box(totalTreeWt/(float)denom);      
      popMatrix();
      for(int i = 0 ;i < currentNode.children.length; i++)
      {
        float newBranchPos[] = new float[]{(float)(curPos[0] + .25*offSetMults[i][0]*totalTreeWt/denom),
                                           (float)(curPos[1] + .25*offSetMults[i][1]*totalTreeHt/denom),
                                           (float)(curPos[2] + .25*offSetMults[i][2]*totalTreeDt/denom)};
        
        if(currentNode.children[i] != null)
        {
          stroke(0,255,0);
          line(curPos[0],curPos[1],curPos[2],
               newBranchPos[0],newBranchPos[1],newBranchPos[2]);
         stroke(0,255,0,100);
          line(currentNode.position[0],currentNode.position[1],currentNode.position[2],
               currentNode.children[i].position[0],currentNode.children[i].position[1],currentNode.children[i].position[2]);        
          renderTree(currentNode.children[i],level+1,newBranchPos);  
        }
      }
    }
  }
  
  public void countAllNodes()
  {
    int count =  countLeafNodes(rootNode, 0, false,false);
    println("totalNodeCount = " + count);
  }
  
  public void printLeafNodes()
  {
    int count =  countLeafNodes(rootNode, 0, true, true);
    println("totalNodeCount = " + count);
  }
  private int countLeafNodes(OctNode currentNode, int level, boolean printNodes, boolean justLeaves)
  {
    if(currentNode == null)
      return 0;

    if(isLeafNode(currentNode))
    {
      if(printNodes)
        println("node: " + currentNode + ", pos: " + currentNode.position[0] + "," + currentNode.position[1] + "," + currentNode.position[2] );
      return 1;
    }
    else
    {
      int cCount = justLeaves?0:1;
      for(int i = 0 ;i < currentNode.children.length; i++)
      {
        if(currentNode.children[i] != null)
        {
          cCount += countLeafNodes(currentNode.children[i],level+1,printNodes, justLeaves);
        }
      }
      return cCount;
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
//      println("new node! @ " + pos[0]+"," + pos[1]+"," + pos[2]);
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
