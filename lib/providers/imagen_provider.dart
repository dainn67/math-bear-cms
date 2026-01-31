import 'package:flutter/material.dart';
import '../configs/configs.dart';
import '../services/api_service.dart';
import '../models/image_gen_response_model.dart';

class ImageGenProvider with ChangeNotifier {
  ImageGenResponse? imageGenResponse;

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> generateImage(String prompt) async {
    if (prompt.trim().isEmpty) {
      _errorMessage = 'Vui lòng nhập prompt';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await ApiService().post(
        ApiConfig.genImageEndpoint,
        body: {'provider': 'gemini', 'prompt': prompt},
      );

      if (response.success && response.data != null) {
        try {
          if (response.data is Map) {
            imageGenResponse = ImageGenResponse.fromJson(response.data as Map<String, dynamic>);
            _errorMessage = null;
          } else {
            _errorMessage = '${ToastMessageConfig.invalidDataFormat}: ${response.data}';
          }
          notifyListeners();
        } catch (e) {
          _errorMessage = '${ToastMessageConfig.invalidDataFormat}: $e';
        }
      } else {
        _errorMessage = '${ToastMessageConfig.unknownError}: ${response.data}';
      }
    } catch (e) {
      _errorMessage = '${ToastMessageConfig.unknownError}: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearImage() {
    _errorMessage = null;
    notifyListeners();
  }
}
