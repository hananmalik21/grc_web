import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:grc/core/permissions/permission_service.dart';
import 'package:grc/core/router/app_routes.dart';
import 'package:grc/features/auth/presentation/providers/auth_provider.dart';

class SidebarFooter extends ConsumerWidget {
  const SidebarFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
          ),
        ),
      ),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () async {
            await ref.read(authProvider.notifier).logout();
            PermissionService.instance.clear();
            if (context.mounted) {
              context.go(AppRoutes.login);
            }
          },
          child: Row(
            children: [
              Icon(
                Icons.logout_rounded,
                size: 20.sp,
                color: const Color(0xFFEF4444),
              ),
              SizedBox(width: 12.w),
              Text(
                'Logout',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFFEF4444),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
