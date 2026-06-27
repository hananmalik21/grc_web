import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/core/widgets/feedback/shimmer_widget.dart';
import 'package:grc/core/services/initialization/providers/initialization_providers.dart';
import 'package:grc/features/enterprise_structure/domain/models/enterprise.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EnterpriseSelectorMobileWidget extends ConsumerWidget {
  final int? selectedEnterpriseId;
  final ValueChanged<int?> onEnterpriseChanged;

  const EnterpriseSelectorMobileWidget({
    super.key,
    required this.selectedEnterpriseId,
    required this.onEnterpriseChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(showEnterpriseSelectorProvider)) {
      return const SizedBox.shrink();
    }

    final enterprisesState = ref.watch(enterprisesCacheStateProvider);
    final isDark = context.isDark;
    final selectedEnterprise = enterprisesState.findEnterpriseById(selectedEnterpriseId);

    final height = 32.w;
    final hPadding = 14.w;
    final iconSize = 12.sp;
    final chevronSize = 14.sp;
    final gap1 = 7.w;
    final gap2 = 5.w;
    final radius = 16.r;

    if (enterprisesState.isLoading) {
      return ShimmerWidget(
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: isDark ? AppColors.inputBgDark : const Color(0xFFE5E7EB),
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () => _showBottomSheet(context, enterprisesState.enterprises, selectedEnterprise, isDark),
      child: Container(
        height: height,
        padding: EdgeInsetsDirectional.symmetric(horizontal: hPadding),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardBackgroundDark : Colors.white,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color: selectedEnterprise != null
                ? AppColors.primary.withValues(alpha: 0.4)
                : (isDark ? AppColors.cardBorderDark : const Color(0xFFE5E7EB)),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.business_rounded,
              size: iconSize,
              color: selectedEnterprise != null
                  ? AppColors.primary
                  : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondary),
            ),
            Gap(gap1),
            Flexible(
              child: Text(
                selectedEnterprise?.name ?? 'All Enterprises',
                style: context.textTheme.labelMedium?.copyWith(
                  fontSize: 10.5.sp,
                  fontWeight: selectedEnterprise != null ? FontWeight.w600 : FontWeight.w400,
                  color: selectedEnterprise != null
                      ? AppColors.primary
                      : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondary),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Gap(gap2),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: chevronSize,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context, List<Enterprise> enterprises, Enterprise? selected, bool isDark) {
    DigifyBottomSheet.show(
      context,
      type: DigifyBottomSheetType.picker,
      title: 'Select Enterprise',
      child: DigifyPickerSheetContent<Enterprise>(
        items: enterprises,
        itemBuilder: (ctx, e, _) => DigifyPickerItem(
          label: e.name,
          isSelected: selected?.id == e.id,
          isDark: isDark,
          onTap: () {
            Navigator.pop(ctx);
            onEnterpriseChanged(e.id);
          },
        ),
      ),
    );
  }
}
