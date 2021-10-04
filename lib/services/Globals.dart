import 'package:firebase_analytics/firebase_analytics.dart';

import '../../models/Event.dart';
import '../../models/Category.dart';

/// Static global state. Immutable services that do not care about build context.
class Global {
  // App Data
  static final String title = 'Buddies';

  // Services
  static final FirebaseAnalytics analytics = FirebaseAnalytics();

  // Data Models
  static final Map models = {
    Event: (data) => Event.fromMap(data),
    Category: (data) => Category.fromMap(data),
  };
}
