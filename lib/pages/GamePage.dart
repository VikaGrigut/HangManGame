import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int score = 0;
  int numOfAttempts = 6;
  int numOfLives = 5;
  int numOfHints = 3;
  String word = '';
  String underscores = '';
  List letterBtnStatus = List.filled(32, true);

  String _getImage() {
    String path = '';
    switch (numOfAttempts) {
      case 6:
        {
          path = 'my_res/images/0.png';
          break;
        }
      case 5:
        {
          path = 'my_res/images/1.png';
          break;
        }
      case 4:
        {
          path = 'my_res/images/2.png';
          break;
        }
      case 3:
        {
          path = 'my_res/images/3.png';
          break;
        }
      case 2:
        {
          path = 'my_res/images/4.png';
          break;
        }
      case 1:
        {
          path = 'my_res/images/5.png';
          break;
        }
      case 0:
        {
          path = 'my_res/images/6.png';
          break;
        }
    }

    return path;
  }

  Future<void> chooseWord() async {
    String line = await rootBundle.loadString('my_res/words.txt');
    List<String> words = line.split('\r\n');
    word = words[Random().nextInt(words.length)].toLowerCase();
    while (word == "") {}
    setState(() {
      _getUnderscore();
    });
    print(word);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chooseWord();
  }

  void _getUnderscore() {
    for (int i = 0; i < word.length; i++) {
      underscores += '_';
    }
  }

  List<int> findAllLetterIndexes(letter) {
    List<int> indexes = [];
    int currentIndex = 0;
    int i = 0;
    while (currentIndex != word.length && i != word.length) {
      var index = word.indexOf(letter, currentIndex);
      if (index != -1) {
        indexes.add(index);
        currentIndex = index + 1;
      }
      i++;
    }
    return indexes;
  }

  _restartGame() {
    Navigator.of(context).pop();
    underscores = '';
    numOfAttempts = 6;
    chooseWord();
    letterBtnStatus = List.filled(32, true);
  }

  _onPressedLetter(index) {
    String letter = String.fromCharCode(index + 1072);
      var mas = underscores.split('');
      var indexes = findAllLetterIndexes(letter);
      if (indexes.isNotEmpty) {
        for (int ind in indexes) {
          mas[ind] = letter;
        }
        String newUnderscores = '';
        for (var l in mas) {
          newUnderscores += l;
        }
        setState(() {
          underscores = newUnderscores;
          letterBtnStatus[index] = false;
        });
        wordVerification();
      } else {
        setState(() {
          numOfAttempts--;
          letterBtnStatus[index] = false;
        });
      }
      if(numOfAttempts == 0){
        showDialog(
          context: context,
          builder: (BuildContext builder) {
            return showAlertDialogWhenZeroAttempts();
          });
      }
  }

  AlertDialog showAlertDialogWhenZeroAttempts(){
    if(numOfLives == 1){
      return  AlertDialog(
              content: const Text(
                  'У вас закончились жизни.',
                  style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.deepPurple[400],
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/');
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple),
                    child: const Text(
                      'Вернуться в меню',
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            );
    }else{
      return AlertDialog(
              content: const Text(
                  'Вы истратили все попытки. Начните игру заново.',
                  style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.deepPurple[400],
              actions: [
                ElevatedButton(
                    onPressed: () {
                      numOfLives--;
                      _restartGame();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple),
                    child: const Text(
                      'Начать заново',
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            );
    }
  }

  wordVerification() {
    if (!underscores.contains('_')) {
      showDialog(
          context: context,
          builder: (BuildContext builder) {
            return AlertDialog(
              title: const Text('Поздравляю!'),
              content: const Text('Вы отгадали слово.'),
              backgroundColor: Colors.deepPurple[400],
              actions: [
                ElevatedButton(
                  onPressed: () {
                    score++;
                    _restartGame();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple[400]),
                  child: const Text(
                    'Следующее слово',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            );
          });
    }
  }

  showHint() {
    if (numOfHints == 0) {
      Fluttertoast.showToast(
        msg: "Вы истратили все подсказки",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey,
        textColor: Colors.black,
      );
    } else {
      List indexes = [];
      int currentIndex = 0;
      while (currentIndex != underscores.length) {
        var index = underscores.indexOf('_', currentIndex);
        if (index != -1) {
          indexes.add(index);
          currentIndex = index + 1;
        } else {
          currentIndex++;
        }
      }
      if (indexes.isNotEmpty) {
        int indexForHint = indexes[Random().nextInt(indexes.length)];
        var mas = underscores.split('');
        var letter = word[indexForHint];
        var indexesOfLetters = findAllLetterIndexes(letter);
        if (indexesOfLetters.isNotEmpty) {
          for (int ind in indexesOfLetters) {
            mas[ind] = letter;
          }
          var newString = "";
          for (var l in mas) {
            newString += l;
          }
          setState(() {
            underscores = newString;
            letterBtnStatus[letter.codeUnitAt(0) - 1072] = false;
            numOfHints--;
          });
        }
        wordVerification();
      }
    }
  }

  Widget _createButton(index) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: TextButton(
          onPressed:
              letterBtnStatus[index] ? () => _onPressedLetter(index) : () {},
          style: TextButton.styleFrom(
            alignment: Alignment.center,
            backgroundColor:
                letterBtnStatus[index] ? Colors.deepPurple[600] : Colors.grey,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          ),
          child: Text(
            textAlign: TextAlign.start,
            String.fromCharCode(index + 1072).toUpperCase(),
            style: const TextStyle(
                color: Colors.white, fontFamily: 'swampy_clean', fontSize: 30),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.deepPurple,
        body: SafeArea(
            child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 15, top: 10),
                      child: Image(
                        image: AssetImage('my_res/images/heart.png'),
                        color: Colors.white,
                      ),
                    ),
                    Positioned(
                        left: 37,
                        top: 22,
                        child: Text(
                          numOfLives.toString(),
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'swampy_clean'),
                        ))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text('$score',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'swampy_clean')),
                ),
                Stack(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(top: 10, right: 10),
                        child: IconButton(
                            onPressed: showHint,
                            icon: Image.asset(
                              'my_res/images/hint.png',
                              color: Colors.white,
                            ))),
                    Positioned(
                        right: 36,
                        top: 28,
                        child: Text(
                          numOfHints.toString(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'swampy_clean'),
                        ))
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Image(
                image: AssetImage(_getImage()),
                height: 250,
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Text(
                  underscores,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontFamily: 'swampy_clean',
                  ),
                  textAlign: TextAlign.center,
                )),
            Container(
              padding: const EdgeInsets.fromLTRB(10.0, 15.0, 8.0, 10.0),
              child: Table(
                textBaseline: TextBaseline.alphabetic,
                defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
                children: [
                  TableRow(children: [
                    TableCell(child: _createButton(0)),
                    TableCell(child: _createButton(1)),
                    TableCell(child: _createButton(2)),
                    TableCell(child: _createButton(3)),
                    TableCell(child: _createButton(4)),
                    TableCell(child: _createButton(5)),
                    TableCell(child: _createButton(6)),
                    TableCell(child: _createButton(7)),
                  ]),
                  TableRow(children: [
                    TableCell(child: _createButton(8)),
                    TableCell(child: _createButton(9)),
                    TableCell(child: _createButton(10)),
                    TableCell(child: _createButton(11)),
                    TableCell(child: _createButton(12)),
                    TableCell(child: _createButton(13)),
                    TableCell(child: _createButton(14)),
                    TableCell(child: _createButton(15)),
                  ]),
                  TableRow(children: [
                    TableCell(
                      child: _createButton(16),
                    ),
                    TableCell(
                      child: _createButton(17),
                    ),
                    TableCell(
                      child: _createButton(18),
                    ),
                    TableCell(
                      child: _createButton(19),
                    ),
                    TableCell(
                      child: _createButton(20),
                    ),
                    TableCell(
                      child: _createButton(21),
                    ),
                    TableCell(
                      child: _createButton(22),
                    ),
                    TableCell(
                      child: _createButton(23),
                    ),
                  ]),
                  TableRow(children: [
                    TableCell(
                      child: _createButton(24),
                    ),
                    TableCell(
                      child: _createButton(25),
                    ),
                    TableCell(
                      child: _createButton(26),
                    ),
                    TableCell(
                      child: _createButton(27),
                    ),
                    TableCell(
                      child: _createButton(28),
                    ),
                    TableCell(
                      child: _createButton(29),
                    ),
                    TableCell(
                      child: _createButton(30),
                    ),
                    TableCell(
                      child: _createButton(31),
                    ),
                  ])
                ],
              ),
            )
          ],
        )));
  }
}
