import 'dart:convert';
import 'package:http/http.dart' as http;

class TriviaService {
  final String baseUrl =
      'https://opentdb.com/api.php?amount=10&category=18&difficulty=easy&type=multiple';

  Future<List<dynamic>> fetchQuestions({int amount = 10}) async {
    final response =
        await http.get(Uri.parse('$baseUrl?amount=$amount&type=multiple'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['results'];
    } else {
      throw Exception('Failed to load questions');
    }
  }
}
