import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../providers/dashboard_provider.dart';

class FloatingEyeIcon extends ConsumerWidget {
  const FloatingEyeIcon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => ref.read(cardsVisibilityProvider.notifier).toggle(),
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
          width: 56.w,
          height: 56.w,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(14.r),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 10)),
              BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, 4)),
            ],
          ),
          child: Center(
            child: DigifyAsset(assetPath: Assets.icons.eyesIcon.path, width: 28, height: 28, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
