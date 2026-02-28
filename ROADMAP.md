# Lộ trình Phát triển Dự án (SpendSync Roadmap)

- [ ] **Phase 1: Foundation & UI System**
  - Khởi tạo Flutter, cấu hình thư mục Feature-first.
  - Cài đặt packages: `supabase_flutter`, `flutter_riverpod`, `go_router`, `fl_chart`.
  - Tạo `AppColors`, `AppTheme` (Dark Mode + Yellow accent).
  - Build các UI Components cốt lõi trong `INTERFACE.md` (BottomNav, TransactionTile).

- [ ] **Phase 2: Authentication (Bảo mật)**
  - Tích hợp Supabase Auth.
  - Màn hình Đăng nhập / Đăng ký.
  - Cấu hình GoRouter: Redirect nếu chưa đăng nhập.

- [ ] **Phase 3: Core Data (Accounts & Categories)**
  - Viết Repositories & Riverpod Providers để kéo dữ liệu từ bảng `accounts` và `categories`.
  - Xây dựng màn hình Reports (Hiển thị Net Worth, Assets, Liabilities).

- [ ] **Phase 4: Transactions (Trái tim của App)**
  - Xây dựng màn hình Add Transaction (Tabs: Expense, Income, Transfer).
  - Áp dụng logic Transfer: Trừ tiền ví A, cộng tiền ví B.
  - Xây dựng màn hình Records (Trang chủ): Load danh sách, group theo ngày.

- [ ] **Phase 5: Charts & Analytics**
  - Tích hợp `fl_chart`.
  - Xây dựng biểu đồ Doughnut (Pie chart) vẽ dựa trên `color_hex` của danh mục.
  - Tính toán phần trăm chi tiêu.

- [ ] **Phase 6: Profile & Polish**
  - Màn hình Me (Profile, Đăng xuất).
  - Sửa lỗi, tối ưu hiệu năng và UX/UI.