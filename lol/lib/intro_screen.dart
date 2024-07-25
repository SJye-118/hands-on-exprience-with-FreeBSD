import 'package:flutter/material.dart';
import 'trivia_screen.dart'; // Add this line to import TriviaScreen

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to Trivia Quiz'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TriviaScreen()),
            );
          },
          child: Text('Start Quiz'),
        ),
      ),
    );
  }
}
