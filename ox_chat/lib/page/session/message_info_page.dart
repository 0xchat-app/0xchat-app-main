import 'package:flutter/material.dart';
import 'package:chatcore/chat-core.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_localizable/ox_localizable.dart';

class MessageInfoPage extends StatefulWidget {
  /// Event ID to query - can be giftwrappedEventId for gift-wrapped messages
  /// or messageId for normal messages
  final String giftwrappedEventId;

  const MessageInfoPage({
    super.key,
    required this.giftwrappedEventId,
  });

  static void show(BuildContext context, {required String giftwrappedEventId}) {
    OXNavigator.pushPage(
      context,
      (context) => MessageInfoPage(giftwrappedEventId: giftwrappedEventId),
    );
  }

  @override
  State<MessageInfoPage> createState() => _MessageInfoPageState();
}

class _MessageInfoPageState extends State<MessageInfoPage> {
  EventDBISAR? eventDB;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEventData();
  }

  Future<void> _loadEventData() async {
    try {
      final event = await EventCache.sharedInstance.loadEventFromDB(widget.giftwrappedEventId);
      setState(() {
        eventDB = event;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.color180,
      appBar: AppBar(
        backgroundColor: ThemeColor.color180,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ThemeColor.color0),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          Localized.text('ox_chat.message_info_title'),
          style: TextStyle(color: ThemeColor.color0, fontSize: 18.sp),
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: ThemeColor.color0,
              ),
            )
          : eventDB == null
              ? Center(
                  child: Text(
                    Localized.text('ox_chat.message_info_not_found'),
                    style: TextStyle(color: ThemeColor.color60, fontSize: 14.sp),
                  ),
                )
              : _buildContent(),
    );
  }

  Widget _buildContent() {
    final sendStatuses = eventDB!.eventSendStatus;
    
    if (sendStatuses.isEmpty) {
      return Center(
        child: Text(
          Localized.text('ox_chat.message_info_no_status'),
          style: TextStyle(color: ThemeColor.color60, fontSize: 14.sp),
        ),
      );
    }

    final successRelays = sendStatuses.where((s) => s.status).toList();
    final failedRelays = sendStatuses.where((s) => !s.status).toList();

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.px),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (successRelays.isNotEmpty) ...[
            _buildSectionHeader(Localized.text('ox_chat.message_info_success_relays')),
            SizedBox(height: 8.px),
            ...successRelays.map((status) => _buildRelayItem(status, isSuccess: true)),
            SizedBox(height: 24.px),
          ],
          if (failedRelays.isNotEmpty) ...[
            _buildSectionHeader(Localized.text('ox_chat.message_info_failed_relays')),
            SizedBox(height: 8.px),
            ...failedRelays.map((status) => _buildRelayItem(status, isSuccess: false)),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        color: ThemeColor.color0,
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildRelayItem(EventStatusISAR status, {required bool isSuccess}) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.px),
      padding: EdgeInsets.all(12.px),
      decoration: BoxDecoration(
        color: ThemeColor.color160,
        borderRadius: BorderRadius.circular(8.px),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8.px,
                height: 8.px,
                decoration: BoxDecoration(
                  color: isSuccess ? Colors.green : Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 8.px),
              Expanded(
                child: Text(
                  status.relay,
                  style: TextStyle(
                    color: ThemeColor.color0,
                    fontSize: 14.sp,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (status.message.isNotEmpty) ...[
            SizedBox(height: 4.px),
            Text(
              status.message,
              style: TextStyle(
                color: ThemeColor.color60,
                fontSize: 12.sp,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

