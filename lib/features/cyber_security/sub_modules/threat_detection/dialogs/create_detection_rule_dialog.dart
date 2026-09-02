import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';

class CreateDetectionRuleDialog extends StatefulWidget {
  const CreateDetectionRuleDialog({super.key});

  @override
  State<CreateDetectionRuleDialog> createState() =>
      _CreateDetectionRuleDialogState();
}

class _CreateDetectionRuleDialogState extends State<CreateDetectionRuleDialog> {
  final TextEditingController _ruleNameController = TextEditingController();
  final TextEditingController _mitreController = TextEditingController();
  final TextEditingController _queryController = TextEditingController();

  String _severity = 'High';
  String _source = 'Cloud';

  @override
  void dispose() {
    _ruleNameController.dispose();
    _mitreController.dispose();
    _queryController.dispose();
    super.dispose();
  }

  void _handleCreate() {
    if (_ruleNameController.text.trim().isEmpty) {
      ToastService.show(
        context: context,
        message: 'Rule name is required',
        type: ToastType.error,
      );
      return;
    }

    Navigator.of(context).pop();
    ToastService.show(
      context: context,
      message: 'Detection rule "${_ruleNameController.text.trim()}" activated across real-time telemetry.',
      type: ToastType.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.cyberCardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: const BorderSide(color: AppColors.cyberCardBorder),
      ),
      child: Container(
        width: 540.w,
        padding: EdgeInsets.all(20.r),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.bolt_rounded,
                          size: 18.sp,
                          color: AppColors.barPurple,
                        ),
                        const Gap(8),
                        Expanded(
                          child: Text(
                            'Create Threat Detection Rule',
                            style: TextStyle(
                              color: AppColors.textPrimaryDark,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(4.r),
                    child: Icon(
                      Icons.close_rounded,
                      size: 18.sp,
                      color: AppColors.textPlaceholderDark,
                    ),
                  ),
                ],
              ),
              const Gap(18),
              _buildFieldLabel('RULE NAME'),
              const Gap(6),
              _buildTextField(
                controller: _ruleNameController,
                hint: 'e.g. S3 Bucket Public Access Policy Modified',
              ),
              const Gap(14),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel('SEVERITY'),
                        const Gap(6),
                        _buildDropdown(
                          value: _severity,
                          items: const ['Critical', 'High', 'Medium', 'Low'],
                          onChanged: (v) => setState(() => _severity = v),
                        ),
                      ],
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel('SOURCE LAYER'),
                        const Gap(6),
                        _buildDropdown(
                          value: _source,
                          items: const ['Cloud', 'Identity', 'Network', 'AppSec', 'Data'],
                          onChanged: (v) => setState(() => _source = v),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Gap(14),
              _buildFieldLabel('MITRE ATT&CK TECHNIQUE'),
              const Gap(6),
              _buildTextField(
                controller: _mitreController,
                hint: 'e.g. T1530: Data from Cloud Storage',
              ),
              const Gap(14),
              _buildFieldLabel('DETECTION QUERY / LOG PATTERN'),
              const Gap(6),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.backgroundDark,
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(color: AppColors.cyberCardBorder),
                ),
                child: TextField(
                  controller: _queryController,
                  maxLines: 3,
                  style: TextStyle(
                    color: AppColors.textPrimaryDark,
                    fontSize: 11.5.sp,
                    fontFamily: 'monospace',
                  ),
                  decoration: InputDecoration(
                    hintText: 'event.source == "aws.s3" AND event.name == "PutBucketPolicy" AND request.policy.Statement[*].Principal == "*"',
                    hintStyle: TextStyle(
                      color: AppColors.textPlaceholderDark,
                      fontSize: 10.5.sp,
                      fontFamily: 'monospace',
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(10.r),
                  ),
                ),
              ),
              const Gap(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppButton(
                    label: 'Cancel',
                    type: AppButtonType.secondary,
                    size: AppButtonSize.sm,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Gap(10),
                  AppButton(
                    label: 'Deploy Rule',
                    type: AppButtonType.primary,
                    size: AppButtonSize.sm,
                    onPressed: _handleCreate,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        color: AppColors.textPlaceholderDark,
        fontSize: 10.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundDark,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: AppColors.cyberCardBorder),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(
          color: AppColors.textPrimaryDark,
          fontSize: 12.sp,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: AppColors.textPlaceholderDark,
            fontSize: 11.sp,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: AppColors.backgroundDark,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: AppColors.cyberCardBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: AppColors.cyberCardBg,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 16.sp,
            color: AppColors.textPlaceholderDark,
          ),
          style: TextStyle(
            color: AppColors.textPrimaryDark,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
          onChanged: (val) {
            if (val != null) onChanged(val);
          },
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
        ),
      ),
    );
  }
}
