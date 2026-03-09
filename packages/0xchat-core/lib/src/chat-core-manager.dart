import 'package:chatcore/chat-core.dart';

/// Chat core manager responsible for initializing and managing chat functionality components
///
/// Uses singleton pattern to ensure only one global instance
class ChatCoreManager {
  /// Private constructor to prevent external instantiation
  ChatCoreManager._internal();

  /// Factory constructor that returns singleton instance
  factory ChatCoreManager() => _instance;

  /// Singleton instance
  static final ChatCoreManager _instance = ChatCoreManager._internal();

  /// Whether in lite mode
  bool _isLite = false;

  /// Get current lite mode status
  bool get isLite => _isLite;

  /// Initialize chat core functionality
  ///
  /// [isLite] - Whether to enable lite mode, channels and moments are not loaded in lite mode
  /// [contactUpdatedCallBack] - Contact update callback
  /// [channelsUpdatedCallBack] - Channels update callback
  /// [groupsUpdatedCallBack] - Groups update callback
  /// [relayGroupsUpdatedCallBack] - Relay groups update callback
  ///
  /// Throws exception if initialization fails
  Future<void> initChatCore({
    bool isLite = false,
    String? circleRelay,
    ContactUpdatedCallBack? contactUpdatedCallBack,
    ChannelsUpdatedCallBack? channelsUpdatedCallBack,
    GroupsUpdatedCallBack? groupsUpdatedCallBack,
    GroupsUpdatedCallBack? relayGroupsUpdatedCallBack,
  }) async {
    try {
      _isLite = isLite;

      // Load all event cache from database
      await EventCache.sharedInstance.loadAllEventsFromDB();

      // Initialize relay service
      await Relays.sharedInstance.init(circleRelay: circleRelay);

      // Initialize core components
      await _initCoreComponents(
        contactUpdatedCallBack: contactUpdatedCallBack,
        groupsUpdatedCallBack: groupsUpdatedCallBack,
      );

      // Initialize extended features if not in lite mode
      if (!_isLite) {
        await _initExtendedFeatures(
          channelsUpdatedCallBack: channelsUpdatedCallBack,
          relayGroupsUpdatedCallBack: relayGroupsUpdatedCallBack,
        );
      }
    } catch (e) {
      // Log error and rethrow
      print('ChatCoreManager initialization failed: $e');
      rethrow;
    }
  }

  /// Initialize core components
  Future<void> _initCoreComponents({
    ContactUpdatedCallBack? contactUpdatedCallBack,
    GroupsUpdatedCallBack? groupsUpdatedCallBack,
  }) async {
    // Initialize core components in parallel for better performance
    await Future.wait([
      Future(() => Messages.sharedInstance.init()),
      Future(() => Contacts.sharedInstance.init(callBack: contactUpdatedCallBack)),
      Future(() => Groups.sharedInstance.init(callBack: groupsUpdatedCallBack)),
    ]);
  }

  /// Initialize extended features
  Future<void> _initExtendedFeatures({
    ChannelsUpdatedCallBack? channelsUpdatedCallBack,
    GroupsUpdatedCallBack? relayGroupsUpdatedCallBack,
  }) async {
    // Initialize extended features in parallel
    await Future.wait([
      Future(() => Channels.sharedInstance.init(callBack: channelsUpdatedCallBack)),
      Future(() => Moment.sharedInstance.init()),
      Future(() => BadgesHelper.sharedInstance.init()),
      Future(() => Zaps.sharedInstance.init()),
      Future(() => RelayGroup.sharedInstance.init(callBack: relayGroupsUpdatedCallBack)),
    ]);
  }

  List<int> myProfileKinds() {
    return _isLite ? [0] : [0, 3, 10000, 10002, 10005, 10009, 10050, 30000, 30001, 30003, 30008];
  }

  List<int> userProfileKinds() {
    return _isLite ? [0] : [0, 10002, 10050, 30008];
  }

  bool isAcceptedEventKind(int kind) {
    final accepted = _isLite ? [0, 443, 444, 445, 1059, 10051, 7, 9] : [];
    return accepted.isEmpty || accepted.contains(kind);
  }
}
