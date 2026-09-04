import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/features/auth/presentation/providers/auth_provider.dart';

class SidebarUserCard extends ConsumerWidget {
  final bool isExpanded;

  const SidebarUserCard({super.key, required this.isExpanded});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    String userName = authState.userFullName ?? '';
    if (userName.isEmpty) {
      userName = 'M Ikhlaq Ahmed';
    }

    String userRole = authState.userRole ?? '';
    if (userRole.isEmpty) {
      userRole = 'System Administrator';
    }

    final initial = userName.trim().isNotEmpty
        ? userName.trim()[0].toUpperCase()
        : 'A';

    if (!isExpanded) {
      return LayoutBuilder(builder: (context, constraints) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Column(
            children: [
              Tooltip(
                message: '$userName\n$userRole',
                child: CircleAvatar(
                  radius: 15.r,
                  backgroundColor: const Color(0xFF0284C7),
                  child: Text(
                    initial,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      });
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 100) {
          return const SizedBox.shrink();
        }
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 14.r,
                backgroundColor: const Color(0xFF0284C7),
                child: Text(
                  initial,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Gap(8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      userName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: const Color(0xFF0F172A),
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Gap(1.h),
                    Text(
                      userRole,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: const Color(0xFF64748B),
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down,
                size: 16,
                color: Color(0xFF94A3B8),
              ),
            ],
          ),
        );
      },
    );
  }
}
