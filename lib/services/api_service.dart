import 'dart:convert';
import '../utils/constants.dart';

/// Service để xử lý các API calls
/// TODO: Cài đặt http package để sử dụng
class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final String baseUrl = AppConstants.baseUrl;
  String? _authToken;

  void setAuthToken(String token) {
    _authToken = token;
  }

  void clearAuthToken() {
    _authToken = null;
  }

  Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
    };
    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    return headers;
  }

  // TODO: Implement các methods sau khi cài đặt http package
  // Future<dynamic> get(String endpoint) async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse('$baseUrl$endpoint'),
  //       headers: _headers,
  //     );
  //     return _handleResponse(response);
  //   } catch (e) {
  //     debugPrint('GET Error: $e');
  //     rethrow;
  //   }
  // }

  // Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('$baseUrl$endpoint'),
  //       headers: _headers,
  //       body: jsonEncode(data),
  //     );
  //     return _handleResponse(response);
  //   } catch (e) {
  //     debugPrint('POST Error: $e');
  //     rethrow;
  //   }
  // }

  dynamic _handleResponse(dynamic response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception('API Error: ${response.statusCode}');
    }
  }
}
