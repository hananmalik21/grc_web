import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:flutter/material.dart';

class EmployeeCompensationTableFooter extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int pageSize;
  final VoidCallback? onPreviousPage;
  final VoidCallback? onNextPage;

  const EmployeeCompensationTableFooter({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.pageSize,
    this.onPreviousPage,
    this.onNextPage,
  });

  @override
  Widget build(BuildContext context) {
    return PaginationControls(
      currentPage: currentPage,
      totalPages: totalPages,
      totalItems: totalItems,
      pageSize: pageSize,
      hasNext: currentPage < totalPages,
      hasPrevious: currentPage > 1,
      onPrevious: onPreviousPage,
      onNext: onNextPage,
      showBorder: true,
      style: PaginationStyle.simple,
    );
  }
}
