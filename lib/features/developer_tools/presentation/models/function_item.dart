import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/features/developer_tools/domain/models/security_function.dart';
import 'package:flutter/material.dart';

class FunctionItem {
  const FunctionItem({
    required this.name,
    required this.code,
    this.description,
    required this.moduleName,
    required this.functionType,
    required this.permissionKey,
    required this.isActive,
    required this.iconBg,
    required this.iconAccent,
  });

  factory FunctionItem.fromSecurityFunction(SecurityFunction fn) {
    final theme = _FunctionThemeResolver.resolve(fn.functionCode);
    return FunctionItem(
      name: fn.functionName,
      code: fn.functionCode,
      description: fn.description,
      moduleName: fn.module?.moduleName ?? '—',
      functionType: fn.functionType,
      permissionKey: fn.permissionKey,
      isActive: fn.isActive,
      iconBg: theme.$1,
      iconAccent: theme.$2,
    );
  }

  final String name;
  final String code;
  final String? description;
  final String moduleName;
  final String functionType;
  final String permissionKey;
  final bool isActive;
  final Color iconBg;
  final Color iconAccent;
}

class _FunctionThemeResolver {
  static const _palettes = [
    (AppColors.infoBg, AppColors.info),
    (AppColors.greenBg, AppColors.success),
    (AppColors.alertHighBg, AppColors.alertHigh),
    (AppColors.purpleBg, AppColors.purple),
    (AppColors.errorBg, AppColors.error),
    (AppColors.dataRoleScopeBg, AppColors.dashLeaveManagement),
  ];

  static (Color, Color) resolve(String functionCode) {
    final index = functionCode.codeUnits.fold(0, (sum, c) => sum + c) % _palettes.length;
    return _palettes[index];
  }
}
