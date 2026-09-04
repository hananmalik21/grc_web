import 'package:flutter/material.dart';

enum FindingSeverity {
  critical('CRITICAL', Color(0xFFEF4444)),
  high('HIGH', Color(0xFFF97316)),
  medium('MEDIUM', Color(0xFFFBBF24)),
  low('LOW', Color(0xFF38BDF8));

  final String label;
  final Color color;
  const FindingSeverity(this.label, this.color);
}

enum FindingStatus {
  open('Open', Color(0xFFEF4444)),
  remediating('Remediating', Color(0xFFA855F7)),
  resolved('Resolved', Color(0xFF10B981)),
  acknowledged('Acknowledged', Color(0xFF64748B));

  final String label;
  final Color color;
  const FindingStatus(this.label, this.color);
}

class FindingItemModel {
  final String id;
  final String resource;
  final String finding;
  final FindingSeverity severity;
  final String account;
  final String service;
  final int riskScore;
  final String age;
  final FindingStatus status;
  final String? resourceUri;
  final String? aiRiskExplanation;
  final List<String> remediationSteps;
  final Map<String, String> controlMappings;
  final List<SimilarFinding> similarFindings;

  const FindingItemModel({
    required this.id,
    required this.resource,
    required this.finding,
    required this.severity,
    required this.account,
    required this.service,
    required this.riskScore,
    required this.age,
    required this.status,
    this.resourceUri,
    this.aiRiskExplanation,
    this.remediationSteps = const [],
    this.controlMappings = const {},
    this.similarFindings = const [],
  });

  static List<FindingItemModel> getMockFindings() => [
    FindingItemModel(
      id: 'F-2401',
      resource: 's3://prod-customer-data',
      finding: 'Public Storage Bucket',
      severity: FindingSeverity.critical,
      account: 'AWS Production',
      service: 'S3',
      riskScore: 97,
      age: '8d',
      status: FindingStatus.open,
      resourceUri: 's3://prod-customer-data',
      aiRiskExplanation:
          'The S3 bucket has a public-read ACL making all 847 GB of customer PII accessible to any Internet user without authentication. CloudTrail shows 14 external IPs accessed the bucket during the 8-day exposure window. Automated scanners index newly exposed buckets within minutes — this is the #1 source of enterprise cloud data breaches.',
      remediationSteps: [
        'Remove public-read ACL immediately: aws s3api put-bucket-acl --bucket prod-customer-data --acl private',
        'Enable S3 Block Public Access at account level to prevent future misconfigurations',
        'Review bucket policy for any Statement with Principal * and remove them',
        'Audit CloudTrail logs for the 8-day window — collect all external IP accesses as legal evidence',
        'Notify DPO and Legal — GDPR Article 33 requires supervisory authority notification within 72 hours if EU data was accessed',
        'Enable Amazon Macie to continuously classify S3 buckets for future sensitive data exposure',
      ],
      controlMappings: {
        'NIST CSF': 'PR.DS-1',
        'CIS Controls': '3.4',
        'ISO 27001': 'A.13.1.1',
        'SOC 2': 'CC6.1',
      },
      similarFindings: const [
        SimilarFinding(severity: 'MEDIUM', id: 'F-2418', title: 'Bucket Encryption Disabled', color: Color(0xFFFBBF24)),
        SimilarFinding(severity: 'LOW', id: 'F-2417', title: 'Lifecycle Policy Not Configured', color: Color(0xFF38BDF8)),
      ],
    ),
    const FindingItemModel(
      id: 'F-2402',
      resource: 'sg-0a1b2c3d4e5f',
      finding: 'RDP Exposed to 0.0.0.0/0',
      severity: FindingSeverity.critical,
      account: 'AWS Production',
      service: 'EC2',
      riskScore: 95,
      age: '3d',
      status: FindingStatus.open,
      resourceUri: 'sg-0a1b2c3d4e5f',
      aiRiskExplanation:
          'Security group allows direct inbound RDP (Port 3389) traffic from any public IP address (0.0.0.0/0), exposing windows servers to automated brute-force attacks.',
      remediationSteps: [
        'Revoke public ingress rule for port 3389 in security group sg-0a1b2c3d4e5f',
        'Enforce connection via AWS Systems Manager Session Manager or Bastion host',
      ],
      controlMappings: {
        'NIST CSF': 'PR.AC-5',
        'CIS Controls': '4.1',
        'ISO 27001': 'A.13.1.3',
        'SOC 2': 'CC6.6',
      },
    ),
    const FindingItemModel(
      id: 'F-2403',
      resource: 'arn:aws:iam::root',
      finding: 'Root Account API Key Active',
      severity: FindingSeverity.critical,
      account: 'AWS Production',
      service: 'IAM',
      riskScore: 94,
      age: '22d',
      status: FindingStatus.open,
      resourceUri: 'arn:aws:iam::root',
      aiRiskExplanation:
          'Active root account access keys bypass IAM role boundaries and multi-factor authorization safeguards.',
      remediationSteps: [
        'Delete root account access key via AWS IAM Console',
        'Provision dedicated administrative IAM roles with temporary STS tokens',
      ],
      controlMappings: {
        'NIST CSF': 'PR.AC-1',
        'CIS Controls': '5.2',
        'ISO 27001': 'A.9.2.3',
        'SOC 2': 'CC6.2',
      },
    ),
    const FindingItemModel(
      id: 'F-2404',
      resource: 'db-prod-oracle-01',
      finding: 'Database Exposed to Internet',
      severity: FindingSeverity.critical,
      account: 'AWS Production',
      service: 'RDS',
      riskScore: 92,
      age: '5d',
      status: FindingStatus.remediating,
      resourceUri: 'rds:db-prod-oracle-01',
      aiRiskExplanation:
          'Production Oracle RDS instance has PubliclyAccessible flag set to True in an internet-gateway route table subnet.',
      remediationSteps: [
        'Modify DB Instance setting PubliclyAccessible to False',
        'Move database subnet group into private VPC subnets',
      ],
      controlMappings: {
        'NIST CSF': 'PR.DS-2',
        'CIS Controls': '3.1',
        'ISO 27001': 'A.13.1.2',
        'SOC 2': 'CC6.7',
      },
    ),
    const FindingItemModel(
      id: 'F-2405',
      resource: 'k8s-prod-cluster',
      finding: 'Kubernetes Dashboard Exposed',
      severity: FindingSeverity.high,
      account: 'GCP Production',
      service: 'GKE',
      riskScore: 88,
      age: '11d',
      status: FindingStatus.open,
      resourceUri: 'gke:k8s-prod-cluster',
      aiRiskExplanation:
          'GKE cluster has administrative Kubernetes dashboard deployed with anonymous authentication permitted.',
      remediationSteps: [
        'Disable public NodePort or LoadBalancer exposing dashboard service',
        'Enforce GKE Workload Identity and Cloud IAM RBAC mapping',
      ],
      controlMappings: {
        'NIST CSF': 'PR.AC-4',
        'CIS Controls': '4.8',
        'ISO 27001': 'A.9.4.2',
        'SOC 2': 'CC6.3',
      },
    ),
    const FindingItemModel(
      id: 'F-2406',
      resource: 'Over-privileged Service Account',
      finding: 'Over-privileged Service Account',
      severity: FindingSeverity.high,
      account: 'GCP Production',
      service: 'IAM',
      riskScore: 84,
      age: '16d',
      status: FindingStatus.open,
      resourceUri: 'sa-prod-worker@cybershield-prod.iam.gserviceaccount.com',
      aiRiskExplanation:
          'Service account has owner role bound across the entire project despite only requiring Cloud Storage object read permissions.',
      remediationSteps: [
        'Remove roles/owner role binding from service account',
        'Assign scoped roles/storage.objectViewer role instead',
      ],
      controlMappings: {
        'NIST CSF': 'PR.AC-6',
        'CIS Controls': '5.4',
        'ISO 27001': 'A.9.1.2',
        'SOC 2': 'CC6.3',
      },
    ),
  ];
}

class SimilarFinding {
  final String severity;
  final String id;
  final String title;
  final Color color;

  const SimilarFinding({
    required this.severity,
    required this.id,
    required this.title,
    required this.color,
  });
}
