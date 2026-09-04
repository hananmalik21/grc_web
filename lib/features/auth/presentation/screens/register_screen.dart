import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:grc/core/navigation/sidebar/sidebar_provider.dart';
import 'package:grc/core/router/app_routes.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/utils/form_validators.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/auth/presentation/providers/auth_provider.dart';
import 'package:grc/features/auth/presentation/widgets/login_desktop_left_panel.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  static const Color skyBlue = Color(0xFF00B4D8);

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

    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 960;

          if (isDesktop) {
            final totalWidth = constraints.maxWidth;
            final rightWidth = totalWidth >= 1600
                ? (totalWidth * 0.35).clamp(480.0, 560.0)
                : totalWidth >= 1280
                    ? (totalWidth * 0.40).clamp(450.0, 520.0)
                    : (totalWidth * 0.46).clamp(420.0, 480.0);

            return Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Left Hero Banner
                const Expanded(
                  child: LoginDesktopLeftPanel(),
                ),
                // Right Form Container
                SizedBox(
                  width: rightWidth,
                  child: Container(
                    color: Colors.white,
                    child: Center(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 24.h),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 460),
                          child: _buildFormCard(context, authState.isLoading, false),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          // Compact / Mobile View
          return Container(
            color: Colors.white,
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: _buildFormCard(context, authState.isLoading, true),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFormCard(BuildContext context, bool isLoading, bool isMobile) {
    const labelStyle = TextStyle(
      color: Color(0xFF475569),
      fontSize: 11,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.8,
    );

    final buttonText = isMobile ? 'Register' : 'Register Organization';

    Widget buildFieldPair(Widget field1, Widget field2) {
      if (isMobile) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            field1,
            Gap(14.h),
            field2,
          ],
        );
      }
      return Row(
        children: [
          Expanded(child: field1),
          Gap(12.w),
          Expanded(child: field2),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Organization Tag
        Text(
          'ORGANIZATION',
          style: TextStyle(
            color: const Color(0xFF64748B),
            fontSize: 11.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
          ),
        ),
        Gap(8.h),
        Text(
          'Register Organization',
          style: TextStyle(
            color: const Color(0xFF101828),
            fontSize: isMobile ? 22.sp : 26.sp,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        Gap(6.h),
        Text(
          'Create a new tenant organization and initial administrator account.',
          style: TextStyle(
            color: const Color(0xFF64748B),
            fontSize: 14.sp,
            height: 1.4,
          ),
        ),
        Gap(24.h),

        // Organization Name
        const Text('ORGANIZATION NAME *', style: labelStyle),
        Gap(6.h),
        DigifyTextField(
          controller: _orgNameController,
          focusNode: _orgNameFocusNode,
          hintText: 'e.g. Acme Global Security',
          textInputAction: TextInputAction.next,
          fillColor: const Color(0xFFF0F4F8),
          filled: true,
          borderColor: const Color(0xFFE2E8F0),
          focusedBorderColor: RegisterScreen.skyBlue,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        ),
        Gap(14.h),

        // First & Last Name
        buildFieldPair(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('FIRST NAME *', style: labelStyle),
              Gap(6.h),
              DigifyTextField(
                controller: _firstNameController,
                focusNode: _firstNameFocusNode,
                hintText: 'e.g. Alice',
                textInputAction: TextInputAction.next,
                fillColor: const Color(0xFFF0F4F8),
                filled: true,
                borderColor: const Color(0xFFE2E8F0),
                focusedBorderColor: RegisterScreen.skyBlue,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('LAST NAME *', style: labelStyle),
              Gap(6.h),
              DigifyTextField(
                controller: _lastNameController,
                focusNode: _lastNameFocusNode,
                hintText: 'e.g. Smith',
                textInputAction: TextInputAction.next,
                fillColor: const Color(0xFFF0F4F8),
                filled: true,
                borderColor: const Color(0xFFE2E8F0),
                focusedBorderColor: RegisterScreen.skyBlue,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              ),
            ],
          ),
        ),
        Gap(14.h),

        // Email
        const Text('ADMINISTRATOR EMAIL *', style: labelStyle),
        Gap(6.h),
        DigifyTextField(
          controller: _emailController,
          focusNode: _emailFocusNode,
          hintText: 'admin@acme.com',
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          fillColor: const Color(0xFFF0F4F8),
          filled: true,
          borderColor: const Color(0xFFE2E8F0),
          focusedBorderColor: RegisterScreen.skyBlue,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        ),
        Gap(14.h),

        // Password & Confirm Password
        buildFieldPair(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('PASSWORD *', style: labelStyle),
              Gap(6.h),
              DigifyTextField(
                controller: _passwordController,
                focusNode: _passwordFocusNode,
                hintText: '••••••••',
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.next,
                fillColor: const Color(0xFFF0F4F8),
                filled: true,
                borderColor: const Color(0xFFE2E8F0),
                focusedBorderColor: RegisterScreen.skyBlue,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    size: 18,
                    color: const Color(0xFF94A3B8),
                  ),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('CONFIRM PASSWORD *', style: labelStyle),
              Gap(6.h),
              DigifyTextField(
                controller: _confirmPasswordController,
                focusNode: _confirmPasswordFocusNode,
                hintText: '••••••••',
                obscureText: _obscureConfirmPassword,
                textInputAction: TextInputAction.next,
                fillColor: const Color(0xFFF0F4F8),
                filled: true,
                borderColor: const Color(0xFFE2E8F0),
                focusedBorderColor: RegisterScreen.skyBlue,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    size: 18,
                    color: const Color(0xFF94A3B8),
                  ),
                  onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                ),
              ),
            ],
          ),
        ),
        Gap(14.h),

        // Country & Industry
        buildFieldPair(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('COUNTRY (OPTIONAL)', style: labelStyle),
              Gap(6.h),
              DigifyTextField(
                controller: _countryController,
                hintText: 'e.g. United States',
                textInputAction: TextInputAction.next,
                fillColor: const Color(0xFFF0F4F8),
                filled: true,
                borderColor: const Color(0xFFE2E8F0),
                focusedBorderColor: RegisterScreen.skyBlue,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('INDUSTRY (OPTIONAL)', style: labelStyle),
              Gap(6.h),
              DigifyTextField(
                controller: _industryController,
                hintText: 'e.g. Financial Services',
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _handleRegister(),
                fillColor: const Color(0xFFF0F4F8),
                filled: true,
                borderColor: const Color(0xFFE2E8F0),
                focusedBorderColor: RegisterScreen.skyBlue,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              ),
            ],
          ),
        ),
        Gap(24.h),

        // Submit Button (Sky Blue)
        SizedBox(
          height: 48.h,
          child: ElevatedButton(
            onPressed: isLoading ? null : _handleRegister,
            style: ElevatedButton.styleFrom(
              backgroundColor: RegisterScreen.skyBlue,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: isLoading
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
                          buttonText,
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
        Gap(20.h),

        // Link back to Login
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          runSpacing: 4.h,
          children: [
            Text(
              'Already have an account? ',
              style: TextStyle(
                color: const Color(0xFF64748B),
                fontSize: 13.sp,
              ),
            ),
            InkWell(
              onTap: () => context.go(AppRoutes.login),
              child: Text(
                'Sign In',
                style: TextStyle(
                  color: RegisterScreen.skyBlue,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        Gap(24.h),

        // Copyright Footer
        Text(
          isMobile ? '© 2026 Enterprise Edition' : '© 2026 GRC Platform • Enterprise Edition',
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
