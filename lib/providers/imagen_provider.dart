import 'package:flutter/material.dart';
import '../models/models.dart';
import '../repositories/repositories.dart';

class ImageGenProvider with ChangeNotifier {
  final ImageGenRepo _imageGenRepo;

  ImageGenResponse? imageGenResponse;
  List<ImageQuestion> imageQuestions = [];

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
      _isLoading = false;
      notifyListeners();
      return;
    }

    imageGenResponse = response;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> generateImageQuestionsList(String prompt, {int numberOfImages = 5}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _imageGenRepo.getImageQuestionsList(prompt, numberOfImages: numberOfImages);
      if (response.hasError) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      imageQuestions = response.questions;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearImage() {
    notifyListeners();
  }
}
