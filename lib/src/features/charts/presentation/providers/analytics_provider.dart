import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/analytics_repository.dart';
import '../../../categories/presentation/providers/categories_provider.dart';
import '../../../transactions/domain/transaction.dart';
import '../../../transactions/presentation/providers/transactions_provider.dart';

final analyticsRepositoryProvider = Provider<AnalyticsRepository>((ref) {
  return AnalyticsRepository(
    transactionRepository: ref.read(transactionRepositoryProvider),
    categoryRepository: ref.read(categoryRepositoryProvider),
  );
});

class ChartsParams {
  const ChartsParams({
    required this.groupId,
    required this.from,
    required this.to,
  });
  final String groupId;
  final DateTime from;
  final DateTime to;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChartsParams &&
          groupId == other.groupId &&
          from == other.from &&
          to == other.to;

  @override
  int get hashCode => Object.hash(groupId, from, to);
}

final expenseAnalyticsProvider =
    FutureProvider.family<ExpenseAnalytics, ChartsParams>((ref, params) async {
      if (params.groupId.isEmpty) return const ExpenseAnalytics(total: 0, byCategory: []);
      return ref.read(analyticsRepositoryProvider).getExpenseAnalytics(
            groupId: params.groupId,
            from: params.from,
            to: params.to,
          );
    });

final incomeAnalyticsProvider =
    FutureProvider.family<IncomeAnalytics, ChartsParams>((ref, params) async {
      if (params.groupId.isEmpty) return const IncomeAnalytics(total: 0, byCategory: []);
      return ref.read(analyticsRepositoryProvider).getIncomeAnalytics(
            groupId: params.groupId,
            from: params.from,
            to: params.to,
          );
    });

final topIncomeProvider =
    FutureProvider.family<List<Transaction>, ChartsParams>((ref, params) async {
      if (params.groupId.isEmpty) return [];
      final repo = ref.read(analyticsRepositoryProvider);
      return repo.getTopTransactions(
        groupId: params.groupId,
        from: params.from,
        to: params.to,
        type: 'income',
        limit: 5,
      );
    });

final topExpenseProvider =
    FutureProvider.family<List<Transaction>, ChartsParams>((ref, params) async {
      if (params.groupId.isEmpty) return [];
      final repo = ref.read(analyticsRepositoryProvider);
      return repo.getTopTransactions(
        groupId: params.groupId,
        from: params.from,
        to: params.to,
        type: 'expense',
        limit: 5,
      );
    });
