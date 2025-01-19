class Node implements Comparable<Node> {
  int row, col, index;
  public PVector pos;
  public float backEdge, frontEdge;
  public Square square;
  public Node parent;

  Node(int row, int col, float backEdge, Node parent, Square square) {
    this.row = row;
    this.col = col;
    this.index = row * COLC + col;
    this.square = square;
    
    this.backEdge = backEdge;
    this.parent = parent;
  }
  
  public float totalCost() {
    return this.backEdge + this.frontEdge;
  }
  
  
  // comparator for A* fringe
  @Override
  public int compareTo(Node other) {
    return Float.compare(other.totalCost(), this.totalCost());
  }
  
}
