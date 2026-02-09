import 'package:flutter/material.dart';

import '../services/services.dart';
import '../models/models.dart';
import '../configs/configs.dart';

class ImageGenRepo {
  final ApiService _apiService = ApiService();

  Future<ImageGenResponse> generateImage(String prompt) async {
    final response = await _apiService.post(ApiConfig.genImageEndpoint, body: {'prompt': prompt, 'provider': 'gemini'});

    if (response.success && response.data != null) {
      return ImageGenResponse.fromJson(response.data as Map<String, dynamic>);
    } else {
      final statusCode = response.statusCode;
      final body = response.data;
      debugPrint('(generateImage error) statusCode: $statusCode, body: $body');
      return ImageGenResponse.error('$statusCode: $body');
    }
  }
}
