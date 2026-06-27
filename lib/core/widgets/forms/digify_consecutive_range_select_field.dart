import 'package:grc/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DigifyConsecutiveRangeSelectField<T> extends StatelessWidget {
  final List<T> items;
  final String Function(T item) itemLabelBuilder;
  final String Function(T item)? itemSublabelBuilder;
  final List<T> selectedItems;
  final bool Function(T a, T b)? areItemsEqual;
  final ValueChanged<List<T>>? onChanged;
  final String hint;

  const DigifyConsecutiveRangeSelectField({
    super.key,
    required this.items,
    required this.itemLabelBuilder,
    this.itemSublabelBuilder,
    required this.selectedItems,
    this.areItemsEqual,
    required this.onChanged,
    this.hint = 'Select range',
  });

  // Returns -1-safe range bounds derived from items list.
  ({int start, int end}) get _bounds {
    if (selectedItems.isEmpty) return (start: -1, end: -1);
    final s = _indexOfItem(selectedItems.first);
    final e = _indexOfItem(selectedItems.last);
    if (s == -1 || e == -1) return (start: -1, end: -1);
    return (start: s, end: e);
  }

  int _indexOfItem(T target) {
    final matcher = areItemsEqual;
    if (matcher == null) {
      return items.indexOf(target);
    }
    for (var i = 0; i < items.length; i++) {
      if (matcher(items[i], target)) return i;
    }
    return -1;
  }

  void _handleTap(int tappedIndex) {
    if (onChanged == null) return;
    final b = _bounds;

    if (b.start == -1) {
      onChanged!([items[tappedIndex]]);
      return;
    }

    if (tappedIndex < b.start) {
      onChanged!(items.sublist(tappedIndex, b.end + 1));
    } else if (tappedIndex > b.end) {
      onChanged!(items.sublist(b.start, tappedIndex + 1));
    } else if (tappedIndex == b.start && tappedIndex == b.end) {
      onChanged!([]);
    } else if (tappedIndex == b.start) {
      onChanged!(items.sublist(b.start + 1, b.end + 1));
    } else if (tappedIndex == b.end) {
      onChanged!(items.sublist(b.start, b.end));
    } else {
      onChanged!([items[tappedIndex]]);
    }
  }

  _ChipState _chipState(int index) {
    final b = _bounds;
    if (b.start == -1) return _ChipState.unselected;
    if (index < b.start || index > b.end) return _ChipState.unselected;
    if (b.start == b.end) return _ChipState.single;
    if (index == b.start) return _ChipState.rangeStart;
    if (index == b.end) return _ChipState.rangeEnd;
    return _ChipState.rangeMid;
  }

  bool _isTrackActive(int rightIndex) {
    final b = _bounds;
    if (b.start == -1) return false;
    return rightIndex > b.start && rightIndex <= b.end;
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = onChanged == null;

    if (items.isEmpty) {
      return _EmptyHintField(hint: hint);
    }

    final hasSublabel = itemSublabelBuilder != null;
    final chipHeight = hasSublabel ? 54.w : 40.w;

    return SizedBox(
      height: chipHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int i = 0; i < items.length; i++) ...[
            if (i > 0) _TrackConnector(isActive: _isTrackActive(i), isDisabled: isDisabled),
            Expanded(
              child: _RangeChip(
                label: itemLabelBuilder(items[i]),
                sublabel: itemSublabelBuilder?.call(items[i]),
                state: _chipState(i),
                isDisabled: isDisabled,
                onTap: () => _handleTap(i),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

enum _ChipState { unselected, single, rangeStart, rangeMid, rangeEnd }

class _RangeChip extends StatelessWidget {
  final String label;
  final String? sublabel;
  final _ChipState state;
  final bool isDisabled;
  final VoidCallback onTap;

  const _RangeChip({
    required this.label,
    required this.sublabel,
    required this.state,
    required this.isDisabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = state != _ChipState.unselected;

    final bgColor = isDisabled
        ? AppColors.inputBg
        : isSelected
        ? AppColors.primary
        : Colors.white;

    final borderColor = isDisabled
        ? AppColors.borderGrey.withValues(alpha: 0.4)
        : isSelected
        ? AppColors.primary
        : AppColors.borderGrey;

    final labelColor = isDisabled
        ? AppColors.textPlaceholder
        : isSelected
        ? Colors.white
        : AppColors.textPrimary;

    final sublabelColor = isDisabled
        ? AppColors.textPlaceholder.withValues(alpha: 0.6)
        : isSelected
        ? Colors.white.withValues(alpha: 0.78)
        : AppColors.textSecondary;

    final radius = _chipRadius(state);

    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: radius,
          border: Border.all(color: borderColor, width: 1.2),
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600, color: labelColor, height: 1.2),
            ),
            if (sublabel != null) ...[
              SizedBox(height: 2.h),
              Text(
                sublabel!,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 9.5.sp, fontWeight: FontWeight.w500, color: sublabelColor, height: 1.2),
              ),
            ],
          ],
        ),
      ),
    );
  }

  BorderRadius _chipRadius(_ChipState s) {
    final r = Radius.circular(8.r);
    return switch (s) {
      _ChipState.unselected || _ChipState.single => BorderRadius.all(r),
      _ChipState.rangeStart => BorderRadius.only(topLeft: r, bottomLeft: r),
      _ChipState.rangeEnd => BorderRadius.only(topRight: r, bottomRight: r),
      _ChipState.rangeMid => BorderRadius.zero,
    };
  }
}

class _TrackConnector extends StatelessWidget {
  final bool isActive;
  final bool isDisabled;

  const _TrackConnector({required this.isActive, required this.isDisabled});

  @override
  Widget build(BuildContext context) {
    final trackColor = isDisabled
        ? AppColors.borderGrey.withValues(alpha: 0.3)
        : isActive
        ? AppColors.primary
        : AppColors.borderGrey.withValues(alpha: 0.45);

    final iconColor = isDisabled
        ? AppColors.borderGrey.withValues(alpha: 0.4)
        : isActive
        ? AppColors.primary
        : AppColors.borderGrey.withValues(alpha: 0.6);

    return SizedBox(
      width: 22.w,
      child: Row(
        children: [
          Expanded(
            child: AnimatedContainer(duration: const Duration(milliseconds: 160), height: 1.2, color: trackColor),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            child: Icon(Icons.chevron_right_rounded, size: 14.w, color: iconColor),
          ),
          Expanded(
            child: AnimatedContainer(duration: const Duration(milliseconds: 160), height: 1.2, color: trackColor),
          ),
        ],
      ),
    );
  }
}

class _EmptyHintField extends StatelessWidget {
  final String hint;

  const _EmptyHintField({required this.hint});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.w,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: AppColors.inputBg,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.borderGrey.withValues(alpha: 0.5)),
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        hint,
        style: TextStyle(fontSize: 13.sp, color: AppColors.textPlaceholder),
      ),
    );
  }
}
