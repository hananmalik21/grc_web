import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:grc/features/payroll/application/person_result_detail/config/person_result_task_detail_messages_types.dart';
import 'package:grc/features/payroll/presentation/widgets/person_result_detail/messages_table/person_result_task_detail_messages_severity_style.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class PersonResultTaskDetailMessageTextCell extends StatelessWidget {
  const PersonResultTaskDetailMessageTextCell({
    required this.messageText,
    required this.severity,
    required this.textColor,
    super.key,
  });

  final String messageText;
  final PersonResultTaskDetailMessageSeverity severity;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.only(top: 5.h),
          child: PersonResultTaskDetailMessageSeverityDot(severity: severity),
        ),
        Gap(10.w),
        Expanded(
          child: Text(
            messageText,
            style: context.textTheme.bodyMedium?.copyWith(fontSize: 13.sp, height: 1.55, color: textColor),
          ),
        ),
      ],
    );
  }
}

class PersonResultTaskDetailMessageSeverityDot extends StatelessWidget {
  const PersonResultTaskDetailMessageSeverityDot({required this.severity, super.key});

  final PersonResultTaskDetailMessageSeverity severity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8.w,
      height: 8.w,
      decoration: BoxDecoration(
        color: personResultTaskDetailMessageSeverityColor(severity),
        borderRadius: BorderRadius.circular(4.r),
      ),
    );
  }
}

class PersonResultTaskDetailMessageSeverityBadge extends StatelessWidget {
  const PersonResultTaskDetailMessageSeverityBadge({required this.severity, super.key});

  final PersonResultTaskDetailMessageSeverity severity;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final label = personResultTaskDetailMessageSeverityLabel(loc, severity);

    return DigifyCapsule(
      label: label,
      backgroundColor: personResultTaskDetailMessageSeverityColor(severity),
      textColor: AppColors.buttonTextLight,
    );
  }
}

class PersonResultTaskDetailMessageDetailsButton extends StatelessWidget {
  const PersonResultTaskDetailMessageDetailsButton({required this.isExpanded, required this.onPressed, super.key});

  final bool isExpanded;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final buttonBg = isDark ? AppColors.grayBgDark : AppColors.grayBg;
    final iconColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    return Material(
      color: buttonBg,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 32.w,
          height: 32.w,
          child: Center(
            child: AnimatedRotation(
              turns: isExpanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 200),
              child: DigifyAsset(
                assetPath: Assets.icons.workforce.chevronDown.path,
                width: 15,
                height: 15,
                color: iconColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PersonResultTaskDetailMessageInfoLine extends StatelessWidget {
  const PersonResultTaskDetailMessageInfoLine({
    required this.label,
    required this.color,
    this.value,
    this.child,
    super.key,
  });

  final String label;
  final Color color;
  final String? value;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100.w,
          child: Text(label, style: context.textTheme.labelSmall?.copyWith(color: color)),
        ),
        Expanded(
          child: child != null
              ? Align(alignment: AlignmentDirectional.centerStart, child: child)
              : Text(value ?? '', style: context.textTheme.bodySmall?.copyWith(color: color)),
        ),
      ],
    );
  }
}
