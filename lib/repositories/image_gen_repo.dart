import 'package:flutter/material.dart';

import '../services/services.dart';
import '../models/models.dart';
import '../configs/configs.dart';

class ImageGenRepo {
  final ApiService _apiService = ApiService();

  Future<ImageGenResponse> regenerateImageQuestion(String question) async {
    final response = await _apiService.post(ApiConfig.regenImageQuestionEndpoint, body: {
      'inputs': {'question': question, 'provider': 'gemini'}
    });

    if (response.success && response.data != null) {
      try {
        return ImageGenResponse.fromJson(response.data['message'] as Map<String, dynamic>);
      } catch (e) {
        debugPrint('(regenerateImageQuestion parse error): $e');
        return ImageGenResponse.error(e.toString());
      }
    } else {
      final statusCode = response.statusCode;
      final body = response.data;
      debugPrint('(regenerateImageQuestion error) statusCode: $statusCode, body: $body');
      return ImageGenResponse.error('$statusCode: $body');
    }
  }

  Future<ImageQuestionsList> getImageQuestionsList(String prompt, {int numberOfImages = 5}) async {
    final response = await _apiService.post(ApiConfig.genImageQuestionsEndpoint, body: {
      'inputs': {
        'prompt': prompt,
        'image_count': numberOfImages,
      }
    });

    if (response.success && response.data != null) {
      try {
        // The API returns a list: [{question: ..., image_data: {...}}]
        final List<dynamic> jsonList = response.data['message'];

        List<ImageQuestion> questions = jsonList.map((e) {
          final map = e as Map<String, dynamic>;
          final questionText = map['question'] as String? ?? '';
          final imageData = map['image_data'] as Map<String, dynamic>? ?? {};
          final imageGenResponse = ImageGenResponse.fromJson(imageData);

          return ImageQuestion(
            question: questionText,
            imageGenResponse: imageGenResponse,
          );
        }).toList();

        return ImageQuestionsList(questions: questions);
      } catch (e) {
        debugPrint('(getImageQuestionsList parse error): $e');
        return ImageQuestionsList.error(e.toString());
      }
    } else {
      final statusCode = response.statusCode;
      final body = response.data;
      debugPrint('(getImageQuestionsList error) statusCode: $statusCode, body: $body');
      return ImageQuestionsList.error('$statusCode: $body');
    }
  }
}
