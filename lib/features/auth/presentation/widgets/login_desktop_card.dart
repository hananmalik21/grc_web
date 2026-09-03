import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/router/app_routes.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/features/auth/presentation/providers/auth_provider.dart';
import 'package:grc/features/auth/presentation/widgets/login_form.dart';

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

  static const Color skyBlue = Color(0xFF00B4D8);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final authState = ref.watch(authProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Category / Account Tag
        Text(
          'ACCOUNT',
          style: TextStyle(
            color: const Color(0xFF64748B),
            fontSize: 11.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
          ),
        ),
        Gap(8.h),

        // Title
        Text(
          localizations.loginDesktopSignInTitle, // "Sign in"
          style: TextStyle(
            color: const Color(0xFF101828),
            fontSize: 32.sp,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        Gap(6.h),

        // Subtitle
        Text(
          localizations.loginDesktopSignInSubtitle, // "Use your company credentials to continue."
          style: TextStyle(
            color: const Color(0xFF64748B),
            fontSize: 14.sp,
            height: 1.4,
          ),
        ),
        Gap(28.h),

        // Login Form Inputs
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

        if (onSsoTap != null) ...[
          Gap(20.h),
          _SsoDivider(
            label: localizations.loginDesktopOrSignInWithSso,
            lineColor: const Color(0xFFE2E8F0),
            labelColor: const Color(0xFF64748B),
            backgroundColor: Colors.white,
          ),
          Gap(16.h),
          AppButton.outline(
            label: localizations.loginDesktopContinueWithSso,
            onPressed: onSsoTap,
          ),
        ],

        Gap(20.h),

        // Link to Registration (Responsive Wrap)
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              "Don't have an organization account? ",
              style: TextStyle(
                color: const Color(0xFF64748B),
                fontSize: 13.sp,
              ),
            ),
            InkWell(
              onTap: () => context.go(AppRoutes.register),
              child: Text(
                'Register Now',
                style: TextStyle(
                  color: skyBlue,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),

        Gap(32.h),

        // Copyright Footer
        Text(
          '© 2026 GRC Platform • Enterprise Edition',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xFF94A3B8),
            fontSize: 11.sp,
          ),
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
            style: TextStyle(
              color: labelColor,
              fontSize: 12.sp,
            ),
          ),
        ),
      ],
    );
  }
}
