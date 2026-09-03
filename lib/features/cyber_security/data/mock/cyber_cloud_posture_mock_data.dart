import 'package:grc/core/models/cyber_security/cloud_posture/cloud_account_model.dart';
import 'package:grc/core/models/cyber_security/cloud_posture/finding_item_model.dart';
import 'package:grc/core/models/cyber_security/cloud_posture/compliance_mapping_model.dart';
import 'package:grc/core/models/cyber_security/cloud_posture/scan_history_model.dart';
import 'package:grc/core/constants/app_colors.dart';

class CyberCloudPostureMockData {
  CyberCloudPostureMockData._();

  static List<CloudAccountModel> getMockAccounts() => [
    const CloudAccountModel(
      name: 'AWS Production',
      platform: CloudPlatform.aws,
      accountId: '123456789012',
      region: 'us-east-1',
      healthStatus: 'healthy',
      healthColor: AppColors.cyberLiveGreen,
      riskScore: 89,
      riskScoreColor: AppColors.cyberCritical,
      criticalCount: 4,
      highCount: 5,
      mediumCount: 6,
      lowCount: 5,
      totalResources: 847,
      lastScan: '28 Jun 16:30',
    ),
    const CloudAccountModel(
      name: 'GCP Production',
      platform: CloudPlatform.gcp,
      accountId: 'cybershield-prod',
      region: 'us-central1',
      healthStatus: 'warning',
      healthColor: AppColors.cyberHigh,
      riskScore: 72,
      riskScoreColor: AppColors.cyberHigh,
      criticalCount: 0,
      highCount: 2,
      mediumCount: 3,
      lowCount: 2,
      totalResources: 312,
      lastScan: '28 Jun 16:28',
    ),
    const CloudAccountModel(
      name: 'Azure Production',
      platform: CloudPlatform.azure,
      accountId: 'a1b2c3d4-ef56-7890',
      region: 'eastus',
      healthStatus: 'warning',
      healthColor: AppColors.cyberHigh,
      riskScore: 65,
      riskScoreColor: AppColors.cyberHigh,
      criticalCount: 0,
      highCount: 2,
      mediumCount: 2,
      lowCount: 2,
      totalResources: 218,
      lastScan: '28 Jun 16:25',
    ),
    const CloudAccountModel(
      name: 'AWS Development',
      platform: CloudPlatform.aws,
      accountId: '987654321098',
      region: 'eu-west-1',
      healthStatus: 'healthy',
      healthColor: AppColors.cyberLiveGreen,
      riskScore: 42,
      riskScoreColor: AppColors.cyberMedium,
      criticalCount: 0,
      highCount: 0,
      mediumCount: 3,
      lowCount: 3,
      totalResources: 156,
      lastScan: '28 Jun 16:20',
    ),
  ];

  static List<FindingItemModel> getMockFindings() => [
    const FindingItemModel(
      id: 'F-2401',
      resource: 's3://prod-customer-data-2026',
      finding: 'S3 Bucket Publicly Readable',
      severity: FindingSeverity.critical,
      account: 'AWS Production',
      service: 'S3',
      riskScore: 98,
      age: '2d',
      status: FindingStatus.open,
      resourceUri: 'arn:aws:s3:::prod-customer-data-2026',
      aiRiskExplanation:
          'Bucket ACL allows AllUsers READ permissions. Automated scanner identified 847 GB of sensitive customer analytics data accessible over public internet without authentication.',
      remediationSteps: [
        'Enable S3 Block Public Access at bucket and account level',
        'Update bucket ACL to private',
        'Verify bucket policy does not contain Principal: *',
        'Enable server access logging to review past unauthorized requests',
      ],
      controlMappings: {
        'NIST CSF': 'PR.DS-1',
        'CIS Controls': '3.4',
        'ISO 27001': 'A.13.1.1',
        'SOC 2': 'CC6.1',
      },
      similarFindings: [
        SimilarFinding(
          severity: 'CRITICAL',
          id: 'F-2404',
          title: 'Database Exposed to Internet',
          color: AppColors.cyberCritical,
        ),
        SimilarFinding(
          severity: 'HIGH',
          id: 'F-2405',
          title: 'Kubernetes Dashboard Exposed',
          color: AppColors.cyberHigh,
        ),
      ],
    ),
    const FindingItemModel(
      id: 'F-2402',
      resource: 'sg-0a1b2c3d4e5f6g7h8',
      finding: 'RDP Port 3389 Open to 0.0.0.0/0',
      severity: FindingSeverity.critical,
      account: 'AWS Production',
      service: 'EC2',
      riskScore: 95,
      age: '4d',
      status: FindingStatus.open,
      resourceUri:
          'arn:aws:ec2:us-east-1:123456789012:security-group/sg-0a1b2c3d4e5f6g7h8',
      aiRiskExplanation:
          'Inbound security group rule allows unrestricted RDP access from any IP address. Exposes Windows bastion host to brute-force credential stuffing and ransomware attacks.',
      remediationSteps: [
        'Remove inbound rule for 0.0.0.0/0 on port 3389',
        'Restrict access to corporate VPN IP ranges only',
        'Deploy AWS Systems Manager Session Manager for remote access',
      ],
      controlMappings: {
        'NIST CSF': 'PR.AC-5',
        'CIS Controls': '3.3',
        'ISO 27001': 'A.13.1.3',
        'SOC 2': 'CC6.6',
      },
    ),
    const FindingItemModel(
      id: 'F-2403',
      resource: 'root-account-access-key-01',
      finding: 'Root Account API Access Key Active',
      severity: FindingSeverity.critical,
      account: 'AWS Production',
      service: 'IAM',
      riskScore: 92,
      age: '7d',
      status: FindingStatus.remediating,
      resourceUri: 'arn:aws:iam::123456789012:root',
      aiRiskExplanation:
          'Root account has active programmatic API access keys. Root credentials bypass all SCPs and IAM restrictions. Compromise results in total account takeover.',
      remediationSteps: [
        'Delete root access keys immediately',
        'Use IAM Identity Center or temporary STS credentials with role assumption',
        'Enable hardware MFA for root account',
      ],
      controlMappings: {
        'NIST CSF': 'PR.AC-1',
        'CIS Controls': '1.4',
        'ISO 27001': 'A.9.2.3',
        'SOC 2': 'CC6.3',
      },
    ),
  ];

  static List<ComplianceFindingMappingModel> getMockComplianceFindings() =>
      const [
        ComplianceFindingMappingModel(
          id: 'F-2401',
          type: 'Public Storage Bucket',
          severity: FindingSeverity.critical,
          nistCsf: 'PR.DS-1',
          cisControls: '3.4',
          iso27001: 'A.13.1.1',
          soc2: 'CC6.1',
        ),
        ComplianceFindingMappingModel(
          id: 'F-2402',
          type: 'RDP Exposed to 0.0.0.0/0',
          severity: FindingSeverity.critical,
          nistCsf: 'PR.AC-5',
          cisControls: '3.3',
          iso27001: 'A.13.1.3',
          soc2: 'CC6.6',
        ),
      ];

  static List<ScanHistoryModel> getMockScanHistory() => const [
    ScanHistoryModel(
      scanId: 'SCN-8847',
      dateTime: '2026-06-28 16:30',
      duration: '4m 12s',
      newFindings: 2,
      fixedFindings: -5,
      totalFindings: 312,
      resourcesScanned: 1533,
      status: 'completed',
      isLatest: true,
    ),
    ScanHistoryModel(
      scanId: 'SCN-8846',
      dateTime: '2026-06-27 16:30',
      duration: '4m 08s',
      newFindings: 5,
      fixedFindings: -3,
      totalFindings: 315,
      resourcesScanned: 1521,
      status: 'completed',
    ),
  ];
}
