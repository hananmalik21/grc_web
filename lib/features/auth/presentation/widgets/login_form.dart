import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/digify_checkbox.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.emailFocusNode,
    required this.passwordFocusNode,
    required this.isLoading,
    required this.rememberMe,
    required this.onRememberMeChanged,
    required this.onLogin,
    this.onForgotPasswordTap,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;
  final bool isLoading;
  final bool rememberMe;
  final ValueChanged<bool> onRememberMeChanged;
  final VoidCallback onLogin;
  final VoidCallback? onForgotPasswordTap;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final fieldBorder = isDark ? context.themeBorderGrey : AppColors.authDesktopFieldBorder;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 20.h,
      children: [
        DigifyTextField(
          controller: emailController,
          focusNode: emailFocusNode,
          labelText: localizations.email,
          hintText: localizations.loginDesktopEmailHint,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          borderColor: fieldBorder,
          focusedBorderColor: AppColors.authDesktopPrimary,
          prefixIcon: _LoginFieldIcon(assetPath: Assets.icons.auth.mail.path),
          onSubmitted: (_) => passwordFocusNode.requestFocus(),
        ),
        DigifyTextField(
          controller: passwordController,
          focusNode: passwordFocusNode,
          labelText: localizations.password,
          hintText: localizations.loginDesktopPasswordHint,
          obscureText: true,
          textInputAction: TextInputAction.done,
          borderColor: fieldBorder,
          focusedBorderColor: AppColors.authDesktopPrimary,
          prefixIcon: _LoginFieldIcon(assetPath: Assets.icons.auth.lock.path),
          onSubmitted: (_) => onLogin(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DigifyCheckbox(
              value: rememberMe,
              onChanged: (value) => onRememberMeChanged(value ?? false),
              label: localizations.loginDesktopRememberMe,
            ),
            _LoginTextLink(label: localizations.loginDesktopForgotPassword, onTap: onForgotPasswordTap),
          ],
        ),
        AppButton.primary(
          label: localizations.loginDesktopSignInButton,
          isLoading: isLoading,
          onPressed: isLoading ? null : onLogin,
        ),
      ],
    );
  }
}

class _LoginFieldIcon extends StatelessWidget {
  const _LoginFieldIcon({required this.assetPath});

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    final iconPadding = context.responsiveFine<double>(
      mobile: 12,
      tabletSmall: 13,
      tabletMedium: 14,
      tabletLarge: 15,
      desktop: 16,
    );
    final iconSize = context.responsiveFine<double>(
      mobile: 18,
      tabletSmall: 18.5,
      tabletMedium: 19,
      tabletLarge: 19.5,
      desktop: 20,
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: iconPadding.w),
      child: DigifyAsset(
        assetPath: assetPath,
        width: iconSize.w,
        height: iconSize.h,
        color: AppColors.sidebarTextSecondary,
      ),
    );
  }
}

class _LoginTextLink extends StatelessWidget {
  const _LoginTextLink({required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
        child: Text(
          label,
          style: context.textTheme.labelMedium?.copyWith(
            color: AppColors.authDesktopPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 13.sp,
          ),
        ),
      ),
    );
  }
}
