import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/forms/digify_select_field.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class PersonResultTaskDetailToolbar extends StatefulWidget {
  const PersonResultTaskDetailToolbar({super.key});

  @override
  State<PersonResultTaskDetailToolbar> createState() => _PersonResultTaskDetailToolbarState();
}

class _PersonResultTaskDetailToolbarState extends State<PersonResultTaskDetailToolbar> {
  String? _process;
  String? _assignment;
  String? _calculation;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final isMobile = context.screenLayout.isMobile;
    final fillColor = isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground;

    final filters = Wrap(
      spacing: 10.w,
      runSpacing: 10.h,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _FilterSelectField(
          hint: loc.payrollPersonResultsTaskDetailProcess,
          value: _process,
          fillColor: fillColor,
          onChanged: (value) => setState(() => _process = value),
        ),
        _FilterSelectField(
          hint: loc.payrollPersonResultsTaskDetailAssignment,
          value: _assignment,
          fillColor: fillColor,
          onChanged: (value) => setState(() => _assignment = value),
        ),
        _FilterSelectField(
          hint: loc.payrollPersonResultsTaskDetailCalculation,
          value: _calculation,
          fillColor: fillColor,
          onChanged: (value) => setState(() => _calculation = value),
        ),
      ],
    );

    final actions = Wrap(
      spacing: 10.w,
      runSpacing: 10.h,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        AppButton.primary(
          label: loc.payrollPersonResultsDownloadToExcel,
          svgPath: Assets.icons.downloadIcon.path,
          onPressed: () {},
        ),
        AppButton.outline(label: loc.payrollPersonResultsPrint, icon: Icons.print_outlined, onPressed: () {}),
      ],
    );

    return Padding(
      padding: EdgeInsets.only(top: 4.h),
      child: isMobile
          ? Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [filters, Gap(12.h), actions])
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: filters),
                Gap(16.w),
                actions,
              ],
            ),
    );
  }
}

class _FilterSelectField extends StatelessWidget {
  const _FilterSelectField({required this.hint, required this.value, required this.fillColor, required this.onChanged});

  final String hint;
  final String? value;
  final Color fillColor;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150.w,
      child: DigifySelectField<String>(
        hint: hint,
        value: value,
        items: const [],
        itemLabelBuilder: (item) => item,
        onChanged: onChanged,
        fillColor: fillColor,
      ),
    );
  }
}
