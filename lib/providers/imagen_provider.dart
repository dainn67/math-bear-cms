import 'package:flutter/material.dart';
import '../configs/configs.dart';
import '../services/api_service.dart';

class ImageGenProvider with ChangeNotifier {
  String? _imageBase64;
  String? _text;
  int _imageCount = 0;
  bool _isLoading = false;
  String? _errorMessage;

  String? get imageBase64 => _imageBase64;
  String? get text => _text;
  int get imageCount => _imageCount;
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
        if (response.data is Map && response.data.containsKey('images')) {
          _text = response.data['text'];
          _imageCount = response.data['image_count'];

          if (_imageCount <= 0) {
            _errorMessage = '${ToastMessageConfig.invalidDataFormat}: ${response.data}';
            notifyListeners();
            return;
          }

          final images = response.data['images'];
          if (images is List && images.isNotEmpty) {
            final image = images[0];
            if (image is Map && image.containsKey('data')) {
              _imageBase64 = image['data'];
              _errorMessage = null;
            } else {
              _errorMessage = '${ToastMessageConfig.invalidDataFormat}: ${response.data}';
            }
          } else {
            _errorMessage = '${ToastMessageConfig.noDataFound}: ${response.data}';
          }
        } else {
          _errorMessage = '${ToastMessageConfig.invalidDataFormat}: ${response.data}';
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
    _imageBase64 = null;
    _errorMessage = null;
    notifyListeners();
  }
}
