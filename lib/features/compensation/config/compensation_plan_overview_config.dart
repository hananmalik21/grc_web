import 'package:grc/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

/// Configuration for Compensation Plan Detail Overview data and styling
class CompensationPlanOverviewConfig {
  // Default Business Unit
  static const String defaultBusinessUnit = 'Corporate';

  // Default Department
  static const String defaultDepartment = 'Executive Leadership';

  // Default Owner Information
  static const String defaultOwnerInitials = 'SJ';
  static const String defaultOwnerName = 'Sarah Johnson';

  // Default Plan Dates (can be replaced with dynamic dates)
  static const String defaultCreatedDate = '2025-11-15';
  static const String defaultLastModifiedDate = '2026-02-10';

  // Cost Breakdown Configuration
  static const double costBreakdownBaseSalaryPercentage = 57.6;
  static const double costBreakdownAllowancesPercentage = 23.1;
  static const double costBreakdownBenefitsPercentage = 12.2;
  static const double costBreakdownVariablePayPercentage = 7.1;

  static const Color costBreakdownBaseSalaryColor = AppColors.primary;
  static const Color costBreakdownAllowancesColor = AppColors.success;
  static const Color costBreakdownBenefitsColor = AppColors.warning;
  static const Color costBreakdownVariablePayColor = AppColors.error;

  // Grade Distribution Configuration
  static const Map<String, Map<String, dynamic>> gradeDistributionData = {
    'M5': {'employeeCount': 8.0, 'averageSalary': 14667.0},
    'M6': {'employeeCount': 12.0, 'averageSalary': 22000.0},
    'M7': {'employeeCount': 10.0, 'averageSalary': 18333.0},
    'M8': {'employeeCount': 8.0, 'averageSalary': 14667.0},
    'M9': {'employeeCount': 5.0, 'averageSalary': 9167.0},
    'M10+': {'employeeCount': 2.0, 'averageSalary': 3667.0},
  };

  // Monthly Trend Configuration
  static const Map<String, Map<String, double>> monthlyTrendData = {
    'Jan': {'actual': 425000.0, 'projected': 425000.0},
    'Feb': {'actual': 425000.0, 'projected': 425000.0},
    'Mar': {'actual': 428000.0, 'projected': 428000.0},
    'Apr': {'actual': 0.0, 'projected': 0.0},
    'May': {'actual': 0.0, 'projected': 0.0},
    'Jun': {'actual': 0.0, 'projected': 0.0},
  };

  // Legend colors
  static const Color employeeCountColor = AppColors.primary;
  static const Color averageSalaryColor = AppColors.success;
  static const Color actualTrendColor = AppColors.primary;
  static const Color projectedTrendColor = AppColors.success;

  // Helper method to get cost breakdown items
  static List<Map<String, dynamic>> getCostBreakdownItems() => [
    {'label': 'Base Salary', 'percentage': costBreakdownBaseSalaryPercentage, 'color': costBreakdownBaseSalaryColor},
    {'label': 'Allowances', 'percentage': costBreakdownAllowancesPercentage, 'color': costBreakdownAllowancesColor},
    {'label': 'Benefits', 'percentage': costBreakdownBenefitsPercentage, 'color': costBreakdownBenefitsColor},
    {'label': 'Variable Pay', 'percentage': costBreakdownVariablePayPercentage, 'color': costBreakdownVariablePayColor},
  ];

  // Helper method to get grade distribution list
  static List<Map<String, dynamic>> getGradeDistributionList() {
    final List<String> grades = ['M5', 'M6', 'M7', 'M8', 'M9', 'M10+'];
    return grades.map((grade) {
      final data = gradeDistributionData[grade]!;
      return {'grade': grade, 'employeeCount': data['employeeCount'], 'averageSalary': data['averageSalary']};
    }).toList();
  }

  // Helper method to get monthly trend list
  static List<Map<String, dynamic>> getMonthlyTrendList() {
    final List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
    return months.map((month) {
      final data = monthlyTrendData[month]!;
      return {'month': month, 'actual': data['actual'], 'projected': data['projected']};
    }).toList();
  }
}
