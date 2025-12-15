import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'public_moments_page.dart';

class MomentsViewPage extends StatefulWidget {
  const MomentsViewPage({Key? key}) : super(key: key);

  @override
  State<MomentsViewPage> createState() => _MomentsViewPageState();
}

class _MomentsViewPageState extends State<MomentsViewPage> {
  static const String _saveMomentFilterKey = 'momentFilterKey';
  static const String _saveMomentRelaysKey = 'momentRelaysKey';
  static const String _saveAllRelaysKey = 'momentAllRelaysKey';

  EPublicMomentsPageType _selectedType = EPublicMomentsPageType.contacts;
  List<String> _selectedRelays = [];
  List<String> _allGeneralRelays = [];
  final TextEditingController _relayController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() {
    _relayController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    // Load selected filter type
    final filterType = await OXCacheManager.defaultOXCacheManager
        .getForeverData(_saveMomentFilterKey, defaultValue: 1);
    _selectedType = EPublicMomentsPageTypeEx.getEnumType(filterType);

    final savedAllRelays = await OXCacheManager.defaultOXCacheManager
        .getListData(_saveAllRelaysKey);
    _allGeneralRelays = savedAllRelays.isNotEmpty 
        ? savedAllRelays 
        : Relays.sharedInstance.recommendGlobalRelays;
    
    // Load selected relays
    final relays = await OXCacheManager.defaultOXCacheManager
        .getListData(_saveMomentRelaysKey);
    _selectedRelays = relays.isNotEmpty ? relays : _getDefaultRelays();

    if (mounted) setState(() {});
  }

  List<String> _getDefaultRelays() {
    // Return recommendGlobalRelays as default
    return Relays.sharedInstance.recommendGlobalRelays;
  }


  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: ThemeColor.color190,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitle(textTheme),
                    _buildFilterOptions(textTheme),
                    SizedBox(height: 24.px),
                  ],
                ),
              ),
            ),
            _buildDoneButton(textTheme),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      height: 56.px,
      padding: EdgeInsets.symmetric(horizontal: 24.px),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => OXNavigator.pop(context),
              child: CommonImage(
                iconName: "title_close.png",
                size: 24.px,
                useTheme: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(TextTheme textTheme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.px, vertical: 16.px),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Posts View',
            style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.px),
          Text(
            'Select what content appears in your timeline.',
            style: textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterOptions(TextTheme textTheme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.px, vertical: 16.px),
      child: Column(
        children: [
          _buildFilterCard(EPublicMomentsPageType.contacts, textTheme),
          SizedBox(height: 12.px),
          _buildFilterCard(EPublicMomentsPageType.global, textTheme),
          SizedBox(height: 12.px),
          _buildFilterCard(EPublicMomentsPageType.reacted, textTheme),
          SizedBox(height: 12.px),
          _buildFilterCard(EPublicMomentsPageType.private, textTheme),
        ],
      ),
    );
  }

  Widget _buildFilterCard(EPublicMomentsPageType type, TextTheme textTheme) {
    final isSelected = _selectedType == type;
    final isGlobal = type == EPublicMomentsPageType.global;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = type;
        });
      },
      child: Container(
        padding: EdgeInsets.all(16.px),
        decoration: BoxDecoration(
          color: ThemeColor.color180,
          borderRadius: BorderRadius.circular(16.px),
          border: Border.all(
            color: isSelected ? ThemeColor.color0 : Colors.transparent,
            width: 2.px,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildFilterIcon(type),
                SizedBox(width: 12.px),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        type.text,
                          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 4.px),
                      Text(
                        type.subtitle,
                          style: textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    size: 24.px,
                    color: ThemeColor.color0,
                  ),
              ],
            ),
            if (isGlobal && isSelected) ...[
              SizedBox(height: 16.px),
              _buildSourceRelaysSection(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFilterIcon(EPublicMomentsPageType type) {
    IconData iconData;
    switch (type) {
      case EPublicMomentsPageType.global:
        iconData = Icons.public;
        break;
      case EPublicMomentsPageType.contacts:
        iconData = Icons.people;
        break;
      case EPublicMomentsPageType.reacted:
        iconData = Icons.favorite;
        break;
      case EPublicMomentsPageType.private:
        iconData = Icons.lock;
        break;
    }
    return Icon(
      iconData,
      size: 24.px,
      color: ThemeColor.color0,
    );
  }

  Widget _buildSourceRelaysSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.wifi,
              size: 20.px,
              color: ThemeColor.color0,
            ),
            SizedBox(width: 8.px),
            Text(
              'SOURCE RELAYS',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(width: 8.px),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.px, vertical: 2.px),
              decoration: BoxDecoration(
                color: ThemeColor.color170,
                borderRadius: BorderRadius.circular(12.px),
              ),
              child: Text(
                '${_selectedRelays.length}',
                style: TextStyle(
                  color: ThemeColor.color0,
                  fontSize: 12.px,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.px),
        _buildRelayInput(),
        SizedBox(height: 12.px),
        _buildRelayList(),
      ],
    );
  }

  Widget _buildRelayInput() {
    return Container(
      decoration: BoxDecoration(
        color: ThemeColor.color180,
        borderRadius: BorderRadius.circular(12.px),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _relayController,
              decoration: InputDecoration(
                hintText: 'wss://...',
                hintStyle: TextStyle(
                  color: ThemeColor.color100,
                  fontSize: 15.px,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.px,
                  vertical: 12.px,
                ),
              ),
              style: TextStyle(
                color: ThemeColor.color0,
                fontSize: 15.px,
              ),
            ),
          ),
          GestureDetector(
            onTap: _addRelay,
            child: Container(
              margin: EdgeInsets.all(8.px),
              width: 24.px,
              height: 24.px,
              decoration: BoxDecoration(
                color: ThemeColor.color0,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '+',
                  style: TextStyle(
                    color: ThemeColor.color200,
                    fontSize: 20.px,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelayList() {
    // Show all general relays, not just selected ones
    if (_allGeneralRelays.isEmpty) {
      return Container();
    }

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: 200.px, // Maximum height for the relay list
      ),
      child: SingleChildScrollView(
        child: Column(
          children: _allGeneralRelays.map((relay) {
            final isSelected = _selectedRelays.contains(relay);
            return _buildRelayItem(relay, isSelected);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildRelayItem(String relay, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedRelays.remove(relay);
          } else {
            _selectedRelays.add(relay);
          }
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8.px),
        padding: EdgeInsets.symmetric(vertical: 8.px, horizontal: 12.px),
        decoration: BoxDecoration(
          color: isSelected ? ThemeColor.color170 : Colors.transparent,
          borderRadius: BorderRadius.circular(8.px),
        ),
        child: Row(
          children: [
            Container(
              width: 24.px,
              height: 24.px,
              decoration: BoxDecoration(
                color: isSelected ? ThemeColor.color0 : Colors.transparent,
                border: Border.all(
                  color: ThemeColor.color0,
                  width: 2.px,
                ),
                borderRadius: BorderRadius.circular(4.px),
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      size: 16.px,
                      color: ThemeColor.color200,
                    )
                  : null,
            ),
            SizedBox(width: 12.px),
            Expanded(
              child: Text(
                relay,
                style: Theme.of(context).textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoneButton(TextTheme textTheme) {
    return Container(
      margin: EdgeInsets.all(24.px),
      width: double.infinity,
      height: 48.px,
      decoration: BoxDecoration(
        color: ThemeColor.color0,
        borderRadius: BorderRadius.circular(24.px),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _saveSettings,
          borderRadius: BorderRadius.circular(24.px),
          child: Center(
            child: Text(
              'Done',
              style: textTheme.titleSmall?.copyWith(
                color: ThemeColor.color200,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _addRelay() {
    final relay = _relayController.text.trim();
    if (relay.isEmpty) {
      CommonToast.instance.show(context, 'Please enter a relay URL');
      return;
    }

    if (!_isValidRelayUrl(relay)) {
      CommonToast.instance.show(context, 'Invalid relay URL format');
      return;
    }

    if (_allGeneralRelays.contains(relay)) {
      CommonToast.instance.show(context, 'Relay already exists');
      return;
    }

    setState(() {
      _allGeneralRelays.add(relay);
      _selectedRelays.add(relay);
      _relayController.clear();
    });
  }

  bool _isValidRelayUrl(String url) {
    final regex = RegExp(
        r'^wss?:\/\/(([a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,})|(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}))(:\d{1,5})?(\/\S*)?$');
    return regex.hasMatch(url);
  }

  Future<void> _saveSettings() async {
    // Save filter type
    await OXCacheManager.defaultOXCacheManager
        .saveForeverData(_saveMomentFilterKey, _selectedType.changeInt);

    // Save selected relays
    await OXCacheManager.defaultOXCacheManager
        .saveListData(_saveMomentRelaysKey, _selectedRelays);

    // Save all general relays (user's relay list for display)
    await OXCacheManager.defaultOXCacheManager
        .saveListData(_saveAllRelaysKey, _allGeneralRelays);

    if (mounted) {
      OXNavigator.pop(context, {
        'type': _selectedType,
        'relays': _selectedRelays,
      });
    }
  }
}

