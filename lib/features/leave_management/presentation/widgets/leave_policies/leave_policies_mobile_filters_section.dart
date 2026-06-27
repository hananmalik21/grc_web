import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/widgets/forms/digify_select_field.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_policies_filter_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LeavePoliciesMobileFiltersSection extends ConsumerStatefulWidget {
  const LeavePoliciesMobileFiltersSection({super.key, required this.localizations, required this.isDark});

  final AppLocalizations localizations;
  final bool isDark;

  @override
  ConsumerState<LeavePoliciesMobileFiltersSection> createState() => _LeavePoliciesMobileFiltersSectionState();
}

class _LeavePoliciesMobileFiltersSectionState extends ConsumerState<LeavePoliciesMobileFiltersSection> {
  late TextEditingController _searchController;

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

  static const List<String?> _statusItems = [null, 'ACTIVE', 'INACTIVE'];
  static const List<String?> _typeValues = [null, 'kuwait_y', 'kuwait_n'];

  String _statusLabel(String? v) {
    if (v == null) return 'All Status';
    return v == 'ACTIVE' ? 'Active' : 'Inactive';
  }

  String _typeLabel(String? v) {
    if (v == null) return 'All';
    return v == 'kuwait_y' ? 'Compliant' : 'Not compliant';
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(leavePoliciesFilterProvider);

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: widget.isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DigifyTextField.search(controller: _searchController, hintText: 'Search policies...', onChanged: (_) {}),
          Gap(12.h),
          Row(
            children: [
              Expanded(
                child: DigifySelectField<String?>(
                  hint: 'Compliant',
                  value: filter.type,
                  items: _typeValues,
                  itemLabelBuilder: _typeLabel,
                  onChanged: (v) => ref.read(leavePoliciesFilterProvider.notifier).setType(v),
                ),
              ),
              Gap(12.w),
              Expanded(
                child: DigifySelectField<String?>(
                  hint: 'Status',
                  value: filter.status,
                  items: _statusItems,
                  itemLabelBuilder: _statusLabel,
                  onChanged: (v) => ref.read(leavePoliciesFilterProvider.notifier).setStatus(v),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
