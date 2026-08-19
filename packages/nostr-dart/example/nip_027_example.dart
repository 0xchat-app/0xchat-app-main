import 'package:nostr_core_dart/nostr.dart';

void main() async {
  ProfileMention profileMention1 = ProfileMention(
      0, 3, 'a60679692533b308f1d862c2a5ca5c08a304e5157b1df5cde0ff0454b9920605',
      ['wss://relay.0xchat.com']);
  ProfileMention profileMention2 = ProfileMention(
      8, 11, 'a60679692533b308f1d862c2a5ca5c08a304e5157b1df5cde0ff0454b9920605',
      ['wss://relay.0xchat.com']);
  String encode = Nip27.encodeProfileMention(
      [profileMention1, profileMention2], '@he s,s @kd ksss');
  print(encode);

  List<ProfileMention> p = Nip27.decodeProfileMention(
      'nostr:nprofile1qqs2vpnedyjn8vcg78vx9s49efwq3gcyu52hk804ehs07pz5hxfqvpgpzemhxue69uhhyetvv9ujuvrcvd5xzapwvdhk6xz2z6u s,s nostr:nprofile1qqs2vpnedyjn8vcg78vx9s49efwq3gcyu52hk804ehs07pz5hxfqvpgpzemhxue69uhhyetvv9ujuvrcvd5xzapwvdhk6xz2z6u ksss');
  for (var pp in p) {
    print(pp.pubkey);
  }
}