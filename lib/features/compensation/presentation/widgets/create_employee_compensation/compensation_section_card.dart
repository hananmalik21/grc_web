import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';

class CompensationSectionCard extends StatelessWidget {
  final String title;
  final String? titleIconPath;
  final Widget child;

  const CompensationSectionCard({super.key, required this.title, required this.child, this.titleIconPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.themeCardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: context.themeCardBorder),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Row(
              children: [
                Text(
                  title,
                  style: context.textTheme.titleSmall?.copyWith(fontSize: 18.sp, color: context.themeTextPrimary),
                ),
              ],
            ),
          ),
          DigifyDivider.horizontal(),
          Padding(padding: EdgeInsets.all(16.w), child: child),
        ],
      ),
    );
  }
}
