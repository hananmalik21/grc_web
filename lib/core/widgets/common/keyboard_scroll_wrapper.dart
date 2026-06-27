import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class _ScrollIntent extends Intent {
  final double delta;
  final bool isHorizontal;
  const _ScrollIntent(this.delta, {this.isHorizontal = false});
}

class AppKeyboardScroller extends StatefulWidget {
  final Widget child;
  const AppKeyboardScroller({super.key, required this.child});

  @override
  State<AppKeyboardScroller> createState() => _AppKeyboardScrollerState();
}

class _AppKeyboardScrollerState extends State<AppKeyboardScroller> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Request focus after the frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _focusNode.canRequestFocus) {
        _focusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  bool _isTypingInTextField() {
    final focused = FocusManager.instance.primaryFocus;
    if (focused == null) return false;

    final ctx = focused.context;
    if (ctx == null) return false;

    // Check if the focused widget is an EditableText (used by TextField/TextFormField)
    final widget = ctx.widget;
    if (widget is EditableText) return true;

    // Check if we're inside a TextField or TextFormField by looking up the tree
    if (ctx.findAncestorWidgetOfExactType<TextField>() != null) return true;
    if (ctx.findAncestorWidgetOfExactType<TextFormField>() != null) return true;

    return false;
  }

  ScrollPosition? _findScrollPosition({bool horizontal = false}) {
    // Try multiple strategies to find a scrollable widget

    // Strategy 1: Try from current focus context
    final focused = FocusManager.instance.primaryFocus;
    BuildContext? ctx = focused?.context;

    if (ctx != null) {
      // Try Scrollable from focus context
      final scrollable = Scrollable.maybeOf(ctx);
      if (scrollable != null) {
        final pos = scrollable.position;
        final isHorizontalScroll = _isHorizontalScrollable(scrollable);
        if (pos.hasContentDimensions && pos.maxScrollExtent > pos.minScrollExtent && isHorizontalScroll == horizontal) {
          return pos;
        }
      }

      // Try PrimaryScrollController from focus context (usually vertical)
      if (!horizontal) {
        final primary = PrimaryScrollController.maybeOf(ctx);
        if (primary != null && primary.hasClients) {
          final pos = primary.position;
          if (pos.hasContentDimensions && pos.maxScrollExtent > pos.minScrollExtent) {
            return pos;
          }
        }
      }
    }

    // Strategy 2: Try from widget's context
    final scrollable = Scrollable.maybeOf(context);
    if (scrollable != null) {
      final pos = scrollable.position;
      final isHorizontalScroll = _isHorizontalScrollable(scrollable);
      if (pos.hasContentDimensions && pos.maxScrollExtent > pos.minScrollExtent && isHorizontalScroll == horizontal) {
        return pos;
      }
    }

    // Try PrimaryScrollController from widget's context (usually vertical)
    if (!horizontal) {
      final primary = PrimaryScrollController.maybeOf(context);
      if (primary != null && primary.hasClients) {
        final pos = primary.position;
        if (pos.hasContentDimensions && pos.maxScrollExtent > pos.minScrollExtent) {
          return pos;
        }
      }
    }

    // Strategy 3: Recursively search through the widget tree for scrollable with matching axis
    ScrollPosition? foundPosition;
    void searchElement(Element element) {
      final scrollable = Scrollable.maybeOf(element);
      if (scrollable != null) {
        final pos = scrollable.position;
        final isHorizontalScroll = _isHorizontalScrollable(scrollable);
        if (pos.hasContentDimensions && pos.maxScrollExtent > pos.minScrollExtent && isHorizontalScroll == horizontal) {
          foundPosition = pos;
          return; // Found one, use it
        }
      }
      element.visitChildElements(searchElement);
    }

    context.visitChildElements(searchElement);

    return foundPosition;
  }

  bool _isHorizontalScrollable(ScrollableState scrollable) {
    // Check if the scrollable is horizontal by examining its context and ancestor widgets
    try {
      final context = scrollable.context;

      // Strategy 1: Check for explicit scrollDirection in ancestor widgets
      // Check for SingleChildScrollView with horizontal direction
      final scrollView = context.findAncestorWidgetOfExactType<SingleChildScrollView>();
      if (scrollView != null) {
        return scrollView.scrollDirection == Axis.horizontal;
      }

      // Check for ListView with horizontal direction
      final listView = context.findAncestorWidgetOfExactType<ListView>();
      if (listView != null) {
        return listView.scrollDirection == Axis.horizontal;
      }

      // Check for GridView with horizontal direction
      final gridView = context.findAncestorWidgetOfExactType<GridView>();
      if (gridView != null) {
        return gridView.scrollDirection == Axis.horizontal;
      }

      // Strategy 2: Check if scrollable is inside a table context
      // Tables with many columns often have horizontal scrolling
      final dataTable = context.findAncestorWidgetOfExactType<DataTable>();
      final table = context.findAncestorWidgetOfExactType<Table>();

      if (dataTable != null || table != null) {
        // If we're inside a table, check if there's a horizontal scrollable wrapping it
        // by looking for SingleChildScrollView in the ancestor tree
        bool foundHorizontal = false;
        context.visitAncestorElements((element) {
          final widget = element.widget;
          if (widget is SingleChildScrollView) {
            if (widget.scrollDirection == Axis.horizontal) {
              foundHorizontal = true;
              return false; // Stop searching
            }
          }
          return true; // Continue searching
        });

        if (foundHorizontal) {
          return true;
        }

        // Heuristic: If we're inside a table and the scrollable can scroll,
        // and we're looking for horizontal scroll, assume it might be horizontal
        // This is a fallback for tables that are wrapped in horizontal scrollables
        final position = scrollable.position;
        if (position.hasContentDimensions && position.maxScrollExtent > position.minScrollExtent) {
          // Check if this scrollable is likely horizontal by checking if it's
          // the closest scrollable to a table widget
          return true;
        }
      }
    } catch (_) {
      // If we can't determine, assume vertical
    }

    return false;
  }

  void _scrollActive(double delta, {bool horizontal = false}) {
    // Don't scroll if user is typing in a text field
    if (_isTypingInTextField()) return;

    final pos = _findScrollPosition(horizontal: horizontal);
    if (pos == null) return;

    // Check if scrolling is actually possible
    if (pos.maxScrollExtent <= pos.minScrollExtent) return;

    final currentPixels = pos.pixels;
    final target = (currentPixels + delta).clamp(pos.minScrollExtent, pos.maxScrollExtent);

    // Only scroll if target is different from current position
    if ((target - currentPixels).abs() < 0.1) return;

    // Use smooth scrolling for better UX
    pos.animateTo(target, duration: const Duration(milliseconds: 100), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      child: Focus(
        focusNode: _focusNode,
        autofocus: false,
        canRequestFocus: true,
        skipTraversal: false,
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent) {
            double? delta;
            bool? isHorizontal;

            if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
              delta = 80;
              isHorizontal = false;
            } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
              delta = -80;
              isHorizontal = false;
            } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
              delta = 80;
              isHorizontal = true;
            } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
              delta = -80;
              isHorizontal = true;
            } else if (event.logicalKey == LogicalKeyboardKey.pageDown) {
              delta = 500;
              isHorizontal = false;
            } else if (event.logicalKey == LogicalKeyboardKey.pageUp) {
              delta = -500;
              isHorizontal = false;
            } else if (event.logicalKey == LogicalKeyboardKey.home) {
              delta = -999999;
              isHorizontal = false;
            } else if (event.logicalKey == LogicalKeyboardKey.end) {
              delta = 999999;
              isHorizontal = false;
            }

            if (delta != null && isHorizontal != null) {
              _scrollActive(delta, horizontal: isHorizontal);
              return KeyEventResult.handled;
            }
          }
          return KeyEventResult.ignored;
        },
        child: Shortcuts(
          shortcuts: <ShortcutActivator, Intent>{
            const SingleActivator(LogicalKeyboardKey.arrowDown): const _ScrollIntent(80, isHorizontal: false),
            const SingleActivator(LogicalKeyboardKey.arrowUp): const _ScrollIntent(-80, isHorizontal: false),
            const SingleActivator(LogicalKeyboardKey.arrowRight): const _ScrollIntent(80, isHorizontal: true),
            const SingleActivator(LogicalKeyboardKey.arrowLeft): const _ScrollIntent(-80, isHorizontal: true),
            const SingleActivator(LogicalKeyboardKey.pageDown): const _ScrollIntent(500, isHorizontal: false),
            const SingleActivator(LogicalKeyboardKey.pageUp): const _ScrollIntent(-500, isHorizontal: false),
            const SingleActivator(LogicalKeyboardKey.home): const _ScrollIntent(-999999, isHorizontal: false),
            const SingleActivator(LogicalKeyboardKey.end): const _ScrollIntent(999999, isHorizontal: false),
          },
          child: Actions(
            actions: <Type, Action<Intent>>{
              _ScrollIntent: CallbackAction<_ScrollIntent>(
                onInvoke: (intent) {
                  _scrollActive(intent.delta, horizontal: intent.isHorizontal);
                  return null;
                },
              ),
            },
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
