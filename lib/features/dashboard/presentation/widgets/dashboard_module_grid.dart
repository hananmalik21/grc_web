import 'package:grc/core/services/responsive_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reorderables/reorderables.dart';

import 'dashboard_button_model.dart';
import 'dashboard_module_button.dart';
import 'dashboard_module_grid_skeleton.dart';

class DashboardModuleGrid extends ConsumerStatefulWidget {
  final List<DashboardButton> buttons;
  final Function(DashboardButton) onButtonTap;
  final bool isLoading;

  const DashboardModuleGrid({super.key, required this.buttons, required this.onButtonTap, this.isLoading = false});

  @override
  ConsumerState<DashboardModuleGrid> createState() => _DashboardModuleGridState();
}

class _DashboardModuleGridState extends ConsumerState<DashboardModuleGrid> {
  late List<DashboardButton> _buttons;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _buttons = List.from(widget.buttons);
  }

  @override
  void didUpdateWidget(DashboardModuleGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.buttons != widget.buttons) {
      _buttons = List.from(widget.buttons);
    }
  }

  GridSpec _gridSpecForWidth(double maxW) {
    final layout = AppBreakpoints.fromWidth(maxW);
    final double spacing = layout.isMobile ? 4.w : 6.w;

    if (layout.isMobile) {
      const int columns = 2;
      final double totalSpacing = spacing * (columns - 1);
      final double tileW = ((maxW - totalSpacing) / columns).floorToDouble();
      final double tileH = (tileW * 1.05).clamp(140.h, 165.h).toDouble();
      return GridSpec(columns: columns, spacing: spacing, tileW: tileW, tileH: tileH, needsLongPress: true);
    }

    final double minTileW = layout.isDesktop ? 140.w : 120.w;
    final double maxTileW = layout.isDesktop ? 175.w : 155.w;

    int columns = ((maxW + spacing) / (minTileW + spacing)).floor();

    switch (layout) {
      case ScreenLayout.tabletSmall:
        columns = columns.clamp(3, 4);
      case ScreenLayout.tabletMedium:
        columns = columns.clamp(4, 5);
      case ScreenLayout.tabletLarge:
        columns = columns.clamp(5, 7);
      case ScreenLayout.desktop:
        columns = columns.clamp(6, 9);
      case ScreenLayout.mobile:
        break;
    }

    final double usableZone = maxW - (spacing * (columns - 1));
    final double tileW = (usableZone / columns).clamp(minTileW, maxTileW).toDouble();
    final double tileH = (tileW * 0.95).clamp(135.h, 160.h).toDouble();

    return GridSpec(columns: columns, spacing: spacing, tileW: tileW, tileH: tileH, needsLongPress: false);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return const DashboardModuleGridSkeleton();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxW = constraints.maxWidth;
        final layout = AppBreakpoints.fromWidth(maxW);
        final spec = _gridSpecForWidth(maxW);

        return ReorderableWrap(
          spacing: spec.spacing,
          runSpacing: layout.isMobile ? 4.h : 6.h,
          alignment: WrapAlignment.start,
          needsLongPressDraggable: spec.needsLongPress,
          buildDraggableFeedback: (context, boxConstraints, child) {
            return Material(
              type: MaterialType.transparency,
              color: Colors.transparent,
              shadowColor: Colors.transparent,
              child: ConstrainedBox(constraints: boxConstraints, child: child),
            );
          },
          onReorderStarted: (_) => setState(() => _isDragging = true),
          onReorder: (oldIndex, newIndex) {
            setState(() {
              final item = _buttons.removeAt(oldIndex);
              _buttons.insert(newIndex, item);
              _isDragging = false;
            });
          },
          children: List.generate(_buttons.length, (index) {
            final btn = _buttons[index];
            return SizedBox(
              key: ValueKey('dash-${btn.id}'),
              width: spec.tileW,
              height: spec.tileH,
              child: DashboardModuleButton(button: btn, isDragging: _isDragging, onTap: () => widget.onButtonTap(btn)),
            );
          }),
        );
      },
    );
  }
}
