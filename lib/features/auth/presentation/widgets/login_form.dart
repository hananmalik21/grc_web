import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/utils/input_formatters.dart';
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
    required this.usernameController,
    required this.passwordController,
    required this.enterpriseIdController,
    required this.usernameFocusNode,
    required this.passwordFocusNode,
    required this.enterpriseIdFocusNode,
    required this.isLoading,
    required this.rememberMe,
    required this.onRememberMeChanged,
    required this.onLogin,
    this.onForgotPasswordTap,
  });

  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController enterpriseIdController;
  final FocusNode usernameFocusNode;
  final FocusNode passwordFocusNode;
  final FocusNode enterpriseIdFocusNode;
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
          controller: usernameController,
          focusNode: usernameFocusNode,
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
          textInputAction: TextInputAction.next,
          borderColor: fieldBorder,
          focusedBorderColor: AppColors.authDesktopPrimary,
          prefixIcon: _LoginFieldIcon(assetPath: Assets.icons.auth.lock.path),
          onSubmitted: (_) => enterpriseIdFocusNode.requestFocus(),
        ),
        DigifyTextField(
          controller: enterpriseIdController,
          focusNode: enterpriseIdFocusNode,
          labelText: localizations.loginDesktopEnterpriseCode,
          hintText: localizations.loginDesktopEnterpriseCodeHint,
          isRequired: true,
          keyboardType: FieldFormat.integer,
          textInputAction: TextInputAction.done,
          borderColor: fieldBorder,
          focusedBorderColor: AppColors.authDesktopPrimary,
          inputFormatters: FieldFormat.integerOnly,
          prefixIcon: const _LoginEnterpriseFieldIcon(),
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

class _LoginEnterpriseFieldIcon extends StatelessWidget {
  const _LoginEnterpriseFieldIcon();

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
        assetPath: Assets.icons.basicInfoIcon.path,
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
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
        child: Text(
          label,
          style: context.textTheme.bodyMedium?.copyWith(
            fontSize: 14.sp,
            color: AppColors.authDesktopPrimary,
            height: 20 / 14,
          ),
        ),
      ),
    );
  }
}
