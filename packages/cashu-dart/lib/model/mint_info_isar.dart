
import 'dart:convert';

import 'package:isar/isar.dart';

import '../utils/tools.dart';

part 'mint_info_isar.g.dart';

class NutsSupportInfo {
  NutsSupportInfo({
    required this.nutNum,
    this.methods = const [],
    this.supported = true,
    this.disabled = false,
  });

  static Set<int> get mandatoryNut => {0, 1, 2, 3, 4, 5, 6};

  final int nutNum;
  final List<List<String>> methods;
  final bool supported;
  final bool disabled;

  factory NutsSupportInfo.fromServerJson(String nutNum, Map json) {
    final methods = <List<String>>[];
    final methodsRaw = json['methods'];
    if (methodsRaw is List) {
      final methodList = [...methodsRaw];
      for (var method in methodList) {
        if (method is List) {
          final list = [...method];
          final target = list.map((e) => e.toString()).toList();
          methods.add(target);
        }
      }
    }

    final supported = Tools.getValueAs(json, 'supported', true);
    final disabled = Tools.getValueAs(json, 'disabled', false);

    return NutsSupportInfo(
      nutNum: int.tryParse(nutNum) ?? 0,
      methods: methods,
      supported: supported,
      disabled: disabled,
    );
  }

  @override
  String toString() {
    return '${super.toString()}, nutNum: $nutNum, methods: $methods, supported: $supported, disabled: $disabled';
  }
}

@collection
class MintInfoIsar {
  MintInfoIsar({
    required this.mintURL,
    required this.name,
    required this.pubkey,
    required this.version,
    required this.description,
    required this.descriptionLong,
    required this.contactJsonRaw,
    required this.motd,
    required this.nutsJsonRaw,
  }) {
    var contactRaw = [];
    var nutsRaw = {};

    try {
      contactRaw = json.decode(contactJsonRaw);
      nutsRaw = json.decode(nutsJsonRaw);
    } catch(_) { }

    // Contact
    for (var entry in contactRaw) {
      if (entry is List && entry.length > 1) {
        contact.add(entry.map((e) => e.toString()).toList());
      }
    }

    // Nuts
    nutsRaw.forEach((key, value) {
      if (value is Map) {
        nutsInfo.add(NutsSupportInfo.fromServerJson(key.toString(), value));
      }
    });

    nutsInfo.sort((a, b) => a.nutNum - b.nutNum);
  }

  Id id = Isar.autoIncrement;

  @Index(unique: true)
  final String mintURL;
  final String name;
  final String pubkey;
  final String version;
  final String description;
  final String descriptionLong;

  final String contactJsonRaw;
  @Ignore()
  List<List<String>> contact = [];

  final String motd;

  final String nutsJsonRaw;
  @Ignore()
  List<NutsSupportInfo> nutsInfo = [];

  factory MintInfoIsar.fromServerMap(Map jsonMap, String mintURL) {
    var nuts = {};
    final nutsRaw = jsonMap['nuts'];
    if (nutsRaw is Map) {
      nuts = nutsRaw;
    } else if (nutsRaw is List) {
      nuts = nutsRaw.fold(<String, Map<String, dynamic>>{}, (pre, e) {
        pre[e] = {};
        return pre;
      });
    }

    String contactJsonRaw = '';
    String nutsJsonRaw = '';
    try {
      contactJsonRaw = json.encode(Tools.getValueAs(jsonMap, 'contact', []));
      nutsJsonRaw = json.encode(nuts);
    } catch(_) { }

    return MintInfoIsar(
      mintURL: mintURL,
      name: Tools.getValueAs(jsonMap, 'name', ''),
      pubkey: Tools.getValueAs(jsonMap, 'pubkey', ''),
      version: Tools.getValueAs(jsonMap, 'version', ''),
      description: Tools.getValueAs(jsonMap, 'description', ''),
      descriptionLong: Tools.getValueAs(jsonMap, 'description_long', ''),
      contactJsonRaw: contactJsonRaw,
      motd: Tools.getValueAs(jsonMap, 'motd', ''),
      nutsJsonRaw: nutsJsonRaw,
    );
  }

  @override
  String toString() {
    return '${super.toString()}, name: $name, pubkey: $pubkey, version: $version';
  }
}