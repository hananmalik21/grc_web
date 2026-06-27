import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/theme_extensions.dart';
import '../../../../../../core/widgets/assets/digify_asset.dart';
import '../../../../../../core/widgets/common/digify_checkbox.dart';
import '../../../../../../core/widgets/common/section_header_card.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../../providers/create_new_component_provider.dart';
import 'component_creation_shared.dart';

class AdvancedSettingsStep extends ConsumerWidget {
  const AdvancedSettingsStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final state = ref.watch(createNewComponentProvider);
    final notifier = ref.read(createNewComponentProvider.notifier);

    return ComponentCreationPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeaderCard(
            icon: DigifyAsset(
              assetPath: Assets.icons.manageEnterpriseIcon.path,
              width: 17.sp,
              height: 17.sp,
              color: AppColors.primary,
            ),
            title: 'Component Attributes',
            subtitle: 'Configure tax treatment, CTC inclusion, and other special attributes',
          ),
          Gap(24.h),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 700;
              final crossAxisCount = isWide ? 2 : 1;

              // Matches the Figma card height (101px) on wide layouts.
              final cardHeight = isWide ? 101.h : 124.h;

              final items = <_AttributeItem>[
                _AttributeItem(
                  title: 'Pro-Rated Component',
                  description:
                      "Component value is proportionally adjusted based on employee's working days in the month",
                  value: state.isProRated,
                  onChanged: (val) => notifier.setIsProRated(val),
                ),
                _AttributeItem(
                  title: 'Taxable Component',
                  description: 'Component is subject to income tax withholding and included in taxable income',
                  value: state.isTaxable,
                  onChanged: (val) => notifier.setIsTaxable(val),
                ),
                _AttributeItem(
                  title: 'Include in CTC',
                  description: 'Component is included in Cost to Company calculations and reporting',
                  value: state.includeInCtc,
                  onChanged: (val) => notifier.setIncludeInCtc(val),
                ),
                _AttributeItem(
                  title: 'Pensionable Component',
                  description: 'Component is included in pension/provident fund calculations',
                  value: state.isPensionable,
                  onChanged: (val) => notifier.setIsPensionable(val),
                ),
                _AttributeItem(
                  title: 'Statutory Component',
                  description: 'Component is mandated by law and must be provided to all eligible employees',
                  value: state.isStatutory,
                  onChanged: (val) => notifier.setIsStatutory(val),
                ),
                _AttributeItem(
                  title: 'Recurring Component',
                  description: 'Component is paid every month automatically',
                  value: state.isRecurring,
                  onChanged: (val) => notifier.setIsRecurring(val),
                ),
                _AttributeItem(
                  title: 'Optional Component',
                  description: 'Component can be opted out by employee or not applied in certain cases',
                  value: state.isOptional,
                  onChanged: (val) => notifier.setIsOptional(val),
                ),
                _AttributeItem(
                  title: 'Amortizable Component',
                  description:
                      'Component cost is spread over multiple periods rather than recognized in a single period',
                  value: state.isAmortizable,
                  onChanged: (val) => notifier.setIsAmortizable(val),
                ),
              ];

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisExtent: cardHeight,
                  crossAxisSpacing: 24.w,
                  mainAxisSpacing: 20.h,
                ),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return _AttributeCard(
                    title: item.title,
                    description: item.description,
                    value: item.value,
                    onChanged: item.onChanged,
                    isDark: isDark,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AttributeItem {
  final String title;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _AttributeItem({required this.title, required this.description, required this.value, required this.onChanged});
}

class _AttributeCard extends StatelessWidget {
  final String title;
  final String description;
  final bool value;
  final bool isDark;
  final ValueChanged<bool> onChanged;

  const _AttributeCard({
    required this.title,
    required this.description,
    required this.value,
    required this.onChanged,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final titleStyle = context.textTheme.headlineMedium?.copyWith(
      fontSize: 14.sp,
      color: isDark ? context.themeTextPrimary : AppColors.textPrimary,
    );
    final descriptionStyle = context.textTheme.labelSmall?.copyWith(
      fontSize: 12.sp,
      color: isDark ? context.themeTextMuted : AppColors.textSecondary,
    );

    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        padding: EdgeInsets.all(18.w),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardBackgroundDark : Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 2.w),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DigifyCheckbox(value: value, onChanged: (val) => onChanged(val ?? false)),
            Gap(12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title.toUpperCase(), style: titleStyle, maxLines: 1, overflow: TextOverflow.ellipsis),
                  Gap(6.h),
                  Text(description, style: descriptionStyle, maxLines: 2, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
