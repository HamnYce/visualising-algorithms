# Visualising Algorithms

This repository contains visualisations for two different algorithms: a minimax algorithm and a treasure hunt algorithm using BFS, DFS, and A\* search strategies.

## Minimax Algorithm

This visualisation demonstrates a minimax algorithm with two agents. Each agent attempts to collect treasures while denying the opponent from collecting theirs. The visualisation allows you to:

- **Pause**: Press the `space` key to pause or resume the visualisation.
- **Rewind**: Press the `left arrow` key to rewind the visualisation.
- **Fast-forward**: Press the `right arrow` key to fast-forward the visualisation.

## Treasure Hunt Algorithm

This visualisation shows an agent collecting treasures using different search strategies: BFS (Breadth-First Search), DFS (Depth-First Search), and A\* search. The visualisation allows you to:

- **Pause**: Press the `space` key to pause or resume the visualisation.
- **Rewind**: Press the `left arrow` key to rewind the visualisation.
- **Fast-forward**: Press the `right arrow` key to fast-forward the visualisation.

## How to Run

1. Clone the repository:

   ```sh
   git clone <repository-url>
   ```

2. Open the project in your preferred Processing IDE.
3. Run the sketches to see the visualisations in action.

## File Structure

- `minimax/`: Contains the minimax algorithm visualisation.
  - `Main.pde`: Main sketch for the minimax visualisation.
  - `State.pde`: Defines the state of the game.
  - `sketch.properties`: Properties file for the Processing sketch.
- `treasure_hunt/`: Contains the treasure hunt algorithm visualisation.
  - `Main.pde`: Main sketch for the treasure hunt visualisation.
  - `Node.pde`: Defines the node structure for the search algorithms.
  - `SearchBoard.pde`: Defines the search board and search logic.
  - `Square.pde`: Defines the square structure on the board.
  - `Fringe.pde`: Defines the fringe for the search algorithms.
  - `sketch.properties`: Properties file for the Processing sketch.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Acknowledgements

Special thanks to the contributors and the Processing community for their support and resources.
