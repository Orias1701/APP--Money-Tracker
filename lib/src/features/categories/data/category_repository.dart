import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/services/supabase_service.dart';
import '../domain/category.dart';

class CategoryRepository {
  CategoryRepository() : _client = SupabaseService.client;

  final SupabaseClient _client;

  String? get _userId => _client.auth.currentUser?.id;

  /// Lấy danh mục: hệ thống + của user, chỉ status active (xoá mềm).
  Future<List<Category>> getCategories({String? type}) async {
    final uid = _userId;
    try {
      var query = _client.from('categories').select().eq('is_active', true);
      try {
        query = query.or('status.is.null,status.eq.active');
      } catch (_) {}
      if (type != null) query = query.eq('type', type);
      final res = uid == null
          ? await query.isFilter('user_id', null).order('order_index')
          : await query.or('user_id.is.null,user_id.eq.$uid').order('order_index');
      return (res as List).map((e) => Category.fromMap(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  /// Thêm danh mục của user (user_id = current user).
  /// Trả về (category, error): nếu lỗi thì category == null và error có nội dung.
  Future<({Category? category, String? error})> addCategory({
    required String name,
    required String type,
    String iconName = 'category',
    String colorHex = '#6B7280',
    int orderIndex = 0,
  }) async {
    final uid = _userId;
    if (uid == null) {
      return (
        category: null,
        error: 'Chưa đăng nhập. Vui lòng đăng nhập lại.',
      );
    }
    try {
      final res = await _client.from('categories').insert({
        'user_id': uid,
        'name': name,
        'type': type,
        'icon_name': iconName,
        'color_hex': colorHex,
        'order_index': orderIndex,
        'is_active': true,
      }).select().single();
      return (category: Category.fromMap(res), error: null);
    } catch (e) {
      // Thường gặp: RLS policy chặn INSERT → bật policy INSERT cho user trong Supabase Dashboard.
      return (
        category: null,
        error: e.toString().replaceFirst(RegExp(r'^Exception:?\s*', caseSensitive: false), ''),
      );
    }
  }

  /// Xoá mềm: set status = 'deleted'. Chỉ category do user tạo (user_id = current user).
  Future<bool> softDeleteCategory(String categoryId) async {
    final uid = _userId;
    if (uid == null) return false;
    try {
      await _client
          .from('categories')
          .update({'status': 'deleted'})
          .eq('id', categoryId)
          .eq('user_id', uid);
      return true;
    } catch (_) {
      return false;
    }
  }
}
