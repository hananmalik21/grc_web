import 'package:flutter/material.dart';

class IdentityUserModel {
  final String username;
  final String department;
  final String role;
  final int riskScore;
  final Color riskScoreColor;
  final int alertsCount;
  final bool hasMfa;
  final bool isPrivileged;
  final String status;
  final Color statusColor;

  const IdentityUserModel({
    required this.username,
    required this.department,
    required this.role,
    required this.riskScore,
    required this.riskScoreColor,
    required this.alertsCount,
    required this.hasMfa,
    required this.isPrivileged,
    required this.status,
    required this.statusColor,
  });
}
