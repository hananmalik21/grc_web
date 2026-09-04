import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reorderables/reorderables.dart';

import 'dashboard_button_model.dart';
import 'dashboard_module_grid_skeleton.dart';
import 'modern_module_card.dart';

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
    final double spacing = 16.r;

    int columns = 5;
    if (maxW < 540) {
      columns = 1;
    } else if (maxW < 780) {
      columns = 2;
    } else if (maxW < 960) {
      columns = 3;
    } else if (maxW < 1000) {
      columns = 4;
    } else {
      columns = 5;
    }

    final double totalSpacing = spacing * (columns - 1);
    final double tileW = ((maxW - totalSpacing) / columns).floorToDouble();
    final double tileH = 155.0; // Rectangular height matching user reference image

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
        final spec = _gridSpecForWidth(maxW);

        return ReorderableWrap(
          spacing: spec.spacing,
          runSpacing: 16.h,
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
              child: ModernModuleCard(
                button: btn,
                index: index + 1,
                isDragging: _isDragging,
                onTap: () => widget.onButtonTap(btn),
              ),
            );
          }),
        );
      },
    );
  }
}
