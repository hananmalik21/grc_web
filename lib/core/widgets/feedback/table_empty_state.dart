import 'package:grc/core/widgets/feedback/empty_state_widget.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TableEmptyState extends StatelessWidget {
  final String title;
  final String? message;
  final String? iconPath;
  final double? height;
  final double? width;

  const TableEmptyState({super.key, required this.title, this.message, this.iconPath, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 400.h,
      child: EmptyStateWidget(iconPath: iconPath ?? Assets.icons.employeeListIcon.path, title: title, message: message),
    );
  }
}
