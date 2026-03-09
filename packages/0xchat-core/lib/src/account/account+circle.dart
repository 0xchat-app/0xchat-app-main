import 'dart:async';
import 'package:chatcore/chat-core.dart';
import 'package:isar/isar.dart';

extension AccountCircle on Account {
  /// Logout from current circle and clean up resources
  Future<void> _logoutCircle() async {
    await NotificationHelper.sharedInstance.logout();
    await Connect.sharedInstance.closeAllConnects();
    Contacts.sharedInstance.allContacts.clear();
    Contacts.sharedInstance.secretSessionMap.clear();
    Channels.sharedInstance.myChannels.clear();
    Groups.sharedInstance.myGroups.clear();
    Groups.sharedInstance.currentGroupRelays.clear();
    RelayGroup.sharedInstance.myGroups.clear();
    RelayGroup.sharedInstance.groupRelays.clear();
    Relays.sharedInstance.relays.clear();
    EventCache.sharedInstance.cacheIds.clear();
    await DBISAR.sharedInstance.closeDatabase();
  }

  /// Switch to a different circle or create a new one if it doesn't exist
  /// [circleId] Unique circle identifier
  /// Returns the circle object, null if failed
  Future<CircleDBISAR?> switchToCircle(String circleId) async {
    if (circleId.isEmpty) return null;
    await _logoutCircle();
    await DBISAR.sharedInstance.open(currentPubkey, circleId: circleId);
    await syncMe();
    return await getCircleById(circleId);
  }

  /// Create a new circle or switch to an existing one
  /// [circleId] Unique circle identifier
  /// [name] Circle name
  /// [description] Circle description
  /// [image] Circle avatar URL
  /// [relayList] Relay server list
  /// [fileserverList] File server list
  /// [iceserverList] ICE server list
  /// [pushserverList] Push server list
  /// [groupId] Associated group ID (optional)
  /// Returns the circle object, null if failed
  Future<CircleDBISAR?> createCircle({
    required String circleId,
    required String name,
    String description = '',
    String image = '',
    List<String> relayList = const [],
    List<String> fileserverList = const [],
    List<String> iceserverList = const [],
    List<String> pushserverList = const [],
    String? groupId,
    String? dbPath,
  }) async {
    try {
      // Logout from current circle first
      await _logoutCircle();

      // Open database with the target circle ID
      await DBISAR.sharedInstance.open(
        currentPubkey,
        circleId: circleId,
        dbPath: dbPath,
      );

      // Sync user profile
      await syncMe();

      // Check if circle already exists
      final existingCircle = await getCircleById(circleId);
      if (existingCircle != null) {
        LogUtils.v(() => 'Switched to existing circle: ${existingCircle.name}');
        return existingCircle;
      }

      // Create new circle if it doesn't exist
      return await _newcircle(
        circleId: circleId,
        name: name,
        description: description,
        image: image,
        relayList: relayList,
        fileserverList: fileserverList,
        iceserverList: iceserverList,
        pushserverList: pushserverList,
        groupId: groupId,
      );
    } catch (e) {
      LogUtils.e(() => 'Failed to switch circle: $e');
      return null;
    }
  }

  /// Create a new circle
  /// [circleId] Unique circle identifier
  /// [name] Circle name
  /// [description] Circle description
  /// [image] Circle avatar URL
  /// [relayList] Relay server list
  /// [fileserverList] File server list
  /// [iceserverList] ICE server list
  /// [pushserverList] Push server list
  /// [groupId] Associated group ID (optional)
  /// Returns the created circle object, null if failed
  Future<CircleDBISAR?> _newcircle({
    required String circleId,
    required String name,
    String description = '',
    String image = '',
    List<String> relayList = const [],
    List<String> fileserverList = const [],
    List<String> iceserverList = const [],
    List<String> pushserverList = const [],
    String? groupId,
  }) async {
    try {
      // Validate input parameters
      if (circleId.trim().isEmpty) {
        LogUtils.e(() => 'Circle ID cannot be empty');
        return null;
      }

      if (name.trim().isEmpty) {
        LogUtils.e(() => 'Circle name cannot be empty');
        return null;
      }

      // Check if a circle with the same ID already exists
      final existingCircle = await getCircleById(circleId);
      if (existingCircle != null) {
        LogUtils.e(() => 'Circle with ID "$circleId" already exists');
        return null;
      }

      // Create new circle object
      final circle = CircleDBISAR(
        circleId: circleId,
        name: name.trim(),
        description: description.trim(),
        image: image.trim(),
        relayList: relayList,
        fileserverList: fileserverList,
        iceserverList: iceserverList,
        pushserverList: pushserverList,
        groupId: groupId,
      );

      // Save to database
      await DBISAR.sharedInstance.saveToDB(circle);

      LogUtils.v(() => 'Successfully created circle: ${circle.name}');
      return circle;
    } catch (e) {
      LogUtils.e(() => 'Failed to create circle: $e');
      return null;
    }
  }

  /// Delete a circle and its entire database
  /// [deleteId] Circle ID to delete
  /// [switchId] Circle ID to switch to after deletion
  /// Returns whether deletion was successful
  Future<bool> deletecircle(String deleteId, [String? switchId]) async {
    try {
      if (deleteId.isEmpty) return false;

      // If a switchId is provided and not the same as deleteId, attempt to switch first
      if (switchId != null && switchId.isNotEmpty && switchId != deleteId) {
        final switchSuccess = await switchToCircle(switchId);
        if (switchSuccess != null) {
          LogUtils.w(() => 'Switch to circle $switchId failed, will continue deleting $deleteId');
        }
      } else {
        await _logoutCircle();
      }

      // Delete DB files of the circle
      final success = await DBISAR.sharedInstance.delete(
        currentPubkey,
        circleId: deleteId,
      );

      if (success) {
        LogUtils.v(() => 'Successfully deleted circle: $deleteId');
      } else {
        LogUtils.w(() => 'Failed to delete circle: $deleteId');
      }

      return success;
    } catch (e) {
      LogUtils.e(() => 'Failed to delete circle: $e');
      return false;
    }
  }

  /// Update circle information
  /// [circleId] Circle ID
  /// [name] New circle name
  /// [description] New circle description
  /// [image] New circle avatar URL
  /// [relayList] New relay server list
  /// [fileserverList] New file server list
  /// [iceserverList] New ICE server list
  /// [pushserverList] New push server list
  /// [groupId] New associated group ID
  /// Returns the updated circle object, null if failed
  Future<CircleDBISAR?> updatecircle({
    required String circleId,
    String? name,
    String? description,
    String? image,
    List<String>? relayList,
    List<String>? fileserverList,
    List<String>? iceserverList,
    List<String>? pushserverList,
    String? groupId,
  }) async {
    try {
      final isar = DBISAR.sharedInstance.isar;

      // Find the circle to update
      final circle = await isar.circleDBISARs
          .filter()
          .circleIdEqualTo(circleId)
          .findFirst();
      if (circle == null) {
        LogUtils.e(() => 'Circle with id $circleId not found');
        return null;
      }

      // Check if new name conflicts with other circles
      if (name != null && name.trim().isNotEmpty && name != circle.name) {
        final existingCircle = await getCircleByName(name);
        if (existingCircle != null && existingCircle.circleId != circleId) {
          LogUtils.e(() => 'Circle with name "$name" already exists');
          return null;
        }
      }

      // Update circle information
      if (name != null && name.trim().isNotEmpty) circle.name = name.trim();
      if (description != null) circle.description = description.trim();
      if (image != null) circle.image = image.trim();
      if (relayList != null) circle.relayList = relayList;
      if (fileserverList != null) circle.fileserverList = fileserverList;
      if (iceserverList != null) circle.iceserverList = iceserverList;
      if (pushserverList != null) circle.pushserverList = pushserverList;
      if (groupId != null) circle.groupId = groupId;

      // Save updates
      await DBISAR.sharedInstance.saveToDB(circle);

      LogUtils.v(() => 'Successfully updated circle: ${circle.name}');
      return circle;
    } catch (e) {
      LogUtils.e(() => 'Failed to update circle: $e');
      return null;
    }
  }

  /// Get circle by name
  /// [name] Circle name
  /// Returns circle object, null if not found
  Future<CircleDBISAR?> getCircleByName(String name) async {
    try {
      final isar = DBISAR.sharedInstance.isar;
      final circles =
          await isar.circleDBISARs.filter().nameEqualTo(name).findAll();
      return circles.isNotEmpty ? circles.first : null;
    } catch (e) {
      LogUtils.e(() => 'Failed to get circle by name: $e');
      return null;
    }
  }

  /// Get all circles
  /// Returns list of circles
  Future<List<CircleDBISAR>> getAllCircles() async {
    try {
      final isar = DBISAR.sharedInstance.isar;
      return await isar.circleDBISARs.where().findAll();
    } catch (e) {
      LogUtils.e(() => 'Failed to get all circles: $e');
      return [];
    }
  }

  /// Get circle by ID
  /// [circleId] Circle ID
  /// Returns circle object, null if not found
  Future<CircleDBISAR?> getCircleById(String circleId) async {
    try {
      final isar = DBISAR.sharedInstance.isar;
      return await isar.circleDBISARs
          .filter()
          .circleIdEqualTo(circleId)
          .findFirst();
    } catch (e) {
      LogUtils.e(() => 'Failed to get circle by id: $e');
      return null;
    }
  }
}
