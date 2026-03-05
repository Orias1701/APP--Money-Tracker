# SpendSync - Pro Personal Finance Tracker

SpendSync là ứng dụng quản lý chi tiêu cá nhân/gia đình cao cấp, được thiết kế với giao diện Dark Mode hiện đại, tối giản và tập trung tối đa vào trải nghiệm nhập liệu nhanh (UX).

## Tech Stack

- **Framework:** Flutter (Cross-platform: iOS, Android, Web)
- **Backend/BaaS:** Supabase (PostgreSQL, Auth, Storage)
- **State Management:** Riverpod (Xử lý state an toàn, dễ test)
- **Routing:** GoRouter (Quản lý luồng điều hướng chuyên nghiệp)
- **Architecture:** Feature-first (Phân chia thư mục theo tính năng)

## Tính năng Cốt lõi

1. **Quản lý Đa Tài Khoản (Accounts):** Hỗ trợ Ví tiền mặt, Tài khoản ngân hàng (Assets) và Thẻ tín dụng/Khoản nợ (Liabilities).
2. **Giao dịch thông minh (Transactions):** Thu, Chi và Chuyển khoản nội bộ (Transfer).
3. **Thống kê Trực quan (Charts):** Biểu đồ Doughnut Pie Chart phân tích theo Tuần/Tháng/Năm.
4. **Báo cáo Tài sản (Net Worth):** Tự động tính toán Tổng tài sản thực (Assets - Liabilities).
5. **Hệ thống Danh mục (Categories):** Tùy chỉnh màu sắc (HEX code), Icon, hỗ trợ danh mục cha-con.
6. **Bảo mật:** Đăng nhập/Đăng ký qua Email (Supabase Auth), tự động tạo ví mặc định cho user mới.

## 🛠 Hướng dẫn Cài đặt

1. Yêu cầu: Flutter SDK (>= 3.0), tài khoản Supabase.
2. Clone dự án và chạy `flutter pub get`.
3. Tạo file `.env` ở thư mục gốc:
  ```env
   SUPABASE_URL=your_project_url
   SUPABASE_ANON_KEY=your_anon_key
  ```
4. **Supabase Dashboard → Authentication → Providers → Email:** Nếu muốn đăng ký xong đăng nhập ngay (không xác thực email), tắt **Confirm email**.
5. **Nếu gặp lỗi 403 khi thêm tài khoản / giao dịch:** Mở Supabase Dashboard → SQL Editor, chạy nội dung file `Assets/SQL/rls_policies.sql` để bật Row Level Security và tạo policy cho phép user thao tác dữ liệu của chính mình.
6. **Đăng nhập bằng tên hiển thị:** Chạy thêm file `Assets/SQL/rpc_get_email_for_login.sql` trong SQL Editor để cho phép đăng nhập bằng email hoặc tên (full_name trong bảng users).
7. Chạy ứng dụng: `flutter run`

