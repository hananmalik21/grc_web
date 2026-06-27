import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginCompactLogo extends StatelessWidget {
  const LoginCompactLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return DigifyAsset(assetPath: Assets.logo.digifyLogo.path, width: 28.r, height: 28.r);
  }
}
