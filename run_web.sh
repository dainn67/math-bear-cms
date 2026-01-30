#!/bin/bash

# Script để chạy Flutter Web và cho phép truy cập từ thiết bị khác

echo "🔍 Đang tìm địa chỉ IP..."
echo ""

# Lấy IP address (thử nhiều cách)
if command -v ipconfig &> /dev/null; then
    # MacOS
    IP=$(ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1 2>/dev/null)
elif command -v hostname &> /dev/null; then
    # Linux/MacOS alternative
    IP=$(hostname -I | awk '{print $1}')
fi

# Nếu không tìm được IP, sử dụng localhost
if [ -z "$IP" ]; then
    IP="localhost"
    echo "⚠️  Không tìm thấy IP address. Sử dụng localhost."
else
    echo "✅ Địa chỉ IP của bạn: $IP"
fi

echo ""
echo "🚀 Đang khởi động Flutter Web..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📱 Truy cập từ máy này:"
echo "   http://localhost:8080"
echo ""
if [ "$IP" != "localhost" ]; then
    echo "📱 Truy cập từ thiết bị khác (cùng WiFi):"
    echo "   http://$IP:8080"
    echo ""
fi
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "💡 Tips:"
echo "   - Nhấn 'r' để hot reload"
echo "   - Nhấn 'R' để hot restart"
echo "   - Nhấn 'q' để thoát"
echo ""

# Chạy Flutter web
fvm flutter run -d chrome --web-hostname=0.0.0.0 --web-port=8080
