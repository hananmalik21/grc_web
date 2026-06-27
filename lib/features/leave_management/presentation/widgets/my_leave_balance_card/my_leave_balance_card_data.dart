import 'package:flutter/material.dart';

class MyLeaveBalanceCardData {
  final String leaveType;
  final String leaveTypeArabic;
  final String iconPath;
  final double totalBalance;
  final double currentYear;
  final double carriedForward;
  final bool carryForwardAllowed;
  final String? carryForwardMax;
  final String? expiryDate;
  final bool isAtRisk;
  final double? atRiskDays;
  final String? atRiskExpiryDate;
  final bool encashmentAvailable;
  final VoidCallback? onEncashmentRequest;

  const MyLeaveBalanceCardData({
    required this.leaveType,
    required this.leaveTypeArabic,
    required this.iconPath,
    required this.totalBalance,
    required this.currentYear,
    required this.carriedForward,
    required this.carryForwardAllowed,
    this.carryForwardMax,
    this.expiryDate,
    this.isAtRisk = false,
    this.atRiskDays,
    this.atRiskExpiryDate,
    this.encashmentAvailable = false,
    this.onEncashmentRequest,
  });
}
