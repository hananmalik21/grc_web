import 'package:grc/core/models/cyber_security/incidents/incident_item_model.dart';

class CyberIncidentsMockData {
  CyberIncidentsMockData._();

  static const List<IncidentItemModel> mockIncidents = [
    IncidentItemModel(
      id: 'INC-2847',
      title: 'Suspicious Login from Tor Exit Node',
      severity: IncidentSeverity.high,
      status: IncidentStatus.investigating,
      owner: 'P. Nair',
      createdDate: '28 Jun 14:23',
      mitreCode: 'T1078',
      description:
          '47 failed logins followed by successful auth from Frankfurt Tor node for Finance Analyst account.',
      evidence: [
        'User: j.martinez@corp.com',
        'Source IP: 185.220.101.47 (Tor Exit Node)',
        'MFA: Disabled on target account',
      ],
      containmentSteps: [
        'Temporarily disable account j.martinez',
        'Block IP 185.220.101.0/24 at perimeter WAF',
        'Force password reset with out-of-band notification',
      ],
    ),
    IncidentItemModel(
      id: 'INC-2846',
      title: 'Mass File Download — SharePoint Online',
      severity: IncidentSeverity.critical,
      status: IncidentStatus.open,
      owner: 'Unassigned',
      createdDate: '28 Jun 13:51',
      mitreCode: 'T1048',
      description:
          '4.7 GB downloaded across 2,847 files in 23 minutes by departing employee.',
      evidence: [
        'User: a.thompson@corp.com (Last day: 2026-06-30)',
        'Volume: 4.7 GB (Excel 47%, PDF 31%, Word 22%)',
        'Device: Unenrolled personal laptop',
      ],
      containmentSteps: [
        'Suspend SaaS account access',
        'Block personal cloud sync via DLP policy',
        'Apply legal hold on M365 logs',
      ],
    ),
    IncidentItemModel(
      id: 'INC-2845',
      title: 'Lateral Movement — Internal SSH Scanning',
      severity: IncidentSeverity.high,
      status: IncidentStatus.contained,
      owner: 'A. Wong',
      createdDate: '27 Jun 22:14',
      mitreCode: 'T1021',
      description:
          'Compromised staging container attempted rapid SSH sweeps across internal RFC 1918 subnets.',
      evidence: [
        'Host: k8s-node-staging-04',
        'Port Scanned: TCP 22, 445',
        'Firewall: Microsegmentation rules dropped 98% of packets',
      ],
      containmentSteps: [
        'Isolated staging pod and killed malicious container instance',
        'Rotated cluster node service credentials',
      ],
    ),
    IncidentItemModel(
      id: 'INC-2844',
      title: 'API Key Leaked in Public GitHub Repo',
      severity: IncidentSeverity.critical,
      status: IncidentStatus.resolved,
      owner: 'C. Rodriguez',
      createdDate: '27 Jun 09:33',
      mitreCode: 'T1552',
      description:
          'AWS secret key committed in public open-source repository by contractor.',
      evidence: [
        'Repository: github.com/external-dev/frontend-demo',
        'Detected in: 4 minutes via secret scanner',
      ],
      containmentSteps: [
        'AWS IAM access key automatically invalidated and rotated',
        'CloudTrail confirmed zero unauthorized API calls executed',
      ],
    ),
    IncidentItemModel(
      id: 'INC-2843',
      title: 'Privilege Escalation — IAM Role Modification',
      severity: IncidentSeverity.high,
      status: IncidentStatus.open,
      owner: 'Unassigned',
      createdDate: '26 Jun 18:07',
      mitreCode: 'T1548',
      description:
          'Service account granted roles/owner without an approved change management request.',
      evidence: [
        'Principal: svc-cicd-runner@grc-cloud.iam',
        'Role: roles/owner (Project Level)',
        'Change Window: Outside standard deployment schedule',
      ],
      containmentSteps: [
        'Revoke roles/owner binding',
        'Audit session activity from service account',
      ],
    ),
    IncidentItemModel(
      id: 'INC-2842',
      title: 'Malware Detected — Endpoint EP-WKS-047',
      severity: IncidentSeverity.critical,
      status: IncidentStatus.resolved,
      owner: 'P. Nair',
      createdDate: '25 Jun 11:22',
      mitreCode: 'T1059',
      description:
          'Ransomware executable blocked and quarantined by endpoint detection agent.',
      evidence: [
        'Host: DESKTOP-ENG-4491',
        'Hash: sha256:4b9a102...',
        'Block Time: 120ms',
      ],
      containmentSteps: ['Host isolated and re-imaged with clean golden image'],
    ),
  ];
}
