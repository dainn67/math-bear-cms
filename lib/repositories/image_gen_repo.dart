import 'package:flutter/material.dart';

import '../services/services.dart';
import '../models/models.dart';
import '../configs/configs.dart';

class ImageGenRepo {
  final ApiService _apiService = ApiService();

  Future<ImageGenResponse> generateImage(String prompt) async {
    final response = await _apiService.post(ApiConfig.genImageEndpoint, body: {'prompt': prompt, 'provider': 'gemini'});

    if (response.success && response.data != null) {
      try {
        return ImageGenResponse.fromJson(response.data as Map<String, dynamic>);
      } catch (e) {
        debugPrint('(generateImage parse error): $e');
        return ImageGenResponse.error(e.toString());
      }
    } else {
      final statusCode = response.statusCode;
      final body = response.data;
      debugPrint('(generateImage error) statusCode: $statusCode, body: $body');
      return ImageGenResponse.error('$statusCode: $body');
    }
  }

  Future<ImageQuestionsList> getImageQuestionsList(String prompt) async {
    final response = await _apiService.post(ApiConfig.genImageQuestionsEndpoint, body: {
      'inputs': {'prompt': prompt}
    });

    if (response.success && response.data != null) {
      try {
        // The API returns a list of questions, each with question text and image_data.
        // image_data contains the generated image and possibly text.
        final List<dynamic> jsonList = response.data['message'];

        print('xxx: ' +
            jsonList
                .map((e) => e.toString().substring(0, e.toString().length > 200 ? 200 : e.toString().length))
                .join('\n'));

        // Map to List<ImageQuestion> for the ImageQuestionsList
        List<ImageQuestion> questions = jsonList.map((e) => ImageQuestion.fromJson(e as Map<String, dynamic>)).toList();

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
