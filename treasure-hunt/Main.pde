final int WIDTH = 500;
final int HEIGHT = 500;
final int COLC = 100;
final int ROWC = 100;
final int COLU = WIDTH / COLC;
final int ROWU = HEIGHT / ROWC;
boolean paused = false;
ArrayList<ArrayList<Square>> states;
int stateCounter = 0;
SearchBoard board;
void setup() {
  size(500, 500);
  board = new SearchBoard(Mode.AS, Heuristic.L1, 10, 0);
  drawBoard(board.board);
  frameRate(120);
  states = new ArrayList<>();
  
  while (board.step()) {
    states.add(board.cloneBoard());
  }
  states.add(board.cloneBoard());
}

void draw() {
  background(100);
  drawBoard(states.get(stateCounter));
  if (!paused) {
    stateCounter = min(states.size() - 1, stateCounter + 1);
  }
}

void keyPressed() {
  switch (keyCode) {
    case ' ': paused = !paused;
              break;
    case LEFT: stateCounter = max(0, stateCounter - 1);
               break;
    case RIGHT: stateCounter = min(states.size() - 1, stateCounter + 1);
                break;
    
  }
}

private boolean isValidIndex(PVector coords) {
  return coords.x > -1 && coords.y > -1 && coords.x < ROWC && coords.y < COLC;
}

private int _2DIndex(int row, int col) {
  return row * COLC + col;
}

private int _2DRow(int index2D) {
  return index2D / COLC; 
}

private int _2DCol(int index2D) {
  return index2D % COLC;
}

private void drawRect(int index) {
  // the row and column here are reversed due to the coordinate system
  noStroke();
  rect(_2DCol(index) * COLU,_2DRow(index) * ROWU , COLU, ROWU);
}

public void drawBoard(ArrayList<Square> board) {
  for (int i = 0; i < ROWC * COLC; i++) {
    fill(board.get(i).c);
    drawRect(i);
  }
}
