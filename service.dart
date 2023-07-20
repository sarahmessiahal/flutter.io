import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:quizapp1/quiz.dart';

class ServiceAPI {
  Future<List<Question>> sarahMessiahal() async {
    const url =
        "https://opentdb.com/api.php?amount=25&category=17&difficulty=easy";
    final uri = Uri.parse(url);
    http.get(uri);

    final response = await http.get(uri);

    final body = response.body;

    final json = jsonDecode(body);
    final data = json['results'] as List<dynamic>;
    final results = data.map((e) {
      return Question.fromJson(json);
    }).toList();

    return results;
  }
}
