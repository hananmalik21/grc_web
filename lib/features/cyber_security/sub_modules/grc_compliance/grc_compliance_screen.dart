import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/features/cyber_security/sub_modules/grc_compliance/dialogs/generate_policy_dialog.dart';
import 'package:grc/features/cyber_security/sub_modules/grc_compliance/models/compliance_framework_model.dart';
import 'package:grc/features/cyber_security/sub_modules/grc_compliance/widgets/compliance_controls_table.dart';
import 'package:grc/features/cyber_security/sub_modules/grc_compliance/widgets/framework_cards_row.dart';

class GrcComplianceScreen extends StatefulWidget {
  const GrcComplianceScreen({super.key});

  @override
  State<GrcComplianceScreen> createState() => _GrcComplianceScreenState();
}

class _GrcComplianceScreenState extends State<GrcComplianceScreen> {
  final List<ComplianceFrameworkModel> _frameworks =
      ComplianceFrameworkModel.getMockFrameworks();
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Color(0xFF131D31),
        content: Text(
          'SOC 2 & NIST CSF continuous audit report compiled and exported to PDF/ZIP.',
          style: TextStyle(color: Color(0xFF00B4D8)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    final padding = ResponsiveHelper.getPagePadding(context);

    final titleSection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'GRC & Compliance',
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 18.sp : 22.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Gap(4),
        Text(
          'Control mapping, evidence management, and framework compliance',
          style: TextStyle(
            color: const Color(0xFF94A3B8),
            fontSize: isMobile ? 11.sp : 12.sp,
          ),
        ),
      ],
    );

    final actionsSection = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // + Generate Policy
        InkWell(
          onTap: _openGeneratePolicyDialog,
          borderRadius: BorderRadius.circular(6.r),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 8.h,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF131D31),
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(color: const Color(0xFF1E293B)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.add_rounded,
                  size: 14.sp,
                  color: const Color(0xFFCBD5E1),
                ),
                const Gap(6),
                Text(
                  'Generate Policy',
                  style: TextStyle(
                    color: const Color(0xFFCBD5E1),
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        const Gap(10),

        // Audit Report Button
        InkWell(
          onTap: _exportAuditReport,
          borderRadius: BorderRadius.circular(6.r),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 8.h,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF131D31),
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(color: const Color(0xFF1E293B)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.file_download_outlined,
                  size: 14.sp,
                  color: const Color(0xFFCBD5E1),
                ),
                const Gap(6),
                Text(
                  'Audit Report',
                  style: TextStyle(
                    color: const Color(0xFFCBD5E1),
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );

    return SingleChildScrollView(
      padding: padding.copyWith(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          if (isMobile) ...[
            titleSection,
            const Gap(12),
            actionsSection,
          ] else ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: titleSection),
                actionsSection,
              ],
            ),
          ],
          const Gap(20),

          // 5 Top Framework Cards Row
          FrameworkCardsRow(
            frameworks: _frameworks,
            selectedFrameworkId: _selectedFramework.id,
            onSelectFramework: (fw) {
              setState(() => _selectedFramework = fw);
            },
          ),
          const Gap(24),

          // Control Sample Table
          ComplianceControlsTable(
            framework: _selectedFramework,
          ),
        ],
      ),
    );
  }
}
