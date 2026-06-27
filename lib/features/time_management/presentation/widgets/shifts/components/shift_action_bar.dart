import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/enums/position_status.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/forms/digify_select_field.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/time_management/presentation/providers/shifts_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ShiftActionBar extends ConsumerStatefulWidget {
  final int enterpriseId;

  const ShiftActionBar({super.key, required this.enterpriseId});

  @override
  ConsumerState<ShiftActionBar> createState() => _ShiftActionBarState();
}

class _ShiftActionBarState extends ConsumerState<ShiftActionBar> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final currentStatus = ref.watch(shiftsNotifierProvider(widget.enterpriseId).select((s) => s.status));
    final searchQuery = ref.watch(shiftsNotifierProvider(widget.enterpriseId).select((s) => s.searchQuery));

    if (searchQuery == null && _searchController.text.isNotEmpty) {
      _searchController.clear();
    } else if (searchQuery != null && _searchController.text.isEmpty) {
      _searchController.text = searchQuery;
    }

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DigifyTextField.search(
            controller: _searchController,
            hintText: 'Search shifts...',
            onChanged: (value) {
              ref.read(shiftsNotifierProvider(widget.enterpriseId).notifier).search(value);
            },
          ),
          Gap(16.h),
          Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: 144.w,
                child: DigifySelectField<PositionStatus?>(
                  hint: 'All Status',
                  value: currentStatus,
                  items: [null, ...PositionStatus.values],
                  itemLabelBuilder: (status) => status?.label ?? 'All Status',
                  onChanged: (newValue) {
                    ref
                        .read(shiftsNotifierProvider(widget.enterpriseId).notifier)
                        .setStatusFilter(newValue == null ? null : newValue == PositionStatus.active);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
