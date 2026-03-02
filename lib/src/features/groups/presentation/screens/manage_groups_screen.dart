import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../providers/active_group_provider.dart';

class ManageGroupsScreen extends ConsumerStatefulWidget {
  const ManageGroupsScreen({super.key});

  @override
  ConsumerState<ManageGroupsScreen> createState() => _ManageGroupsScreenState();
}

class _ManageGroupsScreenState extends ConsumerState<ManageGroupsScreen> {
  final _createNameController = TextEditingController();
  final _joinIdController = TextEditingController();
  var _createLoading = false;
  var _joinLoading = false;
  String? _createError;
  String? _joinError;
  String? _joinSuccess;

  @override
  void dispose() {
    _createNameController.dispose();
    _joinIdController.dispose();
    super.dispose();
  }

  Future<void> _createGroup() async {
    final name = _createNameController.text.trim();
    if (name.isEmpty) {
      setState(() {
        _createError = 'Nhập tên nhóm';
        _createLoading = false;
      });
      return;
    }
    setState(() {
      _createError = null;
      _createLoading = true;
    });
    final repo = ref.read(groupRepositoryProvider);
    final g = await repo.createGroup(name);
    if (!mounted) return;
    setState(() => _createLoading = false);
    if (g != null) {
      ref.read(activeGroupProvider.notifier).setActiveGroup(g);
      ref.invalidate(userGroupsListProvider);
      if (mounted) context.pop();
    } else {
      setState(() => _createError = 'Không tạo được nhóm');
    }
  }

  Future<void> _joinGroup() async {
    final id = _joinIdController.text.trim();
    if (id.isEmpty) {
      setState(() {
        _joinError = 'Nhập ID nhóm';
        _joinLoading = false;
      });
      return;
    }
    setState(() {
      _joinError = null;
      _joinSuccess = null;
      _joinLoading = true;
    });
    final repo = ref.read(groupRepositoryProvider);
    final err = await repo.joinGroupById(id);
    if (!mounted) return;
    setState(() => _joinLoading = false);
    if (err == null) {
      setState(() => _joinSuccess = 'Đã tham gia nhóm');
      ref.invalidate(userGroupsListProvider);
      final groups = await repo.getUserGroups();
      final joined = groups.where((g) => g.id == id).firstOrNull ?? (groups.isNotEmpty ? groups.first : null);
      if (joined != null) ref.read(activeGroupProvider.notifier).setActiveGroup(joined);
    } else {
      setState(() => _joinError = err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Tạo & tham gia nhóm'),
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Tạo nhóm mới',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _createNameController,
              decoration: const InputDecoration(
                labelText: 'Tên nhóm',
                hintText: 'VD: Chi tiêu gia đình',
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(color: AppColors.textPrimary),
              onSubmitted: (_) => _createGroup(),
            ),
            if (_createError != null) ...[
              const SizedBox(height: 8),
              Text(
                _createError!,
                style: const TextStyle(color: AppColors.expense, fontSize: 14),
              ),
            ],
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _createLoading ? null : _createGroup,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _createLoading
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Tạo nhóm'),
            ),
            const SizedBox(height: 32),
            const Text(
              'Tham gia nhóm bằng ID',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _joinIdController,
              decoration: const InputDecoration(
                labelText: 'ID nhóm',
                hintText: 'Dán ID nhóm được chia sẻ',
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(color: AppColors.textPrimary),
              onSubmitted: (_) => _joinGroup(),
            ),
            if (_joinError != null) ...[
              const SizedBox(height: 8),
              Text(
                _joinError!,
                style: const TextStyle(color: AppColors.expense, fontSize: 14),
              ),
            ],
            if (_joinSuccess != null) ...[
              const SizedBox(height: 8),
              Text(
                _joinSuccess!,
                style: const TextStyle(color: AppColors.income, fontSize: 14),
              ),
            ],
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _joinLoading ? null : _joinGroup,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.surface,
                foregroundColor: AppColors.textPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _joinLoading
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Tham gia nhóm'),
            ),
          ],
        ),
      ),
    );
  }
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull => isEmpty ? null : first;
}
