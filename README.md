# Math Bear CMS

Ứng dụng quản lý nội dung Math Bear được xây dựng bằng Flutter với Provider state management.

> 📚 **[Xem tất cả tài liệu tại INDEX.md](INDEX.md)**

## Yêu cầu

- Flutter SDK (được quản lý bởi FVM)
- FVM (Flutter Version Management)
- Dart SDK

## Cài đặt FVM

Nếu chưa cài đặt FVM, chạy lệnh sau:

```bash
# MacOS/Linux
brew tap leoafarias/fvm
brew install fvm

# Hoặc sử dụng pub global
dart pub global activate fvm
```

## Thiết lập dự án

### 1. Cài đặt Flutter version với FVM

```bash
# Cài đặt phiên bản stable
fvm install stable

# Sử dụng phiên bản stable cho dự án này
fvm use stable
```

### 2. Cài đặt dependencies

```bash
# Sử dụng FVM để chạy flutter commands
fvm flutter pub get
```

### 3. Chạy ứng dụng

```bash
# Chạy trên thiết bị/emulator
fvm flutter run

# Hoặc chạy trên web
fvm flutter run -d chrome
```

## Cấu trúc dự án

```
lib/
├── main.dart                 # Entry point của ứng dụng
├── models/                   # Data models
│   └── user_model.dart
├── providers/                # State management với Provider
│   ├── app_provider.dart     # Provider chính của app
│   └── counter_provider.dart # Provider mẫu
├── screens/                  # Các màn hình
│   └── home_screen.dart
├── widgets/                  # Các widget tái sử dụng
├── services/                 # Services (API, Database, etc.)
└── utils/                    # Utilities và constants
    └── constants.dart
```

## State Management với Provider

Dự án này sử dụng Provider để quản lý state. Các providers được đăng ký trong `main.dart`:

```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => AppProvider()),
    ChangeNotifierProvider(create: (_) => CounterProvider()),
  ],
  child: MyApp(),
)
```

### Sử dụng Provider

**Đọc giá trị:**
```dart
// Trong widget
final counter = context.watch<CounterProvider>().counter;

// Hoặc sử dụng Consumer
Consumer<CounterProvider>(
  builder: (context, provider, child) {
    return Text('${provider.counter}');
  },
)
```

**Gọi methods:**
```dart
context.read<CounterProvider>().increment();
```

## Tính năng

- ✅ Provider state management setup
- ✅ Dark/Light theme toggle
- ✅ Counter example với Provider
- ✅ Cấu trúc thư mục chuẩn
- ✅ FVM configuration

## Chạy trên Web

```bash
# Chạy trên web (local)
fvm flutter run -d chrome

# Chạy và cho phép truy cập từ thiết bị khác trong cùng WiFi
fvm flutter run -d chrome --web-hostname=0.0.0.0 --web-port=8080

# Hoặc sử dụng script
./run_web.sh
```

> 📱 **[Xem hướng dẫn chi tiết chạy web tại WEB_DEPLOY.md](WEB_DEPLOY.md)**

## Lệnh hữu ích

```bash
# Kiểm tra phiên bản Flutter đang sử dụng
fvm flutter --version

# Chạy tests
fvm flutter test

# Build APK
fvm flutter build apk

# Build iOS
fvm flutter build ios

# Build Web
fvm flutter build web --release

# Analyze code
fvm flutter analyze

# Format code
fvm flutter format lib/
```

## VS Code Configuration

Để VS Code sử dụng Flutter version từ FVM, thêm vào `.vscode/settings.json`:

```json
{
  "dart.flutterSdkPath": ".fvm/flutter_sdk",
  "search.exclude": {
    "**/.fvm": true
  },
  "files.watcherExclude": {
    "**/.fvm": true
  }
}
```

## Đóng góp

Vui lòng tạo pull request hoặc issue nếu bạn muốn đóng góp vào dự án.

## License

MIT License
