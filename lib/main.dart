import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 앱 실행
void main() {
  runApp(MyApp());
}

// 퀴즈 : 레벨과 질문 답변으로 구성
class Quiz {
  final int level;
  final String question;
  final String answer;

  Quiz({required this.level, required this.question, required this.answer});
}

// 앱 : 스테이트 x, 홈스크린과 디버그 배너 숨기기
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      debugShowCheckedModeBanner: false, // Debug 배너를 숨깁니다.
    );
  }
}

// 퀴즈 스크린 : 스테이트 O
class QuizListScreen extends StatefulWidget {
  final String buttonText;

  QuizListScreen({required this.buttonText});

  @override
  _QuizListScreenState createState() => _QuizListScreenState();
}

// 퀴즈 리스트 스크린
class _QuizListScreenState extends State<QuizListScreen> {
  List<Quiz> quizzes = [];

  // 초기화 및 퀴즈 불러오기
  @override
  void initState() {
    super.initState();
    _loadQuizzes();
  }

  // 퀴즈 리스트 빌드함수
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.buttonText),
      ),
      body: ListView.builder(
        itemCount: quizzes.length, // quizzes만큼 리스트 불러오기
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0), // 버튼에 패딩 입히기
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start, // Align to the left
              children: [
                Expanded(
                  child: ElevatedButton(
                    // 행동 : 클릭
                    onPressed: () {
                      // Handle quiz button tap
                      print('Level ${quizzes[index].level} tapped');
                      // 퀴즈의 답을 보여주는 팝업창을 띄웁니다.
                      _showAnswerDialog(context, quizzes[index]);
                    },
                    // 디자인 : 버튼 텍스트 디자인
                    child: Row(
                      children: [
                        // 레벨을 왼쪽에 정렬합니다.
                        Text('Lv ${quizzes[index].level}',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(width: 8), // 레벨과 질문 사이의 간격
                        Expanded(
                          // 질문 표시, 밖으로 나가면 ...
                          child: Text('${quizzes[index].question}',
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                  ),
                ),
                // 오른쪽 수정버튼
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _showEditQuizDialog(context, index);
                  },
                ),
                // 오른쪽 삭제버튼
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
      // 바텀 버튼
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

  // 확인 창
  void _confirmDeleteQuiz(int index) {
    _showDeleteConfirmationDialog(context, () {
      _deleteQuiz(index);
    }, '정말로 이 퀴즈를 삭제하시겠습니까?');
  }

  // 메시지로 확인
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

  // 퀴즈 추가 다이얼로그 화면
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

  // 퀴즈 수정 다이얼로그
  Future<void> _showEditQuizDialog(BuildContext context, int index) async {
    // 해당 퀴즈 정보 불러오기
    String editedQuestion = quizzes[index].question;
    String editedAnswer = quizzes[index].answer;

    // 다이얼로그 반환하기
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // 퀴즈 수정
          title: Text('Edit Quiz'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                // 질문 텍스트 입력
                onChanged: (value) {
                  editedQuestion = value;
                },
                // 컨트롤러 : 텍스트 및 데코레이션
                controller: TextEditingController()
                  ..text = quizzes[index].question,
                decoration: InputDecoration(
                  hintText: 'Enter edited question',
                ),
              ),
              TextField(
                // 답변 텍스트 입력
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
          // 취소 및 수정
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

  // 삭제 이행
  void _deleteQuiz(int index) {
    // Delete the quiz at the specified index
    setState(() {
      quizzes.removeAt(index);
      _saveQuizzes();
    });
  }

  // 수정 이행
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

  //
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

  // 퀴즈 순차 실행
  Future<void> _showQuizDialogSequentially(
      BuildContext context, int level, int quizIndex) async {
    // 퀴즈 레벨로 필터링
    List<Quiz> filteredQuizzes =
        quizzes.where((quiz) => quiz.level == level).toList();

    // 모든 퀴즈를 마치면 끝내기
    if (quizIndex >= filteredQuizzes.length) {
      return; // 모든 퀴즈를 마쳤을 때 로직
    }

    // 현재 퀴즈, 답 컨트롤러, 피드백 메시지
    Quiz currentQuiz = filteredQuizzes[quizIndex];
    TextEditingController answerController = TextEditingController();
    String feedbackMessage = '';

    // 다이얼로그
    showDialog(
      // 컨텍스트
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            // 얼럿 다이얼로그
            return AlertDialog(
              // 질문 인덱스
              title: Text('Question ${quizIndex + 1}'),
              content: Column(
                // 축 크기와 정렬
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                // 질문 출력 및 인풋 받기
                children: [
                  Text('Q: ${currentQuiz.question}'),
                  TextField(
                    controller: answerController,
                    decoration: InputDecoration(
                      hintText: 'Enter your answer',
                    ),
                  ),
                  SizedBox(height: 10),

                  // 피드백 메시지가 있으면 출력하기
                  if (feedbackMessage.isNotEmpty) Text(feedbackMessage),
                ],
              ),
              // 행동 추가
              actions: <Widget>[
                // 스톱퀴즈 버튼
                TextButton(
                  // 누르면 팝
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  // 텍스트
                  child: Text('Stop Quiz'),
                ),
                // 제출버튼
                TextButton(
                  // 제출 눌렀을 때 행동
                  onPressed: () {
                    // 제출한 답 vs 현재 퀴즈답 비교
                    bool isCorrect =
                        answerController.text.trim() == currentQuiz.answer;

                    if (isCorrect) {
                      // 퀴즈 레벨 업데이트 및 피드백 메시지 - 정답으로 스테이트 변경
                      _updateQuizLevel(currentQuiz, currentQuiz.level + 1);
                      setState(() => feedbackMessage = "정답입니다!");

                      // 1초 대기 및 이전 상태로 되돌아가기
                      Future.delayed(Duration(milliseconds: 1000), () {
                        Navigator.of(context).pop(); // 현재 팝업을 닫음
                        // 퀴즈 인덱스 확인하고 다음 문제 실행
                        if (quizIndex < filteredQuizzes.length - 1) {
                          _showQuizDialogSequentially(
                              context, level, quizIndex);
                        }
                      });
                    } else {
                      // 퀴즈 레벨 0으로 돌려보내고 피드백 메시지로 스테이트 변경
                      _updateQuizLevel(currentQuiz, 0);
                      setState(() =>
                          feedbackMessage = "틀렸습니다. 정답: ${currentQuiz.answer}");
                      // 3초 대기 및 이전 상태로 되돌아가기
                      Future.delayed(Duration(milliseconds: 3000), () {
                        Navigator.of(context).pop(); // 현재 팝업을 닫음
                        // 퀴즈 인덱스 확인하고 다음 문제 실행
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

  // 퀴즈 업데이트하기
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

  // 퀴즈 보여주기 대화창
  Future<void> _showQuizDialog(BuildContext context, int level) async {
    // 퀴즈 불러오기
    List<Quiz> filteredQuizzes =
        quizzes.where((quiz) => quiz.level == level).toList();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // 레벨 퀴즈 타이틀
          title: Text('Level $level Quizzes'),
          // 싱글 스크롤뷰
          content: SingleChildScrollView(
            child: Column(
              // 사이즈 조정
              mainAxisSize: MainAxisSize.min,
              // 퀴즈 매핑
              children: filteredQuizzes.map((quiz) {
                return Column(
                  // 정렬
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 답 쓰기
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
          // 스탑퀴즈, 제출
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

  // 퀴즈 추가 후 저장
  void _addQuiz(Quiz quiz) {
    // Add a new quiz with the entered question and answer
    setState(() {
      quizzes.add(quiz);
      _saveQuizzes();
    });
  }

  // 퀴즈 불러오기
  Future<void> _loadQuizzes() async {
    // 데이터 저장
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // 스테이트 변경 : 퀴즈 데이터 설정
    setState(() {
      // 퀴즈 데이터 불러오기
      final List<String> quizData =
          prefs.getStringList(widget.buttonText) ?? [];

      // 퀴즈 = 퀴즈문자열
      quizzes = quizData.map((quizString) {
        final parts = quizString.split(',');
        return Quiz(
            level: int.parse(parts[0]), question: parts[1], answer: parts[2]);
      }).toList();
    });
  }

  // 퀴즈 저장
  Future<void> _saveQuizzes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> quizData = quizzes
        .map((quiz) => '${quiz.level},${quiz.question},${quiz.answer}')
        .toList();
    await prefs.setStringList(widget.buttonText, quizData);
  }
}

// 홈스크린
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> buttonTexts = [];

  // 스테이트 초기화
  @override
  void initState() {
    super.initState();
    _loadButtonTexts();
  }

  // 빌드함수
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 앱바
      appBar: AppBar(
        title: Text('Quiz List App'),
      ),
      // 바디
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              // 아이템 카운트, 아이템 빌드
              itemCount: buttonTexts.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          // 버튼 클릭시 이동할 퀴즈 목록 화면으로 이동
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
                          // 버튼 텍스트
                          child: Text(buttonTexts[index]),
                        ),
                      ),
                      // 수정버튼
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // Show dialog to edit button name
                          _showEditButtonDialog(context, index);
                        },
                      ),
                      // 삭제 버튼
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
              // 퀴즈 리스트 추가 버튼
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

  // 삭제 확인 대화창
  void _showDeleteConfirmationDialog(
      BuildContext context, Function onConfirm, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text(message),
          actions: <Widget>[
            // 취소
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // 팝업창 닫기
              },
            ),
            // 삭제
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

  // 추가 버튼 대화창
  Future<void> _showAddButtonDialog(BuildContext context) async {
    // 새 버튼 텍스트
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

  // 버튼 수정 대화창
  Future<void> _showEditButtonDialog(BuildContext context, int index) async {
    // 수정할 버튼 인덱스로 불러옴
    String editedButtonText = buttonTexts[index];

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // 퀴즈리스트 수정
          title: Text('Edit Quiz List'),
          content: TextField(
            // 변경시 텍스트 버튼에 넣기
            onChanged: (value) {
              editedButtonText = value;
            },
            // 컨트롤러 데코레이션
            controller: TextEditingController()..text = buttonTexts[index],
            decoration: InputDecoration(
              hintText: 'Enter edited name of quiz list',
            ),
          ),
          // 취소 또는 실행
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

  // 버튼 삭제
  void _deleteButton(int index) {
    // Delete the button at the specified index
    setState(() {
      buttonTexts.removeAt(index);
      _saveButtonTexts();
    });
  }

  // 버튼 추가 로직
  void _addButton(String buttonText) {
    // Add a new button with the entered text
    setState(() {
      buttonTexts.add(buttonText);
      _saveButtonTexts();
    });
  }

  // 버튼 수정 로직
  void _editButton(int index, String editedButtonText) {
    // Edit the button name
    setState(() {
      buttonTexts[index] = editedButtonText;
      _saveButtonTexts();
    });
  }

  // 불러오기 버튼
  Future<void> _loadButtonTexts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      buttonTexts = prefs.getStringList('buttonTexts') ?? [];
    });
  }

  // 저장 버튼 : 데이터 저장
  Future<void> _saveButtonTexts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('buttonTexts', buttonTexts);
  }
}
