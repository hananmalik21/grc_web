import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: colorScheme.surfaceContainerHighest,
      ),
      child: Row(
        children: [
          Icon(Icons.verified_user, color: colorScheme.primary),
          SizedBox(width: 12.w),
          Expanded(child: Text(title, style: textTheme.titleMedium)),
        ],
      ),
    );
  }
}

