import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// A class that represents a date header between messages.
@immutable
class DateHeader extends Equatable {
  /// Creates a date header.
  DateHeader({
    required this.dateTime,
    required this.text,
  }) {
    // Derived from the date rather than random: the header is keyed by it,
    // and a fresh id on every regrouping rebuilt every date header subtree.
    id = '${dateTime.microsecondsSinceEpoch}';
  }

  String id = '';

  /// Message date.
  final DateTime dateTime;

  /// Text to show in a header.
  final String text;

  /// Equatable props.
  @override
  List<Object> get props => [text];
}
