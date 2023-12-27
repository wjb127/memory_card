import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class Quiz {
  final int level;
  final String question;
  final String answer;

  Quiz({required this.level, required this.question, required this.answer});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      debugShowCheckedModeBanner: false, // Debug 배너를 숨깁니다.
    );
  }
}

class QuizListScreen extends StatefulWidget {
  final String buttonText;

  QuizListScreen({required this.buttonText});

  @override
  _QuizListScreenState createState() => _QuizListScreenState();
}

class _QuizListScreenState extends State<QuizListScreen> {
  List<Quiz> quizzes = [];

  @override
  void initState() {
    super.initState();
    _loadQuizzes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.buttonText),
      ),
      body: ListView.builder(
        itemCount: quizzes.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start, // Align to the left
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle quiz button tap
                      print('Level ${quizzes[index].level} tapped');
                      // 퀴즈의 답을 보여주는 팝업창을 띄웁니다.
                      _showAnswerDialog(context, quizzes[index]);
                    },
                    child: Row(
                      children: [
                        // 레벨을 왼쪽에 정렬합니다.
                        Text('Lv ${quizzes[index].level}',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(width: 8), // 레벨과 질문 사이의 간격
                        Expanded(
                          child: Text('${quizzes[index].question}',
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _showEditQuizDialog(context, index);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _confirmDeleteQuiz(index);
                    //_deleteQuiz(index);
                  },
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  _showAddQuizDialog(context);
                },
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(vertical: 16, horizontal: 32)),
                ),
                child: Text('Add Quiz'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Start quizzes button tapped
                  print('Start Quiz tapped');
                  _showStartQuizzesDialog(context);
                },
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(vertical: 16, horizontal: 32)),
                ),
                child: Text('Start Quiz'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDeleteQuiz(int index) {
    _showDeleteConfirmationDialog(context, () {
      _deleteQuiz(index);
    }, '정말로 이 퀴즈를 삭제하시겠습니까?');
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, Function onConfirm, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // 팝업창 닫기
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                onConfirm(); // 실제 삭제 작업 수행
                Navigator.of(context).pop(); // 팝업창 닫기
              },
            ),
          ],
        );
      },
    );
  }

  // 퀴즈의 답을 보여주는 팝업창을 생성하는 메서드
  void _showAnswerDialog(BuildContext context, Quiz quiz) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Quiz Answer'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Question: ${quiz.question}'),
                SizedBox(height: 8),
                Text('Answer: ${quiz.answer}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAddQuizDialog(BuildContext context) async {
    String question = '';
    String answer = '';

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Quiz'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  question = value;
                },
                decoration: InputDecoration(
                  hintText: 'Enter question',
                ),
              ),
              TextField(
                onChanged: (value) {
                  answer = value;
                },
                decoration: InputDecoration(
                  hintText: 'Enter answer',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Add a new quiz with the entered question and answer
                _addQuiz(Quiz(level: 0, question: question, answer: answer));
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showEditQuizDialog(BuildContext context, int index) async {
    String editedQuestion = quizzes[index].question;
    String editedAnswer = quizzes[index].answer;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Quiz'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  editedQuestion = value;
                },
                controller: TextEditingController()
                  ..text = quizzes[index].question,
                decoration: InputDecoration(
                  hintText: 'Enter edited question',
                ),
              ),
              TextField(
                onChanged: (value) {
                  editedAnswer = value;
                },
                controller: TextEditingController()
                  ..text = quizzes[index].answer,
                decoration: InputDecoration(
                  hintText: 'Enter edited answer',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Edit the quiz
                _editQuiz(index, editedQuestion, editedAnswer);
                Navigator.of(context).pop();
              },
              child: Text('Edit'),
            ),
          ],
        );
      },
    );
  }

  void _deleteQuiz(int index) {
    // Delete the quiz at the specified index
    setState(() {
      quizzes.removeAt(index);
      _saveQuizzes();
    });
  }

  void _editQuiz(int index, String editedQuestion, String editedAnswer) {
    // Edit the quiz
    setState(() {
      quizzes[index] = Quiz(
          level: quizzes[index].level,
          question: editedQuestion,
          answer: editedAnswer);
      _saveQuizzes();
    });
  }

  Future<void> _showStartQuizzesDialog(BuildContext context) async {
    int selectedLevel = 0; // Default level

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Start Quiz'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(6, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      selectedLevel = index;
                      Navigator.of(context).pop();
                      _showQuizDialogSequentially(context, selectedLevel, 0);
                    },
                    child: Text('Level $index'),
                  ),
                );
              }),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showQuizDialogSequentially(
      BuildContext context, int level, int quizIndex) async {
    List<Quiz> filteredQuizzes =
        quizzes.where((quiz) => quiz.level == level).toList();

    if (quizIndex >= filteredQuizzes.length) {
      return; // 모든 퀴즈를 마쳤을 때 로직
    }

    Quiz currentQuiz = filteredQuizzes[quizIndex];
    TextEditingController answerController = TextEditingController();
    String feedbackMessage = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Question ${quizIndex + 1}'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Q: ${currentQuiz.question}'),
                  TextField(
                    controller: answerController,
                    decoration: InputDecoration(
                      hintText: 'Enter your answer',
                    ),
                  ),
                  SizedBox(height: 10),
                  if (feedbackMessage.isNotEmpty) Text(feedbackMessage),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Stop Quiz'),
                ),
                TextButton(
                  onPressed: () {
                    bool isCorrect =
                        answerController.text.trim() == currentQuiz.answer;
                    if (isCorrect) {
                      _updateQuizLevel(currentQuiz, currentQuiz.level + 1);
                      setState(() => feedbackMessage = "정답입니다!");

                      Future.delayed(Duration(milliseconds: 1000), () {
                        Navigator.of(context).pop(); // 현재 팝업을 닫음
                        if (quizIndex < filteredQuizzes.length - 1) {
                          _showQuizDialogSequentially(
                              context, level, quizIndex);
                        }
                      });
                    } else {
                      _updateQuizLevel(currentQuiz, 0);
                      setState(() =>
                          feedbackMessage = "틀렸습니다. 정답: ${currentQuiz.answer}");

                      Future.delayed(Duration(milliseconds: 3000), () {
                        Navigator.of(context).pop(); // 현재 팝업을 닫음
                        if (quizIndex < filteredQuizzes.length - 1) {
                          _showQuizDialogSequentially(
                              context, level, quizIndex);
                        }
                      });
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _updateQuizLevel(Quiz quiz, int newLevel) {
    int quizIndex = quizzes.indexOf(quiz);
    if (quizIndex != -1) {
      setState(() {
        quizzes[quizIndex] =
            Quiz(level: newLevel, question: quiz.question, answer: quiz.answer);
        _saveQuizzes();
      });
    }
  }

  Future<void> _showQuizDialog(BuildContext context, int level) async {
    List<Quiz> filteredQuizzes =
        quizzes.where((quiz) => quiz.level == level).toList();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Level $level Quizzes'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: filteredQuizzes.map((quiz) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Q: ${quiz.question}'),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter your answer',
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Stop Quiz'),
            ),
            TextButton(
              onPressed: () {
                // 여기에 답변 제출 로직을 추가하세요.
                Navigator.of(context).pop();
              },
              child: Text('Submit Answers'),
            ),
          ],
        );
      },
    );
  }

  void _addQuiz(Quiz quiz) {
    // Add a new quiz with the entered question and answer
    setState(() {
      quizzes.add(quiz);
      _saveQuizzes();
    });
  }

  Future<void> _loadQuizzes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      final List<String> quizData =
          prefs.getStringList(widget.buttonText) ?? [];
      quizzes = quizData.map((quizString) {
        final parts = quizString.split(',');
        return Quiz(
            level: int.parse(parts[0]), question: parts[1], answer: parts[2]);
      }).toList();
    });
  }

  Future<void> _saveQuizzes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> quizData = quizzes
        .map((quiz) => '${quiz.level},${quiz.question},${quiz.answer}')
        .toList();
    await prefs.setStringList(widget.buttonText, quizData);
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> buttonTexts = [];

  @override
  void initState() {
    super.initState();
    _loadButtonTexts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz List App'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: buttonTexts.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle button tap
                            print('Button ${index + 1} tapped');

                            // 이동할 퀴즈 목록 화면으로 이동
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QuizListScreen(
                                    buttonText: buttonTexts[index]),
                              ),
                            );
                          },
                          child: Text(buttonTexts[index]),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // Show dialog to edit button name
                          _showEditButtonDialog(context, index);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          // Delete the button
                          _confirmDeleteButton(index);
                          //_deleteButton(index);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: ElevatedButton(
              onPressed: () {
                // Show dialog to get button name
                _showAddButtonDialog(context);
              },
              child: Text('Add Quiz List'),
            ),
          ),
        ],
      ),
    );
  }

  // 퀴즈 목록 삭제를 위한 확인 팝업창을 표시하는 메서드
  void _confirmDeleteButton(int index) {
    _showDeleteConfirmationDialog(
        context, () => _deleteButton(index), '퀴즈 목록을 정말로 삭제하시겠습니까?');
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, Function onConfirm, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // 팝업창 닫기
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                onConfirm(); // 실제 삭제 작업 수행
                Navigator.of(context).pop(); // 팝업창 닫기
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAddButtonDialog(BuildContext context) async {
    String newButtonText = '';

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Quiz List'),
          content: TextField(
            onChanged: (value) {
              newButtonText = value;
            },
            decoration: InputDecoration(
              hintText: 'Enter name of quiz list',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Add a new button with the entered text
                _addButton(newButtonText);
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showEditButtonDialog(BuildContext context, int index) async {
    String editedButtonText = buttonTexts[index];

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Quiz List'),
          content: TextField(
            onChanged: (value) {
              editedButtonText = value;
            },
            controller: TextEditingController()..text = buttonTexts[index],
            decoration: InputDecoration(
              hintText: 'Enter edited name of quiz list',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Edit the button name
                _editButton(index, editedButtonText);
                Navigator.of(context).pop();
              },
              child: Text('Edit'),
            ),
          ],
        );
      },
    );
  }

  void _deleteButton(int index) {
    // Delete the button at the specified index
    setState(() {
      buttonTexts.removeAt(index);
      _saveButtonTexts();
    });
  }

  void _addButton(String buttonText) {
    // Add a new button with the entered text
    setState(() {
      buttonTexts.add(buttonText);
      _saveButtonTexts();
    });
  }

  void _editButton(int index, String editedButtonText) {
    // Edit the button name
    setState(() {
      buttonTexts[index] = editedButtonText;
      _saveButtonTexts();
    });
  }

  Future<void> _loadButtonTexts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      buttonTexts = prefs.getStringList('buttonTexts') ?? [];
    });
  }

  Future<void> _saveButtonTexts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('buttonTexts', buttonTexts);
  }
}
