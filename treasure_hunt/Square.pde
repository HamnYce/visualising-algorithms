enum SquareT {
  UNVISITED,
  TREASURE,
  OBSTACLE,
  VISITED_PATH,
  VISITED_TREASURE,
  EXPANDED,
  PATH
}

class Square {
  SquareT type;
  color c;
  
  Square(SquareT type, color c) {
    this.type = type;
    this.c = c;
  }
  
  Square(color c) {
    this.type = SquareT.UNVISITED;
    this.c  = c;
  }
  
  Square(SquareT type) {
    this.type = type;
    this.c = color(255, 255, 255);
  }
  
  Square() {
    this.type = SquareT.UNVISITED;
    this.c = color(255, 255, 255);
  }
  
  void setType(SquareT type) {
    this.type = type;
    
    
  }
  
  void setColor(color c) {
    this.c = c;
  }
  
  void setColor(SquareT type) {
    switch (type) {
      case TREASURE: this.c = color(0, 255, 0);  
                     break;
      case OBSTACLE: this.c = color(255, 0, 0);
                     break;
      default: break;
    }
  }
  
  void setTreasureColor() {
  }
  
  void setObstacleColor() {
  }
  
  void visit() {
    if (this.isUnvisited()) {
      this.type = SquareT.VISITED_PATH;
      this.c = color(red(this.c), green(this.c) - 40, blue(this.c));
    }
    else if (this.isTreasure()) {
      this.type = SquareT.VISITED_TREASURE;
      this.c = color(red(this.c) + 40, green(this.c), blue(this.c));
    }
  }
  
  void unvisit() {
    this.type = SquareT.UNVISITED;
  }
  
  void expand() {
    this.type = SquareT.EXPANDED;
  }
  
  boolean isUnvisited() {
    return this.type == SquareT.UNVISITED ;
  }
  
  boolean isTreasure() {
    return this.type == SquareT.TREASURE;
  }
  
  boolean isVisitedPath() {
    return this.type == SquareT.VISITED_PATH;
  }
  
  boolean isVisitedTreasure() {
    return this.type == SquareT.VISITED_TREASURE;
  }
  
  boolean isExpanded() {
    return this.type == SquareT.EXPANDED;
  }
  
  Square clone() {
    return new Square(this.type, this.c);
  }
}
