
Memory Card for memory practice

앱 개발 포트폴리오용 및 내가 직접 사용하려고 만듦

앱 개요
- 퀴즈 관리: 사용자는 퀴즈를 추가, 편집, 삭제할 수 있습니다.
- 퀴즈 목록: 각 퀴즈는 레벨, 질문, 답변으로 구성됩니다.
- 퀴즈 플레이: 사용자는 선택한 레벨의 퀴즈를 플레이할 수 있습니다.

주요 화면 및 기능

HomeScreen

퀴즈 목록을 나열합니다.
새 퀴즈 목록을 추가할 수 있는 버튼이 있습니다.
각 퀴즈 목록 옆에는 편집 및 삭제 버튼이 있습니다.

QuizListScreen

선택한 퀴즈 목록의 퀴즈들을 보여줍니다.
퀴즈 추가, 퀴즈 플레이 시작, 퀴즈 편집 및 삭제 기능이 있습니다.
퀴즈는 레벨, 질문, 답변으로 구성됩니다.


사용 방법

퀴즈 목록 추가
- HomeScreen에서 'Add Quiz List' 버튼을 클릭합니다.
- 새 퀴즈 목록의 이름을 입력하고 'Add'를 클릭합니다.

퀴즈 추가
- QuizListScreen에서 'Add Quiz' 버튼을 클릭합니다.
- 질문과 답변을 입력하고 'Add'를 클릭합니다.

퀴즈 편집 및 삭제
- 퀴즈 목록에서 편집하거나 삭제하고 싶은 퀴즈의 편집 또는 삭제 버튼을 클릭합니다.
- 편집 시, 변경하고자 하는 내용을 수정하고 'Edit'를 클릭합니다.
- 삭제 시, 'Delete'를 클릭하여 퀴즈를 목록에서 제거합니다.

퀴즈 플레이
- QuizListScreen에서 'Start Quiz' 버튼을 클릭합니다.
- 원하는 레벨의 퀴즈를 선택합니다.
- 퀴즈에 답변하고, 'Submit'을 클릭하여 답변을 제출합니다.

기술적 세부 사항
- SharedPreferences: 앱은 SharedPreferences를 사용하여 퀴즈 데이터를 로컬 저장소에 저장하고 불러옵니다.
- State Management: Flutter의 State Management 기능을 활용하여 사용자 인터페이스를 업데이트합니다.

이 앱은 사용자가 쉽게 퀴즈를 관리하고 플레이할 수 있는 직관적인 인터페이스를 제공합니다. Flutter 프레임워크를 사용함으로써, 앱은 안드로이드 및 iOS 플랫폼에서 모두 사용할 수 있습니다.


# 요구사항 추가 리스트

1. firebase 등을 활용해서 DB에 저장할 수 있도록 함
2. 만든 퀴즈목록을 중앙 DB에 저장할 수 있도록 만들기
3. 엑셀파일 등 수동입력 안 하고도 입력 가능하도록 만들기
4. 중앙 DB에서 다운로드 가능하도록 만들기
5. 수정삭제 버튼 크기 줄이기
6. 사용법 영상 만들기
7. 퀴즈목록화면에서 레벨별 퀴즈개수 알 수 있도록 하기 
8. 코드 분석하고 주석 추가하기


## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

