import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/features/workforce_structure/presentation/providers/position_providers.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/search/workforce_search_bar.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/search/workforce_status_dropdown.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

final _showPositionFiltersProvider = StateProvider<bool>((ref) => false);

class WorkforcePositionsFilterBarMobile extends ConsumerStatefulWidget {
  const WorkforcePositionsFilterBarMobile({
    required this.localizations,
    required this.isDark,
    this.onExport,
    this.isExporting = false,
    super.key,
  });

  final AppLocalizations localizations;
  final bool isDark;
  final VoidCallback? onExport;
  final bool isExporting;

  @override
  ConsumerState<WorkforcePositionsFilterBarMobile> createState() => _WorkforcePositionsFilterBarMobileState();
}

class _WorkforcePositionsFilterBarMobileState extends ConsumerState<WorkforcePositionsFilterBarMobile> {
  @override
  Widget build(BuildContext context) {
    final showFilters = ref.watch(_showPositionFiltersProvider);

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: widget.isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: WorkforceSearchBar(
                  hintText: widget.localizations.searchPositionsPlaceholder,
                  isDark: widget.isDark,
                  width: double.infinity,
                  onSearchChanged: (value) => ref.read(positionNotifierProvider.notifier).search(value),
                ),
              ),
              Gap(8.w),
              AppMobileButton(
                svgPath: Assets.icons.employeeManagement.filterMain.path,
                type: AppButtonType.outline,
                onPressed: () {
                  ref.read(_showPositionFiltersProvider.notifier).state = !showFilters;
                },
                backgroundColor: showFilters ? AppColors.primary.withValues(alpha: 0.1) : null,
                borderColor: showFilters ? AppColors.primary : null,
                foregroundColor: showFilters
                    ? AppColors.primary
                    : (widget.isDark ? AppColors.textPrimaryDark : AppColors.textPrimary),
              ),
              Gap(8.w),
              AppMobileButton(
                svgPath: Assets.icons.downloadIcon.path,
                type: AppButtonType.primary,
                backgroundColor: AppColors.shiftExportButton,
                onPressed: widget.isExporting ? null : widget.onExport,
                isLoading: widget.isExporting,
              ),
            ],
          ),
          if (showFilters) ...[
            Gap(12.h),
            WorkforceStatusDropdown(
              label: widget.localizations.allStatus,
              isDark: widget.isDark,
              width: double.infinity,
            ),
          ],
        ],
      ),
    );
  }
}
