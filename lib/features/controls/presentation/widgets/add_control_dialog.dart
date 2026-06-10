import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grc_web/core/theme/app_colors.dart';
import 'package:grc_web/core/widgets/app_button.dart';
import 'package:grc_web/core/widgets/app_select_field.dart';
import 'package:grc_web/core/widgets/app_text_field.dart';

Future<void> showAddControlDialog({required BuildContext context}) {
  return showControlFormDialog(context: context);
}

Future<void> showEditControlDialog({
  required BuildContext context,
  required ControlFormData data,
}) {
  return showControlFormDialog(context: context, initialData: data);
}

Future<void> showControlFormDialog({
  required BuildContext context,
  ControlFormData? initialData,
}) {
  return showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    builder: (context) => AddControlDialog(initialData: initialData),
  );
}

class ControlFormData {
  const ControlFormData({
    this.id,
    required this.name,
    required this.description,
    required this.controlType,
    required this.status,
    required this.owner,
    required this.testFrequency,
    required this.effectiveness,
    required this.frameworks,
    required this.linkedRisks,
    required this.linkedAssets,
    required this.linkedAssessments,
  });

  final String? id;
  final String name;
  final String description;
  final String controlType;
  final String status;
  final String owner;
  final String testFrequency;
  final double effectiveness;
  final List<String> frameworks;
  final String linkedRisks;
  final String linkedAssets;
  final String linkedAssessments;

  bool get isEditing => id != null;

  factory ControlFormData.fromSummary({
    required String id,
    required String name,
    required String description,
    required String controlType,
    required String status,
    required String owner,
    required List<String> frameworks,
    required int effectiveness,
    required int riskLinks,
    required int assetLinks,
    required int assessmentLinks,
  }) {
    if (id == 'CTL-001') {
      return ControlFormData(
        id: id,
        name: name,
        description: description,
        controlType: controlType,
        status: status,
        owner: owner,
        testFrequency: 'continuous',
        effectiveness: effectiveness.toDouble(),
        frameworks: List<String>.from(frameworks),
        linkedRisks: 'R-004, R-001',
        linkedAssets: 'AST-006, AST-001',
        linkedAssessments: 'ASSESS-001, ASSESS-003',
      );
    }

    return ControlFormData(
      id: id,
      name: name,
      description: description,
      controlType: controlType,
      status: status,
      owner: owner,
      testFrequency: 'annual',
      effectiveness: effectiveness.toDouble(),
      frameworks: List<String>.from(frameworks),
      linkedRisks: [
        for (var i = 0; i < riskLinks; i++)
          'R-${(i + 1).toString().padLeft(3, '0')}',
      ].join(', '),
      linkedAssets: [
        for (var i = 0; i < assetLinks; i++)
          'AST-${(i + 1).toString().padLeft(3, '0')}',
      ].join(', '),
      linkedAssessments: [
        for (var i = 0; i < assessmentLinks; i++)
          'ASSESS-${(i + 1).toString().padLeft(3, '0')}',
      ].join(', '),
    );
  }
}

class AddControlDialog extends StatefulWidget {
  const AddControlDialog({super.key, this.initialData});

  final ControlFormData? initialData;

  static const _dialogWidth = 896.0;

  @override
  State<AddControlDialog> createState() => _AddControlDialogState();
}

class _AddControlDialogState extends State<AddControlDialog> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _frameworkController = TextEditingController();
  final _linkedRisksController = TextEditingController();
  final _linkedAssetsController = TextEditingController();
  final _linkedAssessmentsController = TextEditingController();

  String _controlType = 'preventive';
  String _status = 'notImplemented';
  String? _owner;
  String _testFrequency = 'annual';
  double _effectiveness = 0;
  final List<String> _frameworkMappings = [];

  static const _controlTypes = ['preventive', 'detective', 'corrective'];
  static const _statuses = ['notImplemented', 'implemented', 'partiallyImplemented'];
  static const _owners = [
    'Security Team',
    'Data Team',
    'Cloud Team',
    'CISO',
    'IT Operations',
    'SOC Team',
  ];
  static const _frequencies = ['annual', 'quarterly', 'monthly', 'continuous'];

  bool get _isEditing => widget.initialData?.isEditing ?? false;

  @override
  void initState() {
    super.initState();
    final data = widget.initialData;
    if (data == null) return;

    _nameController.text = data.name;
    _descriptionController.text = data.description;
    _controlType = data.controlType;
    _status = data.status;
    _owner = data.owner;
    _testFrequency = data.testFrequency;
    _effectiveness = data.effectiveness;
    _frameworkMappings.addAll(data.frameworks);
    _linkedRisksController.text = data.linkedRisks;
    _linkedAssetsController.text = data.linkedAssets;
    _linkedAssessmentsController.text = data.linkedAssessments;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _frameworkController.dispose();
    _linkedRisksController.dispose();
    _linkedAssetsController.dispose();
    _linkedAssessmentsController.dispose();
    super.dispose();
  }

  void _addFrameworkMapping() {
    final value = _frameworkController.text.trim();
    if (value.isEmpty || _frameworkMappings.contains(value)) return;
    setState(() {
      _frameworkMappings.add(value);
      _frameworkController.clear();
    });
  }

  void _removeFrameworkMapping(String value) {
    setState(() => _frameworkMappings.remove(value));
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.sizeOf(context);
    final dialogWidth = math.min(AddControlDialog._dialogWidth.w, screen.width - 48.w);
    final dialogHeight = math.min(1147.h, screen.height * 0.92);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: SizedBox(
        width: dialogWidth,
        height: dialogHeight,
        child: Material(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10.r),
          clipBehavior: Clip.antiAlias,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: const [
                BoxShadow(color: Color(0x1A000000), blurRadius: 25, offset: Offset(0, 20)),
                BoxShadow(color: Color(0x1A000000), blurRadius: 10, offset: Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                _DialogHeader(
                  title: _isEditing ? 'Edit Control' : 'Add New Control',
                  subtitle: _isEditing
                      ? 'Editing ${widget.initialData!.id}'
                      : 'Create a new security control',
                  onClose: () => Navigator.of(context).pop(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _BasicInformationSection(
                          nameController: _nameController,
                          descriptionController: _descriptionController,
                          controlType: _controlType,
                          status: _status,
                          onControlTypeChanged: (v) {
                            if (v != null) setState(() => _controlType = v);
                          },
                          onStatusChanged: (v) {
                            if (v != null) setState(() => _status = v);
                          },
                        ),
                        SizedBox(height: 24.h),
                        _OwnershipSection(
                          owner: _owner,
                          testFrequency: _testFrequency,
                          effectiveness: _effectiveness,
                          onOwnerChanged: (v) => setState(() => _owner = v),
                          onFrequencyChanged: (v) {
                            if (v != null) setState(() => _testFrequency = v);
                          },
                          onEffectivenessChanged: (v) => setState(() => _effectiveness = v),
                        ),
                        SizedBox(height: 24.h),
                        _FrameworkMappingsSection(
                          controller: _frameworkController,
                          mappings: _frameworkMappings,
                          onAdd: _addFrameworkMapping,
                          onRemove: _removeFrameworkMapping,
                        ),
                        SizedBox(height: 24.h),
                        _IntegrationSection(
                          risksController: _linkedRisksController,
                          assetsController: _linkedAssetsController,
                          assessmentsController: _linkedAssessmentsController,
                        ),
                        SizedBox(height: 24.h),
                        _DialogFooter(
                          isEditing: _isEditing,
                          onCancel: () => Navigator.of(context).pop(),
                          onSubmit: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DialogHeader extends StatelessWidget {
  const _DialogHeader({
    required this.title,
    required this.subtitle,
    required this.onClose,
  });

  final String title;
  final String subtitle;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 17.h),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    height: 28 / 20,
                    letterSpacing: -0.46,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    height: 20 / 14,
                    letterSpacing: -0.154,
                  ),
                ),
              ],
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onClose,
              borderRadius: BorderRadius.circular(10.r),
              child: Padding(
                padding: EdgeInsets.all(8.r),
                child: SvgPicture.asset(
                  'assets/figma/library/svg/close_white.svg',
                  width: 28.r,
                  height: 28.r,
                  colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.iconAsset, required this.title});

  final String iconAsset;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(iconAsset, width: 28.r, height: 28.r),
        SizedBox(width: 8.w),
        Text(
          title,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            height: 20 / 14,
            letterSpacing: -0.154,
          ),
        ),
      ],
    );
  }
}

class _BasicInformationSection extends StatelessWidget {
  const _BasicInformationSection({
    required this.nameController,
    required this.descriptionController,
    required this.controlType,
    required this.status,
    required this.onControlTypeChanged,
    required this.onStatusChanged,
  });

  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final String controlType;
  final String status;
  final ValueChanged<String?> onControlTypeChanged;
  final ValueChanged<String?> onStatusChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionHeader(
          iconAsset: 'assets/figma/controls/svg/section_basic.svg',
          title: 'Basic Information',
        ),
        SizedBox(height: 16.h),
        AppTextField(
          label: 'Control Name',
          isRequired: true,
          labelSpacing: 8,
          controller: nameController,
          hint: 'e.g., Multi-Factor Authentication',
        ),
        SizedBox(height: 16.h),
        AppTextField(
          label: 'Description',
          isRequired: true,
          labelSpacing: 8,
          controller: descriptionController,
          hint: 'Describe what this control does and how it works...',
          minLines: 3,
          maxLines: 5,
        ),
        SizedBox(height: 16.h),
        _TwoColumnRow(
          left: AppSelectField<String>(
            label: 'Control Type',
            isRequired: true,
            labelSpacing: 8,
            value: controlType,
            items: _AddControlDialogState._controlTypes,
            itemLabel: _controlTypeLabel,
            onChanged: onControlTypeChanged,
          ),
          right: AppSelectField<String>(
            label: 'Status',
            isRequired: true,
            labelSpacing: 8,
            value: status,
            items: _AddControlDialogState._statuses,
            itemLabel: _statusLabel,
            onChanged: onStatusChanged,
          ),
        ),
      ],
    );
  }
}

class _OwnershipSection extends StatelessWidget {
  const _OwnershipSection({
    required this.owner,
    required this.testFrequency,
    required this.effectiveness,
    required this.onOwnerChanged,
    required this.onFrequencyChanged,
    required this.onEffectivenessChanged,
  });

  final String? owner;
  final String testFrequency;
  final double effectiveness;
  final ValueChanged<String?> onOwnerChanged;
  final ValueChanged<String?> onFrequencyChanged;
  final ValueChanged<double> onEffectivenessChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionDivider(),
        SizedBox(height: 25.h),
        const _SectionHeader(
          iconAsset: 'assets/figma/controls/svg/section_ownership.svg',
          title: 'Ownership & Testing',
        ),
        SizedBox(height: 16.h),
        _TwoColumnRow(
          left: AppSelectField<String?>(
            label: 'Control Owner',
            isRequired: true,
            labelSpacing: 8,
            value: owner,
            hint: 'Select owner...',
            items: const [null, ..._AddControlDialogState._owners],
            itemLabel: (v) => v ?? 'Select owner...',
            onChanged: onOwnerChanged,
          ),
          right: AppSelectField<String>(
            label: 'Test Frequency',
            isRequired: true,
            labelSpacing: 8,
            value: testFrequency,
            items: _AddControlDialogState._frequencies,
            itemLabel: _frequencyLabel,
            onChanged: onFrequencyChanged,
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          'Control Effectiveness (${effectiveness.toStringAsFixed(0)}%)',
          style: TextStyle(
            color: AppColors.textLabel,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            height: 20 / 14,
            letterSpacing: -0.154,
          ),
        ),
        SizedBox(height: 10.h),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: AppColors.borderInput,
            thumbColor: AppColors.primary,
            overlayColor: AppColors.primary.withValues(alpha: 0.12),
            trackHeight: 4.h,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.r),
          ),
          child: Slider(
            value: effectiveness,
            min: 0,
            max: 100,
            onChanged: onEffectivenessChanged,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _SliderLabel('0%'),
            _SliderLabel('50%'),
            _SliderLabel('100%'),
          ],
        ),
      ],
    );
  }
}

class _FrameworkMappingsSection extends StatelessWidget {
  const _FrameworkMappingsSection({
    required this.controller,
    required this.mappings,
    required this.onAdd,
    required this.onRemove,
  });

  final TextEditingController controller;
  final List<String> mappings;
  final VoidCallback onAdd;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionDivider(),
        SizedBox(height: 25.h),
        const _SectionHeader(
          iconAsset: 'assets/figma/controls/svg/section_framework.svg',
          title: 'Framework Mappings',
        ),
        SizedBox(height: 16.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AppTextField(
                controller: controller,
                hint: 'e.g., ISO 27001: A.9.4.2 or NIST: PR.AC-7',
                onSubmitted: (_) => onAdd(),
              ),
            ),
            SizedBox(width: 8.w),
            AppButton(
              label: 'Add',
              variant: AppButtonVariant.primary,
              onPressed: onAdd,
            ),
          ],
        ),
        if (mappings.isNotEmpty) ...[
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              for (final mapping in mappings)
                _MappingChip(
                  label: mapping,
                  onRemove: () => onRemove(mapping),
                ),
            ],
          ),
        ],
        SizedBox(height: 16.h),
        Text(
          'Common frameworks: ISO 27001, NIST CSF, CIS Controls, SOC 2, PCI DSS, HIPAA',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            height: 16 / 12,
          ),
        ),
      ],
    );
  }
}

class _IntegrationSection extends StatelessWidget {
  const _IntegrationSection({
    required this.risksController,
    required this.assetsController,
    required this.assessmentsController,
  });

  final TextEditingController risksController;
  final TextEditingController assetsController;
  final TextEditingController assessmentsController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionDivider(),
        SizedBox(height: 25.h),
        const _SectionHeader(
          iconAsset: 'assets/figma/controls/svg/section_integration.svg',
          title: 'Integration (Optional)',
        ),
        SizedBox(height: 16.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AppTextField(
                label: 'Linked Risks',
                labelSpacing: 8,
                controller: risksController,
                hint: 'e.g., R-001, R-002',
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: AppTextField(
                label: 'Linked Assets',
                labelSpacing: 8,
                controller: assetsController,
                hint: 'e.g., AST-001, AST-002',
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: AppTextField(
                label: 'Linked Assessments',
                labelSpacing: 8,
                controller: assessmentsController,
                hint: 'e.g., ASSESS-001',
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Text(
          'Comma-separated IDs to link this control to risks, assets, and assessments',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            height: 16 / 12,
          ),
        ),
      ],
    );
  }
}

class _DialogFooter extends StatelessWidget {
  const _DialogFooter({
    required this.isEditing,
    required this.onCancel,
    required this.onSubmit,
  });

  final bool isEditing;
  final VoidCallback onCancel;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionDivider(),
        SizedBox(height: 17.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AppButton(
              label: 'Cancel',
              variant: AppButtonVariant.outlined,
              onPressed: onCancel,
            ),
            SizedBox(width: 12.w),
            AppButton(
              label: isEditing ? 'Update Control' : 'Create Control',
              variant: AppButtonVariant.primary,
              onPressed: onSubmit,
            ),
          ],
        ),
      ],
    );
  }
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(color: AppColors.border, height: 1, thickness: 1);
  }
}

class _TwoColumnRow extends StatelessWidget {
  const _TwoColumnRow({required this.left, required this.right});

  final Widget left;
  final Widget right;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        SizedBox(width: 16.w),
        Expanded(child: right),
      ],
    );
  }
}

class _SliderLabel extends StatelessWidget {
  const _SliderLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: AppColors.textSecondary,
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        height: 16 / 12,
      ),
    );
  }
}

class _MappingChip extends StatelessWidget {
  const _MappingChip({required this.label, required this.onRemove});

  final String label;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.primaryTint,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.weightBadgeFg,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              height: 20 / 14,
              letterSpacing: -0.154,
            ),
          ),
          SizedBox(width: 8.w),
          InkWell(
            onTap: onRemove,
            borderRadius: BorderRadius.circular(4.r),
            child: Text(
              '×',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                height: 24 / 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _controlTypeLabel(String value) => switch (value) {
      'preventive' => 'Preventive',
      'detective' => 'Detective',
      'corrective' => 'Corrective',
      _ => value,
    };

String _statusLabel(String value) => switch (value) {
      'notImplemented' => 'Not Implemented',
      'implemented' => 'Implemented',
      'partiallyImplemented' => 'Partially Implemented',
      _ => value,
    };

String _frequencyLabel(String value) => switch (value) {
      'annual' => 'Annual',
      'quarterly' => 'Quarterly',
      'monthly' => 'Monthly',
      'continuous' => 'Continuous',
      _ => value,
    };
