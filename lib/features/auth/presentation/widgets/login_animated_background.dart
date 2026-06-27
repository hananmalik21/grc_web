import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class LoginAnimatedBackground extends StatelessWidget {
  const LoginAnimatedBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(child: Image.asset(Assets.icons.auth.bg.path, fit: BoxFit.cover, gaplessPlayback: true));
  }
}
