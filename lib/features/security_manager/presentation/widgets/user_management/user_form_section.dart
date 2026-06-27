import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';

class UserFormSection extends StatelessWidget {
  final Widget header;
  final Widget child;
  final bool isDark;

  const UserFormSection({super.key, required this.header, required this.child, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(10.r), topRight: Radius.circular(10.r)),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header,
          Padding(padding: EdgeInsets.all(16.w), child: child),
        ],
      ),
    );
  }
}
