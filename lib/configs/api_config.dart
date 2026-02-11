class ApiConfig {
  // Url
  static const String baseUrl = 'http://localhost:8000';

  // Endpoints
  static const String genImageEndpoint = '/api/imagegen/generate-image';
  static const String genImageQuestionsEndpoint = '/api/single-question/generate-math-questions';
  static const String regenImageQuestionEndpoint = '/api/single-question/regenerate-math-question-image';
}
