import 'package:nostr_core_dart/nostr.dart';

Future<void> main() async {
  var sender = Keychain(
      "fb505c65d4df950f5d28c9e4d285ee12ffaf315deef1fc24e3c7cd1e7e35f2b1");
  var p1 = "9ec7a778167afb1d30c4833de9322da0c08ba71a69e1911d5578d3144bb56437";
  var p2 = "8c0da4862130283ff9e67d889df264177a508974e2feb96de139804ea66d6168";

  List<People> items = [People(p1, "aliasPubKey", "mainRelay", "petName"), People(p2, "aliasPubKey", "mainRelay", "petName")];
  Event event = await Nip51.createCategorizedPeople(
      "identifier", [], items, sender.private, sender.public);
  print(event.content);
  Lists lists = await Nip51.getLists(event, sender.private);
  print(lists.people.toString());
}
