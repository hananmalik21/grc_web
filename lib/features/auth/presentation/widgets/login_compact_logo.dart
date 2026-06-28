import 'package:grc/core/widgets/grc_brand_mark.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginCompactLogo extends StatelessWidget {
  const LoginCompactLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return GrcBrandMark(fontSize: 28.sp);
  }
}
