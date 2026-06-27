import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/mobile/mobile_state_card.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:grc/features/workforce_structure/domain/models/position.dart';
import 'package:grc/features/workforce_structure/presentation/providers/position_providers.dart';
import 'package:grc/features/workforce_structure/presentation/screens/positions/positions_permission_mixin.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class WorkforcePositionsListMobile extends ConsumerWidget {
  const WorkforcePositionsListMobile({
    required this.localizations,
    required this.positions,
    required this.isDark,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
    this.isLoading = false,
    super.key,
  });

  final AppLocalizations localizations;
  final List<Position> positions;
  final bool isDark;
  final bool isLoading;
  final Function(Position) onView;
  final Function(Position) onEdit;
  final Function(Position) onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final positionState = ref.watch(positionNotifierProvider);
    final hasPaginationData = positionState.totalPages > 0 || positions.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.dashboardCard,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isLoading)
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
              itemCount: 3,
              separatorBuilder: (_, _) => Gap(10.h),
              itemBuilder: (context, index) => Skeletonizer(
                enabled: true,
                child: _PositionCard(
                  position: Position.empty(),
                  isDark: isDark,
                  onView: onView,
                  onEdit: onEdit,
                  onDelete: onDelete,
                ),
              ),
            )
          else if (positions.isEmpty && !isLoading)
            MobileStateCard(
              isDark: isDark,
              borderColor: isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder,
              iconBackground: isDark ? AppColors.primary.withValues(alpha: 0.18) : AppColors.infoBg,
              icon: Icon(Icons.work_outline, size: 32, color: AppColors.primary),
              title: 'No Positions',
              subtitle: 'No positions available at this time',
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
              itemCount: positions.length,
              separatorBuilder: (_, _) => Gap(10.h),
              itemBuilder: (context, index) => _PositionCard(
                position: positions[index],
                isDark: isDark,
                onView: onView,
                onEdit: onEdit,
                onDelete: onDelete,
              ),
            ),
          if (hasPaginationData) ...[
            const DigifyDivider.horizontal(),
            MobilePaginationControls(
              isDark: isDark,
              currentPage: positionState.currentPage,
              totalPages: positionState.totalPages,
              hasPrevious: positionState.hasPreviousPage,
              hasNext: positionState.hasNextPage,
              onPrevious: positionState.hasPreviousPage && !isLoading
                  ? () => ref.read(positionNotifierProvider.notifier).goToPage(positionState.currentPage - 1)
                  : null,
              onNext: positionState.hasNextPage && !isLoading
                  ? () => ref.read(positionNotifierProvider.notifier).goToPage(positionState.currentPage + 1)
                  : null,
            ),
          ],
        ],
      ),
    );
  }
}

class _PositionCard extends ConsumerWidget with PositionsPermissionMixin {
  const _PositionCard({
    required this.position,
    required this.isDark,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  final Position position;
  final bool isDark;
  final Function(Position) onView;
  final Function(Position) onEdit;
  final Function(Position) onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deletingId = ref.watch(
      positionNotifierProvider.select((_) => ref.read(positionNotifierProvider.notifier).deletingPositionId),
    );
    final isDeleting = deletingId == position.id;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                position.titleEnglish,
                style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Spacer(),
              DigifyStatusCapsule(status: position.status),
            ],
          ),
          Gap(4.h),
          Text(position.code, style: context.textTheme.bodySmall?.copyWith(color: textSecondary)),
          Gap(10.h),
          const DigifyDivider.thin(),
          Gap(10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (canViewPosition)
                AppMobileButton.primary(svgPath: Assets.icons.viewIconBlue.path, onPressed: () => onView(position)),
              if (canUpdatePosition) ...[
                Gap(8.w),
                AppMobileButton(
                  svgPath: Assets.icons.editIconGreen.path,
                  backgroundColor: AppColors.editIconGreen,
                  type: AppButtonType.secondary,
                  onPressed: () => onEdit(position),
                ),
              ],
              if (canDeletePosition) ...[
                Gap(8.w),
                AppMobileButton.danger(
                  svgPath: Assets.icons.deleteIconRed.path,
                  onPressed: isDeleting ? null : () => onDelete(position),
                  isLoading: isDeleting,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
