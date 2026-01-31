/// Model cho response từ API generate image
class ImageGenResponse {
  final List<String> images; // List các base64 image strings
  final String? text;
  final int imageCount;

  ImageGenResponse({
    required this.images,
    this.text,
    required this.imageCount,
  });

  factory ImageGenResponse.fromJson(Map<String, dynamic> json) {
    final imagesList = <String>[];
    
    if (json['images'] is List) {
      for (var item in json['images']) {
        if (item is Map && item.containsKey('data')) {
          final imageData = item['data'];
          if (imageData is String) {
            imagesList.add(imageData);
          }
        }
      }
    }

    return ImageGenResponse(
      images: imagesList,
      text: json['text'],
      imageCount: json['image_count'] ?? imagesList.length,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'images': images.map((image) => {'data': image}).toList(),
      'text': text,
      'image_count': imageCount,
    };
  }

  /// Lấy image đầu tiên (nếu có)
  String? get firstImage => images.isNotEmpty ? images[0] : null;

  /// Kiểm tra có images không
  bool get hasImages => images.isNotEmpty;
}

