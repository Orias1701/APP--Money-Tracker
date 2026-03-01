import '../domain/group.dart';
import '../../auth/domain/app_user.dart';

class GroupMember {
  const GroupMember({
    required this.id,
    required this.groupId,
    required this.userId,
    required this.role,
    this.status = 'active',
    this.joinedAt,
    this.user,
    this.group,
  });

  final String id;
  final String groupId;
  final String userId;
  final String role;
  final String status;
  final DateTime? joinedAt;
  final AppUser? user;
  final AppGroup? group;

  bool get isAdmin => role == 'admin';

  factory GroupMember.fromMap(Map<String, dynamic> map) {
    final d = map['joined_at'];
    final u = map['user'] as Map<String, dynamic>?;
    final g = map['group'] as Map<String, dynamic>?;
    return GroupMember(
      id: map['id'] as String,
      groupId: map['group_id'] as String,
      userId: map['user_id'] as String,
      role: map['role'] as String? ?? 'member',
      status: map['status'] as String? ?? 'active',
      joinedAt: d != null ? (d is DateTime ? d : DateTime.parse(d.toString())) : null,
      user: u != null ? AppUser.fromMap(u) : null,
      group: g != null ? AppGroup.fromMap(g) : null,
    );
  }
}
