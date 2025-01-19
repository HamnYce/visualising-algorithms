enum Mode {
  BFS,
  DFS,
  AS
}

class Fringe {
  LinkedList<Node> fringe;
  Mode mode;
  
  Fringe(Mode mode) {
    this.mode = mode;
    this.fringe = new LinkedList<>();
  }
  
  public void push(Node node) {
    switch (this.mode) {
      
      case DFS: this.fringe.addLast(node); // simulate stack
                return;
      case BFS: this.fringe.addFirst(node); // simulate queue
                return;
      case AS: this.fringe.addLast(node); 
               Collections.sort(this.fringe); // sort the lowest cost at the ene (to simplify popping just pop off)
               return; // 
      
    }
  }
  
  public Node pop() {
     return this.fringe.removeLast();
  }
  
  public int size() {
    return this.fringe.size();
  }
  
  public boolean isEmpty() {
    return this.fringe.isEmpty();
  }

  public void clear() {
    fringe.clear();
  }
  
  
  
  
}
