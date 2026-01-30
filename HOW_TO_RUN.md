# 🚀 Cách chạy dự án

## Chạy trên Web (Local)

### Cách 1: Sử dụng script (Đơn giản nhất)
```bash
./run_web.sh
```

Script sẽ tự động:
- Tìm địa chỉ IP của máy
- Chạy Flutter web trên port 8080
- Hiển thị URL để truy cập

### Cách 2: Chạy thủ công
```bash
# Chỉ chạy local
fvm flutter run -d chrome

# Hoặc chạy và cho phép truy cập từ thiết bị khác
fvm flutter run -d chrome --web-hostname=0.0.0.0 --web-port=8080
```

## 📱 Truy cập từ điện thoại / máy khác (cùng WiFi)

### Bước 1: Tìm địa chỉ IP của máy

**MacOS:**
```bash
ipconfig getifaddr en0
# Output ví dụ: 192.168.1.100
```

**Windows:**
```bash
ipconfig
# Tìm dòng "IPv4 Address"
```

**Linux:**
```bash
hostname -I
```

### Bước 2: Truy cập từ thiết bị khác

Mở browser trên điện thoại/máy khác và truy cập:
```
http://192.168.1.100:8080
```
(Thay `192.168.1.100` bằng IP thực tế của máy bạn)

## ⚙️ Cấu hình Backend

⚠️ **Quan trọng**: Nếu ứng dụng cần gọi API, backend cũng phải accessible từ network!

Trong `lib/configs/api_config.dart`:
```dart
// Thay đổi từ localhost sang IP thực tế
static const String baseUrl = 'http://192.168.1.100:8000';
```

## 🔥 Quick Commands

```bash
# Chạy web với script
./run_web.sh

# Build web production
fvm flutter build web --release

# Chạy production build với Python
cd build/web
python3 -m http.server 8080
```

## 🐛 Troubleshooting

### Không truy cập được từ thiết bị khác?

1. **Kiểm tra cùng WiFi**: Đảm bảo cả 2 thiết bị cùng mạng WiFi
2. **Kiểm tra Firewall**: Tắt firewall hoặc cho phép port 8080
3. **Kiểm tra IP**: Đảm bảo dùng đúng IP address

**Tắt firewall tạm thời (MacOS):**
```bash
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate off
```

### CORS Error khi gọi API?

Backend cần cấu hình CORS. Ví dụ với FastAPI:
```python
from fastapi.middleware.cors import CORSMiddleware

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)
```

---

📚 **Xem thêm**: [WEB_DEPLOY.md](WEB_DEPLOY.md) để biết hướng dẫn chi tiết hơn.
