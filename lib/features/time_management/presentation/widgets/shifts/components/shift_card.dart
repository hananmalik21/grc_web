import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/features/time_management/domain/models/shift.dart';
import 'package:grc/features/time_management/presentation/widgets/shifts/components/shift_card_actions.dart';
import 'package:grc/features/time_management/presentation/widgets/shifts/components/shift_card_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShiftCard extends StatelessWidget {
  final ShiftOverview shift;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onCopy;
  final VoidCallback? onDelete;
  final bool isDeleting;

  const ShiftCard({
    super.key,
    required this.shift,
    required this.onView,
    required this.onEdit,
    required this.onCopy,
    this.onDelete,
    this.isDeleting = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final padding = ResponsiveHelper.getCardPadding(context);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ShiftCardContent(shift: shift, isDark: isDark),
          DigifyDivider(
            height: 1,
            color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
            margin: EdgeInsets.symmetric(horizontal: padding),
          ),
          Padding(
            padding: EdgeInsets.all(padding),
            child: ShiftCardActions(
              onView: onView,
              onEdit: onEdit,
              onCopy: onCopy,
              onDelete: onDelete,
              isDeleting: isDeleting,
            ),
          ),
        ],
      ),
    );
  }
}
