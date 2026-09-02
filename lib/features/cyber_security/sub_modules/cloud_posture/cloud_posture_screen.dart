import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/models/cyber_security/cloud_posture/cloud_account_model.dart';
import 'package:grc/core/models/cyber_security/cloud_posture/compliance_mapping_model.dart';
import 'package:grc/core/models/cyber_security/cloud_posture/finding_item_model.dart';
import 'package:grc/core/models/cyber_security/cloud_posture/scan_history_model.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/features/cyber_security/data/mock/cyber_cloud_posture_mock_data.dart';
import 'package:grc/features/cyber_security/presentation/widgets/cyber_screen_layout.dart';
import 'package:grc/features/cyber_security/sub_modules/cloud_posture/dialogs/create_remediation_ticket_dialog.dart';
import 'package:grc/features/cyber_security/sub_modules/cloud_posture/dialogs/finding_detail_modal.dart';
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
  late List<CloudAccountModel> _accounts;
  late List<ComplianceFindingMappingModel> _complianceFindings;
  late List<ScanHistoryModel> _scanHistory;

  @override
  void initState() {
    super.initState();
    _allFindings = CyberCloudPostureMockData.getMockFindings();
    _accounts = CyberCloudPostureMockData.getMockAccounts();
    _complianceFindings = CyberCloudPostureMockData.getMockComplianceFindings();
    _scanHistory = CyberCloudPostureMockData.getMockScanHistory();
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

  void _showFindingDetail(FindingItemModel finding) {
    FindingDetailModal.show(
      context,
      finding: finding,
      onCreateTicket: () {
        CreateRemediationTicketDialog.show(context, finding: finding);
      },
    );
  }

  void _triggerScan() {
    ToastService.show(
      context: context,
      message: 'Cloud posture scan initiated across AWS, GCP & Azure...',
      type: ToastType.info,
    );
  }

  void _exportReport() {
    ToastService.show(
      context: context,
      message: 'Cloud security posture report exported successfully.',
      type: ToastType.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CyberScreenLayout(
      title: 'Cloud Posture',
      subtitle: 'Multi-cloud inventory, misconfigurations, and compliance findings',
      actions: [
        AppButton(
          label: 'Scan Now',
          type: AppButtonType.primary,
          size: AppButtonSize.sm,
          onPressed: _triggerScan,
        ),
        const Gap(8),
        AppButton(
          label: 'Export',
          type: AppButtonType.secondary,
          size: AppButtonSize.sm,
          onPressed: _exportReport,
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CloudPostureKpiRow(),
          const Gap(20),
          CloudPostureTabBar(
            activeIndex: _activeSubTabIndex,
            onTabChanged: (index) {
              setState(() {
                _activeSubTabIndex = index;
              });
            },
          ),
          const Gap(16),
          if (_activeSubTabIndex == 0) ...[
            CloudPostureFilters(
              searchQuery: _searchQuery,
              onSearchChanged: (v) => setState(() => _searchQuery = v),
              selectedSeverity: _selectedSeverity,
              onSeverityChanged: (v) => setState(() => _selectedSeverity = v),
              selectedAccount: _selectedAccount,
              onAccountChanged: (v) => setState(() => _selectedAccount = v),
              selectedService: _selectedService,
              onServiceChanged: (v) => setState(() => _selectedService = v),
              selectedStatus: _selectedStatus,
              onStatusChanged: (v) => setState(() => _selectedStatus = v),
            ),
            const Gap(14),
            CloudPostureFindingsTable(
              findings: _filteredFindings,
              onOpenDetail: _showFindingDetail,
              onCreateTicket: (finding) {
                CreateRemediationTicketDialog.show(context, finding: finding);
              },
            ),
          ] else if (_activeSubTabIndex == 1) ...[
            CloudPostureAccountsView(accounts: _accounts),
          ] else if (_activeSubTabIndex == 2) ...[
            CloudPostureComplianceView(complianceFindings: _complianceFindings),
          ] else if (_activeSubTabIndex == 3) ...[
            CloudPostureScanHistoryView(scanHistory: _scanHistory),
          ],
        ],
      ),
    );
  }
}
