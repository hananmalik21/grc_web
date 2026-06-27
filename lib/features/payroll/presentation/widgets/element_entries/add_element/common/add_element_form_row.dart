import 'package:grc/core/services/responsive_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AddElementFormRow extends StatelessWidget {
  const AddElementFormRow({required this.children, this.columns, super.key});

  final List<Widget> children;
  final int? columns;

  @override
  Widget build(BuildContext context) {
    if (context.screenLayout.isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < children.length; i++) ...[if (i > 0) Gap(16.h), children[i]],
        ],
      );
    }

    final slotCount = columns ?? children.length;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < slotCount; i++) ...[
          if (i > 0) Gap(16.w),
          Expanded(child: i < children.length ? children[i] : const SizedBox.shrink()),
        ],
      ],
    );
  }
}
