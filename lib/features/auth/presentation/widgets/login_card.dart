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

class LoginCard extends ConsumerWidget {
  const LoginCard({
    super.key,
    required this.maxWidth,
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

  final double maxWidth;
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
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Container(
          padding: isMobile
              ? EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h)
              : EdgeInsets.symmetric(horizontal: 24.w, vertical: 28.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
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
              Text(
                localizations.loginDesktopSignInTitle,
                style: TextStyle(
                  color: const Color(0xFF101828),
                  fontSize: isMobile ? 24.sp : 28.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Gap(6.h),
              Text(
                localizations.loginDesktopSignInSubtitle,
                style: TextStyle(
                  color: const Color(0xFF64748B),
                  fontSize: 14.sp,
                ),
              ),
              Gap(24.h),
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

              // Responsive Wrap to prevent overflow on mobile screen width
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                runSpacing: 4.h,
                children: [
                  Text(
                    "Don't have an organization account? ",
                    style: TextStyle(
                      color: const Color(0xFF64748B),
                      fontSize: 12.sp,
                    ),
                  ),
                  InkWell(
                    onTap: () => context.go(AppRoutes.register),
                    child: Text(
                      'Register Now',
                      style: TextStyle(
                        color: skyBlue,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              Gap(20.h),
              Text(
                isMobile ? '© 2026 Enterprise Edition' : '© 2026 GRC Platform • Enterprise Edition',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF94A3B8),
                  fontSize: 11.sp,
                ),
              ),
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
