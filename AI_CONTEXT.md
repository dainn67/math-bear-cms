# AI Context - Math Bear CMS

## Tổng quan dự án

**Math Bear CMS** là ứng dụng Flutter để tạo câu hỏi toán học với hình ảnh tự động sử dụng AI.

## Tech Stack

- **Framework**: Flutter 3.0+ (SDK >=3.0.0 <4.0.0)
- **Language**: Dart
- **State Management**: Provider (v6.1.2)
- **HTTP Client**: http (v1.6.0)
- **Version Management**: FVM (Flutter Version Management)

## Kiến trúc

### Cấu trúc thư mục

```
lib/
├── main.dart               # Entry point
├── screens/                # UI screens (home_screen.dart)
├── providers/              # State management (imagen_provider.dart)
├── repositories/           # Data layer (image_gen_repo.dart)
├── services/               # API services (api_service.dart)
├── models/                 # Data models
└── configs/                # Configurations (api_config.dart)
```

### Pattern

- **Architecture**: Repository Pattern + Provider
- **Data Flow**: UI → Provider → Repository → Service → API
- **State**: Provider ChangeNotifier để quản lý state reactive

## Business Logic

### Chức năng chính

Tạo nhiều câu hỏi toán học kèm hình minh họa từ một prompt đầu vào.

### Flow hoạt động

1. User nhập prompt + số lượng câu hỏi (mặc định 5)
2. `ImageGenProvider.generateImageQuestionsList()` được gọi
3. Repository call API `POST /api/single-question/generate-math-questions`
4. API trả về list `[{question: string, image_data: {...}}]`
5. Parse thành `List<ImageQuestion>` và hiển thị dạng list

### Models chính

- **ImageGenResponse**: Chứa list base64 images từ AI
  - `images: List<String>` - Base64 encoded images
  - `firstImage: String?` - Ảnh đầu tiên
  - `hasImages: bool` - Check có ảnh không

- **ImageQuestion**: Một câu hỏi + ảnh minh họa
  - `question: String` - Nội dung câu hỏi
  - `imageGenResponse: ImageGenResponse` - Ảnh của câu hỏi

- **ImageQuestionsList**: Wrapper cho danh sách câu hỏi
  - `questions: List<ImageQuestion>`
  - `hasError: bool` - Flag lỗi

### API Configuration

- **Base URL**: `http://localhost:8000`
- **Endpoint**: `POST /api/single-question/generate-math-questions`
- **Request body**:
  ```json
  {
    "inputs": {
      "prompt": "string",
      "image_count": 5
    }
  }
  ```
- **Response**:
  ```json
  {
    "message": [
      {
        "question": "...",
        "image_data": {
          "images": [{ "data": "base64_string" }],
          "image_count": 1
        }
      }
    ]
  }
  ```

### Provider State

- `isLoading: bool` - Trạng thái đang tạo câu hỏi
- `imageQuestions: List<ImageQuestion>` - Danh sách câu hỏi đã tạo

## UI/UX

- Grid layout hiển thị câu hỏi dạng cards
- Mỗi card: ảnh phía trên + text câu hỏi phía dưới
- Loading state với CircularProgressIndicator
- Error state với icon và retry button
- Empty state khi chưa có dữ liệu

## Conventions

- File naming: snake_case (e.g., `home_screen.dart`)
- Class naming: PascalCase (e.g., `ImageGenProvider`)
- Private members: prefix `_` (e.g., `_isLoading`)
- Async methods: return `Future<void>` or `Future<T>`
- Error handling: try-catch với factory `.error()` constructors
