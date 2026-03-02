# Migration V2: Nhóm, xoá mềm, username

## Tóm tắt thay đổi

1. **Soft delete (status)**  
   Tất cả bảng chính có thêm cột `status` (`active`/`deleted`).  
   Bảng `transactions` dùng cột `row_status` (vì đã có cột `status` cho cleared/pending).

2. **Users**  
   Thêm `username` (unique). Đăng ký dùng username (bắt buộc), họ tên (tùy chọn).  
   Họ tên sửa trong **Me → Chỉnh sửa hồ sơ**.

3. **Groups & Group_Members**  
   Bảng mới: `groups` (id, name, is_personal, status, created_at),  
   `group_members` (group_id, user_id, role, status, joined_at).  
   Khi đăng ký: tạo nhóm cá nhân (is_personal = true) và gán user làm admin.

4. **Transactions**  
   Bỏ `user_id`. Thêm `group_id` (bắt buộc), `created_by`, `paid_by` (user_id).  
   API lấy giao dịch theo `group_id`; trả về thông tin created_by_user, paid_by_user.

5. **Frontend**  
   - **ActiveGroup**: state hiện tại (mặc định = nhóm cá nhân sau khi đăng nhập).  
   - **GroupSwitcher**: dropdown trên Records để chọn nhóm.  
   - Danh sách giao dịch: khi không phải nhóm cá nhân, hiển thị "Trả bởi: ...".  
   - Form thêm giao dịch: khi nhóm nhiều người, có dropdown "Người thanh toán".

6. **Categories**  
   Lọc theo `status = 'active'`. Thêm `softDeleteCategory(id)` (chỉ category do user tạo).

---

## Chạy migration trên Supabase

1. **DB mới (chưa có dữ liệu)**  
   Chạy lần lượt trong SQL Editor:
   - `Assets/SQL/schema.sql` (tạo bảng gốc)
   - `Assets/SQL/rls_policies.sql`
   - `Assets/SQL/migration_v2_groups_soft_delete_username.sql`  
   **Lưu ý:** Trên DB đã có bảng `transactions` với `user_id`, cần backfill trước khi drop cột:
   - Tạo nhóm cá nhân cho từng user có giao dịch.
   - `UPDATE transactions SET group_id = ..., created_by = user_id, paid_by = user_id WHERE user_id = ...`.
   - Sau đó mới chạy các lệnh `ALTER TABLE transactions` (drop user_id, add not null cho group_id, created_by, paid_by).

2. **RPC đăng nhập**  
   Migration đã cập nhật `get_email_for_login`: tìm email theo `username` hoặc `full_name`.  
   Đăng nhập bằng email hoặc username đều được.

3. **Trigger `handle_new_user`**  
   Đã chỉnh: ghi `username` vào `public.users`, tạo nhóm cá nhân và gán user vào `group_members` làm admin, tạo 2 ví mặc định.

---

## Cấu trúc code đã thêm/sửa

| Thành phần | Mô tả |
|------------|--------|
| `lib/.../auth/domain/app_user.dart` | Thêm `username`. |
| `lib/.../auth/data/auth_repository.dart` | `signUpWithEmail(..., username, fullName?)`, `updateProfile(fullName)`. |
| `lib/.../auth/.../register_screen.dart` | Form: username (bắt buộc), họ tên (tùy chọn). |
| `lib/.../groups/domain/group.dart` | Model `AppGroup`. |
| `lib/.../groups/domain/group_member.dart` | Model `GroupMember`. |
| `lib/.../groups/data/group_repository.dart` | `getUserGroups`, `getPersonalGroup`, `getGroupMembers`, `createGroup`. |
| `lib/.../groups/.../active_group_provider.dart` | `activeGroupProvider`, `ensurePersonalGroup()`, `groupMembersProvider`. |
| `lib/.../groups/.../group_switcher.dart` | Dropdown chọn nhóm (Records). |
| `lib/.../transactions/domain/transaction.dart` | Thêm `groupId`, `createdBy`, `paidBy`, `*UserName`, `*AvatarUrl`. |
| `lib/.../transactions/data/transaction_repository.dart` | `getTransactions(groupId, ...)`, `addTransaction(..., groupId, createdBy, paidBy)`. |
| `lib/.../transactions/.../transactions_provider.dart` | `TransactionListParams.groupId`; list theo active group. |
| `lib/.../records/.../records_screen.dart` | Dùng `activeGroup`, hiển thị `paidByLabel` khi không phải nhóm cá nhân, AppBar có `GroupSwitcher`. |
| `lib/.../transactions/.../add_transaction_screen.dart` | Truyền `groupId`, `createdBy`, `paidBy`; dropdown "Người thanh toán" khi nhóm nhiều người. |
| `lib/.../categories/data/category_repository.dart` | Lọc status active; thêm `softDeleteCategory(id)`. |
| `lib/.../charts/...` | Analytics theo `groupId` (ChartsParams.groupId). |
| `lib/.../shell/main_shell_screen.dart` | Gọi `ensurePersonalGroup()` khi vào shell. |
| `lib/.../profile/.../me_placeholder_screen.dart` | Hiển thị username, mục "Chỉnh sửa hồ sơ" (đổi họ tên). |

---

## Tính năng "Mời thành viên" (nhóm không cá nhân)

Yêu cầu: API tạo link mời, tìm user, gửi lời mời; chặn thêm thành viên vào nhóm `is_personal = true`.  
Chưa triển khai trong đợt này; có thể bổ sung sau với:

- Bảng `group_invites` (token, group_id, invited_by, expires_at) hoặc cột `invite_token` trên `groups`.
- RPC/API: `generate_invite_link(group_id)`, `search_users(query)`, `accept_invite(token)`.
- Trong `group_repository.createGroup` / add member: kiểm tra `is_personal` và throw nếu true.
