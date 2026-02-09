import 'package:flutter/material.dart';
import '../models/models.dart';
import '../repositories/repositories.dart';

class ImageGenProvider with ChangeNotifier {
  final ImageGenRepo _imageGenRepo;

  ImageGenResponse? imageGenResponse;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  ImageGenProvider({ImageGenRepo? imageGenRepo}) : _imageGenRepo = imageGenRepo ?? ImageGenRepo();

  Future<void> generateImage(String prompt) async {
    if (prompt.trim().isEmpty) {
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    final response = await _imageGenRepo.generateImage(prompt);
    if (response.hasError) {
      notifyListeners();
      return;
    }

    imageGenResponse = response;
    _isLoading = false;
    notifyListeners();
  }

  void clearImage() {
    notifyListeners();
  }
}
