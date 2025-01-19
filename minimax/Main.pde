import java.util.*;

enum Square {
  UNVISITED,
  VISITED,
  P1,
  P2,
  TREASURE
}

int WIDTH = 400, HEIGHT = 400;
int COLC = 5, ROWC = 5;
int COLU = WIDTH / COLC;
int ROWU = HEIGHT / ROWC;
int INITIAL_TREASURE_COUNT = 3;
ArrayList<State> states;
int stateNum = 0;
State initialState;
boolean paused = false;

void setup() {
  textSize(50);
  textAlign(CENTER);
  size(400, 400);
  
  ArrayList<Square> board = new ArrayList<>();
  ArrayList<Integer> treasures = new ArrayList<>();
  
  states = new ArrayList<>();
  
  
  for (int i = 0; i < COLC * ROWC; i++) {
    board.add(Square.UNVISITED);
  }
  
  while (treasures.size() < INITIAL_TREASURE_COUNT) {
    int index = int(random(board.size()));
    if (index == 0 || index == board.size() - 1 || board.get(index) == Square.TREASURE) continue;
    
    treasures.add(index);
    board.set(index, Square.TREASURE);
  }
  
  board.set(0, Square.P1);
  board.set(board.size() - 1, Square.P2);
  
  initialState = new State(board, 0, board.size() - 1, true, 0, 0);
  
  println("Minimax end result: " + value(initialState, Integer.MIN_VALUE, Integer.MAX_VALUE));
  
  getStates(initialState);
  
  println("numbers of states: " + states.size());
  
  frameRate(15);

}

void draw() {
  if (!paused) stateNum = min(states.size() - 1, stateNum + 1);
  State currentState = states.get(stateNum);


  drawBoard(currentState.board);
  
  fill(0);
  text(
    String.format(
      "p1: %d p2: %d", 
      currentState.p1Treasure,
      currentState.p2Treasure
      ),
    width / 2, 50
    );
}

void keyPressed() {
  switch (keyCode) {
    case ' ': paused = !paused;
              break;
    case LEFT: stateNum = max(0, stateNum - 1);
               break;
    case RIGHT: stateNum = min(states.size() - 1, stateNum + 1);
                break;
  }
}

void getStates(State state) {
  if (state == null) return;
  states.add(state);
  getStates(state.bestNextState);
}

int value(State state, int alpha, int beta) {
  if (state.isTerminal()) {
    return state.evaluate();
  }

  int v = state.isP1Turn ? Integer.MIN_VALUE : Integer.MAX_VALUE;

  for (int nextIndex : nextIndexes(state.isP1Turn ? state.p1Index : state.p2Index)) {
    if (!state.isValidIndex(nextIndex)) continue;

    State nextState = state.move(nextIndex);

    int nextV = value(nextState, alpha, beta);

    if ((state.isP1Turn && nextV >= v) || (!state.isP1Turn && nextV <= v)) {
      state.bestNextState = nextState;
      v = nextV;
      
      // alpha beta pruning
      if (state.isP1Turn) {
        if (v >= beta) return v;
        alpha = max(alpha, v);
      }
      if (!state.isP1Turn) {
        if (v <= alpha) return v;
        beta = min(beta, v);
      }
    }
   }
   
   // if no move is made that means there is no valid move for the current player
   // therefore the current player moves onto the same position again to simulate
   // a move skip
   if (v == Integer.MIN_VALUE || v == Integer.MAX_VALUE) {
     state.bestNextState = state.move(state.isP1Turn ? state.p1Index : state.p2Index);
     v = value(state.bestNextState, alpha, beta);
   }
   
   return v;
}


ArrayList<Integer> nextIndexes(int index) {
  ArrayList<Integer> actions = new ArrayList<>();

  int row = _2DRow(index);
  int col = _2DCol(index);
  if (isWithinBounds(row - 1, col)) actions.add(_2DIndex(row - 1, col));

  if (isWithinBounds(row + 1, col)) actions.add(_2DIndex(row + 1, col));

  if (isWithinBounds(row, col - 1)) actions.add(_2DIndex(row, col - 1));

  if (isWithinBounds(row, col + 1)) actions.add(_2DIndex(row, col + 1));

  return actions;
}

boolean isWithinBounds(int row, int col) {
  return row > -1 && row < ROWC && col > -1 && col < COLC;
}

int _2DIndex(int row, int col) {
  return row * COLC + col;
}

int _2DRow(int index) {
  return index / COLC;
}

int _2DCol(int index) {
  return index % COLC;
}

void setFill(Square t) {
  switch (t) {
    case UNVISITED: fill(255);
                    break;
    case VISITED: fill(122);
                  break;
    case P1: fill(0,255,255);
             break;
    case P2: fill(255,0,255);
             break;
    case TREASURE: fill(0, 255, 0);
                   break;
  }
}

void drawRect(int index) {
  rect(_2DCol(index) * COLU, _2DRow(index) * ROWU, COLU, ROWU);
}

void drawBoard(ArrayList<Square> board) {
  for (int i = 0 ; i < board.size(); i++) {
    setFill(board.get(i));
    drawRect(i);
  }
}
