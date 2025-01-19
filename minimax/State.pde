class State {
  ArrayList<Square> board;
  int p1Index, p1Treasure;
  int p2Index, p2Treasure;
  boolean isP1Turn;
  State bestNextState;
  

  State(ArrayList<Square> board, int p1Index, int p2Index, boolean isP1Turn, int p1Treasure, int p2Treasure) {
    this.board = board;
    this.p1Index = p1Index;
    this.p2Index = p2Index;
    this.isP1Turn = isP1Turn;
    this.p1Treasure = p1Treasure;
    this.p2Treasure = p2Treasure;
  }

  State move(int nextIndex) {
    State nextState = new State(
        (ArrayList<Square>) this.board.clone(),
        this.p1Index,
        this.p2Index,
        this.isP1Turn,
        this.p1Treasure,
        this.p2Treasure
     );
     
     if (nextState.board.get(nextIndex) == Square.TREASURE) {
      if (nextState.isP1Turn) nextState.p1Treasure++;
      else nextState.p2Treasure++;
     }

    nextState.board.set(nextState.isP1Turn ? nextState.p1Index : nextState.p2Index, Square.VISITED);
    nextState.board.set(nextIndex, nextState.isP1Turn ? Square.P1 : Square.P2);
    
    if (nextState.isP1Turn) nextState.p1Index = nextIndex;
    else nextState.p2Index = nextIndex;
    
    nextState.isP1Turn = !nextState.isP1Turn;
    
    return nextState;
  }

  int evaluate() {
    return this.p1Score() - this.p2Score();
  }
  
  int p1Score() {
    return this.p1Treasure * 100;
  }
  
  int p2Score() {
    return this.p2Treasure * 100;
  }
  
  boolean isValidIndex(int index) {
    Square nextSquare = this.board.get(index);
    return nextSquare == Square.UNVISITED || nextSquare == Square.TREASURE;
  }
  
  boolean isTerminal() {
    boolean hasTreasure = false, p1CanMove = false, p2CanMove = false;
  
    for (Square square : this.board) {
      hasTreasure = hasTreasure || square == Square.TREASURE;
    }
    
    for (int nextP1 : nextIndexes(this.p1Index)) {
      p1CanMove = p1CanMove || this.isValidIndex(nextP1);
    }
    
    for (int nextP2 : nextIndexes(this.p2Index)) {
      p2CanMove = p2CanMove || this.isValidIndex(nextP2);
    }
  
    return !hasTreasure || (!p1CanMove && !p2CanMove);
  }
  
  int distToClosestTreasure(int index) {
    int row = _2DRow(index);
    int col = _2DCol(index);
    int dis = -1;

    for (int i = 0 ; i < this.board.size(); i++) {
      Square square = this.board.get(i);
      if (square == Square.TREASURE) {
        int tempDis = abs(row - _2DRow(i)) + abs(col - _2DCol(i));
        dis = min(dis, tempDis);
      }
    }
    return dis;
  }
}
