import '../enum/moment_enum.dart';

class MomentContentModel {
  final String authorPubkey;
  final String content;
  final DateTime timestamp;
  final EMomentType type;

  MomentContentModel({
    required this.authorPubkey,
    required this.content,
    required this.timestamp,
    required this.type,
  });
}