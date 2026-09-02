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

  static List<IdentityUserModel> getMockUsers() => const [
    IdentityUserModel(
      username: 'carlos.rodriguez',
      department: 'Cloud Platform',
      role: 'Cloud Admin',
      riskScore: 94,
      riskScoreColor: Color(0xFFEF4444),
      alertsCount: 5,
      hasMfa: true,
      isPrivileged: true,
      status: 'active',
      statusColor: Color(0xFF10B981),
    ),
    IdentityUserModel(
      username: 'ashley.wong',
      department: 'IT Operations',
      role: 'Sys Admin',
      riskScore: 87,
      riskScoreColor: Color(0xFFEF4444),
      alertsCount: 3,
      hasMfa: true,
      isPrivileged: true,
      status: 'active',
      statusColor: Color(0xFF10B981),
    ),
    IdentityUserModel(
      username: 'derek.okonkwo',
      department: 'Finance',
      role: 'AP Manager',
      riskScore: 76,
      riskScoreColor: Color(0xFFF97316),
      alertsCount: 2,
      hasMfa: false,
      isPrivileged: false,
      status: 'active',
      statusColor: Color(0xFF10B981),
    ),
    IdentityUserModel(
      username: 'svc-ci-pipeline',
      department: 'DevOps',
      role: 'Service Account',
      riskScore: 72,
      riskScoreColor: Color(0xFFF97316),
      alertsCount: 4,
      hasMfa: false,
      isPrivileged: true,
      status: 'active',
      statusColor: Color(0xFF10B981),
    ),
    IdentityUserModel(
      username: 'jen.martinez',
      department: 'Finance',
      role: 'Finance Analyst',
      riskScore: 60,
      riskScoreColor: Color(0xFFF97316),
      alertsCount: 1,
      hasMfa: false,
      isPrivileged: false,
      status: 'active',
      statusColor: Color(0xFF10B981),
    ),
    IdentityUserModel(
      username: 'priya.nair',
      department: 'Security',
      role: 'SOC Analyst',
      riskScore: 45,
      riskScoreColor: Color(0xFFFBBF24),
      alertsCount: 0,
      hasMfa: true,
      isPrivileged: false,
      status: 'active',
      statusColor: Color(0xFF10B981),
    ),
    IdentityUserModel(
      username: 'tom.harrison',
      department: 'Engineering',
      role: 'Developer',
      riskScore: 38,
      riskScoreColor: Color(0xFF10B981),
      alertsCount: 1,
      hasMfa: true,
      isPrivileged: false,
      status: 'dormant',
      statusColor: Color(0xFF64748B),
    ),
    IdentityUserModel(
      username: 'lisa.chen',
      department: 'HR',
      role: 'HR Manager',
      riskScore: 22,
      riskScoreColor: Color(0xFF10B981),
      alertsCount: 0,
      hasMfa: true,
      isPrivileged: false,
      status: 'active',
      statusColor: Color(0xFF10B981),
    ),
  ];
}
