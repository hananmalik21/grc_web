import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/navigation/sidebar/sidebar_provider.dart';
import 'package:grc/core/router/app_routes.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/utils/form_validators.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/auth/presentation/providers/auth_provider.dart';
import 'package:grc/features/auth/presentation/widgets/login_desktop_left_panel.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _orgNameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _countryController = TextEditingController();
  final _industryController = TextEditingController();

  final _orgNameFocusNode = FocusNode();
  final _firstNameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _orgNameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _countryController.dispose();
    _industryController.dispose();

    _orgNameFocusNode.dispose();
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    final orgName = _orgNameController.text.trim();
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    final country = _countryController.text.trim();
    final industry = _industryController.text.trim();

    if (orgName.isEmpty) {
      _orgNameFocusNode.requestFocus();
      ToastService.error(context, 'Organization name is required', title: 'Registration Error');
      return;
    }

    if (firstName.isEmpty) {
      _firstNameFocusNode.requestFocus();
      ToastService.error(context, 'First name is required', title: 'Registration Error');
      return;
    }

    if (lastName.isEmpty) {
      _lastNameFocusNode.requestFocus();
      ToastService.error(context, 'Last name is required', title: 'Registration Error');
      return;
    }

    final emailValidation = FormValidators.combine(email, [
      (v) => FormValidators.required(v, errorMessage: 'Email address is required'),
      (v) => FormValidators.email(v, errorMessage: 'Invalid email address'),
    ]);
    if (emailValidation != null) {
      _emailFocusNode.requestFocus();
      ToastService.error(context, emailValidation, title: 'Registration Error');
      return;
    }

    final passwordValidation = FormValidators.combine(password, [
      (v) => FormValidators.required(v, errorMessage: 'Password is required'),
      (v) => FormValidators.minLength(v, 8, errorMessage: 'Password must be at least 8 characters'),
    ]);
    if (passwordValidation != null) {
      _passwordFocusNode.requestFocus();
      ToastService.error(context, passwordValidation, title: 'Registration Error');
      return;
    }

    if (password != confirmPassword) {
      _confirmPasswordFocusNode.requestFocus();
      ToastService.error(context, 'Passwords do not match', title: 'Registration Error');
      return;
    }

    await ref.read(authProvider.notifier).registerTenant(
          orgName: orgName,
          email: email,
          password: password,
          firstName: firstName,
          lastName: lastName,
          country: country.isNotEmpty ? country : null,
          industry: industry.isNotEmpty ? industry : null,
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    ref.listen<AuthState>(authProvider, (prev, next) {
      final feedback = next.pendingLoginFeedback;
      if (feedback != null) {
        ref.read(authProvider.notifier).clearPendingLoginFeedback();
        if (feedback.success) {
          ToastService.success(context, 'Tenant registered successfully!');
          ref.read(sidebarProvider.notifier).collapse();
          context.go(AppRoutes.dashboard);
        } else {
          final message = feedback.errorMessage?.trim() ?? 'Registration failed. Please try again.';
          ToastService.error(context, message, title: 'Registration Failed');
        }
        return;
      }
      if (next.isAuthenticated && !next.isRestoring) {
        ref.read(sidebarProvider.notifier).collapse();
        context.go(AppRoutes.dashboard);
      }
    });

    final isDark = context.isDark;

    return Scaffold(
      backgroundColor: AppColors.authDesktopBackground,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 1000;

          if (isDesktop) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Expanded(child: LoginDesktopLeftPanel()),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 48.w, vertical: 32.h),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 520.w),
                        child: _buildFormCard(context, isDark, authState.isLoading),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          return Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.r),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 480.w),
                child: _buildFormCard(context, isDark, authState.isLoading),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFormCard(BuildContext context, bool isDark, bool isLoading) {
    final fieldBorder = isDark ? context.themeBorderGrey : AppColors.authDesktopFieldBorder;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Register Organization',
          style: context.textTheme.displaySmall?.copyWith(
            color: isDark ? context.themeTextPrimary : AppColors.authDesktopSignInTitle,
            fontSize: 32.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        Gap(8.h),
        Text(
          'Create a new tenant organization and initial administrator account.',
          style: context.textTheme.bodyLarge?.copyWith(
            color: isDark ? context.themeTextSecondary : AppColors.authDesktopSignInSubtitle,
            fontSize: 14.sp,
          ),
        ),
        Gap(24.h),

        // Organization Name
        DigifyTextField(
          controller: _orgNameController,
          focusNode: _orgNameFocusNode,
          labelText: 'Organization Name *',
          hintText: 'e.g. Acme Global Security',
          prefixIcon: const Icon(Icons.business_outlined, size: 20, color: AppColors.textPlaceholderDark),
          textInputAction: TextInputAction.next,
          borderColor: fieldBorder,
          focusedBorderColor: AppColors.authDesktopPrimary,
        ),
        Gap(14.h),

        // First & Last Name
        Row(
          children: [
            Expanded(
              child: DigifyTextField(
                controller: _firstNameController,
                focusNode: _firstNameFocusNode,
                labelText: 'First Name *',
                hintText: 'e.g. Alice',
                prefixIcon: const Icon(Icons.person_outline, size: 20, color: AppColors.textPlaceholderDark),
                textInputAction: TextInputAction.next,
                borderColor: fieldBorder,
                focusedBorderColor: AppColors.authDesktopPrimary,
              ),
            ),
            Gap(12.w),
            Expanded(
              child: DigifyTextField(
                controller: _lastNameController,
                focusNode: _lastNameFocusNode,
                labelText: 'Last Name *',
                hintText: 'e.g. Smith',
                prefixIcon: const Icon(Icons.person_outline, size: 20, color: AppColors.textPlaceholderDark),
                textInputAction: TextInputAction.next,
                borderColor: fieldBorder,
                focusedBorderColor: AppColors.authDesktopPrimary,
              ),
            ),
          ],
        ),
        Gap(14.h),

        // Email
        DigifyTextField(
          controller: _emailController,
          focusNode: _emailFocusNode,
          labelText: 'Administrator Email *',
          hintText: 'admin@acme.com',
          prefixIcon: const Icon(Icons.email_outlined, size: 20, color: AppColors.textPlaceholderDark),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          borderColor: fieldBorder,
          focusedBorderColor: AppColors.authDesktopPrimary,
        ),
        Gap(14.h),

        // Password & Confirm Password
        Row(
          children: [
            Expanded(
              child: DigifyTextField(
                controller: _passwordController,
                focusNode: _passwordFocusNode,
                labelText: 'Password (min 8 chars) *',
                hintText: '••••••••',
                obscureText: _obscurePassword,
                prefixIcon: const Icon(Icons.lock_outline, size: 20, color: AppColors.textPlaceholderDark),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    size: 18,
                    color: AppColors.textPlaceholderDark,
                  ),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
                textInputAction: TextInputAction.next,
                borderColor: fieldBorder,
                focusedBorderColor: AppColors.authDesktopPrimary,
              ),
            ),
            Gap(12.w),
            Expanded(
              child: DigifyTextField(
                controller: _confirmPasswordController,
                focusNode: _confirmPasswordFocusNode,
                labelText: 'Confirm Password *',
                hintText: '••••••••',
                obscureText: _obscureConfirmPassword,
                prefixIcon: const Icon(Icons.lock_outline, size: 20, color: AppColors.textPlaceholderDark),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                    size: 18,
                    color: AppColors.textPlaceholderDark,
                  ),
                  onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                ),
                textInputAction: TextInputAction.next,
                borderColor: fieldBorder,
                focusedBorderColor: AppColors.authDesktopPrimary,
              ),
            ),
          ],
        ),
        Gap(14.h),

        // Country & Industry
        Row(
          children: [
            Expanded(
              child: DigifyTextField(
                controller: _countryController,
                labelText: 'Country (Optional)',
                hintText: 'e.g. United States',
                prefixIcon: const Icon(Icons.public_outlined, size: 20, color: AppColors.textPlaceholderDark),
                textInputAction: TextInputAction.next,
                borderColor: fieldBorder,
                focusedBorderColor: AppColors.authDesktopPrimary,
              ),
            ),
            Gap(12.w),
            Expanded(
              child: DigifyTextField(
                controller: _industryController,
                labelText: 'Industry (Optional)',
                hintText: 'e.g. Financial Services',
                prefixIcon: const Icon(Icons.category_outlined, size: 20, color: AppColors.textPlaceholderDark),
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _handleRegister(),
                borderColor: fieldBorder,
                focusedBorderColor: AppColors.authDesktopPrimary,
              ),
            ),
          ],
        ),
        Gap(24.h),

        // Submit button
        AppButton(
          label: 'Register & Launch GRC',
          isLoading: isLoading,
          onPressed: _handleRegister,
        ),
        Gap(16.h),

        // Link back to Login
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Already have an account? ',
              style: TextStyle(
                color: isDark ? context.themeTextSecondary : AppColors.authDesktopSignInSubtitle,
                fontSize: 13.sp,
              ),
            ),
            InkWell(
              onTap: () => context.go(AppRoutes.login),
              child: Text(
                'Sign In',
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
