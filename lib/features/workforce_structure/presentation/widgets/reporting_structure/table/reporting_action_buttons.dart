import 'package:grc/core/widgets/assets/digify_asset_button.dart';
import 'package:grc/features/workforce_structure/domain/models/reporting_position.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReportingActionButtons extends StatelessWidget {
  final ReportingPosition position;
  final Function(ReportingPosition)? onView;
  final Function(ReportingPosition)? onEdit;

  const ReportingActionButtons({super.key, required this.position, this.onView, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 8.w,
      children: [
        DigifyAssetButton(assetPath: Assets.icons.blueEyeIcon.path, onTap: () => onView?.call(position)),
        DigifyAssetButton(assetPath: Assets.icons.editIcon.path, onTap: () => onEdit?.call(position)),
      ],
    );
  }
}
