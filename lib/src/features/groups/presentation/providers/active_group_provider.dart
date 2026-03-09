import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/group_repository.dart';
import '../../domain/group.dart';
import '../../domain/group_invitation.dart';
import '../../domain/group_member.dart';

final groupRepositoryProvider = Provider<GroupRepository>((ref) {
  return GroupRepository();
});

final activeGroupProvider = StateNotifierProvider<ActiveGroupNotifier, AppGroup?>((ref) {
  return ActiveGroupNotifier(ref);
});

class ActiveGroupNotifier extends StateNotifier<AppGroup?> {
  ActiveGroupNotifier(this._ref) : super(null);

  final Ref _ref;

  void setActiveGroup(AppGroup? group) {
    state = group;
  }

  /// Gán nhóm cá nhân làm active nếu chưa có (gọi sau khi đăng nhập).
  Future<void> ensurePersonalGroup() async {
    if (state != null) return;
    final repo = _ref.read(groupRepositoryProvider);
    final g = await repo.getPersonalGroup();
    if (g != null) state = g;
  }
}

final userGroupsListProvider = FutureProvider<List<AppGroup>>((ref) async {
  return ref.read(groupRepositoryProvider).getUserGroups();
});

final groupMembersProvider = FutureProvider.family<List<GroupMember>, String>((ref, groupId) async {
  if (groupId.isEmpty) return [];
  return ref.read(groupRepositoryProvider).getGroupMembers(groupId);
});

final myInvitationsProvider = FutureProvider<List<GroupInvitation>>((ref) async {
  return ref.read(groupRepositoryProvider).getMyInvitations();
});
