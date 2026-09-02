import 'package:go_router/go_router.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/router/app_routes.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/features/auth/presentation/providers/auth_provider.dart';
import 'package:grc/features/auth/presentation/widgets/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LoginDesktopCard extends ConsumerWidget {
  const LoginDesktopCard({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.emailFocusNode,
    required this.passwordFocusNode,
    required this.rememberMe,
    required this.onRememberMeChanged,
    required this.onLogin,
    this.onForgotPasswordTap,
    this.onSsoTap,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;
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
    final titleColor = isDark
        ? context.themeTextPrimary
        : AppColors.authDesktopSignInTitle;
    final subtitleColor = isDark
        ? context.themeTextSecondary
        : AppColors.authDesktopSignInSubtitle;
    final dividerColor = isDark
        ? context.themeBorderGrey
        : AppColors.authDesktopSignInDivider;
    final dividerLabelColor = isDark
        ? context.themeTextMuted
        : AppColors.authDesktopSignInDividerLabel;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          localizations.loginDesktopSignInTitle,
          style: context.textTheme.displaySmall?.copyWith(
            color: titleColor,
            fontSize: 40.sp,
          ),
        ),
        Gap(12.h),
        Text(
          localizations.loginDesktopSignInSubtitle,
          style: context.textTheme.bodyLarge?.copyWith(
            color: subtitleColor,
            fontSize: 18.sp,
          ),
        ),
        Gap(32.h),
        LoginForm(
          emailController: emailController,
          passwordController: passwordController,
          emailFocusNode: emailFocusNode,
          passwordFocusNode: passwordFocusNode,
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
          backgroundColor: isDark
              ? context.themeCardBackground
              : AppColors.authDesktopBackground,
        ),
        Gap(20.h),
        AppButton.outline(
          label: localizations.loginDesktopContinueWithSso,
          onPressed: onSsoTap,
        ),
        Gap(16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't have an organization account? ",
              style: TextStyle(
                color: subtitleColor,
                fontSize: 13.sp,
              ),
            ),
            InkWell(
              onTap: () => context.go(AppRoutes.register),
              child: Text(
                'Register Now',
                style: TextStyle(
                  color: AppColors.dashCyberSecurity,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ],
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
          child: Text(
            label,
            style: context.textTheme.bodyMedium?.copyWith(color: labelColor),
          ),
        ),
      ],
    );
  }
}
