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
  final int score;
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
  final int readinessScore;
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
}
