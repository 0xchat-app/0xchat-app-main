import 'package:nostr_core_dart/src/filter.dart';
import 'package:nostr_core_dart/src/request.dart';
import 'package:test/test.dart';

void main() {
  group('Request', () {
    test('Constructor.toJson', () {
      Filter myFilter = Filter(
        ids: [
          "047663d895d56aefa3f528935c7ce7dc8939eb721a0ec76ef2e558a8257955d2"
        ],
        authors: [
          "0ba0206887bd61579bf65ec09d7806bea32c64be1cf2c978cf031a811cd238db"
        ],
        kinds: [0, 1, 2, 7],
        e: [],
        p: [],
        since: 1672477960,
        until: 1674063680,
        limit: 450,
      );

      Request req = Request("733209259899167", [myFilter]);

      expect(req.subscriptionId, "733209259899167");
      expect(req.filters[0].ids, myFilter.ids);
      expect(req.filters[0].authors, myFilter.authors);
      expect(req.filters[0].kinds, myFilter.kinds);
      expect(req.filters[0].e, myFilter.e);
      expect(req.filters[0].p, myFilter.p);
      expect(req.filters[0].kinds, myFilter.kinds);
      expect(req.filters[0].since, myFilter.since);
      expect(req.filters[0].until, myFilter.until);
      expect(req.filters[0].limit, myFilter.limit);
    });

    test('Request.serialize', () {
      String serialized =
          '["REQ","733209259899167",{"ids":["047663d895d56aefa3f528935c7ce7dc8939eb721a0ec76ef2e558a8257955d2"],"authors":["0ba0206887bd61579bf65ec09d7806bea32c64be1cf2c978cf031a811cd238db"],"kinds":[0,1,2,7],"#e":[],"#p":[],"since":1672477960,"until":1674063680,"limit":450},{"kinds":[0,1,2,7],"since":1673980547,"limit":450}]';
      var json = [
        "REQ",
        "733209259899167",
        {
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
        },
        {
          "kinds": [0, 1, 2, 7],
          "since": 1673980547,
          "limit": 450
        }
      ];
      Request req = Request.deserialize(json);
      expect(req.serialize(), serialized);
    });

    test('Request.deserialize', () {
      var json = [
        "REQ",
        "733209259899167",
        {
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
        },
        {
          "kinds": [0, 1, 2, 7],
          "since": 1673980547,
          "limit": 450
        }
      ];
      Request req = Request.deserialize(json);
      expect(req.subscriptionId, "733209259899167");
      expect(req.filters[0].ids,
          ["047663d895d56aefa3f528935c7ce7dc8939eb721a0ec76ef2e558a8257955d2"]);
      expect(req.filters[0].authors,
          ["0ba0206887bd61579bf65ec09d7806bea32c64be1cf2c978cf031a811cd238db"]);
      expect(req.filters[0].e, []);
      expect(req.filters[0].p, []);
      expect(req.filters[0].kinds, [0, 1, 2, 7]);
      expect(req.filters[0].since, 1672477960);
      expect(req.filters[0].until, 1674063680);
      expect(req.filters[0].limit, 450);
      expect(req.filters[1].kinds, [0, 1, 2, 7]);
      expect(req.filters[1].since, 1673980547);
      expect(req.filters[1].limit, 450);
    });
  });
}
