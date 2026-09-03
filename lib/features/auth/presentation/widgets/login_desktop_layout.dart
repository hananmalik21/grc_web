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
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 70% Left Hero Banner
          const Expanded(
            flex: 7,
            child: LoginDesktopLeftPanel(),
          ),
          // 30% Right Login Form Panel (Solid Light Mode)
          Expanded(
            flex: 3,
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
