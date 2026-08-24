import 'package:nostr_core_dart/src/filter.dart';
import 'package:test/test.dart';

void main() {
  group('Filter', () {
    test('Default constructor', () {
      List<String> ids = [
        "047663d895d56aefa3f528935c7ce7dc8939eb721a0ec76ef2e558a8257955d2"
      ];
      List<String> authors = [
        "0ba0206887bd61579bf65ec09d7806bea32c64be1cf2c978cf031a811cd238db"
      ];
      List<int> kinds = [0, 1, 2, 7];
      List<String> e = [];
      List<String> p = [];
      int since = 1672477960;
      int until = 1674063680;
      int limit = 450;

      Filter filter = Filter(
        ids: ids,
        authors: authors,
        kinds: kinds,
        e: e,
        p: p,
        since: since,
        until: until,
        limit: limit,
      );

      expect(filter.ids, ids);
      expect(filter.authors, authors);
      expect(filter.kinds, kinds);
      expect(filter.e, e);
      expect(filter.p, p);
      expect(filter.since, since);
      expect(filter.until, until);
      expect(filter.limit, limit);
    });

    test('Constructor.fromJson', () {
      var json = {
        "ids": [
          "047663d895d56aefa3f528935c7ce7dc8939eb721a0ec76ef2e558a8257955d2"
        ],
        "authors": [
          "0ba0206887bd61579bf65ec09d7806bea32c64be1cf2c978cf031a811cd238db"
        ],
        "kinds": [0, 1, 2, 7],
        "#e": [],
        "#p": [],
        "since": 1672477960,
        "until": 1674063680,
        "limit": 450
      };

      Filter filter = Filter.fromJson(json);
      expect(filter.ids, json['ids']);
      expect(filter.authors, json['authors']);
      expect(filter.kinds, json['kinds']);
      expect(filter.e, json['#e']);
      expect(filter.p, json['#p']);
      expect(filter.since, json['since']);
      expect(filter.until, json['until']);
      expect(filter.limit, json['limit']);
    });
  });
}
