import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/buttons/app_view_toggle_button.dart';
import 'package:grc/core/widgets/forms/digify_select_field.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/hiring/application/candidates/providers/candidates_controller_provider.dart';
import 'package:grc/features/hiring/domain/models/candidates/candidate_status.dart';
import 'package:grc/features/hiring/presentation/providers/candidates/candidates_filter_provider.dart';
import 'package:grc/features/hiring/presentation/providers/candidates/candidates_tab_enterprise_provider.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CandidatesFilterBar extends ConsumerStatefulWidget {
  const CandidatesFilterBar({super.key});

  @override
  ConsumerState<CandidatesFilterBar> createState() => _CandidatesFilterBarState();
}

class _CandidatesFilterBarState extends ConsumerState<CandidatesFilterBar> {
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
    final filterState = ref.watch(candidatesFilterProvider);
    final controller = ref.read(candidatesControllerProvider);
    final viewMode = ref.watch(candidatesViewModeProvider);
    final effectiveFillColor = isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground;

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
                  hintText: loc.hiringCandidatesSearchHint,
                  onChanged: controller.setSearch,
                ),
              ),
              Gap(8.w),
              _buildViewModeToggle(viewMode, isDark),
              Gap(8.w),
              AppButton.outline(
                label: loc.advancedFilters,
                svgPath: Assets.icons.employeeManagement.filterMain.path,
                onPressed: () {},
              ),
            ],
          ),
          Gap(16.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              SizedBox(
                width: 220.w,
                child: DigifySelectField<CandidateStatus>(
                  hint: loc.allStatuses,
                  value: CandidateStatus.fromRaw(filterState.status),
                  items: CandidateStatus.values,
                  itemLabelBuilder: (value) {
                    return switch (value) {
                      CandidateStatus.all => loc.allCandidates,
                      CandidateStatus.active => loc.active,
                      CandidateStatus.hired => loc.hiringCandidatesStatHired,
                      CandidateStatus.rejected => loc.rejected,
                      CandidateStatus.blacklisted => loc.blacklisted,
                    };
                  },
                  onChanged: (val) {
                    if (val != null) {
                      controller.setStatus(val == CandidateStatus.all ? null : val.raw);
                    }
                  },
                  fillColor: effectiveFillColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildViewModeToggle(CandidatesViewMode viewMode, bool isDark) {
    final assetPath = viewMode == CandidatesViewMode.grid
        ? Assets.icons.employeeManagement.gridView.path
        : Assets.icons.hiring.listing.path;

    return AppViewToggleButton(
      svgPath: assetPath,
      onPressed: ref.read(candidatesControllerProvider).toggleViewMode,
      backgroundColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
      foregroundColor: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
      borderColor: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
    );
  }
}
