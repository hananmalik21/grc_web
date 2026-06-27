import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginDesktopLeftPanel extends StatelessWidget {
  const LoginDesktopLeftPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.r),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: Assets.icons.auth.leftBanner.image(
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}
