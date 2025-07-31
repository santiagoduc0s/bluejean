import 'dart:async';
import 'package:flutter/widgets.dart';

/// A utility class that debounces the execution of a function.
///
/// This class is useful to control the rate at which a function is executed,
/// particularly for events that fire rapidly, such as user input.
/// The [Debouncer] delays the execution of the action by a
/// specified [duration].
class Debouncer {
  /// Creates a [Debouncer] with the specified [duration].
  ///
  /// The [duration] parameter sets the delay interval before executing the
  /// debounced action.
  Debouncer({required this.duration});

  /// The duration to wait before executing the debounced action.
  final Duration duration;

  Timer? _timer;

  /// Runs the provided [action] after the specified [duration].
  ///
  /// If [executeImmediately] is set to `true`, the [action] is executed
  /// immediately
  /// provided there is no active timer. In either case, any existing
  /// timer is canceled,
  /// and a new timer is started that will execute the [action] after
  /// the [duration].
  ///
  /// - [action]: The callback function to execute.
  /// - [executeImmediately]: If `true`, executes [action] immediately
  /// if there's no active timer.
  void run(VoidCallback action, {bool executeImmediately = false}) {
    if (executeImmediately && (_timer == null || !_timer!.isActive)) {
      action();
    }
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(duration, action);
  }

  /// Cancels the currently scheduled action if it hasn't been
  /// executed yet.
  ///
  /// This method stops the timer and sets it to `null`.
  void cancel() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
  }

  /// Resets the timer without executing any action.
  ///
  /// This cancels any current timer and starts a new one with the
  /// same [duration],
  /// but with an empty callback.
  void reset() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = Timer(duration, () {});
    }
  }

  /// Disposes of the [Debouncer] by canceling any scheduled action.
  ///
  /// This should be called when the [Debouncer] is no longer needed to
  /// free up resources.
  void dispose() {
    cancel();
  }
}
