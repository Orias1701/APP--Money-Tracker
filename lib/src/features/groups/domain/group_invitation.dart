class GroupInvitation {
  const GroupInvitation({
    required this.id,
    required this.groupId,
    required this.groupName,
    required this.invitedBy,
    required this.inviterName,
    this.createdAt,
  });

  final String id;
  final String groupId;
  final String groupName;
  final String invitedBy;
  final String inviterName;
  final DateTime? createdAt;

  factory GroupInvitation.fromMap(Map<String, dynamic> map) {
    final d = map['created_at'];
    return GroupInvitation(
      id: map['id'] as String,
      groupId: map['group_id'] as String,
      groupName: map['group_name'] as String? ?? '',
      invitedBy: map['invited_by'] as String,
      inviterName: map['inviter_name'] as String? ?? '',
      createdAt: d != null ? (d is DateTime ? d : DateTime.tryParse(d.toString())) : null,
    );
  }
}
