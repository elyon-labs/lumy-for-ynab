import 'package:time_machine/time_machine.dart';

/// A type that represents a `server_knowledge` that is only valid for each month.
/// If `month` is `null` or is not equal to the current month, `knowledge` should
/// be considered invalid. In that case, an API call should be made to fetch the
/// latest data in its entirety.
typedef MonthConstrainedKnowledge = ({int knowledge, LocalDate? month});

extension MonthConstrainedKnowledgeX on MonthConstrainedKnowledge? {
  /// We no longer use this, but leaving this method for a bit until we're sure
  /// it's safe to remove/do a DB migration.
  ///
  /// The migration should remove the 'month' column and simply use the 'knowledge'.
  bool isValid() {
    return this != null;
  }
}
