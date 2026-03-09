class Transaction {
  const Transaction({
    required this.id,
    required this.groupId,
    required this.accountId,
    this.toAccountId,
    this.categoryId,
    required this.type,
    required this.amount,
    this.feeAmount = 0,
    required this.transactionDate,
    this.note,
    required this.createdBy,
    required this.paidBy,
    this.createdByUserName,
    this.paidByUserName,
    this.createdByAvatarUrl,
    this.paidByAvatarUrl,
  });

  final String id;
  final String groupId;
  final String accountId;
  final String? toAccountId;
  final String? categoryId;
  final String type;
  final double amount;
  final double feeAmount;
  final DateTime transactionDate;
  final String? note;
  final String createdBy;
  final String paidBy;
  final String? createdByUserName;
  final String? paidByUserName;
  final String? createdByAvatarUrl;
  final String? paidByAvatarUrl;

  bool get isIncome => type == 'income';
  bool get isExpense => type == 'expense';
  bool get isTransfer => type == 'transfer';

  factory Transaction.fromMap(Map<String, dynamic> map) {
    final d = map['transaction_date'];
    final createdByUser = map['created_by_user'] as Map<String, dynamic>?;
    final paidByUser = map['paid_by_user'] as Map<String, dynamic>?;
    return Transaction(
      id: map['id'] as String,
      groupId: map['group_id'] as String,
      accountId: map['account_id'] as String,
      toAccountId: map['to_account_id'] as String?,
      categoryId: map['category_id'] as String?,
      type: map['type'] as String,
      amount: (map['amount'] is num) ? (map['amount'] as num).toDouble() : 0,
      feeAmount: (map['fee_amount'] is num) ? (map['fee_amount'] as num).toDouble() : 0,
      transactionDate: d != null ? (d is DateTime ? d : DateTime.parse(d.toString())) : DateTime.now(),
      note: map['note'] as String?,
      createdBy: map['created_by'] as String,
      paidBy: map['paid_by'] as String,
      createdByUserName: createdByUser?['full_name'] as String? ?? createdByUser?['username'] as String?,
      paidByUserName: paidByUser?['full_name'] as String? ?? paidByUser?['username'] as String?,
      createdByAvatarUrl: createdByUser?['avatar_url'] as String?,
      paidByAvatarUrl: paidByUser?['avatar_url'] as String?,
    );
  }
}
