import java.util.*;

enum Heuristic {
  L1,
  L2
}

class SearchBoard {
  Fringe fringe;
  Node lastNode, lastTreasure;
  Mode mode;
  Heuristic heuristic;
  
  ArrayList<Square> board;
  ArrayList<Square> boardBackup;
  
  ArrayList<Integer> treasureIndexes;
  ArrayList<Integer> treasureBackup;

  SearchBoard(Mode mode, Heuristic heuristic, int treasureAmount, int obstacleAmount) {
    this.treasureIndexes = new ArrayList<>();
    this.treasureBackup = new ArrayList<>();
    
    this.mode = mode;
    this.fringe = new Fringe(mode);
    
    this.board = new ArrayList<>();
    initBoard();
    

    this.treasureIndexes = sprinkleSquares(treasureAmount, SquareT.TREASURE);
    this.treasureBackup = (ArrayList<Integer>) this.treasureIndexes.clone();
    
    sprinkleSquares(obstacleAmount, SquareT.OBSTACLE);
    
    Node start = new Node(0, 0, 0f, null, this.board.get(0));
    this.board.get(0).visit();
    fringe.push(start);
    
    this.heuristic = heuristic;
  }

  public boolean step() {
    // fringe is empty or all treasures collected
    if (isGameOver()) {
      this.printEndGameMessage();
      this.colorInParents();
      return false;
    }

    Node currNode = this.fringe.pop();
    Square square = this.board.get(currNode.index);
    
    if (square.isVisitedTreasure()) {
      captureTreasure(currNode);
    }
    
    ArrayList<Node> nextNodes = getNextNodes(currNode);
    
    if (this.treasureIndexes.isEmpty()) {
      nextNodes.clear();
    }
    
    for (Node nextNode : nextNodes) {
      this.fringe.push(nextNode);

      // change color and type to visited version
      this.board.get(nextNode.index).visit();
    }

    board.get(currNode.index).expand();

    this.lastNode = currNode;
    
    return true;
  }
  
  private ArrayList<Node> getNextNodes(Node currNode) {
    ArrayList<Node> nextNodes = new ArrayList<>();
    
    PVector[] nexts = {
      new PVector(currNode.row + 1, currNode.col),
      new PVector(currNode.row - 1, currNode.col),
      new PVector(currNode.row, currNode.col - 1),
      new PVector(currNode.row, currNode.col + 1),
    };

    // checks bounds and is unvisited / treasure
    for (PVector next : nexts) {
      if (!isValidIndex(next)) continue;
      
      int row = int(next.x);
      int col = int(next.y);
      Square square = this.board.get(_2DIndex(row, col));

      // if it is anything besides UNVISITED || TREASURE then skip position
      if (!(square.isUnvisited() || square.isTreasure())) continue;

      Node node = new Node(row, col, currNode.backEdge + 1,currNode, square);
      node.frontEdge = this.heurFunc(node);

      nextNodes.add(node);
    }
    
    return nextNodes;
  }

  public void colorInParents() {
    getParents(new ArrayList<>(), this.lastNode).forEach((parent) -> parent.square.c = color(100, 100, 255, 150));
    treasureBackup.forEach((treasureIndex) -> this.board.get(treasureIndex).c = color(0, 255, 0));
  }

  private ArrayList<Node> getParents(ArrayList<Node> parents, Node parent) {
    if (parent == null) return parents;
    parents.add(parent);
    return getParents(parents, parent.parent);
  }

  private void captureTreasure(Node treasureNode) {
    this.fringe.clear();
    
    //makes all visited squares into unvisited
    unvisitBoard();
    
    this.board.get(treasureNode.index).unvisit();
    
    // inefficient removal of treasure from list
    this.treasureIndexes.removeIf((treasureIndex) -> treasureIndex == treasureNode.index);
    this.lastTreasure = treasureNode;
  }

  private void initBoard() {
    for (int i = 0; i < ROWC * COLC; i++) {
        board.add(new Square());
    }
  }

  private void unvisitBoard() {
    for (int i = 0; i < this.board.size(); i++) {
      Square sq = this.board.get(i);
      if (sq.isExpanded() || sq.isVisitedPath() ) {
        sq.unvisit();
      }
      else if (sq.isVisitedTreasure()) {
        sq.setType(SquareT.TREASURE);
      }
    }
  }

  // sprinkle (int)amount of (Square)square onto the board
  private ArrayList<Integer> sprinkleSquares(int amount, SquareT type) {
    ArrayList<Integer> indexes = new ArrayList<>();
    int index;
    for (int i = 0; i < amount; i++) {
      do {
        index = int(random(this.board.size()));
      } while(!board.get(index).isUnvisited() || index == 0); // while its either visited before or first square

      this.board.get(index).setType(type);
      this.board.get(index).setColor(type);
      
      indexes.add(index);
    }
    return indexes;
  }

  private float heurFunc(Node n) {
    float smallestDistance = Float.POSITIVE_INFINITY;
    for (int treasureIndex : this.treasureIndexes) {
      int treasureRow = _2DRow(treasureIndex);
      int treasureCol = _2DCol(treasureIndex);
      switch (this.heuristic) {
        case L1: smallestDistance = Math.min(smallestDistance, Math.abs(treasureRow - n.row) + Math.abs(treasureCol - n.col));
                 break;
        case L2: smallestDistance = Math.min(smallestDistance, dist(n.pos.x, n.pos.y, treasureRow, treasureCol));
                 break;
      }
    }
    return smallestDistance;
  }

 
  private boolean isGameOver() {
    return this.fringe.isEmpty() || this.treasureIndexes.isEmpty();
  }

  private void printEndGameMessage() {
    if (this.treasureBackup.size() > this.treasureIndexes.size()) {
      println("Acquired " + (this.treasureBackup.size() - this.treasureIndexes.size()) + " treasures!!");
      this.lastNode = this.lastTreasure;
    }
    else println("No treasures got! Better luck next time..");
  }
  
  ArrayList<Square> cloneBoard() {
    ArrayList<Square> clonedBoard = new ArrayList<>();
    for (Square sq : this.board) {
      clonedBoard.add(sq.clone());
    }
    
    return clonedBoard;
  }
  
  
}
