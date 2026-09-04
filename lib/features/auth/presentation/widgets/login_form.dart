import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/widgets/common/digify_checkbox.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';

class LoginForm extends StatefulWidget {
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

  static const Color skyBlue = Color(0xFF00B4D8);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Username / Email Label
        Text(
          'USERNAME',
          style: TextStyle(
            color: const Color(0xFF475569),
            fontSize: 11.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        Gap(6.h),
        DigifyTextField(
          controller: widget.emailController,
          focusNode: widget.emailFocusNode,
          hintText: localizations.loginDesktopEmailHint,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          fillColor: const Color(0xFFF0F4F8),
          filled: true,
          borderColor: const Color(0xFFE2E8F0),
          focusedBorderColor: LoginForm.skyBlue,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          onSubmitted: (_) => widget.passwordFocusNode.requestFocus(),
        ),
        Gap(18.h),

        // Password Label
        Text(
          'PASSWORD',
          style: TextStyle(
            color: const Color(0xFF475569),
            fontSize: 11.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        Gap(6.h),
        DigifyTextField(
          controller: widget.passwordController,
          focusNode: widget.passwordFocusNode,
          hintText: localizations.loginDesktopPasswordHint,
          obscureText: _obscurePassword,
          textInputAction: TextInputAction.done,
          fillColor: const Color(0xFFF0F4F8),
          filled: true,
          borderColor: const Color(0xFFE2E8F0),
          focusedBorderColor: LoginForm.skyBlue,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              size: 20,
              color: const Color(0xFF94A3B8),
            ),
            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
          ),
          onSubmitted: (_) => widget.onLogin(),
        ),
        Gap(16.h),

        // Remember Me & Forgot Password
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 340) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DigifyCheckbox(
                    value: widget.rememberMe,
                    onChanged: (value) => widget.onRememberMeChanged(value ?? false),
                    label: localizations.loginDesktopRememberMe,
                  ),
                  Gap(8.h),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: widget.onForgotPasswordTap,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.h),
                        child: Text(
                          localizations.loginDesktopForgotPassword,
                          style: TextStyle(
                            color: LoginForm.skyBlue,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: DigifyCheckbox(
                    value: widget.rememberMe,
                    onChanged: (value) => widget.onRememberMeChanged(value ?? false),
                    label: localizations.loginDesktopRememberMe,
                  ),
                ),
                Gap(8.w),
                InkWell(
                  onTap: widget.onForgotPasswordTap,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: Text(
                      localizations.loginDesktopForgotPassword,
                      style: TextStyle(
                        color: LoginForm.skyBlue,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        Gap(24.h),

        // Sign In Button (Sky Blue)
        SizedBox(
          height: 48.h,
          child: ElevatedButton(
            onPressed: widget.isLoading ? null : widget.onLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: LoginForm.skyBlue,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: widget.isLoading
                ? SizedBox(
                    width: 20.r,
                    height: 20.r,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Sign in',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Gap(6.w),
                        Icon(Icons.arrow_forward_rounded, size: 18.sp),
                      ],
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
