/// filter is a JSON object that determines what events will be sent in that subscription
class Filter {
  /// a list of event ids or prefixes
  List<String>? ids;

  /// a list of pubkeys or prefixes, the pubkey of an event must be one of these
  List<String>? authors;

  /// a list of a kind numbers
  List<int>? kinds;

  /// a list of event ids that are referenced in an "e" tag
  List<String>? e;

  /// a list of pubkeys that are referenced in a "p" tag
  List<String>? p;

  /// a list of pubkeys that are referenced in a "P" tag
  List<String>? P;

  /// a list of identifiers that are referenced in a "d" tag
  List<String>? d;

  /// a list of identifiers that are referenced in a "t" tag
  List<String>? t;

  /// a list of identifiers that are referenced in a "h" tag
  List<String>? h;

  /// a list of bolt11 in a "bolt11" tag
  List<String>? bolt11;

  /// a timestamp, events must be newer than this to pass
  int? since;

  /// a timestamp, events must be older than this to pass
  int? until;

  /// maximum number of events to be returned in the initial query
  int? limit;

  /// NIP-50: Search capability - a string describing a query in human-readable form
  /// e.g. "best nostr apps" or "orange include:spam language:en"
  /// May contain key:value pairs as extensions (include:spam, domain:, language:, sentiment:, nsfw:)
  String? search;

  /// Default constructor
  Filter(
      {this.ids,
      this.authors,
      this.kinds,
      this.e,
      this.p,
      this.P,
      this.d,
      this.t,
      this.h,
      this.bolt11,
      this.since,
      this.until,
      this.limit,
      this.search});

  /// Deserialize a filter from a JSON
  Filter.fromJson(Map<String, dynamic> json) {
    ids = json['ids'] == null ? null : List<String>.from(json['ids']);
    authors =
        json['authors'] == null ? null : List<String>.from(json['authors']);
    kinds = json['kinds'] == null ? null : List<int>.from(json['kinds']);
    e = json['#e'] == null ? null : List<String>.from(json['#e']);
    p = json['#p'] == null ? null : List<String>.from(json['#p']);
    P = json['#P'] == null ? null : List<String>.from(json['#P']);
    d = json['#d'] == null ? null : List<String>.from(json['#d']);
    t = json['#t'] == null ? null : List<String>.from(json['#t']);
    h = json['#h'] == null ? null : List<String>.from(json['#h']);
    bolt11 =
        json['#bolt11'] == null ? null : List<String>.from(json['#bolt11']);

    since = json['since'];
    until = json['until'];
    limit = json['limit'];
    search = json['search'];
  }

  /// Serialize a filter in JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (ids != null) {
      data['ids'] = ids;
    }
    if (authors != null) {
      data['authors'] = authors;
    }
    if (kinds != null) {
      data['kinds'] = kinds;
    }
    if (e != null) {
      data['#e'] = e;
    }
    if (p != null) {
      data['#p'] = p;
    }
    if (P != null) {
      data['#P'] = P;
    }
    if (d != null) {
      data['#d'] = d;
    }
    if (t != null) {
      data['#t'] = t;
    }
    if (h != null) {
      data['#h'] = h;
    }
    if (bolt11 != null) {
      data['#bolt11'] = bolt11;
    }
    if (since != null) {
      data['since'] = since;
    }
    if (until != null) {
      data['until'] = until;
    }
    if (limit != null) {
      data['limit'] = limit;
    }
    if (search != null) {
      data['search'] = search;
    }
    return data;
  }
}
