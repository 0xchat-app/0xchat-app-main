import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ox_common/mixin/common_state_view_mixin.dart';
import 'package:ox_common/mixin/common_navigator_observer_mixin.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/widgets/common_pull_refresher.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_network_image.dart';
import 'package:ox_module_service/ox_module_service.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import '../discovery_page.dart';

class NAppModel {
  final String id;
  final String url;
  final String name;
  final String icon;
  final String description;
  final Map<String, dynamic> metadata;

  NAppModel({
    required this.id,
    required this.url,
    required this.name,
    required this.icon,
    required this.description,
    this.metadata = const {},
  });

  // Helper getter for backward compatibility
  String get iconUrl => icon;
  
  // Convert to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'url': url,
      'name': name,
      'icon': icon,
      'description': description,
      'metadata': metadata,
    };
  }

  // Create from Map
  factory NAppModel.fromMap(Map<String, dynamic> map) {
    return NAppModel(
      id: map['id'] ?? '',
      url: map['url'] ?? '',
      name: map['name'] ?? '',
      icon: map['icon'] ?? '',
      description: map['description'] ?? '',
      metadata: map['metadata'] is Map ? Map<String, dynamic>.from(map['metadata']) : {},
    );
  }
}

class NAppPage extends StatefulWidget {
  final ENAppFilterType? filterType;
  const NAppPage({Key? key, this.filterType}) : super(key: key);

  @override
  State<NAppPage> createState() => _NAppPageState();
}

class _NAppPageState extends State<NAppPage>
    with
        AutomaticKeepAliveClientMixin,
        OXUserInfoObserver,
        CommonStateViewMixin,
        WidgetsBindingObserver,
        NavigatorObserverMixin {
  final RefreshController _refreshController = RefreshController();
  final TextEditingController _searchController = TextEditingController();
  List<NAppModel> _nappList = [];
  List<NAppModel> _filteredNappList = [];
  String _searchQuery = '';
  Map<String, NAppModel> _nappMap = {}; // Map for quick lookup by id

  @override
  void initState() {
    super.initState();
    OXUserInfoManager.sharedInstance.addObserver(this);
    WidgetsBinding.instance.addObserver(this);
    _loadNappList();
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _loadNappList() async {
    try {
      // Load NApp list from JSON file
      final String jsonString = await rootBundle.loadString('packages/ox_discovery/assets/napp_list.json');
      final List<dynamic> jsonList = jsonDecode(jsonString);
      
      _nappList = jsonList.map((item) => NAppModel.fromMap(item as Map<String, dynamic>)).toList();
      
      // Create a map for quick lookup by id
      _nappMap = {for (var napp in _nappList) napp.id: napp};
      
      if (mounted) {
        await _applyFilter();
      }
    } catch (e) {
      print('Error loading napp_list.json: $e');
      // Fallback to empty list
      _nappList = [];
      _nappMap = {};
      if (mounted) {
        await _applyFilter();
      }
    }
  }

  void _onSearchChanged() {
    _searchQuery = _searchController.text;
    _applyFilter();
  }

  Future<void> _recordNappAccess(NAppModel napp) async {
    // Get current access history (only store ids)
    List<dynamic> history = await OXCacheManager.defaultOXCacheManager
        .getForeverData('napp_recent_history', defaultValue: []) ?? [];
    
    // Remove existing entry with same id (if any)
    history.removeWhere((item) => 
      item is Map && item['id'] == napp.id);
    
    // Add new entry at the beginning (only store id and timestamp)
    history.insert(0, {
      'id': napp.id,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
    
    // Keep only the most recent 20 entries
    if (history.length > 20) {
      history = history.sublist(0, 20);
    }
    
    // Save back to cache
    await OXCacheManager.defaultOXCacheManager
        .saveForeverData('napp_recent_history', history);
  }

  Future<void> _applyFilter() async {
    List<NAppModel> filtered = [];

    // Apply filter type
    if (widget.filterType != null) {
      switch (widget.filterType!) {
        case ENAppFilterType.favorite:
          // Load bookmarked NApp ids from cache
          List<dynamic> bookmarkIds = await OXCacheManager.defaultOXCacheManager
              .getForeverData('napp_bookmarks', defaultValue: []) ?? [];
          
          // Get full NApp data by id from _nappMap
          filtered = bookmarkIds.map((item) {
            String? id;
            if (item is Map) {
              id = item['id'];
            } else if (item is String) {
              id = item;
            }
            if (id != null && _nappMap.containsKey(id)) {
              return _nappMap[id]!;
            }
            return null;
          }).whereType<NAppModel>().toList();
          break;
        case ENAppFilterType.recent:
          // Load access history (only ids with timestamps)
          List<dynamic> history = await OXCacheManager.defaultOXCacheManager
              .getForeverData('napp_recent_history', defaultValue: []) ?? [];
          
          // Sort by timestamp (most recent first)
          List<Map<String, dynamic>> historyMaps = history
              .whereType<Map<String, dynamic>>()
              .where((item) => item['timestamp'] != null && item['id'] != null)
              .toList();
          historyMaps.sort((a, b) => 
              (b['timestamp'] as int).compareTo(a['timestamp'] as int));
          
          // Get full NApp data by id from _nappMap
          filtered = historyMaps.map((item) {
            String? id = item['id'] as String?;
            if (id != null && _nappMap.containsKey(id)) {
              return _nappMap[id]!;
            }
            return null;
          }).whereType<NAppModel>().toList();
          break;
        case ENAppFilterType.all:
          filtered = List.from(_nappList);
          break;
      }
    } else {
      filtered = List.from(_nappList);
    }

    // Apply search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((napp) {
        return napp.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            napp.description.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    if (mounted) {
      setState(() {
        _filteredNappList = filtered;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    OXUserInfoManager.sharedInstance.removeObserver(this);
    WidgetsBinding.instance.removeObserver(this);
    _refreshController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // Refresh list when app comes to foreground, especially if showing favorite filter
    if (state == AppLifecycleState.resumed && widget.filterType == ENAppFilterType.favorite) {
      _applyFilter();
    }
  }

  @override
  Future<void> didPopNext() async {
    // Refresh favorite list when returning from another page (e.g., WebView)
    if (widget.filterType == ENAppFilterType.favorite) {
      await _applyFilter();
    }
  }

  @override
  void didUpdateWidget(NAppPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.filterType != oldWidget.filterType) {
      _applyFilter(); // async function, but we don't need to await here
    } else if (widget.filterType == ENAppFilterType.favorite) {
      // Refresh favorite list when widget updates (e.g., after returning from WebView)
      _applyFilter();
    }
  }

  @override
  stateViewCallBack(CommonStateView commonStateView) {
    switch (commonStateView) {
      case CommonStateView.CommonStateView_None:
        break;
      case CommonStateView.CommonStateView_NetworkError:
        break;
      case CommonStateView.CommonStateView_NoData:
        break;
      case CommonStateView.CommonStateView_NotLogin:
        break;
    }
  }

  void _onRefresh() async {
    await _loadNappList();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return OXSmartRefresher(
      controller: _refreshController,
      enablePullDown: true,
      enablePullUp: false,
      onRefresh: _onRefresh,
      onLoading: null,
      child: commonStateViewWidget(context, _buildContent()),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        _buildSearchBar(),
          Expanded(
          child: _buildNappList(),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 24.px,
        vertical: 6.px,
      ),
      height: 48.px,
      decoration: BoxDecoration(
        color: ThemeColor.color190,
        borderRadius: BorderRadius.circular(16.px),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(left: 18.px),
            child: CommonImage(
              iconName: 'icon_chat_search.png',
              width: 24.px,
              height: 24.px,
              fit: BoxFit.cover,
              package: 'ox_chat',
            ),
          ),
          SizedBox(width: 8.px),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: 'Search Nostr Apps',
                hintStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 15.px,
                  color: ThemeColor.color150,
                ),
              ),
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 15.px,
                color: ThemeColor.color0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNappList() {
    if (_filteredNappList.isEmpty) {
      return Center(
        child: Text(
          'No NApps found',
          style: TextStyle(
            fontSize: 14.px,
            color: ThemeColor.color120,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 24.px, vertical: 12.px),
      itemCount: _filteredNappList.length,
      itemBuilder: (context, index) {
        return _buildNappItem(_filteredNappList[index]);
      },
    );
  }

  Widget _buildNappItem(NAppModel napp) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        if (napp.url.isNotEmpty) {
          // Record access history
          await _recordNappAccess(napp);
          
          // Open NApp in built-in WebView with NIP-07 support
          OXModuleService.invoke('ox_common', 'gotoWebView', [
            context,
            napp.url,
            true, // isPresentPage: true means use built-in WebView
            true, // fullscreenDialog
            false, // isLocalHtmlResource
            null, // urlCallback
            {'title': napp.name, 'nappName': napp.name, 'nappUrl': napp.url, 'nappId': napp.id}, // extraParams
          ]);
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.px),
        child: Container(
          padding: EdgeInsets.all(16.px),
          decoration: BoxDecoration(
            color: ThemeColor.color190,
            borderRadius: BorderRadius.circular(16.px),
          ),
          child: Row(
            children: [
              // NApp Icon
              Container(
                width: 48.px,
                height: 48.px,
                decoration: BoxDecoration(
                  color: ThemeColor.color190,
                  borderRadius: BorderRadius.circular(8.px),
                ),
                child: _buildNappIcon(napp),
              ),
              SizedBox(width: 16.px),
              // NApp Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      napp.name,
                      style: TextStyle(
                        fontSize: 16.px,
                        fontWeight: FontWeight.bold,
                        color: ThemeColor.color0,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.px),
                    Text(
                      napp.description,
                      style: TextStyle(
                        fontSize: 14.px,
                        fontWeight: FontWeight.w400,
                        color: ThemeColor.color120,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.px),
              // Arrow Icon
              CommonImage(
                iconName: 'icon_arrow_more.png',
                width: 24.px,
                height: 24.px,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNappIcon(NAppModel napp) {
    final String iconUrl = napp.iconUrl;
    final Widget fallback = _buildNappIconFallback(napp);

    if (iconUrl.isEmpty) {
      return fallback;
    }

    final Widget iconWidget;
    if (_isSvgUrl(iconUrl)) {
      iconWidget = SvgPicture.network(
        iconUrl,
        width: 48.px,
        height: 48.px,
        fit: BoxFit.cover,
        placeholderBuilder: (_) => fallback,
      );
    } else {
      iconWidget = OXCachedNetworkImage(
        imageUrl: iconUrl,
        width: 48.px,
        height: 48.px,
        fit: BoxFit.cover,
        errorWidget: (context, url, error) => fallback,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8.px),
      child: iconWidget,
    );
  }

  Widget _buildNappIconFallback(NAppModel napp) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        napp.name.isNotEmpty ? napp.name[0].toUpperCase() : 'N',
        style: TextStyle(
          fontSize: 20.px,
          fontWeight: FontWeight.bold,
          color: ThemeColor.color0,
        ),
      ),
    );
  }

  bool _isSvgUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return false;
    final path = uri.path.toLowerCase();
    return path.endsWith('.svg') || path.contains('.svg');
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void didLoginSuccess(UserDBISAR? userInfo) {
    if (mounted) setState(() {});
  }

  @override
  void didLogout() {
    if (mounted) setState(() {});
  }

  @override
  void didSwitchUser(UserDBISAR? userInfo) {
    if (mounted) setState(() {});
  }
}

