import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/navigation/sidebar/models/sidebar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SidebarMenu extends StatelessWidget {
  const SidebarMenu({
    super.key,
    required this.items,
    required this.isExpanded,
    required this.scrollController,
    required this.itemBuilder,
  });

  final List<SidebarItem> items;
  final bool isExpanded;
  final ScrollController scrollController;
  final Widget Function(BuildContext context, SidebarItem item, int index) itemBuilder;

  @override
  Widget build(BuildContext context) {
    final scrollbarTheme = Theme.of(context).scrollbarTheme.copyWith(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.hovered) || states.contains(WidgetState.dragged)) {
          return AppColors.sidebarCategoryText.withValues(alpha: 0.4);
        }
        return AppColors.sidebarCategoryText.withValues(alpha: 0.15);
      }),
      thickness: WidgetStateProperty.all(3.w),
      radius: Radius.circular(10.r),
      mainAxisMargin: 8.h,
      crossAxisMargin: 3.w,
      minThumbLength: 48.h,
    );

    return Theme(
      data: Theme.of(context).copyWith(scrollbarTheme: scrollbarTheme),
      child: Scrollbar(
        controller: scrollController,
        thumbVisibility: false,
        child: SingleChildScrollView(
          controller: scrollController,
          child: AnimatedPadding(
            duration: const Duration(milliseconds: 400),
            curve: Curves.fastOutSlowIn,
            padding: EdgeInsetsDirectional.symmetric(horizontal: isExpanded ? 16.w : 0, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return Padding(
                  key: ValueKey('menu-item-${item.id}'),
                  padding: EdgeInsetsDirectional.only(bottom: index < items.length - 1 ? 4.h : 0),
                  child: itemBuilder(context, item, index),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
