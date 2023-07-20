class Question {
  final String category;
  final String type;
  final String difficulty;
  final String question;
  final String correctAnswer;
  final List<String> options;

  Question({
    required this.category,
    required this.type,
    required this.difficulty,
    required this.question,
    required this.correctAnswer,
    required this.options,
  });

  factory Question.fromJson(
    Map<String, dynamic> json,
  ) {
    return Question(
      category: json['category'],
      type: json['type'],
      difficulty: json['difficulty'],
      question: json['question'],
      correctAnswer: json['correct_answer'],
      options: List<String>.from(json['incorrect_answers'])
        ..add(json['correct_answer'])
        ..shuffle(),
    );
  }
}
