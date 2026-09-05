import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/models/cyber_security/grc_compliance/compliance_framework_model.dart';
import 'package:grc/core/permissions/permission_gate.dart';
import 'package:grc/core/permissions/perm_keys.dart';
import 'package:grc/core/permissions/permission_service.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/features/cyber_security/presentation/widgets/cyber_screen_layout.dart';
import 'package:grc/features/cyber_security/presentation/providers/compliance_provider.dart';
import 'package:grc/features/cyber_security/sub_modules/grc_compliance/dialogs/generate_policy_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/features/cyber_security/sub_modules/grc_compliance/widgets/compliance_controls_table.dart';
import 'package:grc/features/cyber_security/sub_modules/grc_compliance/widgets/framework_cards_row.dart';

class GrcComplianceScreen extends ConsumerStatefulWidget {
  const GrcComplianceScreen({super.key});

  @override
  ConsumerState<GrcComplianceScreen> createState() =>
      _GrcComplianceScreenState();
}

class _GrcComplianceScreenState extends ConsumerState<GrcComplianceScreen> {
  String? _localSelectedId;

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
          description:
              'Physical devices and systems within the organization are inventoried.',
          automatedEvidence:
              'Agent discovery synced 14,820 assets with MDM and CMDB inventory.',
        ),
        ControlItemModel(
          controlId: 'CSF-ID.AM-2',
          controlName: 'Software platforms and applications inventory',
          status: ControlStatus.pass,
          score: 100,
          frameworkId: 'nist',
          description:
              'Software platforms and applications within the organization are inventoried.',
          automatedEvidence:
              'Continuous CI/CD package provenance and image catalog scanner active.',
        ),
        ControlItemModel(
          controlId: 'CSF-PR.AC-1',
          controlName: 'Identities and credentials management',
          status: ControlStatus.partial,
          score: 65,
          frameworkId: 'nist',
          description:
              'Identities and credentials are managed for authorized devices and users.',
          automatedEvidence:
              '18 overprivileged roles and 7 inactive credentials (>90d) flagged for rotation.',
        ),
        ControlItemModel(
          controlId: 'CSF-PR.AC-7',
          controlName: 'Users, devices, and assets authentication',
          status: ControlStatus.fail,
          score: 30,
          frameworkId: 'nist',
          description:
              'Users, devices, and other assets are authenticated commensurate with the risk.',
          automatedEvidence:
              'MFA missing on 2 legacy AWS member staging accounts.',
        ),
        ControlItemModel(
          controlId: 'CSF-PR.DS-1',
          controlName: 'Data-at-rest protection',
          status: ControlStatus.pass,
          score: 88,
          frameworkId: 'nist',
          description:
              'Data-at-rest is protected using cryptographic mechanisms.',
          automatedEvidence:
              '100% of discovered datastores encrypted with AWS KMS / AES-256.',
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

  void _openGeneratePolicyDialog() {
    showDialog(
      context: context,
      builder: (ctx) => const GeneratePolicyDialog(),
    );
  }

  void _exportAuditReport() {
    ToastService.show(
      context: context,
      message:
          'SOC 2 & NIST CSF continuous audit report compiled and exported to PDF/ZIP.',
      type: ToastType.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!PermissionService.instance.can(CyberPermKeys.complianceRead)) {
      return PermissionGate(
        permKey: CyberPermKeys.complianceRead,
        fallback: CyberScreenLayout(
          title: 'GRC & Compliance',
          subtitle: 'You do not have permission to view compliance data.',
          child: const SizedBox.shrink(),
        ),
        child: const SizedBox.shrink(),
      );
    }
    final complianceState = ref.watch(complianceProvider);
    final frameworks = complianceState.frameworks.isNotEmpty
        ? complianceState.frameworks
        : _frameworks
              .map(
                (framework) => ComplianceFrameworkModel(
                  id: framework.id,
                  name: framework.name,
                  readinessScore: 0,
                  progressColor: framework.progressColor,
                  passingCount: 0,
                  failingCount: 0,
                  partialCount: 0,
                  totalControls: 0,
                  controls: const [],
                ),
              )
              .toList();
    final selected =
        frameworks
            .where(
              (framework) =>
                  framework.id == (_localSelectedId ?? complianceState.selectedFrameworkId),
            )
            .firstOrNull ??
        frameworks.first;
    return CyberScreenLayout(
      title: 'GRC & Compliance',
      subtitle:
          'Continuous controls validation, audit readiness, and policy enforcement',
      actions: [
        _ScreenActionButton(
          label: 'Export Audit Bundle',
          icon: Icons.download_rounded,
          onTap: _exportAuditReport,
        ),
        const Gap(8),
        _ScreenActionButton(
          label: 'Generate Policy',
          icon: Icons.add_rounded,
          isPrimary: true,
          onTap: PermissionService.instance.can(CyberPermKeys.complianceCreate)
              ? _openGeneratePolicyDialog
              : null,
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FrameworkCardsRow(
            frameworks: frameworks,
            selectedFrameworkId: selected.id,
            onSelectFramework: (framework) {
              setState(() => _localSelectedId = framework.id);
              ref
                  .read(complianceProvider.notifier)
                  .selectFramework(framework.id);
            },
          ),
          const Gap(24),
          ComplianceControlsTable(framework: selected),
        ],
      ),
    );
  }
}

class _ScreenActionButton extends StatelessWidget {
  final IconData? icon;
  final String label;
  final VoidCallback? onTap;
  final bool isPrimary;

  const _ScreenActionButton({
    this.icon,
    required this.label,
    this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
          decoration: BoxDecoration(
            color: isPrimary
                ? AppColors.dashCyberSecurity.withValues(alpha: 0.15)
                : const Color(0xFF1E293B).withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: isPrimary
                  ? AppColors.dashCyberSecurity.withValues(alpha: 0.5)
                  : const Color(0xFF334155),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 14.sp,
                  color: isPrimary ? AppColors.dashCyberSecurity : const Color(0xFFCBD5E1),
                ),
                const Gap(6),
              ],
              Text(
                label,
                style: TextStyle(
                  color: isPrimary ? AppColors.dashCyberSecurity : const Color(0xFFCBD5E1),
                  fontSize: 12.sp,
                  fontWeight: isPrimary ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
