# Kế hoạch chi tiết SpendSync Pro

## Tổng quan
- **Nguồn:** README, STRUCTURE, INTERFACE, ROADMAP.
- **Schema DB:** `public` (9 bảng: users, accounts, categories, transactions, budgets, recurring_transactions, tags, transaction_tags, debts_loans).
- **Giao diện:** Dark #121212, Surface #1E1E1E, Primary #FFD700; Components trong INTERFACE.md.

---

## Phase 1: Foundation & UI System
**Phân tích:** Khởi tạo Flutter, cấu trúc feature-first, packages, theme đúng màu, build common_widgets (BottomNav, TransactionTile, CategoryGridItem, CustomTabBar).

**Todolist Phase 1:**
1. `flutter create .` (hoặc tạo thư mục lib, pubspec.yaml nếu đã có project)
2. Thêm dependencies: supabase_flutter, flutter_riverpod, go_router, fl_chart, flutter_dotenv
3. Tạo cấu trúc: lib/src/core, common_widgets, features; lib/main.dart
4. AppColors (Background #121212, Surface #1E1E1E, Primary #FFD700, text, status)
5. AppTheme dark (Material 3)
6. common_widgets: CustomBottomNavBar (4 items + FAB vàng giữa)
7. common_widgets: TransactionTile (avatar color_hex, title/subtitle, amount đỏ/xanh)
8. common_widgets: CategoryGridItem (circle icon, color_hex khi chọn)
9. common_widgets: CustomTabBar (Expense | Income | Transfer)
10. app.dart + main.dart entry, GoRouter cơ bản (1 route)
11. Tự đánh giá Phase 1, sửa lỗi

---

## Phase 2: Authentication
**Phân tích:** Supabase init, Auth login/register, màn Login/Register, GoRouter redirect khi chưa đăng nhập.

**Todolist Phase 2:**
1. .env + Supabase service, init trong main
2. Auth repository (signIn, signUp, getProfile từ public.users)
3. Màn Login, Register (email/password)
4. GoRouter: splash/login/home, redirect !isLoggedIn -> login
5. Trigger handle_new_user đã có trong schema.sql
6. Tự đánh giá Phase 2

---

## Phase 3: Core Data (Accounts & Categories, Reports)
**Phân tích:** Repository + Provider cho accounts, categories (public schema). Màn Reports: Net Worth, Assets, Liabilities, danh sách accounts, Add Account.

**Todolist Phase 3:**
1. Account model + AccountRepository (public.accounts)
2. Category model (icon_name, color_hex) + CategoryRepository (public.categories)
3. Riverpod providers
4. Màn Reports: card Net Worth, 2 cột Assets/Liabilities, list accounts nhóm theo type, nút Add Account
5. Tự đánh giá Phase 3

---

## Phase 4: Transactions
**Phân tích:** Transaction model (type income/expense/transfer, account_id, to_account_id). Add Transaction: tabs, CategoryGrid, chọn ví, numpad, From/To khi Transfer. Records: list group theo ngày, TransactionTile.

**Todolist Phase 4:**
1. Transaction model + TransactionRepository (trigger đã cập nhật balance)
2. Màn Add Transaction: header Cancel/Add/Save, CustomTabBar, CategoryGridItem grid, chọn account(s), số tiền, note; Transfer: From account -> To account
3. Records (Home): chọn tháng/năm, Expenses/Income/Balance, list group theo ngày dùng TransactionTile
4. Tự đánh giá Phase 4

---

## Phase 5: Charts & Analytics
**Phân tích:** Doughnut (Pie) chart với center hole hiển thị tổng; màu theo color_hex của category. Tab Week/Month/Year. List danh mục % giảm dần + progress bar vàng.

**Todolist Phase 5:**
1. Analytics repository (tính theo tuần/tháng/năm từ transactions + categories)
2. Màn Charts: tabs Week/Month/Year, Doughnut fl_chart (color_hex), list % + progress
3. Tự đánh giá Phase 5

---

## Phase 6: Profile & Polish
**Phân tích:** Màn Me (avatar, full_name, ID, Premium, Settings, Sign out). Sửa lỗi, build thành công.

**Todolist Phase 6:**
1. Màn Me: avatar, tên, ID, menu Premium Member, Settings, Sign out
2. Kiểm tra toàn bộ màn hình, màu sắc #121212/#FFD700
3. flutter build apk (hoặc build web) thành công
4. Báo cáo nghiệm thu cuối cùng
