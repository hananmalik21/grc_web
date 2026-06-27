import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/widgets/forms/digify_select_field.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/employee_self_service/presentation/providers/leave_absence/leave_absence_state.dart';
import 'package:grc/features/employee_self_service/presentation/widgets/ess_surface_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LeaveAbsenceFiltersCard extends StatefulWidget {
  const LeaveAbsenceFiltersCard({
    super.key,
    required this.searchQuery,
    required this.selectedStatus,
    required this.onSearchChanged,
    required this.onStatusSelected,
  });

  final String searchQuery;
  final LeaveAbsenceRequestStatus selectedStatus;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<LeaveAbsenceRequestStatus> onStatusSelected;

  @override
  State<LeaveAbsenceFiltersCard> createState() => _LeaveAbsenceFiltersCardState();
}

class _LeaveAbsenceFiltersCardState extends State<LeaveAbsenceFiltersCard> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.searchQuery);
  }

  @override
  void didUpdateWidget(covariant LeaveAbsenceFiltersCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchQuery != widget.searchQuery && _controller.text != widget.searchQuery) {
      _controller.text = widget.searchQuery;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EssSurfaceCard(
      padding: EdgeInsets.all(14.5.w),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isStacked = constraints.maxWidth < 760;
          final searchField = Expanded(
            child: DigifyTextField.search(
              controller: _controller,
              hintText: 'Search by leave type or reason...',
              onChanged: widget.onSearchChanged,
              borderColor: AppColors.inputBorder,
            ),
          );
          final statusSelector = SizedBox(
            width: 170.w,
            child: DigifySelectField<LeaveAbsenceRequestStatus>(
              value: widget.selectedStatus,
              items: LeaveAbsenceRequestStatus.values,
              itemLabelBuilder: (status) => status.label,
              onChanged: (status) {
                if (status != null) widget.onStatusSelected(status);
              },
              fillColor: AppColors.cardBackground,
            ),
          );

          if (isStacked) {
            return Column(
              children: [
                Row(children: [searchField]),
                Gap(12.h),
                Align(alignment: Alignment.centerRight, child: statusSelector),
              ],
            );
          }

          return Row(
            children: [
              searchField,
              Gap(12.w),
              statusSelector,
            ],
          );
        },
      ),
    );
  }
}
