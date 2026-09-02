import 'package:grc/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

import 'login_desktop_left_panel.dart';
import 'login_desktop_right_panel.dart';

class LoginDesktopLayout extends StatelessWidget {
  const LoginDesktopLayout({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.emailFocusNode,
    required this.passwordFocusNode,
    required this.rememberMe,
    required this.onRememberMeChanged,
    required this.onLogin,
    this.onForgotPasswordTap,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;
  final bool rememberMe;
  final ValueChanged<bool> onRememberMeChanged;
  final VoidCallback onLogin;
  final VoidCallback? onForgotPasswordTap;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.authDesktopBackground,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Expanded(child: LoginDesktopLeftPanel()),
          Expanded(
            child: LoginDesktopRightPanel(
              emailController: emailController,
              passwordController: passwordController,
              emailFocusNode: emailFocusNode,
              passwordFocusNode: passwordFocusNode,
              rememberMe: rememberMe,
              onRememberMeChanged: onRememberMeChanged,
              onLogin: onLogin,
              onForgotPasswordTap: onForgotPasswordTap,
            ),
          ),
        ],
      ),
    );
  }
}
