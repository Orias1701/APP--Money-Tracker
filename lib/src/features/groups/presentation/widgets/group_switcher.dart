import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../providers/active_group_provider.dart';
import '../../domain/group.dart';

class GroupSwitcher extends ConsumerWidget {
  const GroupSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeGroup = ref.watch(activeGroupProvider);
    final groupsAsync = ref.watch(userGroupsListProvider);

    return groupsAsync.when(
      data: (groups) {
        if (groups.isEmpty) {
          return Text(
            activeGroup?.name ?? 'Nhóm',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          );
        }
        final selected = activeGroup != null &&
                groups.any((g) => g.id == activeGroup.id)
            ? groups.firstWhere((g) => g.id == activeGroup.id)
            : groups.first;
        return DropdownButtonHideUnderline(
          child: DropdownButton<AppGroup>(
            value: selected,
            isExpanded: true,
            dropdownColor: AppColors.surface,
            icon: const Icon(Icons.arrow_drop_down, color: AppColors.textPrimary),
            items: groups
                .map(
                  (g) => DropdownMenuItem<AppGroup>(
                    value: g,
                    child: Text(
                      g.name,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                .toList(),
            onChanged: (g) {
              if (g != null) {
                ref.read(activeGroupProvider.notifier).setActiveGroup(g);
              }
            },
          ),
        );
      },
      loading: () => Text(
        activeGroup?.name ?? 'Nhóm',
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
        ),
      ),
      error: (_, __) => Text(
        activeGroup?.name ?? 'Nhóm',
        style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
      ),
    );
  }
}
