import 'services.dart';

/// Static global state. Immutable services that do not care about build context.
class Global {
  // Data Models
  static final Map models = {
    Topic: (data) => Topic.fromMap(data),
    Quiz: (data) => Quiz.fromMap(data),
    Report: (data) => Report.fromMap(data),
  };
}
