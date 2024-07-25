import 'package:flutter/material.dart';
import 'trivia_service.dart';
import 'question.dart';
import 'result_screen.dart';

class TriviaScreen extends StatefulWidget {
  @override
  _TriviaScreenState createState() => _TriviaScreenState();
}

class _TriviaScreenState extends State<TriviaScreen> {
  late Future<List<Question>> _questionsFuture;
  List<Question>? _questions;
  int _currentQuestionIndex = 0;
  Map<int, String?> _userAnswers = {};
  int _correctAnswersCount = 0;

  @override
  void initState() {
    super.initState();
    _questionsFuture = fetchQuestions();
  }

  Future<List<Question>> fetchQuestions() async {
    final triviaService = TriviaService();
    final data = await triviaService.fetchQuestions();
    return data.map<Question>((json) => Question.fromJson(json)).toList();
  }

  void _submitAnswer(String answer) {
    if (_questions != null) {
      setState(() {
        _userAnswers[_currentQuestionIndex] = answer;
        if (answer == _questions![_currentQuestionIndex].correctAnswer) {
          _correctAnswersCount++;
        }
        if (_currentQuestionIndex < (_questions!.length - 1)) {
          _currentQuestionIndex++;
        } else {
          // Navigate to the result page
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => ResultScreen(
                correctAnswers: _correctAnswersCount,
                totalQuestions: _questions!.length,
              ),
            ),
            (Route<dynamic> route) => route.isFirst,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trivia Quiz'),
      ),
      body: FutureBuilder<List<Question>>(
        future: _questionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            _questions = snapshot.data;
            final question = _questions![_currentQuestionIndex];

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    question.question,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ...question.options.map((option) => ListTile(
                        title: Text(option),
                        leading: Radio<String>(
                          value: option,
                          groupValue: _userAnswers[_currentQuestionIndex],
                          onChanged: (value) {
                            if (value != null) {
                              _submitAnswer(value);
                            }
                          },
                        ),
                      )),
                  if (_currentQuestionIndex == _questions!.length - 1)
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to the result page
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResultScreen(
                              correctAnswers: _correctAnswersCount,
                              totalQuestions: _questions!.length,
                            ),
                          ),
                          (Route<dynamic> route) => route.isFirst,
                        );
                      },
                      child: Text('Submit'),
                    ),
                ],
              ),
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
