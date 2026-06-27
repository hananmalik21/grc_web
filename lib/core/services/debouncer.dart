import 'dart:async';
import 'dart:ui';

/// A utility class to delay the execution of a function until after a specific duration
/// has passed since the last time it was called.
class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({this.delay = const Duration(milliseconds: 500)});

  /// Runs the [action] after the [delay].
  /// If [run] is called again before the [delay] passes, the previous call is cancelled.
  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  /// Cancels any pending action.
  void dispose() {
    _timer?.cancel();
  }
}
