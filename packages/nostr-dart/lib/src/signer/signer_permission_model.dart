///Title: signer_permission_model
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/11/30 15:58
class SignerPermissionModel {
  final String type;
  final int? kind;
  static final permissions = [
    SignerPermissionModel(type: "sign_event", kind: 22242),
    SignerPermissionModel(type: "sign_event", kind: 22456),
    SignerPermissionModel(type: "sign_event", kind: 24242),
    SignerPermissionModel(type: "sign_event", kind: 27235),
    SignerPermissionModel(type: "sign_event", kind: 3),
    SignerPermissionModel(type: "sign_event", kind: 4),
    SignerPermissionModel(type: "sign_event", kind: 6),
    SignerPermissionModel(type: "sign_event", kind: 7),
    SignerPermissionModel(type: "sign_event", kind: 9),
    SignerPermissionModel(type: "sign_event", kind: 10),
    SignerPermissionModel(type: "sign_event", kind: 11),
    SignerPermissionModel(type: "sign_event", kind: 12),
    SignerPermissionModel(type: "sign_event", kind: 13),
    SignerPermissionModel(type: "sign_event", kind: 14),
    SignerPermissionModel(type: "sign_event", kind: 15),
    SignerPermissionModel(type: "sign_event", kind: 8),
    SignerPermissionModel(type: "sign_event", kind: 1059),
    SignerPermissionModel(type: "sign_event", kind: 30000),
    SignerPermissionModel(type: "sign_event", kind: 30001),
    SignerPermissionModel(type: "sign_event", kind: 30003),
    SignerPermissionModel(type: "sign_event", kind: 1),
    SignerPermissionModel(type: "sign_event", kind: 0),
    SignerPermissionModel(type: "sign_event", kind: 10100),
    SignerPermissionModel(type: "sign_event", kind: 10101),
    SignerPermissionModel(type: "sign_event", kind: 10102),
    SignerPermissionModel(type: "sign_event", kind: 10103),
    SignerPermissionModel(type: "sign_event", kind: 10104),
    SignerPermissionModel(type: "sign_event", kind: 25050),
    SignerPermissionModel(type: "sign_event", kind: 10000),
    SignerPermissionModel(type: "sign_event", kind: 10002),
    SignerPermissionModel(type: "sign_event", kind: 10005),
    SignerPermissionModel(type: "sign_event", kind: 10009),
    SignerPermissionModel(type: "sign_event", kind: 10050),
    SignerPermissionModel(type: "sign_event", kind: 30008),
    SignerPermissionModel(type: "sign_event", kind: 30009),
    SignerPermissionModel(type: "sign_event", kind: 9734),
    SignerPermissionModel(type: "sign_event", kind: 9733),
    SignerPermissionModel(type: "sign_event", kind: 23194),
    SignerPermissionModel(type: "sign_event", kind: 40),
    SignerPermissionModel(type: "sign_event", kind: 41),
    SignerPermissionModel(type: "sign_event", kind: 42),
    SignerPermissionModel(type: "sign_event", kind: 43),
    SignerPermissionModel(type: "sign_event", kind: 9000),
    SignerPermissionModel(type: "sign_event", kind: 9001),
    SignerPermissionModel(type: "sign_event", kind: 9002),
    SignerPermissionModel(type: "sign_event", kind: 9003),
    SignerPermissionModel(type: "sign_event", kind: 9004),
    SignerPermissionModel(type: "sign_event", kind: 9005),
    SignerPermissionModel(type: "sign_event", kind: 9006),
    SignerPermissionModel(type: "sign_event", kind: 9007),
    SignerPermissionModel(type: "sign_event", kind: 9021),
    SignerPermissionModel(type: "sign_event", kind: 39000),
    SignerPermissionModel(type: "sign_event", kind: 39001),
    SignerPermissionModel(type: "sign_event", kind: 39002),
    SignerPermissionModel(type: "sign_message"),
    SignerPermissionModel(type: "nip04_encrypt"),
    SignerPermissionModel(type: "nip04_decrypt"),
    SignerPermissionModel(type: "nip44_encrypt"),
    SignerPermissionModel(type: "nip44_decrypt"),
  ];

  static final basePermissions = [
    SignerPermissionModel(type: "sign_event", kind: 22456),
    SignerPermissionModel(type: "sign_event", kind: 13),
    SignerPermissionModel(type: "sign_event", kind: 14),
    SignerPermissionModel(type: "sign_event", kind: 15),
    SignerPermissionModel(type: "nip04_encrypt"),
    SignerPermissionModel(type: "nip04_decrypt"),
    SignerPermissionModel(type: "nip44_encrypt"),
    SignerPermissionModel(type: "nip44_decrypt"),
  ];

  SignerPermissionModel({required this.type, this.kind});

  String toJson() {
    return '{"type":"$type","kind":${kind ?? 'null'}}';
  }

  static String defaultPermissions() {
    final jsonArray = StringBuffer('[');
    for (var i = 0; i < permissions.length; i++) {
      jsonArray.write(permissions[i].toJson());
      if (i < permissions.length - 1) {
        jsonArray.write(',');
      }
    }
    jsonArray.write(']');

    return jsonArray.toString();
  }

  static String defaultPermissionsForNIP46() {
    final permissionStrings = <String>[];

    for (var permission in basePermissions) {
      if (permission.kind != null) {
        permissionStrings.add('${permission.type}:${permission.kind}');
      } else {
        permissionStrings.add(permission.type);
      }
    }

    return permissionStrings.join(', ');
  }
}
