import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/navigation/sidebar/sidebar_provider.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SidebarHeader extends ConsumerWidget {
  const SidebarHeader({super.key, required this.isExpanded});

  final bool isExpanded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: isExpanded ? null : () => ref.read(sidebarProvider.notifier).expand(),
      child: Container(
        height: 56.h,
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.cardBorder)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: isExpanded
                    ? Align(
                        alignment: Alignment.centerLeft,
                        key: const ValueKey('full-logo'),
                        child: DigifyAsset(assetPath: Assets.logo.digifyLogo.path, height: 25.h),
                      )
                    : Align(
                        alignment: Alignment.center,
                        key: const ValueKey('condensed-placeholder'),
                        child: Icon(Icons.menu, size: 24.sp, color: AppColors.lightDark),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
