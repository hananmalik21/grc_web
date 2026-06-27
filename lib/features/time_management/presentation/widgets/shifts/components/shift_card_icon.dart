import 'package:grc/core/enums/time_management_enums.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShiftCardIcon extends StatelessWidget {
  final ShiftType shiftType;
  final String colorHex;

  const ShiftCardIcon({super.key, required this.shiftType, required this.colorHex});

  @override
  Widget build(BuildContext context) {
    final bgColor = _parseColor(colorHex);
    final iconPath = _getIconPath(shiftType);
    final isMobile = ResponsiveHelper.isMobile(context);
    final containerSize = isMobile ? 40.w : 48.w;
    final iconSize = isMobile ? 20.0 : 24.0;

    return Container(
      width: containerSize,
      height: containerSize,
      decoration: BoxDecoration(color: bgColor.withValues(alpha: 0.125), shape: BoxShape.circle),
      child: Center(
        child: DigifyAsset(assetPath: iconPath, width: iconSize, height: iconSize, color: bgColor),
      ),
    );
  }

  Color _parseColor(String hex) {
    try {
      final hexColor = hex.replaceAll('#', '');
      if (hexColor.length == 6) {
        return Color(int.parse('FF$hexColor', radix: 16));
      }
      return const Color(0xFF000000);
    } catch (e) {
      return const Color(0xFF000000);
    }
  }

  String _getIconPath(ShiftType type) {
    switch (type) {
      case ShiftType.day:
        return Assets.icons.timeManagement.morning.path;
      case ShiftType.evening:
        return Assets.icons.timeManagement.evening.path;
      case ShiftType.night:
        return Assets.icons.timeManagement.night.path;
      case ShiftType.rotating:
        return Assets.icons.timeManagement.morning.path;
    }
  }
}
