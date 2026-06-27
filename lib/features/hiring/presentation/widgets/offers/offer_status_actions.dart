import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/app_loading_indicator.dart';
import 'package:grc/core/widgets/common/digify_popup_menu_button.dart';
import 'package:grc/core/widgets/feedback/app_confirmation_dialog.dart';
import 'package:grc/features/hiring/application/offers/controllers/offer_status_controller.dart';
import 'package:grc/features/hiring/domain/models/job_offers/offer_status_code.dart';
import 'package:grc/features/hiring/domain/models/offer.dart';
import 'package:grc/features/hiring/presentation/utils/offer_status_labels.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class OfferStatusActions extends ConsumerWidget {
  const OfferStatusActions({required this.offer, this.expanded = false, super.key});

  final Offer offer;
  final bool expanded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final transitions = OfferStatusCode.availableTransitions(offer.status);
    final isLoading = offer.offerGuid.isNotEmpty ? ref.watch(offerStatusActionLoadingProvider(offer.offerGuid)) : false;

    if (transitions.isEmpty) {
      return const SizedBox.shrink();
    }

    final trigger = _UpdateStatusTrigger(
      label: loc.hiringOffersUpdateStatus,
      isLoading: isLoading,
      isDark: isDark,
      expanded: expanded,
    );

    return DigifyPopupMenuButton(
      constraints: BoxConstraints(minWidth: 200.w, maxWidth: 240.w),
      actions: [
        for (final statusCode in transitions)
          DigifyPopupMenuAction(
            value: statusCode,
            label: offerStatusActionLabel(loc, statusCode),
            icon: _statusMenuIcon(statusCode),
            isDestructive: OfferStatusCode.isDestructive(statusCode),
            onSelected: isLoading ? null : () => _confirmAndChangeStatus(context, ref, statusCode),
          ),
      ],
      child: expanded ? SizedBox(width: double.infinity, child: trigger) : trigger,
    );
  }

  Widget _statusMenuIcon(String statusCode) {
    final color = switch (OfferStatusCode.normalize(statusCode)) {
      OfferStatusCode.approved => AppColors.success,
      OfferStatusCode.withdraw => AppColors.error,
      OfferStatusCode.extend => AppColors.warning,
      _ => AppColors.primary,
    };

    return Container(
      width: 8.r,
      height: 8.r,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Future<void> _confirmAndChangeStatus(BuildContext context, WidgetRef ref, String targetStatusCode) async {
    final loc = AppLocalizations.of(context)!;
    final currentLabel = offerStatusDropdownLabel(loc, offer.status);
    final targetLabel = offerStatusActionLabel(loc, targetStatusCode);
    final isDestructive = OfferStatusCode.isDestructive(targetStatusCode);

    final confirmed = await AppConfirmationDialog.show(
      context,
      title: loc.hiringOffersChangeStatusConfirmTitle,
      message: loc.hiringOffersChangeStatusConfirmMessage(currentLabel, targetLabel),
      itemName: offer.candidateName,
      confirmLabel: targetLabel,
      cancelLabel: loc.cancel,
      type: isDestructive ? ConfirmationType.danger : ConfirmationType.info,
      svgPath: isDestructive ? Assets.icons.redDeleteIcon.path : Assets.icons.editIcon.path,
    );

    if (confirmed != true || !context.mounted) return;

    await ref
        .read(offerStatusControllerProvider)
        .changeStatus(context, offer: offer, targetStatusCode: targetStatusCode);
  }
}

class _UpdateStatusTrigger extends StatelessWidget {
  const _UpdateStatusTrigger({
    required this.label,
    required this.isLoading,
    required this.isDark,
    required this.expanded,
  });

  final String label;
  final bool isLoading;
  final bool isDark;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final borderColor = isDark ? AppColors.cardBorderDark : AppColors.cardBorder;
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;

    return Container(
      height: 40.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isLoading) ...[AppLoadingIndicator(size: 16.r), Gap(8.w)],
          Text(
            label,
            style: context.textTheme.labelLarge?.copyWith(
              color: isLoading ? AppColors.textSecondary : textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          Gap(8.w),
          DigifyAsset(assetPath: Assets.icons.dropdownArrowIcon.path, width: 14.r, height: 14.r, color: textColor),
        ],
      ),
    );
  }
}
