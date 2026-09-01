import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/features/cyber_security/sub_modules/cloud_posture/dialogs/create_remediation_ticket_dialog.dart';
import 'package:grc/features/cyber_security/sub_modules/cloud_posture/dialogs/finding_detail_modal.dart';
import 'package:grc/features/cyber_security/sub_modules/cloud_posture/models/finding_item_model.dart';
import 'package:grc/features/cyber_security/sub_modules/cloud_posture/widgets/cloud_posture_accounts_view.dart';
import 'package:grc/features/cyber_security/sub_modules/cloud_posture/widgets/cloud_posture_compliance_view.dart';
import 'package:grc/features/cyber_security/sub_modules/cloud_posture/widgets/cloud_posture_filters.dart';
import 'package:grc/features/cyber_security/sub_modules/cloud_posture/widgets/cloud_posture_findings_table.dart';
import 'package:grc/features/cyber_security/sub_modules/cloud_posture/widgets/cloud_posture_kpi_row.dart';
import 'package:grc/features/cyber_security/sub_modules/cloud_posture/widgets/cloud_posture_scan_history_view.dart';
import 'package:grc/features/cyber_security/sub_modules/cloud_posture/widgets/cloud_posture_tab_bar.dart';

class CloudPostureScreen extends StatefulWidget {
  const CloudPostureScreen({super.key});

  @override
  State<CloudPostureScreen> createState() => _CloudPostureScreenState();
}

class _CloudPostureScreenState extends State<CloudPostureScreen> {
  int _activeSubTabIndex = 0;
  String _searchQuery = '';
  String _selectedSeverity = 'ALL';
  String _selectedAccount = 'All accounts';
  String _selectedService = 'All services';
  String _selectedStatus = 'All statuses';

  late List<FindingItemModel> _allFindings;

  @override
  void initState() {
    super.initState();
    _allFindings = FindingItemModel.getMockFindings();
  }

  List<FindingItemModel> get _filteredFindings {
    return _allFindings.where((f) {
      if (_selectedSeverity != 'ALL' && f.severity.name.toUpperCase() != _selectedSeverity) {
        return false;
      }
      if (_selectedAccount != 'All accounts' && f.account != _selectedAccount) {
        return false;
      }
      if (_selectedService != 'All services' && f.service != _selectedService) {
        return false;
      }
      if (_selectedStatus != 'All statuses' && f.status.label != _selectedStatus) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final match = f.id.toLowerCase().contains(q) ||
            f.resource.toLowerCase().contains(q) ||
            f.finding.toLowerCase().contains(q);
        if (!match) return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    final padding = ResponsiveHelper.getPagePadding(context);

    final titleSection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cloud Security Posture',
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 18.sp : 22.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Gap(3),
        Text(
          'AI-powered misconfiguration detection across AWS, GCP, and Azure',
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
        _buildHeaderButton(
          icon: Icons.sync_rounded,
          label: 'Scan Now',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Color(0xFF131D31),
                content: Text(
                  'Cloud posture scan initiated across AWS, GCP & Azure...',
                  style: TextStyle(color: Color(0xFF00B4D8)),
                ),
              ),
            );
          },
        ),
        const Gap(10),
        _buildHeaderButton(
          icon: Icons.download_rounded,
          label: 'Export',
          onTap: () {},
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

          // 4 Top Posture KPI Cards
          const CloudPostureKpiRow(),

          const Gap(24),

          // 4 Sub-Tabs Navigation Bar
          CloudPostureTabBar(
            activeIndex: _activeSubTabIndex,
            onTabChanged: (index) {
              setState(() => _activeSubTabIndex = index);
            },
          ),

          const Gap(16),

          // Dynamic Tab Content
          if (_activeSubTabIndex == 0) ...[
            // Filters Bar
            CloudPostureFilters(
              searchQuery: _searchQuery,
              onSearchChanged: (q) => setState(() => _searchQuery = q),
              selectedSeverity: _selectedSeverity,
              onSeverityChanged: (sev) => setState(() => _selectedSeverity = sev),
              selectedAccount: _selectedAccount,
              onAccountChanged: (acc) => setState(() => _selectedAccount = acc),
              selectedService: _selectedService,
              onServiceChanged: (srv) => setState(() => _selectedService = srv),
              selectedStatus: _selectedStatus,
              onStatusChanged: (st) => setState(() => _selectedStatus = st),
            ),
            const Gap(14),

            // Findings Table
            CloudPostureFindingsTable(
              findings: _filteredFindings,
              onOpenDetail: (finding) {
                FindingDetailModal.show(
                  context,
                  finding: finding,
                  onCreateTicket: () {
                    CreateRemediationTicketDialog.show(context, finding: finding);
                  },
                );
              },
              onCreateTicket: (finding) {
                CreateRemediationTicketDialog.show(context, finding: finding);
              },
            ),
          ] else if (_activeSubTabIndex == 1) ...[
            CloudPostureAccountsView(
              onFilterFindings: () {
                setState(() => _activeSubTabIndex = 0);
              },
            ),
          ] else if (_activeSubTabIndex == 2) ...[
            CloudPostureComplianceView(
              onOpenDetail: (finding) {
                FindingDetailModal.show(
                  context,
                  finding: finding,
                  onCreateTicket: () {
                    CreateRemediationTicketDialog.show(context, finding: finding);
                  },
                );
              },
            ),
          ] else if (_activeSubTabIndex == 3) ...[
            const CloudPostureScanHistoryView(),
          ],
        ],
      ),
    );
  }

  Widget _buildHeaderButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
        decoration: BoxDecoration(
          color: const Color(0xFF131D31),
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(color: const Color(0xFF1E293B)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14.sp, color: const Color(0xFFCBD5E1)),
            const Gap(6),
            Text(
              label,
              style: TextStyle(
                color: const Color(0xFFCBD5E1),
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
