import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:chatcore/chat-core.dart';

/// All possible roles user can have.
enum Role { admin, agent, moderator, user }

/// A class that represents user.
@immutable
class User extends Equatable {
  /// Creates a user.
  User({
    this.createdAt,
    required this.id,
    this.lastName,
    this.lastSeen,
    this.metadata,
    this.role,
    this.updatedAt,
    this.sourceObject,
  });

  /// Creates user from a map (decoded JSON).
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// Created user timestamp, in ms.
  int? createdAt;

  /// First name of the user.
  String? get firstName => sourceObject?.name ;

  /// Unique ID of the user.
  String id;

  /// Remote image URL representing user's avatar.
  String? get imageUrl => sourceObject?.picture;

  /// Last name of the user.
  String? lastName;

  /// Timestamp when user was last visible, in ms.
  int? lastSeen;

  /// Additional custom metadata or attributes related to the user.
  Map<String, dynamic>? metadata;

  /// User [Role].
  Role? role;

  /// Updated user timestamp, in ms.
  int? updatedAt;

  UserDBISAR? sourceObject;

  /// Equatable props.
  @override
  List<Object?> get props => [
        createdAt,
        firstName,
        id,
        imageUrl,
        lastName,
        lastSeen,
        metadata,
        role,
        updatedAt,
      ];


  /// Converts user to the map representation, encodable to JSON.
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

User _$UserFromJson(Map<String, dynamic> json) => User(
  createdAt: json['createdAt'] as int?,
  id: json['id'] as String,
  lastName: json['lastName'] as String?,
  lastSeen: json['lastSeen'] as int?,
  metadata: json['metadata'] as Map<String, dynamic>?,
  role: $enumDecodeNullable(_$RoleEnumMap, json['role']),
  updatedAt: json['updatedAt'] as int?,
);

Map<String, dynamic> _$UserToJson(User instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('createdAt', instance.createdAt);
  writeNotNull('firstName', instance.firstName);
  val['id'] = instance.id;
  writeNotNull('imageUrl', instance.imageUrl);
  writeNotNull('lastName', instance.lastName);
  writeNotNull('lastSeen', instance.lastSeen);
  writeNotNull('metadata', instance.metadata);
  writeNotNull('role', _$RoleEnumMap[instance.role]);
  writeNotNull('updatedAt', instance.updatedAt);
  return val;
}

const _$RoleEnumMap = {
  Role.admin: 'admin',
  Role.agent: 'agent',
  Role.moderator: 'moderator',
  Role.user: 'user',
};