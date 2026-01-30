import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../configs/api_config.dart';

class ImageGenProvider with ChangeNotifier {
  String? _imageBase64;
  bool _isLoading = false;
  String? _errorMessage;

  String? get imageBase64 => _imageBase64;
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
          final images = response.data['images'];
          if (images is List && images.isNotEmpty) {
            final image = images[0];
            if (image is Map && image.containsKey('data')) {
              _imageBase64 = image['data'];
              _errorMessage = null;
            } else {
              _errorMessage = 'Định dạng ảnh không đúng';
            }
          } else {
            _errorMessage = 'Không tìm thấy ảnh trong response';
          }
        } else {
          _errorMessage = 'Định dạng response không đúng';
        }
      } else {
        _errorMessage = response.data?.toString() ?? 'Có lỗi xảy ra';
      }
    } catch (e) {
      _errorMessage = 'Lỗi: $e';
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
