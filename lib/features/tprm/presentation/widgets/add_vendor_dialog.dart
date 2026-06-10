import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grc_web/core/theme/app_colors.dart';
import 'package:grc_web/core/widgets/app_button.dart';
import 'package:grc_web/core/widgets/app_select_field.dart';
import 'package:grc_web/core/widgets/app_text_field.dart';
import 'package:grc_web/features/tprm/presentation/widgets/vendor_detail_dialog.dart';

Future<void> showAddVendorDialog({required BuildContext context}) {
  return showVendorFormDialog(context: context);
}

Future<void> showEditVendorDialog({
  required BuildContext context,
  required VendorFormData data,
}) {
  return showVendorFormDialog(context: context, initialData: data);
}

Future<void> showVendorFormDialog({
  required BuildContext context,
  VendorFormData? initialData,
}) {
  return showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    builder: (context) => AddVendorDialog(initialData: initialData),
  );
}

class VendorFormData {
  const VendorFormData({
    this.id,
    required this.name,
    required this.category,
    required this.tier,
    required this.dataAccessLevel,
    required this.status,
    required this.geography,
    required this.businessOwner,
    required this.servicesProvided,
    required this.riskRating,
    required this.riskLevel,
    required this.inherentRisk,
    required this.residualRisk,
    required this.controlEffectiveness,
    required this.contractValue,
    required this.annualSpend,
    required this.vendorManager,
    required this.lastAssessment,
    required this.nextAssessment,
    required this.linkedAssets,
    required this.linkedRisks,
    required this.linkedControls,
    required this.linkedPrograms,
    required this.certifications,
    required this.infoSecurityScore,
    required this.dataPrivacyScore,
    required this.cloudSecurityScore,
    required this.operationalResilienceScore,
    required this.financialStabilityScore,
  });

  final String? id;
  final String name;
  final String category;
  final String tier;
  final String dataAccessLevel;
  final String status;
  final String geography;
  final String businessOwner;
  final String servicesProvided;
  final int riskRating;
  final String riskLevel;
  final int inherentRisk;
  final int residualRisk;
  final int controlEffectiveness;
  final int contractValue;
  final int annualSpend;
  final String vendorManager;
  final DateTime? lastAssessment;
  final DateTime? nextAssessment;
  final String linkedAssets;
  final String linkedRisks;
  final String linkedControls;
  final String linkedPrograms;
  final Set<String> certifications;
  final int infoSecurityScore;
  final int dataPrivacyScore;
  final int cloudSecurityScore;
  final int operationalResilienceScore;
  final int financialStabilityScore;

  bool get isEditing => id != null;

  factory VendorFormData.fromDetail(VendorDetailData detail) {
    return VendorFormData(
      id: detail.id,
      name: detail.name,
      category: _categoryKeyFromLabel(detail.category),
      tier: _tierKeyFromLabel(detail.tierLabel),
      dataAccessLevel: _dataAccessKeyFromLabel(detail.dataAccess),
      status: 'active',
      geography: detail.geography,
      businessOwner: detail.businessOwner,
      servicesProvided: detail.servicesProvided,
      riskRating: detail.riskRating,
      riskLevel: _riskLevelKeyFromLabel(detail.riskLevelLabel),
      inherentRisk: detail.inherentRisk,
      residualRisk: detail.residualRisk,
      controlEffectiveness: detail.controlEffectiveness,
      contractValue: 2400000,
      annualSpend: 2400000,
      vendorManager: detail.vendorManager,
      lastAssessment: _parseDate(detail.lastAssessment),
      nextAssessment: _parseDate(detail.nextAssessment),
      linkedAssets: detail.linkedAssets.join(', '),
      linkedRisks: detail.linkedRisks.join(', '),
      linkedControls: detail.linkedControls.join(', '),
      linkedPrograms: detail.linkedPrograms.join(', '),
      certifications: {
        'iso27001',
        'soc2',
        'gdpr',
      },
      infoSecurityScore: 92,
      dataPrivacyScore: 88,
      cloudSecurityScore: 95,
      operationalResilienceScore: 85,
      financialStabilityScore: 90,
    );
  }

  static String _categoryKeyFromLabel(String label) {
    return switch (label) {
      'Cloud Provider' => 'cloudProvider',
      'Financial Services' => 'financialServices',
      'SaaS' => 'saas',
      'Security' => 'security',
      'Infrastructure' => 'infrastructure',
      _ => '',
    };
  }

  static String _tierKeyFromLabel(String label) {
    return switch (label) {
      'Critical' => 'critical',
      'Important' => 'important',
      _ => 'standard',
    };
  }

  static String _dataAccessKeyFromLabel(String label) {
    return switch (label) {
      'Confidential' => 'confidential',
      'Public' => 'public',
      _ => 'internal',
    };
  }

  static String _riskLevelKeyFromLabel(String label) {
    final normalized = label.replaceAll(' Risk', '');
    return switch (normalized) {
      'Medium' => 'medium',
      'High' => 'high',
      _ => 'low',
    };
  }

  static DateTime? _parseDate(String value) {
    if (value.isEmpty || value == '—') return null;
    final iso = DateTime.tryParse(value);
    if (iso != null) return iso;
    final parts = value.split('/');
    if (parts.length == 3) {
      final day = int.tryParse(parts[0]);
      final month = int.tryParse(parts[1]);
      final year = int.tryParse(parts[2]);
      if (day != null && month != null && year != null) {
        return DateTime(year, month, day);
      }
    }
    return null;
  }
}

class AddVendorDialog extends StatefulWidget {
  const AddVendorDialog({super.key, this.initialData});

  final VendorFormData? initialData;

  static const _dialogWidth = 896.0;

  @override
  State<AddVendorDialog> createState() => _AddVendorDialogState();
}

class _AddVendorDialogState extends State<AddVendorDialog> {
  final _nameController = TextEditingController();
  final _geographyController = TextEditingController();
  final _businessOwnerController = TextEditingController();
  final _servicesController = TextEditingController();
  final _riskRatingController = TextEditingController(text: '0');
  final _inherentRiskController = TextEditingController(text: '0');
  final _residualRiskController = TextEditingController(text: '0');
  final _controlEffectivenessController = TextEditingController(text: '0');
  final _contractValueController = TextEditingController(text: '0');
  final _annualSpendController = TextEditingController(text: '0');
  final _vendorManagerController = TextEditingController();
  final _lastAssessmentController = TextEditingController();
  final _nextAssessmentController = TextEditingController();
  final _linkedAssetsController = TextEditingController();
  final _linkedRisksController = TextEditingController();
  final _linkedControlsController = TextEditingController();
  final _linkedProgramsController = TextEditingController();
  final _infoSecurityController = TextEditingController(text: '0');
  final _dataPrivacyController = TextEditingController(text: '0');
  final _cloudSecurityController = TextEditingController(text: '0');
  final _operationalResilienceController = TextEditingController(text: '0');
  final _financialStabilityController = TextEditingController(text: '0');

  String _category = '';
  String _tier = 'standard';
  String _dataAccessLevel = 'internal';
  String _status = 'active';
  String _riskLevel = 'low';
  DateTime? _lastAssessment;
  DateTime? _nextAssessment;
  final Set<String> _certifications = {};

  static const _categories = [
    '',
    'cloudProvider',
    'financialServices',
    'saas',
    'security',
    'infrastructure',
  ];
  static const _tiers = ['critical', 'important', 'standard'];
  static const _dataAccessLevels = ['internal', 'confidential', 'public'];
  static const _statuses = ['active', 'inactive'];
  static const _riskLevels = ['low', 'medium', 'high'];
  static const _certificationOptions = [
    ('iso27001', 'ISO 27001'),
    ('soc2', 'SOC 2'),
    ('gdpr', 'GDPR'),
    ('pciDss', 'PCI DSS'),
  ];

  bool get _isEditing => widget.initialData?.isEditing ?? false;

  @override
  void initState() {
    super.initState();
    final data = widget.initialData;
    if (data == null) return;

    _nameController.text = data.name;
    _category = data.category;
    _tier = data.tier;
    _dataAccessLevel = data.dataAccessLevel;
    _status = data.status;
    _geographyController.text = data.geography;
    _businessOwnerController.text = data.businessOwner;
    _servicesController.text = data.servicesProvided;
    _riskRatingController.text = '${data.riskRating}';
    _riskLevel = data.riskLevel;
    _inherentRiskController.text = '${data.inherentRisk}';
    _residualRiskController.text = '${data.residualRisk}';
    _controlEffectivenessController.text = '${data.controlEffectiveness}';
    _contractValueController.text = '${data.contractValue}';
    _annualSpendController.text = '${data.annualSpend}';
    _vendorManagerController.text = data.vendorManager;
    _lastAssessment = data.lastAssessment;
    _nextAssessment = data.nextAssessment;
    _lastAssessmentController.text = _formatDate(data.lastAssessment);
    _nextAssessmentController.text = _formatDate(data.nextAssessment);
    _linkedAssetsController.text = data.linkedAssets;
    _linkedRisksController.text = data.linkedRisks;
    _linkedControlsController.text = data.linkedControls;
    _linkedProgramsController.text = data.linkedPrograms;
    _certifications.addAll(data.certifications);
    _infoSecurityController.text = '${data.infoSecurityScore}';
    _dataPrivacyController.text = '${data.dataPrivacyScore}';
    _cloudSecurityController.text = '${data.cloudSecurityScore}';
    _operationalResilienceController.text = '${data.operationalResilienceScore}';
    _financialStabilityController.text = '${data.financialStabilityScore}';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _geographyController.dispose();
    _businessOwnerController.dispose();
    _servicesController.dispose();
    _riskRatingController.dispose();
    _inherentRiskController.dispose();
    _residualRiskController.dispose();
    _controlEffectivenessController.dispose();
    _contractValueController.dispose();
    _annualSpendController.dispose();
    _vendorManagerController.dispose();
    _lastAssessmentController.dispose();
    _nextAssessmentController.dispose();
    _linkedAssetsController.dispose();
    _linkedRisksController.dispose();
    _linkedControlsController.dispose();
    _linkedProgramsController.dispose();
    _infoSecurityController.dispose();
    _dataPrivacyController.dispose();
    _cloudSecurityController.dispose();
    _operationalResilienceController.dispose();
    _financialStabilityController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(date.day)}/${two(date.month)}/${date.year}';
  }

  Future<void> _pickDate({required bool isLast}) async {
    final now = DateTime.now();
    final current = isLast ? _lastAssessment : _nextAssessment;
    final picked = await showDatePicker(
      context: context,
      initialDate: current ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 10),
    );
    if (picked == null) return;
    setState(() {
      if (isLast) {
        _lastAssessment = picked;
        _lastAssessmentController.text = _formatDate(picked);
      } else {
        _nextAssessment = picked;
        _nextAssessmentController.text = _formatDate(picked);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.sizeOf(context);
    final dialogWidth = math.min(AddVendorDialog._dialogWidth.w, screen.width - 48.w);
    final dialogHeight = math.min(1556.h, screen.height * 0.92);

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
                  title: _isEditing ? 'Edit Vendor' : 'Add New Vendor',
                  onClose: () => Navigator.of(context).pop(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildBasicInformationSection(),
                        _SectionDivider(title: 'Risk & Financial Information'),
                        _buildRiskFinancialSection(),
                        _SectionDivider(title: 'GRC Integration'),
                        _buildGrcIntegrationSection(),
                        _SectionDivider(title: 'Security Certifications'),
                        _buildCertificationsSection(),
                        _SectionDivider(title: 'Assessment Scores (0-100)'),
                        _buildAssessmentScoresSection(),
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

  Widget _buildBasicInformationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionTitle(title: 'Basic Information'),
        SizedBox(height: 12.h),
        AppTextField(
          label: 'Vendor Name',
          isRequired: true,
          labelSpacing: 8,
          controller: _nameController,
          hint: 'e.g., Cloud Infrastructure Services Inc.',
        ),
        SizedBox(height: 16.h),
        _TwoColumnRow(
          left: AppSelectField<String>(
            label: 'Category',
            isRequired: true,
            labelSpacing: 8,
            value: _category,
            items: _categories,
            itemLabel: _categoryLabel,
            onChanged: (v) => setState(() => _category = v ?? ''),
            contentPadding: EdgeInsets.fromLTRB(21.w, 9.h, 12.w, 9.h),
          ),
          right: AppSelectField<String>(
            label: 'Tier',
            isRequired: true,
            labelSpacing: 8,
            value: _tier,
            items: _tiers,
            itemLabel: _tierLabel,
            onChanged: (v) {
              if (v != null) setState(() => _tier = v);
            },
            contentPadding: EdgeInsets.fromLTRB(21.w, 9.h, 12.w, 9.h),
          ),
        ),
        SizedBox(height: 16.h),
        _TwoColumnRow(
          left: AppSelectField<String>(
            label: 'Data Access Level',
            isRequired: true,
            labelSpacing: 8,
            value: _dataAccessLevel,
            items: _dataAccessLevels,
            itemLabel: _dataAccessLabel,
            onChanged: (v) {
              if (v != null) setState(() => _dataAccessLevel = v);
            },
            contentPadding: EdgeInsets.fromLTRB(21.w, 9.h, 12.w, 9.h),
          ),
          right: AppSelectField<String>(
            label: 'Status',
            isRequired: true,
            labelSpacing: 8,
            value: _status,
            items: _statuses,
            itemLabel: _statusLabel,
            onChanged: (v) {
              if (v != null) setState(() => _status = v);
            },
            contentPadding: EdgeInsets.fromLTRB(21.w, 9.h, 12.w, 9.h),
          ),
        ),
        SizedBox(height: 16.h),
        _TwoColumnRow(
          left: AppTextField(
            label: 'Geography',
            labelSpacing: 8,
            controller: _geographyController,
            hint: 'e.g., North America, Global',
          ),
          right: AppTextField(
            label: 'Business Owner',
            labelSpacing: 8,
            controller: _businessOwnerController,
            hint: 'e.g., CTO',
          ),
        ),
        SizedBox(height: 16.h),
        AppTextField(
          label: 'Services Provided',
          labelSpacing: 8,
          controller: _servicesController,
          hint: 'Describe services provided',
          minLines: 2,
          maxLines: 4,
        ),
      ],
    );
  }

  Widget _buildRiskFinancialSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ThreeColumnRow(
          children: [
            _numericField('Risk Rating (0-100)', _riskRatingController),
            AppSelectField<String>(
              label: 'Risk Level',
              labelSpacing: 8,
              value: _riskLevel,
              items: _riskLevels,
              itemLabel: _riskLevelLabel,
              onChanged: (v) {
                if (v != null) setState(() => _riskLevel = v);
              },
              contentPadding: EdgeInsets.fromLTRB(21.w, 9.h, 12.w, 9.h),
            ),
            _numericField('Inherent Risk (%)', _inherentRiskController),
          ],
        ),
        SizedBox(height: 16.h),
        _ThreeColumnRow(
          children: [
            _numericField('Residual Risk (%)', _residualRiskController),
            _numericField('Control Effectiveness (%)', _controlEffectivenessController),
            _numericField('Contract Value (\$)', _contractValueController),
          ],
        ),
        SizedBox(height: 16.h),
        _ThreeColumnRow(
          children: [
            _numericField('Annual Spend (\$)', _annualSpendController),
            AppTextField(
              label: 'Vendor Manager',
              labelSpacing: 8,
              controller: _vendorManagerController,
              hint: 'e.g., IT Team',
            ),
            _dateField('Last Assessment', _lastAssessmentController, () => _pickDate(isLast: true)),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _dateField(
                'Next Assessment',
                _nextAssessmentController,
                () => _pickDate(isLast: false),
              ),
            ),
            SizedBox(width: 16.w),
            const Expanded(child: SizedBox()),
            SizedBox(width: 16.w),
            const Expanded(child: SizedBox()),
          ],
        ),
      ],
    );
  }

  Widget _buildGrcIntegrationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _TwoColumnRow(
          left: AppTextField(
            label: 'Linked Assets (comma-separated IDs)',
            labelSpacing: 8,
            controller: _linkedAssetsController,
            hint: 'AST-001, AST-002',
          ),
          right: AppTextField(
            label: 'Linked Risks (comma-separated IDs)',
            labelSpacing: 8,
            controller: _linkedRisksController,
            hint: 'R-001, R-002',
          ),
        ),
        SizedBox(height: 16.h),
        _TwoColumnRow(
          left: AppTextField(
            label: 'Linked Controls (comma-separated IDs)',
            labelSpacing: 8,
            controller: _linkedControlsController,
            hint: 'CTL-001, CTL-002',
          ),
          right: AppTextField(
            label: 'Linked Programs (comma-separated IDs)',
            labelSpacing: 8,
            controller: _linkedProgramsController,
            hint: 'PGM-001, PGM-002',
          ),
        ),
      ],
    );
  }

  Widget _buildCertificationsSection() {
    return Row(
      children: [
        for (var i = 0; i < _certificationOptions.length; i++) ...[
          if (i > 0) SizedBox(width: 16.w),
          Expanded(
            child: _CertificationCheckbox(
              label: _certificationOptions[i].$2,
              value: _certifications.contains(_certificationOptions[i].$1),
              onChanged: (checked) {
                setState(() {
                  if (checked) {
                    _certifications.add(_certificationOptions[i].$1);
                  } else {
                    _certifications.remove(_certificationOptions[i].$1);
                  }
                });
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAssessmentScoresSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _scoreField('Information Security', _infoSecurityController)),
        SizedBox(width: 16.w),
        Expanded(child: _scoreField('Data Privacy', _dataPrivacyController)),
        SizedBox(width: 16.w),
        Expanded(child: _scoreField('Cloud Security', _cloudSecurityController)),
        SizedBox(width: 16.w),
        Expanded(child: _scoreField('Operational Resilience', _operationalResilienceController)),
        SizedBox(width: 16.w),
        Expanded(child: _scoreField('Financial Stability', _financialStabilityController)),
      ],
    );
  }

  Widget _numericField(String label, TextEditingController controller) {
    return AppTextField(
      label: label,
      labelSpacing: 8,
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    );
  }

  Widget _dateField(String label, TextEditingController controller, VoidCallback onTap) {
    return AppTextField(
      label: label,
      labelSpacing: 8,
      controller: controller,
      hint: 'dd/mm/yyyy',
      readOnly: true,
      onTap: onTap,
      suffixIcon: Padding(
        padding: EdgeInsetsDirectional.only(end: 13.w),
        child: SvgPicture.asset(
          'assets/figma/assessments/svg/calendar.svg',
          width: 16.r,
          height: 16.r,
        ),
      ),
    );
  }

  Widget _scoreField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.textBody,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            height: 16 / 12,
          ),
        ),
        SizedBox(height: 4.h),
        AppTextField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          fontSize: 14,
          contentPadding: EdgeInsets.fromLTRB(13.w, 9.h, 13.w, 9.h),
        ),
      ],
    );
  }

  static String _categoryLabel(String value) {
    return switch (value) {
      '' => 'Select category',
      'cloudProvider' => 'Cloud Provider',
      'financialServices' => 'Financial Services',
      'saas' => 'SaaS',
      'security' => 'Security',
      'infrastructure' => 'Infrastructure',
      _ => value,
    };
  }

  static String _tierLabel(String value) {
    return switch (value) {
      'critical' => 'Critical',
      'important' => 'Important',
      _ => 'Standard',
    };
  }

  static String _dataAccessLabel(String value) {
    return switch (value) {
      'confidential' => 'Confidential',
      'public' => 'Public',
      _ => 'Internal',
    };
  }

  static String _statusLabel(String value) {
    return value == 'inactive' ? 'Inactive' : 'Active';
  }

  static String _riskLevelLabel(String value) {
    return switch (value) {
      'medium' => 'Medium',
      'high' => 'High',
      _ => 'Low',
    };
  }
}

class _DialogHeader extends StatelessWidget {
  const _DialogHeader({required this.title, required this.onClose});

  final String title;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 16.h, 16.w, 17.h),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                height: 28 / 20,
                letterSpacing: -0.46,
              ),
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        height: 20 / 14,
        letterSpacing: -0.154,
      ),
    );
  }
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 24.h),
        Container(
          padding: EdgeInsets.only(top: 25.h),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          child: _SectionTitle(title: title),
        ),
        SizedBox(height: 12.h),
      ],
    );
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

class _ThreeColumnRow extends StatelessWidget {
  const _ThreeColumnRow({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) SizedBox(width: 16.w),
          Expanded(child: children[i]),
        ],
      ],
    );
  }
}

class _CertificationCheckbox extends StatelessWidget {
  const _CertificationCheckbox({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(4.r),
      child: Row(
        children: [
          SizedBox(
            width: 13.r,
            height: 13.r,
            child: Checkbox(
              value: value,
              onChanged: (v) => onChanged(v ?? false),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
              side: const BorderSide(color: Color(0xFF767676), width: 1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.5.r)),
              activeColor: AppColors.primary,
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            label,
            style: TextStyle(
              color: AppColors.textLabel,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              height: 20 / 14,
              letterSpacing: -0.154,
            ),
          ),
        ],
      ),
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
        const Divider(color: AppColors.border, height: 1, thickness: 1),
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
              label: isEditing ? 'Update Vendor' : 'Create Vendor',
              variant: AppButtonVariant.primary,
              onPressed: onSubmit,
            ),
          ],
        ),
      ],
    );
  }
}
