import 'package:flutter/material.dart';
import '../models/models.dart';
import '../repositories/repositories.dart';

class ImageGenProvider with ChangeNotifier {
  final ImageGenRepo _imageGenRepo;

  ImageGenResponse? imageGenResponse;
  List<ImageQuestion> imageQuestions = [];

  bool _isLoading = false;
  final Set<int> _regeneratingIndices = {};

  bool get isLoading => _isLoading;
  
  bool isRegenerating(int index) => _regeneratingIndices.contains(index);

  ImageGenProvider({ImageGenRepo? imageGenRepo}) : _imageGenRepo = imageGenRepo ?? ImageGenRepo();

  Future<void> generateImage(String prompt) async {
    if (prompt.trim().isEmpty) {
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    final response = await _imageGenRepo.regenerateImageQuestion(prompt);
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

  Future<void> regenerateImageQuestion(int index) async {
    if (index < 0 || index >= imageQuestions.length) return;
    
    _regeneratingIndices.add(index);
    notifyListeners();

    try {
      final question = imageQuestions[index].question;
      final response = await _imageGenRepo.regenerateImageQuestion(question);
      
      if (!response.hasError) {
        imageQuestions[index] = imageQuestions[index].copyWith(
          imageGenResponse: response,
        );
      }
    } finally {
      _regeneratingIndices.remove(index);
      notifyListeners();
    }
  }

  void clearImage() {
    notifyListeners();
  }
}
