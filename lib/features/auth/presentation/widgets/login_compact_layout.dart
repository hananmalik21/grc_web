import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/features/auth/presentation/widgets/login_card.dart';
import 'package:grc/features/auth/presentation/widgets/login_compact_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginCompactLayout extends ConsumerWidget {
  const LoginCompactLayout({
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
    final layout = ref.screenLayout;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: _logoPadding(context, ref),
          child: const Align(alignment: AlignmentDirectional.topStart, child: LoginCompactLogo()),
        ),
        Expanded(
          child: layout.isSideBySide
              ? _TabletWideBody(
                  cardMaxWidth: _cardMaxWidth(context, ref),
                  emailController: emailController,
                  passwordController: passwordController,
                  emailFocusNode: emailFocusNode,
                  passwordFocusNode: passwordFocusNode,
                  rememberMe: rememberMe,
                  onRememberMeChanged: onRememberMeChanged,
                  onLogin: onLogin,
                  onForgotPasswordTap: onForgotPasswordTap,
                  onSsoTap: onSsoTap,
                )
              : _StackedBody(
                  cardMaxWidth: _cardMaxWidth(context, ref),
                  emailController: emailController,
                  passwordController: passwordController,
                  emailFocusNode: emailFocusNode,
                  passwordFocusNode: passwordFocusNode,
                  rememberMe: rememberMe,
                  onRememberMeChanged: onRememberMeChanged,
                  onLogin: onLogin,
                  onForgotPasswordTap: onForgotPasswordTap,
                  onSsoTap: onSsoTap,
                ),
        ),
      ],
    );
  }

  static double _cardMaxWidth(BuildContext context, WidgetRef ref) {
    final layout = ref.screenLayout;
    if (layout.isSideBySide) return 400.w;
    return context.responsiveFine(
      mobile: double.infinity,
      tabletSmall: 420.w,
      tabletMedium: 460.w,
      tabletLarge: 480.w,
      desktop: double.infinity,
    );
  }

  static EdgeInsetsGeometry _logoPadding(BuildContext context, WidgetRef ref) {
    return context.responsiveFine(
      mobile: EdgeInsetsDirectional.only(start: 24.w, top: 16.h, end: 24.w, bottom: 8.h),
      tabletSmall: EdgeInsetsDirectional.only(start: 32.w, top: 24.h, end: 32.w, bottom: 12.h),
      tabletMedium: EdgeInsetsDirectional.only(start: 40.w, top: 28.h, end: 40.w, bottom: 16.h),
      tabletLarge: EdgeInsetsDirectional.only(start: 40.w, top: 28.h, end: 40.w, bottom: 16.h),
      desktop: EdgeInsetsDirectional.only(start: 24.w, top: 16.h, end: 24.w, bottom: 8.h),
    );
  }
}

class _TabletWideBody extends ConsumerWidget {
  const _TabletWideBody({
    required this.cardMaxWidth,
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

  final double cardMaxWidth;
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
    final horizontalPadding = context.responsiveFine(
      mobile: 20.w,
      tabletSmall: 32.w,
      tabletMedium: 40.w,
      tabletLarge: 40.w,
      desktop: 20.w,
    );

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsetsDirectional.fromSTEB(horizontalPadding, 8.h, horizontalPadding, 24.h),
        child: LoginCard(
          maxWidth: cardMaxWidth,
          emailController: emailController,
          passwordController: passwordController,
          emailFocusNode: emailFocusNode,
          passwordFocusNode: passwordFocusNode,
          rememberMe: rememberMe,
          onRememberMeChanged: onRememberMeChanged,
          onLogin: onLogin,
          onForgotPasswordTap: onForgotPasswordTap,
          onSsoTap: onSsoTap,
        ),
      ),
    );
  }
}

class _StackedBody extends ConsumerWidget {
  const _StackedBody({
    required this.cardMaxWidth,
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

  final double cardMaxWidth;
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
    final horizontalPadding = context.responsiveFine(
      mobile: 20.w,
      tabletSmall: 32.w,
      tabletMedium: 40.w,
      tabletLarge: 40.w,
      desktop: 20.w,
    );

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsetsDirectional.fromSTEB(horizontalPadding, 8.h, horizontalPadding, 24.h),
        child: LoginCard(
          maxWidth: cardMaxWidth,
          emailController: emailController,
          passwordController: passwordController,
          emailFocusNode: emailFocusNode,
          passwordFocusNode: passwordFocusNode,
          rememberMe: rememberMe,
          onRememberMeChanged: onRememberMeChanged,
          onLogin: onLogin,
          onForgotPasswordTap: onForgotPasswordTap,
          onSsoTap: onSsoTap,
        ),
      ),
    );
  }
}
