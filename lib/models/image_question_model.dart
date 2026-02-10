import 'models.dart';

class ImageQuestion {
  final String question;
  final ImageGenResponse imageGenResponse;
  final String? error;

  ImageQuestion({required this.question, required this.imageGenResponse, this.error});

  factory ImageQuestion.fromJson(Map<String, dynamic> json) {
    return ImageQuestion(question: json['question'], imageGenResponse: ImageGenResponse.fromJson(json['image_gen_response']), error: json['error']);
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'image_gen_response': imageGenResponse.toJson(),
      'error': error,
    };
  }

  factory ImageQuestion.error(String error) {
    return ImageQuestion(question: '', imageGenResponse: ImageGenResponse.error(error), error: error);
  }

  ImageQuestion copyWith({String? question, ImageGenResponse? imageGenResponse}) {
    return ImageQuestion(question: question ?? this.question, imageGenResponse: imageGenResponse ?? this.imageGenResponse);
  }

  bool get hasError => error != null;
}
