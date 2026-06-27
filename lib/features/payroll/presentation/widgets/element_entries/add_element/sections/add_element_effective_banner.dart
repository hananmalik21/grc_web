import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/info_banner_card.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class AddElementEffectiveBanner extends StatelessWidget {
  const AddElementEffectiveBanner({required this.effectiveDate, super.key});

  final DateTime effectiveDate;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final formattedDate = DateFormat('dd MMM yyyy').format(effectiveDate);

    return InfoBannerCard(
      iconAssetPath: Assets.icons.infoCircleBlue.path,
      child: RichText(
        text: TextSpan(
          style: context.textTheme.bodySmall?.copyWith(
            fontSize: 13.sp,
            color: isDark ? AppColors.infoTextDark : AppColors.infoText,
          ),
          children: [
            TextSpan(text: loc.payrollAddElementEffectiveBannerPrefix),
            TextSpan(
              text: formattedDate,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            TextSpan(text: loc.payrollAddElementEffectiveBannerSuffix),
          ],
        ),
      ),
    );
  }
}
