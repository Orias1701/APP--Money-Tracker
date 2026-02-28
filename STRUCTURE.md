*Định nghĩa sơ đồ Database 9 bảng và kiến trúc thư mục Feature-first.*

# Kiến Trúc Hệ Thống (Architecture & Database)

## 1. Cơ sở dữ liệu (Supabase PostgreSQL - 9 Tables)
Hệ thống sử dụng schema `public` với các bảng và logic ràng buộc sau:

1. **`users`**: `id` (PK, ref auth.users), `full_name`, `avatar_url`, `role` (admin/user), `is_premium`.
2. **`accounts`**: `id` (PK), `user_id` (FK), `name`, `account_type` ('asset'/'liability'), `balance`, `currency`. (Tự động trừ/cộng tiền qua Trigger).
3. **`categories`**: `id` (PK), `user_id` (FK, null=default), `name`, `type` ('income'/'expense'), `icon_name`, `color_hex` (Bắt buộc cho UI), `order_index`.
4. **`transactions`**: `id` (PK), `user_id`, `account_id` (Nguồn), `to_account_id` (Đích - dùng cho Transfer), `category_id`, `type` ('income'/'expense'/'transfer'), `amount`, `transaction_date`, `note`.
5. **`budgets`**: Quản lý ngân sách chi tiêu (`amount`, `period`, `start_date`, `end_date`).
6. **`recurring_transactions`**: Giao dịch định kỳ (`frequency`, `next_date`).
7. **`tags`**: Nhãn dán tùy chỉnh (`name`, `color_hex`).
8. **`transaction_tags`**: Bảng nối n-n giữa transactions và tags.
9. **`debts_loans`**: Sổ nợ/Cho vay (`type`, `remaining_amount`, `due_date`).

## 2. Cấu trúc Thư mục Flutter (Feature-First)
Dự án tuân thủ nghiêm ngặt mô hình chia theo tính năng:
```text
lib/
├── src/
│   ├── core/               # Chứa các thành phần dùng chung toàn app
│   │   ├── constants/      # AppColors, AppTextStyles, env variables
│   │   ├── routing/        # Cấu hình GoRouter
│   │   ├── services/       # Supabase client initialization
│   │   └── utils/          # Format tiền tệ, ngày tháng
│   ├── common_widgets/     # UI Components dùng chung (nêu trong INTERFACE.md)
│   ├── features/           # Các tính năng chính
│   │   ├── auth/           # Đăng nhập, Đăng ký, Quên mật khẩu
│   │   ├── accounts/       # Quản lý Ví/Thẻ, Net Worth
│   │   ├── categories/     # Lưới danh mục, Icon, Màu sắc
│   │   ├── transactions/   # Thêm mới, Danh sách giao dịch
│   │   ├── charts/         # Biểu đồ phân tích
│   │   └── profile/        # Trang cá nhân, Cài đặt
│   └── app.dart            # Root MaterialApp
└── main.dart               # Entry point