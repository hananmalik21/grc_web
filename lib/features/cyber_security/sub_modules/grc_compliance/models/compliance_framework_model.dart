import 'package:flutter/material.dart';

enum ControlStatus {
  pass,
  partial,
  fail,
}

class ControlItemModel {
  final String controlId;
  final String controlName;
  final ControlStatus status;
  final int score; // 0 - 100
  final String frameworkId;
  final String description;
  final String automatedEvidence;
  final String lastVerified;

  const ControlItemModel({
    required this.controlId,
    required this.controlName,
    required this.status,
    required this.score,
    required this.frameworkId,
    this.description = 'Continuous audit check validating cloud asset configuration against benchmark policy.',
    this.automatedEvidence = 'AWS CloudTrail & IAM collector verified MFA enforcement across member accounts.',
    this.lastVerified = 'Today at 14:00 UTC',
  });

  String get statusLabel {
    switch (status) {
      case ControlStatus.pass:
        return 'pass';
      case ControlStatus.partial:
        return 'partial';
      case ControlStatus.fail:
        return 'fail';
    }
  }

  Color get statusColor {
    switch (status) {
      case ControlStatus.pass:
        return const Color(0xFF10B981);
      case ControlStatus.partial:
        return const Color(0xFFF59E0B);
      case ControlStatus.fail:
        return const Color(0xFFEF4444);
    }
  }
}

class ComplianceFrameworkModel {
  final String id;
  final String name;
  final int readinessScore; // e.g. 73%
  final Color progressColor;
  final int passingCount;
  final int failingCount;
  final int partialCount;
  final int totalControls;
  final List<ControlItemModel> controls;

  const ComplianceFrameworkModel({
    required this.id,
    required this.name,
    required this.readinessScore,
    required this.progressColor,
    required this.passingCount,
    required this.failingCount,
    required this.partialCount,
    required this.totalControls,
    required this.controls,
  });

  static List<ComplianceFrameworkModel> getMockFrameworks() {
    final nistControls = [
      const ControlItemModel(
        controlId: 'CSF-ID.AM-1',
        controlName: 'Physical device and systems inventory',
        status: ControlStatus.pass,
        score: 100,
        frameworkId: 'nist',
        description: 'Physical devices and systems within the organization are inventoried.',
        automatedEvidence: 'Agent discovery synced 14,820 assets with MDM and CMDB inventory.',
      ),
      const ControlItemModel(
        controlId: 'CSF-ID.AM-2',
        controlName: 'Software platforms and applications inventory',
        status: ControlStatus.pass,
        score: 100,
        frameworkId: 'nist',
        description: 'Software platforms and applications within the organization are inventoried.',
        automatedEvidence: 'Continuous CI/CD package provenance and image catalog scanner active.',
      ),
      const ControlItemModel(
        controlId: 'CSF-PR.AC-1',
        controlName: 'Identities and credentials management',
        status: ControlStatus.partial,
        score: 65,
        frameworkId: 'nist',
        description: 'Identities and credentials are managed for authorized devices and users.',
        automatedEvidence: '18 overprivileged roles and 7 inactive credentials (>90d) flagged for rotation.',
      ),
      const ControlItemModel(
        controlId: 'CSF-PR.AC-7',
        controlName: 'Users, devices, and assets authentication',
        status: ControlStatus.fail,
        score: 30,
        frameworkId: 'nist',
        description: 'Users, devices, and other assets are authenticated commensurate with the risk.',
        automatedEvidence: 'MFA missing on 2 legacy AWS member staging accounts.',
      ),
      const ControlItemModel(
        controlId: 'CSF-PR.DS-1',
        controlName: 'Data-at-rest protection',
        status: ControlStatus.pass,
        score: 88,
        frameworkId: 'nist',
        description: 'Data-at-rest is protected using cryptographic mechanisms.',
        automatedEvidence: '100% of discovered datastores encrypted with AWS KMS / AES-256.',
      ),
      const ControlItemModel(
        controlId: 'CSF-PR.DS-2',
        controlName: 'Data-in-transit protection',
        status: ControlStatus.pass,
        score: 92,
        frameworkId: 'nist',
        description: 'Data-in-transit is protected using TLS 1.3 encryption.',
        automatedEvidence: 'Strict TLS 1.3 and mTLS enforced across all ingress and mesh traffic.',
      ),
      const ControlItemModel(
        controlId: 'CSF-DE.CM-1',
        controlName: 'Network and physical environment monitoring',
        status: ControlStatus.partial,
        score: 55,
        frameworkId: 'nist',
        description: 'The network is monitored to detect potential cybersecurity events.',
        automatedEvidence: 'VPC flow logs active; 2 staging subnets lack VPC mirror sessions.',
      ),
      const ControlItemModel(
        controlId: 'CSF-DE.CM-7',
        controlName: 'Monitoring for unauthorized personnel activity',
        status: ControlStatus.fail,
        score: 40,
        frameworkId: 'nist',
        description: 'Monitoring for unauthorized personnel, connections, and devices is performed.',
        automatedEvidence: 'Anomalous Tor logins detected on finance analyst account without conditional block.',
      ),
      const ControlItemModel(
        controlId: 'CSF-RS.CO-2',
        controlName: 'Incidents reported per established criteria',
        status: ControlStatus.pass,
        score: 90,
        frameworkId: 'nist',
        description: 'Incidents are reported consistent with established criteria.',
        automatedEvidence: 'Automated webhook dispatch to incident response team active (MTTR < 5m).',
      ),
      const ControlItemModel(
        controlId: 'CSF-RC.RP-1',
        controlName: 'Recovery plan executed during/after incidents',
        status: ControlStatus.partial,
        score: 70,
        frameworkId: 'nist',
        description: 'Recovery plan is executed during or after a cybersecurity incident.',
        automatedEvidence: 'Disaster recovery runbooks validated across 3 of 4 production clusters.',
      ),
    ];

    return [
      ComplianceFrameworkModel(
        id: 'nist',
        name: 'NIST CSF 2.0',
        readinessScore: 73,
        progressColor: const Color(0xFF00B4D8),
        passingCount: 78,
        failingCount: 17,
        partialCount: 11,
        totalControls: 106,
        controls: nistControls,
      ),
      ComplianceFrameworkModel(
        id: 'cis',
        name: 'CIS CONTROLS V8',
        readinessScore: 81,
        progressColor: const Color(0xFF38BDF8),
        passingCount: 124,
        failingCount: 18,
        partialCount: 11,
        totalControls: 153,
        controls: nistControls,
      ),
      ComplianceFrameworkModel(
        id: 'iso',
        name: 'ISO 27001:2022',
        readinessScore: 68,
        progressColor: const Color(0xFFA855F7),
        passingCount: 63,
        failingCount: 21,
        partialCount: 9,
        totalControls: 93,
        controls: nistControls,
      ),
      ComplianceFrameworkModel(
        id: 'soc2',
        name: 'SOC 2 TYPE II',
        readinessScore: 85,
        progressColor: const Color(0xFF10B981),
        passingCount: 54,
        failingCount: 7,
        partialCount: 3,
        totalControls: 64,
        controls: nistControls,
      ),
      ComplianceFrameworkModel(
        id: 'csa',
        name: 'CSA CCM V4',
        readinessScore: 62,
        progressColor: const Color(0xFFF59E0B),
        passingCount: 122,
        failingCount: 51,
        partialCount: 24,
        totalControls: 197,
        controls: nistControls,
      ),
    ];
  }
}
