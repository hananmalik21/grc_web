import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/features/workforce_structure/presentation/providers/position_providers.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/search/workforce_search_bar.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/search/workforce_status_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:gap/gap.dart';

class WorkforceSearchAndActions extends ConsumerWidget {
  final AppLocalizations localizations;
  final bool isDark;
  final VoidCallback? onExport;
  final bool isExporting;

  const WorkforceSearchAndActions({
    super.key,
    required this.localizations,
    required this.isDark,
    this.onExport,
    this.isExporting = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: WorkforceSearchBar(
              hintText: localizations.searchPositionsPlaceholder,
              isDark: isDark,
              onSearchChanged: (value) => ref.read(positionNotifierProvider.notifier).search(value),
            ),
          ),
          Gap(16.w),
          WorkforceStatusDropdown(label: localizations.allStatus, isDark: isDark),
          Gap(12.w),
          AppButton(
            label: localizations.import,
            onPressed: () {},
            svgPath: Assets.icons.bulkUploadIconFigma.path,
            backgroundColor: AppColors.shiftUploadButton,
          ),
          Gap(12.w),
          AppButton(
            label: localizations.export,
            onPressed: isExporting ? null : onExport,
            isLoading: isExporting,
            svgPath: Assets.icons.downloadIcon.path,
            backgroundColor: isDark ? AppColors.cardBackgroundGreyDark : AppColors.shiftExportButton,
          ),
        ],
      ),
    );
  }
}
