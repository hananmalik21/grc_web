import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/hiring/presentation/providers/requisitions/requisitions_filter_provider.dart';
import 'package:grc/features/hiring/presentation/widgets/requisitions/requisitions_filter_dropdowns.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class RequisitionsFilterBar extends ConsumerStatefulWidget {
  const RequisitionsFilterBar({super.key});

  @override
  ConsumerState<RequisitionsFilterBar> createState() => _RequisitionsFilterBarState();
}

class _RequisitionsFilterBarState extends ConsumerState<RequisitionsFilterBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final filterNotifier = ref.read(requisitionsFilterProvider.notifier);

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: DigifyTextField.search(
                  controller: _searchController,
                  hintText: loc.hiringRequisitionsSearchHint,
                  onChanged: filterNotifier.setSearch,
                ),
              ),
              Gap(16.w),
              AppButton.outline(
                label: loc.advancedFilters,
                svgPath: Assets.icons.employeeManagement.filterMain.path,
                onPressed: () {},
              ),
            ],
          ),
          Gap(16.h),
          RequisitionsFilterDropdowns(dropdownWidth: 220.w, spacing: 8, runSpacing: 8),
        ],
      ),
    );
  }
}
