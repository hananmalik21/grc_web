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
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        // On very wide monitors (e.g. 23+ inches), right panel takes ~32-35%.
        // On 14/15 inch laptops (960 - 1440px), right panel takes ~40-45% so form is never cramped.
        final rightWidth = totalWidth >= 1600
            ? (totalWidth * 0.32).clamp(440.0, 540.0)
            : totalWidth >= 1280
                ? (totalWidth * 0.38).clamp(420.0, 500.0)
                : (totalWidth * 0.44).clamp(390.0, 460.0);

        return ColoredBox(
          color: Colors.white,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left Hero Banner
              const Expanded(
                child: LoginDesktopLeftPanel(),
              ),
              // Right Login Form Panel
              SizedBox(
                width: rightWidth,
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
      },
    );
  }
}
