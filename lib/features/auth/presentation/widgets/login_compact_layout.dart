import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/features/auth/presentation/widgets/login_card.dart';
import 'package:grc/features/auth/presentation/widgets/login_compact_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginCompactLayout extends ConsumerWidget {
  const LoginCompactLayout({
    super.key,
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
                  usernameController: usernameController,
                  passwordController: passwordController,
                  enterpriseIdController: enterpriseIdController,
                  usernameFocusNode: usernameFocusNode,
                  passwordFocusNode: passwordFocusNode,
                  enterpriseIdFocusNode: enterpriseIdFocusNode,
                  rememberMe: rememberMe,
                  onRememberMeChanged: onRememberMeChanged,
                  onLogin: onLogin,
                  onForgotPasswordTap: onForgotPasswordTap,
                  onSsoTap: onSsoTap,
                )
              : _StackedBody(
                  cardMaxWidth: _cardMaxWidth(context, ref),
                  usernameController: usernameController,
                  passwordController: passwordController,
                  enterpriseIdController: enterpriseIdController,
                  usernameFocusNode: usernameFocusNode,
                  passwordFocusNode: passwordFocusNode,
                  enterpriseIdFocusNode: enterpriseIdFocusNode,
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

  EdgeInsetsDirectional _logoPadding(BuildContext context, WidgetRef ref) {
    return context.responsiveFine(
      mobile: EdgeInsetsDirectional.fromSTEB(20.w, 16.h, 20.w, 0),
      tabletSmall: EdgeInsetsDirectional.fromSTEB(32.w, 20.h, 32.w, 0),
      tabletMedium: EdgeInsetsDirectional.fromSTEB(40.w, 24.h, 40.w, 0),
      tabletLarge: EdgeInsetsDirectional.fromSTEB(40.w, 24.h, 40.w, 0),
      desktop: EdgeInsetsDirectional.zero,
    );
  }

  double _cardMaxWidth(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.sizeOf(context).width;
    return ref.responsiveFine(
      mobile: (width - 32.w).clamp(280.0, 420.0),
      tabletSmall: 480.0,
      tabletMedium: 440.0,
      tabletLarge: 440.0,
      desktop: 440.0,
    );
  }
}

class _StackedBody extends ConsumerWidget {
  const _StackedBody({
    required this.cardMaxWidth,
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

  final double cardMaxWidth;
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
          usernameController: usernameController,
          passwordController: passwordController,
          enterpriseIdController: enterpriseIdController,
          usernameFocusNode: usernameFocusNode,
          passwordFocusNode: passwordFocusNode,
          enterpriseIdFocusNode: enterpriseIdFocusNode,
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

class _TabletWideBody extends StatelessWidget {
  const _TabletWideBody({
    required this.cardMaxWidth,
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

  final double cardMaxWidth;
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
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsetsDirectional.fromSTEB(40.w, 8.h, 40.w, 32.h),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 480.w),
          child: LoginCard(
            maxWidth: cardMaxWidth,
            usernameController: usernameController,
            passwordController: passwordController,
            enterpriseIdController: enterpriseIdController,
            usernameFocusNode: usernameFocusNode,
            passwordFocusNode: passwordFocusNode,
            enterpriseIdFocusNode: enterpriseIdFocusNode,
            rememberMe: rememberMe,
            onRememberMeChanged: onRememberMeChanged,
            onLogin: onLogin,
            onForgotPasswordTap: onForgotPasswordTap,
            onSsoTap: onSsoTap,
          ),
        ),
      ),
    );
  }
}
