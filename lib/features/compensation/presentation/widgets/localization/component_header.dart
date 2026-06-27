import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/widgets/buttons/app_button.dart';
import '../../../../../gen/assets.gen.dart';

class ComponentHeader extends ConsumerWidget {
  const ComponentHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Compensation Localization',
          style: context.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            fontSize: 24.sp,
          ),
        ),
        Gap(8.h),
        Text(
          'Configure country-specific salary structures, statutory benefits, allowances, gratuity, severance, and compensation rules',
          style: context.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
            fontSize: 14.sp,
          ),
        ),
        Gap(24.h),
        SizedBox(
          width: double.infinity,
          child: Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            alignment: WrapAlignment.end,
            children: [
              AppButton.outline(
                label: 'Save Draft',
                svgPath: Assets.icons.saveIcon.path,
                onPressed: () {},
              ),
              AppButton.outline(
                label: 'Clone Country Setup',
                svgPath: Assets.icons.copyGray.path,
                onPressed: () {},
              ),
              AppButton.outline(
                label: 'Compare Countries',
                svgPath: Assets.icons.activeStructureIcon.path,
                onPressed: () {},
              ),
              AppButton.outline(
                label: 'Import Template',
                svgPath: Assets.icons.downloadIcon.path,
                onPressed: () {},
              ),
              AppButton.primary(
                label: 'Create Country Rule',
                icon: Icons.add,
                onPressed: () =>
                    context.goNamed('compensation-localization-country-rule'),
              ),
              AppButton.primary(
                label: 'Publish Configuration',
                svgPath: Assets.icons.activateIcon.path,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
