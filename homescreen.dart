import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Question> questions = [];
  int currentQuestionIndex = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchQuizData();
  }

  Future<void> fetchQuizData() async {
    final url = Uri.parse(
        'https://opentdb.com/api.php?amount=25&category=17&difficulty=easy');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List<dynamic>;
      questions = results.map((result) => Question.fromJson(result)).toList();
    } else {
      print('Failed to fetch quiz data');
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 249, 196, 4),
        title: Text(
          'Quiz App',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              questions[currentQuestionIndex].category.toString(),
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              '${questions[currentQuestionIndex].difficulty.toString()} Level',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              ' ${questions[currentQuestionIndex].type.toString()} Type',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: Text(
                'Question ${currentQuestionIndex + 1}',
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 28.0),
              ),
            ),
            Divider(
              height: 8.0,
              thickness: 2.0,
              color: Colors.black,
            ),
            SizedBox(height: 8),
            Text(
              questions[currentQuestionIndex].question,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0),
            ),
            SizedBox(height: 16),
            ...(questions[currentQuestionIndex].options).map((option) {
              return Container(
                width: double.infinity,
                child: MaterialButton(
                  shape: StadiumBorder(),
                  elevation: 10.0,
                  color: Color.fromARGB(255, 249, 196, 4) ==
                          questions[currentQuestionIndex].correctAnswer
                      ? Colors.red
                      : Colors.green,
                  padding: const EdgeInsets.all(12.0),
                  onPressed: () {
                    checkAnswer(option);
                  },
                  child: Text(option),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  void checkAnswer(String selectedAnswer) {
    String correctAnswer = questions[currentQuestionIndex].correctAnswer;
    String message =
        selectedAnswer == correctAnswer ? 'Correct!' : 'Incorrect!';
    selectedAnswer == correctAnswer ? Colors.green : Colors.red;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Result'),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('Next Question'),
              onPressed: () {
                setState(() {
                  currentQuestionIndex++;
                  if (currentQuestionIndex >= questions.length) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Quiz Completed'),
                          content: Text(
                              'Congratulations! You have completed the quiz.'),
                          actions: [
                            TextButton(
                              child: Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    Navigator.of(context).pop();
                  }
                });
              },
            ),
          ],
        );
      },
    );
  }
}

class Question {
  final String question;
  final String correctAnswer;
  final List<String> options;
  final String category;
  final String type;
  final String difficulty;

  Question({
    required this.question,
    required this.correctAnswer,
    required this.options,
    required this.category,
    required this.difficulty,
    required this.type,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    final incorrectAnswers = json['incorrect_answers'] as List<dynamic>;
    final options = [...incorrectAnswers, json['correct_answer']];
    options.shuffle();

    return Question(
      type: json['type'],
      difficulty: json['difficulty'],
      category: json['category'],
      question: json['question'],
      correctAnswer: json['correct_answer'],
      options: options.map((option) => option.toString()).toList(),
    );
  }
}
