*Quy định chính xác màu sắc, phong cách và các UI Component cần build trước khi ghép logic.*

# Đặc Tả Giao Diện (UI/UX Guidelines)

## 1. Phong Cách Thiết Kế (Design System)
Ứng dụng sử dụng phong cách **Modern Dark Theme** làm chủ đạo, nhấn mạnh bằng màu Vàng (Yellow/Gold) để làm nổi bật các hành động chính.
- **Màu nền (Background):** `#121212` (Đen nhám/Dark Gray).
- **Màu thẻ (Surface/Card):** `#1E1E1E` (Đen nhạt hơn để tạo độ nổi).
- **Màu chủ đạo (Primary/Accent):** `#FFD700` (Vàng Gold - Dùng cho nút FAB, Tabs đang chọn).
- **Màu Text:** `#FFFFFF` (Trắng cho tiêu đề chính), `#A0A0A0` (Xám cho text phụ/ngày tháng).
- **Màu Trạng thái:** Đỏ `#FF4500` (Chi tiêu/Số âm), Xanh lá/Trắng (Thu nhập/Số dương).
- **Font chữ:** Roboto hoặc San Francisco (Mặc định của hệ thống), font-weight rõ ràng.

## 2. Các UI Components dùng chung (Phải tạo trước ở `common_widgets`)
1. **`CustomBottomNavBar`:** - Gồm 4 icon: Records, Charts, Reports, Me.
   - Nút `+` (Floating Action Button) cực kỳ nổi bật màu Vàng nằm lồi lên ở giữa.
2. **`TransactionTile`:** - Left: CircleAvatar chứa Icon của danh mục, nền của avatar chính là `color_hex` của danh mục đó (VD: Food nền vàng, Health nền xanh).
   - Middle: Title (Tên danh mục hoặc Ghi chú), Subtitle (Tên ví).
   - Right: Số tiền (Màu đỏ có dấu `-` nếu là expense, màu trắng/xanh nếu income).
3. **`CategoryGridItem`:**
   - Dùng trong màn hình Thêm giao dịch. Hình tròn chứa icon ở giữa, màu xám khi chưa chọn, sáng lên theo `color_hex` khi được chọn. Text tên danh mục ở dưới.
4. **`CustomTabBar`:** Tab bar bo góc chuyển đổi mượt mà giữa Expense/Income/Transfer.

## 3. Chi tiết Từng Màn Hình (Screens)

### Màn hình 1: Records (Trang chủ)
- **Header:** Chọn Tháng/Năm, hiển thị Tổng Chi (Expenses), Tổng Thu (Income), Số Dư (Balance) của tháng.
- **Body:** Danh sách `TransactionTile` được **Group (Nhóm) theo Ngày**. (VD: "Feb 14 Saturday" -> Dưới là các giao dịch của ngày đó).

### Màn hình 2: Add Transaction (Nút +)
- **Header:** Nút Cancel (trái), Title "Add" (giữa), Nút Save (phải).
- **Tabs:** 3 nút to: Expense | Income | Transfer.
- **Body:** Lưới `CategoryGridItem` (4 cột). Khi click vào icon nào thì bôi đậm icon đó.
- **Bottom:** Khu vực nhập số tiền (Numpad) và chọn Ví, nhập Ghi chú (Note). **Nếu tab là Transfer, phải có 2 dòng: Từ Ví (From) -> Đến Ví (To)**.

### Màn hình 3: Charts (Thống kê)
- **Header:** Tabs: Week | Month | Year.
- **Top Body:** Biểu đồ Doughnut (Pie Chart) khoét lỗ ở giữa. Lỗ giữa hiển thị Tổng tiền. Các vành đai màu sắc khớp chính xác với `color_hex` của category.
- **Bottom Body:** Danh sách các danh mục theo phần trăm giảm dần. Mỗi dòng có: Icon, Tên, Phần trăm (%), và thanh Progress Bar nằm ngang màu Vàng.

### Màn hình 4: Reports (Báo cáo / Accounts)
- **Mục tiêu:** Tính Net Worth (Tổng tài sản).
- **Top:** Card lớn hiển thị: Net Worth = [Số tiền]. Dưới chia làm 2 cột: Assets (Tài sản) và Liabilities (Nợ).
- **Bottom:** Danh sách các Ví/Thẻ, nhóm theo loại (Ví dụ: Nhóm Tiền mặt, Nhóm Thẻ tín dụng/Credit card). Có nút "Add Account".

### Màn hình 5: Me (Cá nhân)
- **Top:** Avatar tròn, Tên (full_name), ID user.
- **List Menu:** Premium Member (vương miện vàng), Settings (Cài đặt), Sign out (Đăng xuất).