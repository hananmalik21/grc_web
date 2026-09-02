import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/features/auth/presentation/providers/auth_provider.dart';
import 'package:grc/features/auth/presentation/widgets/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LoginCard extends ConsumerWidget {
  const LoginCard({
    super.key,
    required this.maxWidth,
    required this.usernameController,
    required this.passwordController,
    required this.enterpriseIdController,
    required this.usernameFocusNode,
    required this.passwordFocusNode,
    required this.enterpriseIdFocusNode,
    required this.rememberMe,
    required this.onRememberMeChanged,
    required this.onLogin,
    this.onForgotPasswordTap,
    this.onSsoTap,
  });

  final double maxWidth;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController enterpriseIdController;
  final FocusNode usernameFocusNode;
  final FocusNode passwordFocusNode;
  final FocusNode enterpriseIdFocusNode;
  final bool rememberMe;
  final ValueChanged<bool> onRememberMeChanged;
  final VoidCallback onLogin;
  final VoidCallback? onForgotPasswordTap;
  final VoidCallback? onSsoTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final authState = ref.watch(authProvider);
    final isDark = context.isDark;
    final cardColor = isDark ? context.themeCardBackground : Colors.white;
    final titleColor = isDark ? context.themeTextPrimary : AppColors.authDesktopTitle;
    final subtitleColor = isDark ? context.themeTextSecondary : AppColors.authDesktopBody;
    final dividerColor = isDark ? context.themeBorderGrey : AppColors.authDesktopFieldBorder;
    final dividerLabelColor = isDark ? context.themeTextMuted : AppColors.authDesktopMuted;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(32.r),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: isDark ? null : AppShadows.primaryShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                localizations.loginDesktopSignInTitle,
                style: context.textTheme.displaySmall?.copyWith(color: titleColor),
              ),
              Gap(8.h),
              Text(
                localizations.loginDesktopSignInSubtitle,
                style: context.textTheme.bodyMedium?.copyWith(color: subtitleColor),
              ),
              Gap(20.h),
              LoginForm(
                usernameController: usernameController,
                passwordController: passwordController,
                enterpriseIdController: enterpriseIdController,
                usernameFocusNode: usernameFocusNode,
                passwordFocusNode: passwordFocusNode,
                enterpriseIdFocusNode: enterpriseIdFocusNode,
                isLoading: authState.isLoading,
                rememberMe: rememberMe,
                onRememberMeChanged: onRememberMeChanged,
                onLogin: onLogin,
                onForgotPasswordTap: onForgotPasswordTap,
              ),
              Gap(20.h),
              _SsoDivider(
                label: localizations.loginDesktopOrSignInWithSso,
                lineColor: dividerColor,
                labelColor: dividerLabelColor,
                backgroundColor: cardColor,
              ),
              Gap(20.h),
              AppButton.outline(label: localizations.loginDesktopContinueWithSso, onPressed: onSsoTap),
              Gap(20.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _SsoDivider extends StatelessWidget {
  const _SsoDivider({
    required this.label,
    required this.lineColor,
    required this.labelColor,
    required this.backgroundColor,
  });

  final String label;
  final Color lineColor;
  final Color labelColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        DigifyDivider(color: lineColor, height: 1, thickness: 1),
        Container(
          color: backgroundColor,
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Text(label, style: context.textTheme.bodyMedium?.copyWith(color: labelColor)),
        ),
      ],
    );
  }
}
