import 'package:flutter/material.dart';
import '../../../../../../features/security_manager/domain/models/system_user.dart';

class UserDetailModels {
  static const SystemUser fallbackUser = SystemUser(
    id: 0,
    userGuid: '',
    username: '',
    name: 'User Name',
    email: 'user@email.com',
    employeeNumber: 'EMP000',
    department: 'IT',
    designation: 'User',
    roles: [],
    status: SystemUserStatus.active,
    is2FAEnabled: false,
  );
}

class QuickActionItem {
  final String iconPath;
  final String label;
  final VoidCallback onTap;

  const QuickActionItem({required this.iconPath, required this.label, required this.onTap});
}
