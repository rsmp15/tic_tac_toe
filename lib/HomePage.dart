import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool ohTurn = true;
  List<String> displayExOh = List.filled(9, '');
  bool gameOver = false;
  int filledBoxes = 0;

  void _tapped(int index) {
    // Prevent tapping if box is filled or game is over
    if (gameOver || displayExOh[index] != '') return;

    setState(() {
      displayExOh[index] = ohTurn ? 'O' : 'X';
      filledBoxes++;
      ohTurn = !ohTurn;
      _checkWinner();
    });
  }

  void _checkWinner() {
    // Winning combinations
    List<List<int>> winPatterns = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
      [0, 4, 8], [2, 4, 6], // Diagonals
    ];

    for (var pattern in winPatterns) {
      if (displayExOh[pattern[0]] != '' &&
          displayExOh[pattern[0]] == displayExOh[pattern[1]] &&
          displayExOh[pattern[0]] == displayExOh[pattern[2]]) {
        _showResultDialog("Winner: ${displayExOh[pattern[0]]}");
        gameOver = true;
        return;
      }
    }

    // Check for Draw
    if (filledBoxes == 9 && !gameOver) {
      _showResultDialog("It's a Draw!");
      gameOver = true;
    }
  }

  void _showResultDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E), // Deep dark background
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
            side: const BorderSide(color: Colors.blueAccent, width: 1), // Subtle glow effect
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min, // Wrap content height
            children: [
              const Icon(
                Icons.emoji_events_rounded, // Trophy icon
                color: Colors.amber,
                size: 60,
              ),
              const SizedBox(height: 20),
              Text(
                message.toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 10),
                const Text(
                  "Great effort! Ready for another round?",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: ElevatedButton(
                onPressed: () {
                  _resetGame();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),

                ),
                child: const Text(
                  "PLAY AGAIN",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _resetGame() {
    setState(() {
      displayExOh = List.filled(9, '');
      ohTurn = true;
      gameOver = false;
      filledBoxes = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Turn Indicator
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      ohTurn ? "O's Turn" : "X's Turn",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 4,
                      width: 40,
                      decoration: BoxDecoration(
                        color: ohTurn ? Colors.redAccent : Colors.blueAccent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),

                // The Grid - flexible and square
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 9,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                              ),
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () => _tapped(index),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1E1E1E),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: displayExOh[index] == ''
                                        ? Colors.white10
                                        : (displayExOh[index] == 'O'
                                              ? Colors.redAccent.withValues(
                                                  alpha: 0.5,
                                                )
                                              : Colors.blueAccent.withValues(
                                                  alpha: 0.5,
                                                )),
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    displayExOh[index],
                                    style: TextStyle(
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold,
                                      color: displayExOh[index] == 'O'
                                          ? Colors.redAccent
                                          : Colors.blueAccent,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),

                // Reset Button
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: OutlinedButton(
                    onPressed: _resetGame,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white24),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "RESET BOARD",
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
