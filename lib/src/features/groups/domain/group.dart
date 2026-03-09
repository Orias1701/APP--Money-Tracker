class AppGroup {
  const AppGroup({
    required this.id,
    required this.name,
    required this.isPersonal,
    this.status = 'active',
    this.createdAt,
  });

  final String id;
  final String name;
  final bool isPersonal;
  final String status;
  final DateTime? createdAt;

  factory AppGroup.fromMap(Map<String, dynamic> map) {
    final d = map['created_at'];
    return AppGroup(
      id: map['id'] as String,
      name: map['name'] as String? ?? '',
      isPersonal: map['is_personal'] as bool? ?? true,
      status: map['status'] as String? ?? 'active',
      createdAt: d != null ? (d is DateTime ? d : DateTime.parse(d.toString())) : null,
    );
  }
}
