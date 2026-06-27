import 'package:flutter/material.dart';

/// A reusable widget that wraps scrollable content with Scrollbars for both axes.
/// 
/// This widget automatically adds scrollbars to any scrollable content,
/// supporting both vertical and horizontal scrolling. It will show scrollbars
/// on the axes where scrolling is needed.
/// 
/// Example usage:
/// ```dart
/// ScrollableWrapper(
///   child: SingleChildScrollView(
///     scrollDirection: Axis.horizontal,
///     child: YourContent(),
///   ),
/// )
/// ```
class ScrollableWrapper extends StatelessWidget {
  /// The scrollable widget to wrap (e.g., SingleChildScrollView, ListView, etc.)
  final Widget child;

  /// Optional scroll controller for the scrollable content
  final ScrollController? controller;

  /// Optional horizontal scroll controller for horizontal scrolling
  final ScrollController? horizontalController;

  /// Whether to show the scrollbar thumb always visible
  final bool thumbVisibility;

  /// The thickness of the scrollbar
  final double? thickness;

  /// The radius of the scrollbar thumb
  final Radius? radius;

  const ScrollableWrapper({
    super.key,
    required this.child,
    this.controller,
    this.horizontalController,
    this.thumbVisibility = true,
    this.thickness,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    // Scrollbar automatically handles both vertical and horizontal scrolling
    // when the child scrollable supports it
    return Scrollbar(
      controller: controller,
      thumbVisibility: thumbVisibility,
      thickness: thickness,
      radius: radius,
      child: child,
    );
  }
}

/// A convenience widget that combines SingleChildScrollView with Scrollbar.
/// 
/// This is a drop-in replacement for SingleChildScrollView that automatically
/// includes a scrollbar. Supports both vertical and horizontal scrolling.
/// 
/// Example usage:
/// ```dart
/// ScrollableSingleChildScrollView(
///   padding: EdgeInsets.all(16),
///   child: YourContent(),
/// )
/// 
/// // For horizontal scrolling:
/// ScrollableSingleChildScrollView(
///   scrollDirection: Axis.horizontal,
///   child: YourContent(),
/// )
/// ```
class ScrollableSingleChildScrollView extends StatelessWidget {
  /// The widget below this widget in the tree.
  final Widget child;

  /// Optional scroll controller
  final ScrollController? controller;

  /// The axis along which the scroll view scrolls
  final Axis scrollDirection;

  /// Whether the scroll view scrolls in the reading direction
  final bool reverse;

  /// How the scroll view should respond to user input
  final ScrollPhysics? physics;

  /// The amount of space by which to inset the child
  final EdgeInsetsGeometry? padding;

  /// Whether to show the scrollbar thumb always visible
  final bool thumbVisibility;

  /// The thickness of the scrollbar
  final double? thickness;

  /// The radius of the scrollbar thumb
  final Radius? radius;

  const ScrollableSingleChildScrollView({
    super.key,
    required this.child,
    this.controller,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.physics,
    this.padding,
    this.thumbVisibility = true,
    this.thickness,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    final scrollController = controller ?? ScrollController();

    return Scrollbar(
      controller: scrollController,
      thumbVisibility: thumbVisibility,
      thickness: thickness,
      radius: radius,
      child: SingleChildScrollView(
        controller: scrollController,
        scrollDirection: scrollDirection,
        reverse: reverse,
        physics: physics,
        padding: padding,
        child: child,
      ),
    );
  }
}

/// A widget that wraps content with both vertical and horizontal scrollbars.
/// 
/// This is useful for tables or content that may need scrolling in both directions.
/// It automatically shows scrollbars only when content overflows in each direction.
/// 
/// Example usage:
/// ```dart
/// DualAxisScrollable(
///   child: Table(
///     children: [...],
///   ),
/// )
/// ```
class DualAxisScrollable extends StatelessWidget {
  /// The widget to wrap
  final Widget child;

  /// Optional vertical scroll controller
  final ScrollController? verticalController;

  /// Optional horizontal scroll controller
  final ScrollController? horizontalController;

  /// Whether to show the scrollbar thumb always visible
  final bool thumbVisibility;

  /// The thickness of the scrollbar
  final double? thickness;

  /// The radius of the scrollbar thumb
  final Radius? radius;

  /// The amount of space by which to inset the child
  final EdgeInsetsGeometry? padding;

  const DualAxisScrollable({
    super.key,
    required this.child,
    this.verticalController,
    this.horizontalController,
    this.thumbVisibility = true,
    this.thickness,
    this.radius,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final vController = verticalController ?? ScrollController();
    final hController = horizontalController ?? ScrollController();

    // Outer Scrollbar for vertical scrolling
    return Scrollbar(
      controller: vController,
      thumbVisibility: thumbVisibility,
      thickness: thickness,
      radius: radius,
      child: SingleChildScrollView(
        controller: vController,
        scrollDirection: Axis.vertical,
        padding: padding,
        // Inner Scrollbar for horizontal scrolling
        // Scrollbar automatically detects horizontal direction from child
        child: Scrollbar(
          controller: hController,
          thumbVisibility: thumbVisibility,
          thickness: thickness,
          radius: radius,
          child: SingleChildScrollView(
            controller: hController,
            scrollDirection: Axis.horizontal,
            child: child,
          ),
        ),
      ),
    );
  }
}
