import 'dart:math';

import 'package:flutter/material.dart';

/*
1. 1 암기할 내용의 주제와 질문/답변 입력하기 Create
    1. 새 주제 만들기
2. 2 암기할 주제목록 조회하기 readAll
3. 3 주제에 대해 레벨별 질문 개수 조회
4. 4 해당 레벨의 질문들로 테스트 수행 read
    1. 5 테스트 맞추면 다음 레벨, 아니면 레벨 1
    2. 6 테스트 중간에서 그만 두기 가능
    3. 7 테스트에서 개수 카운트
    4. 8
5. 9 주제 수정 기능 update
    1. 10 주제에 질문 추가
    2. 11 주제 질문 답변 수정
    3. 12 주제 질답 삭제
    4. 13 주제 이름 변경
6. 14 주제 삭제기능
7. 15 광고 기능
8. 16 레벨 제한?
9. 17 중앙서버에 올릴 수 있게 만들기
10. 18 주제의 버전관리 가능하게

 */


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 16.0,
    );
    return Scaffold(
      body: FutureBuilder(
        future: getNumber(),
        builder: (context, snapshot) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Future Builder',
                style: textStyle.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 0.0,
                ),
              ),
              Text(
                'ConState : ${snapshot.connectionState}',
                style: textStyle,
              ),
              Text(
                'Data : ${snapshot.data}',
              ),
              Text(
                'Error : ${snapshot.error}',
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {});
                },
                child: Text('setState'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<int> getNumber() async {
    await Future.delayed(Duration(seconds: 3));

    final random = Random();

    return random.nextInt(100);
  }
}
