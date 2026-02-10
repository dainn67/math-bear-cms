import 'models.dart';

class ImageQuestionsList {
  final List<ImageQuestion> questions;
  final String? error;

  ImageQuestionsList({required this.questions, this.error});

  factory ImageQuestionsList.fromJson(Map<String, dynamic> json) {
    List<ImageQuestion> questionsList = [];
    
    if (json['questions'] is List) {
      questionsList = (json['questions'] as List)
          .map((q) => ImageQuestion.fromJson(q as Map<String, dynamic>))
          .toList();
    }

    return ImageQuestionsList(
      questions: questionsList,
      error: json['error'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questions': questions.map((q) => q.toJson()).toList(),
      'error': error,
    };
  }

  factory ImageQuestionsList.error(String error) {
    return ImageQuestionsList(questions: [], error: error);
  }

  bool get hasError => error != null;
}
