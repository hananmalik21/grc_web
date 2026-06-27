import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/app_shadows.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/widgets/forms/digify_text_field.dart';
import '../../providers/overtime_configuration/overtime_configuration_provider.dart';

class ComponentConfigurationInformation extends ConsumerStatefulWidget {
  const ComponentConfigurationInformation({super.key});

  @override
  ConsumerState<ComponentConfigurationInformation> createState() => _ComponentConfigurationInformationState();
}

class _ComponentConfigurationInformationState extends ConsumerState<ComponentConfigurationInformation> {
  final TextEditingController _configurationNameController = TextEditingController();
  DateTime? _effectiveStartDate;
  DateTime? _effectiveEndDate;

  @override
  Widget build(BuildContext context) {
    final configInformation = ref.watch(overtimeConfigurationProvider.select((state) => state.configInfo));
    final notifier = ref.read(overtimeConfigurationProvider.notifier);

    if (configInformation != null) {
      if (_configurationNameController.text != configInformation.configName) {
        _configurationNameController.text = configInformation.configName;
      }
      _effectiveStartDate = configInformation.effectiveStartDate;
      _effectiveEndDate = configInformation.effectiveEndDate;
    }

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: context.isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: context.isMobile
          ? Column(
              children: [
                DigifyTextField(
                  labelText: 'Configuration Name',
                  hintText: 'e.g. Default Configuration',
                  isRequired: true,
                  controller: _configurationNameController,
                  onChanged: (value) => notifier.updateConfigurationName(value),
                ),
                Gap(16.h),
                DigifyDateField(
                  label: "Effective Start Date",
                  initialDate: _effectiveStartDate,
                  lastDate: DateTime(2050),
                  onDateSelected: (value) => notifier.updateEffectiveStartDate(value),
                ),
                Gap(16.h),
                DigifyDateField(
                  label: "Effective End Date",
                  initialDate: _effectiveEndDate,
                  lastDate: DateTime(2050),
                  onDateSelected: (value) => notifier.updateEffectiveEndDate(value),
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: DigifyTextField(
                    labelText: 'Configuration Name',
                    hintText: 'e.g. Default Configuration',
                    isRequired: true,
                    controller: _configurationNameController,
                    onChanged: (value) => notifier.updateConfigurationName(value),
                  ),
                ),
                Gap(16.w),
                Expanded(
                  child: DigifyDateField(
                    label: "Effective Start Date",
                    initialDate: _effectiveStartDate,
                    lastDate: DateTime(2050),
                    onDateSelected: (value) => notifier.updateEffectiveStartDate(value),
                  ),
                ),
                Gap(16.w),
                Expanded(
                  child: DigifyDateField(
                    label: "Effective End Date",
                    initialDate: _effectiveEndDate,
                    lastDate: DateTime(2050),
                    onDateSelected: (value) => notifier.updateEffectiveEndDate(value),
                  ),
                ),
              ],
            ),
    );
  }
}
