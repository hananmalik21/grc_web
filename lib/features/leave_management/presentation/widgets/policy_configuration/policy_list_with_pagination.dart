import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/features/leave_management/domain/models/policy_list_item.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/leave_types_list.dart';
import 'package:grc/features/time_management/domain/models/pagination_info.dart';
import 'package:flutter/material.dart';

/// List of policies with optional pagination controls.
/// Used in both mobile and desktop policy configuration layouts.
class PolicyListWithPagination extends StatelessWidget {
  final List<PolicyListItem> policies;
  final PolicyListItem? selectedPolicy;
  final ValueChanged<PolicyListItem> onPolicySelected;
  final bool isDark;
  final BoxConstraints listConstraints;
  final PaginationInfo? paginationInfo;
  final int currentPage;
  final int pageSize;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final bool isLoading;
  final double? width;

  const PolicyListWithPagination({
    super.key,
    required this.policies,
    required this.selectedPolicy,
    required this.onPolicySelected,
    required this.isDark,
    required this.listConstraints,
    this.paginationInfo,
    required this.currentPage,
    required this.pageSize,
    this.onPrevious,
    this.onNext,
    this.isLoading = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ConstrainedBox(
          constraints: listConstraints,
          child: LeaveTypesList(
            policies: policies,
            isDark: isDark,
            selectedPolicy: selectedPolicy,
            onPolicySelected: onPolicySelected,
          ),
        ),
        if (_showPagination) _buildPagination(),
      ],
    );

    if (width != null) {
      return SizedBox(width: width, child: content);
    }
    return content;
  }

  bool get _showPagination => paginationInfo != null && policies.isNotEmpty;

  Widget _buildPagination() {
    final info = paginationInfo!;
    return PaginationControls.fromPaginationInfo(
      paginationInfo: info,
      currentPage: currentPage,
      pageSize: pageSize,
      onPrevious: info.hasPrevious ? onPrevious : null,
      onNext: info.hasNext ? onNext : null,
      isLoading: isLoading,
      style: PaginationStyle.simple,
    );
  }
}
