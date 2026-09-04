import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';

class GeneratePolicyDialog extends StatefulWidget {
  const GeneratePolicyDialog({super.key});

  @override
  State<GeneratePolicyDialog> createState() => _GeneratePolicyDialogState();
}

class _GeneratePolicyDialogState extends State<GeneratePolicyDialog> {
  final TextEditingController _policyNameController = TextEditingController(
    text: 'Continuous Cloud Vulnerability Remediation Policy',
  );

  String _selectedFramework = 'NIST CSF 2.0';
  String _scope = 'All Production & Staging Environments';

  @override
  void dispose() {
    _policyNameController.dispose();
    super.dispose();
  }

  void _handlePublish() {
    if (_policyNameController.text.trim().isEmpty) {
      ToastService.show(
        context: context,
        message: 'Policy title is required',
        type: ToastType.error,
      );
      return;
    }

    Navigator.of(context).pop();
    ToastService.show(
      context: context,
      message:
          'Policy "${_policyNameController.text.trim()}" generated and published to GRC catalog.',
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
        width: 520.w,
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
                          Icons.description_outlined,
                          size: 18.sp,
                          color: AppColors.dashCyberSecurity,
                        ),
                        const Gap(8),
                        Expanded(
                          child: Text(
                            'Generate Compliance Policy',
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
              const Gap(16),
              _buildFieldLabel('POLICY TITLE'),
              const Gap(6),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.backgroundDark,
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(color: AppColors.cyberCardBorder),
                ),
                child: TextField(
                  controller: _policyNameController,
                  style: TextStyle(
                    color: AppColors.textPrimaryDark,
                    fontSize: 12.sp,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 10.h,
                    ),
                  ),
                ),
              ),
              const Gap(14),
              _buildFieldLabel('GOVERNING FRAMEWORK'),
              const Gap(6),
              _buildDropdown(
                value: _selectedFramework,
                items: const [
                  'NIST CSF 2.0',
                  'SOC 2 Type II',
                  'ISO 27001:2022',
                  'CIS Controls v8',
                  'CSA CCM v4',
                ],
                onChanged: (val) => setState(() => _selectedFramework = val),
              ),
              const Gap(14),
              _buildFieldLabel('ENFORCEMENT SCOPE'),
              const Gap(6),
              _buildDropdown(
                value: _scope,
                items: const [
                  'All Production & Staging Environments',
                  'AWS Member Accounts Only',
                  'Identity & SaaS Applications',
                ],
                onChanged: (val) => setState(() => _scope = val),
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
                    label: 'Publish Policy',
                    type: AppButtonType.primary,
                    size: AppButtonSize.sm,
                    onPressed: _handlePublish,
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
              child: Text(item, overflow: TextOverflow.ellipsis),
            );
          }).toList(),
        ),
      ),
    );
  }
}
