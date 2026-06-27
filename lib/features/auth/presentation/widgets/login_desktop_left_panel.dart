import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/auth/presentation/widgets/login_welcome_hero.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginDesktopLeftPanel extends StatelessWidget {
  const LoginDesktopLeftPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return ColoredBox(
      color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
      child: Padding(
        padding: EdgeInsets.all(48.r),
        child: Column(
          children: [Expanded(child: LoginWelcomeHero(gapAfterLogo: 50.h, expandPreview: true))],
        ),
      ),
    );
  }
}
