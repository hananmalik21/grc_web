import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:grc/features/developer_tools/presentation/models/function_item.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class FunctionTile extends StatelessWidget {
  final FunctionItem function;

  const FunctionTile({super.key, required this.function});

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobileLayout;
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 14.w : 18.w, vertical: isMobile ? 12.h : 14.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FunctionIconBox(function: function),
          Gap(isMobile ? 12.w : 16.w),
          Expanded(child: _FunctionInfo(function: function)),
        ],
      ),
    );
  }
}

class _FunctionIconBox extends StatelessWidget {
  final FunctionItem function;

  const _FunctionIconBox({required this.function});

  @override
  Widget build(BuildContext context) {
    final size = context.isMobileLayout ? 38.w : 44.w;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: function.iconBg, borderRadius: BorderRadius.circular(10.r)),
      child: Center(
        child: Assets.icons.developerTools.moduleManagement.svg(
          width: size * 0.52,
          height: size * 0.52,
          colorFilter: ColorFilter.mode(function.iconAccent, BlendMode.srcIn),
        ),
      ),
    );
  }
}

class _FunctionInfo extends StatelessWidget {
  final FunctionItem function;

  const _FunctionInfo({required this.function});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          function.name,
          style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        Gap(3.h),
        Text(
          function.code,
          style: context.textTheme.labelSmall?.copyWith(
            color: AppColors.textTertiary,
            letterSpacing: 0.5,
            fontFamily: 'monospace',
          ),
        ),
        if (function.description != null) ...[
          Gap(4.h),
          Text(
            function.description!,
            style: context.textTheme.bodySmall?.copyWith(color: AppColors.textTertiary, height: 1.4),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        Gap(7.h),
        Wrap(
          spacing: 6.w,
          runSpacing: 4.h,
          children: [
            DigifyCapsule(label: 'Module: ${function.moduleName}'),
            DigifyCapsule(label: 'Type: ${function.functionType}'),
            DigifyCapsule(
              label: 'Permission Key: ${function.permissionKey}',
              backgroundColor: AppColors.infoBg.withValues(alpha: 0.5),
              textColor: AppColors.info,
              borderColor: AppColors.info.withValues(alpha: 0.35),
            ),
          ],
        ),
      ],
    );
  }
}
