import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

extension DeferredNavigation on BuildContext {
  /// Navigates with [GoRouter.go] once the current pointer/gesture handler has
  /// finished, but *before* the next frame is built.
  ///
  /// Triggering a page swap directly from a pointer/hover callback (e.g. an
  /// [InkWell.onTap]) can remove the hovered widget mid-frame and trip the
  /// `MouseTracker` `!_debugDuringDeviceUpdate` assertion on web/desktop.
  ///
  /// A post-frame callback is *not* safe here: it runs during the scheduler's
  /// post-frame phase, the same phase in which the mouse tracker performs its
  /// device update, so navigating there can collide with that update and leave
  /// the freshly pushed page half-rendered (a blank/gray screen). A microtask
  /// instead runs as soon as the current event handler returns and outside the
  /// scheduler phase, breaking the re-entrancy without delaying a frame.
  void deferGo(String location, {Object? extra}) {
    scheduleMicrotask(() {
      if (mounted) go(location, extra: extra);
    });
  }
}
