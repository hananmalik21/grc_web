import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/models/cyber_security/grc_compliance/compliance_framework_model.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/features/cyber_security/presentation/widgets/cyber_screen_layout.dart';
import 'package:grc/features/cyber_security/sub_modules/grc_compliance/dialogs/generate_policy_dialog.dart';
import 'package:grc/features/cyber_security/sub_modules/grc_compliance/widgets/compliance_controls_table.dart';
import 'package:grc/features/cyber_security/sub_modules/grc_compliance/widgets/framework_cards_row.dart';

class GrcComplianceScreen extends StatefulWidget {
  const GrcComplianceScreen({super.key});

  @override
  State<GrcComplianceScreen> createState() => _GrcComplianceScreenState();
}

class _GrcComplianceScreenState extends State<GrcComplianceScreen> {
  final List<ComplianceFrameworkModel> _frameworks = [
    const ComplianceFrameworkModel(
      id: 'nist',
      name: 'NIST CSF 2.0',
      readinessScore: 73,
      progressColor: Color(0xFF00B4D8),
      passingCount: 78,
      failingCount: 17,
      partialCount: 11,
      totalControls: 106,
      controls: [
        ControlItemModel(
          controlId: 'CSF-ID.AM-1',
          controlName: 'Physical device and systems inventory',
          status: ControlStatus.pass,
          score: 100,
          frameworkId: 'nist',
          description: 'Physical devices and systems within the organization are inventoried.',
          automatedEvidence: 'Agent discovery synced 14,820 assets with MDM and CMDB inventory.',
        ),
        ControlItemModel(
          controlId: 'CSF-ID.AM-2',
          controlName: 'Software platforms and applications inventory',
          status: ControlStatus.pass,
          score: 100,
          frameworkId: 'nist',
          description: 'Software platforms and applications within the organization are inventoried.',
          automatedEvidence: 'Continuous CI/CD package provenance and image catalog scanner active.',
        ),
        ControlItemModel(
          controlId: 'CSF-PR.AC-1',
          controlName: 'Identities and credentials management',
          status: ControlStatus.partial,
          score: 65,
          frameworkId: 'nist',
          description: 'Identities and credentials are managed for authorized devices and users.',
          automatedEvidence: '18 overprivileged roles and 7 inactive credentials (>90d) flagged for rotation.',
        ),
        ControlItemModel(
          controlId: 'CSF-PR.AC-7',
          controlName: 'Users, devices, and assets authentication',
          status: ControlStatus.fail,
          score: 30,
          frameworkId: 'nist',
          description: 'Users, devices, and other assets are authenticated commensurate with the risk.',
          automatedEvidence: 'MFA missing on 2 legacy AWS member staging accounts.',
        ),
        ControlItemModel(
          controlId: 'CSF-PR.DS-1',
          controlName: 'Data-at-rest protection',
          status: ControlStatus.pass,
          score: 88,
          frameworkId: 'nist',
          description: 'Data-at-rest is protected using cryptographic mechanisms.',
          automatedEvidence: '100% of discovered datastores encrypted with AWS KMS / AES-256.',
        ),
      ],
    ),
    const ComplianceFrameworkModel(
      id: 'cis',
      name: 'CIS CONTROLS V8',
      readinessScore: 81,
      progressColor: Color(0xFF38BDF8),
      passingCount: 124,
      failingCount: 18,
      partialCount: 11,
      totalControls: 153,
      controls: [],
    ),
    const ComplianceFrameworkModel(
      id: 'iso',
      name: 'ISO 27001:2022',
      readinessScore: 68,
      progressColor: Color(0xFFA855F7),
      passingCount: 63,
      failingCount: 21,
      partialCount: 9,
      totalControls: 93,
      controls: [],
    ),
    const ComplianceFrameworkModel(
      id: 'soc2',
      name: 'SOC 2 TYPE II',
      readinessScore: 85,
      progressColor: Color(0xFF10B981),
      passingCount: 54,
      failingCount: 7,
      partialCount: 3,
      totalControls: 64,
      controls: [],
    ),
    const ComplianceFrameworkModel(
      id: 'csa',
      name: 'CSA CCM V4',
      readinessScore: 62,
      progressColor: Color(0xFFF59E0B),
      passingCount: 122,
      failingCount: 51,
      partialCount: 24,
      totalControls: 197,
      controls: [],
    ),
  ];

  late ComplianceFrameworkModel _selectedFramework;

  @override
  void initState() {
    super.initState();
    _selectedFramework = _frameworks.first;
  }

  void _openGeneratePolicyDialog() {
    showDialog(
      context: context,
      builder: (ctx) => const GeneratePolicyDialog(),
    );
  }

  void _exportAuditReport() {
    ToastService.show(
      context: context,
      message: 'SOC 2 & NIST CSF continuous audit report compiled and exported to PDF/ZIP.',
      type: ToastType.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CyberScreenLayout(
      title: 'GRC & Compliance',
      subtitle: 'Continuous controls validation, audit readiness, and policy enforcement',
      actions: [
        AppButton(
          label: 'Export Audit Bundle',
          type: AppButtonType.secondary,
          size: AppButtonSize.sm,
          onPressed: _exportAuditReport,
        ),
        const Gap(8),
        AppButton(
          label: 'Generate Policy',
          type: AppButtonType.primary,
          size: AppButtonSize.sm,
          onPressed: _openGeneratePolicyDialog,
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FrameworkCardsRow(
            frameworks: _frameworks,
            selectedFrameworkId: _selectedFramework.id,
            onSelectFramework: (framework) {
              setState(() {
                _selectedFramework = framework;
              });
            },
          ),
          const Gap(24),
          ComplianceControlsTable(framework: _selectedFramework),
        ],
      ),
    );
  }
}
