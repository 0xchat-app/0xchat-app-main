import 'dart:async';
import 'dart:ui';
import 'package:chatcore/chat-core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/upload/file_type.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_select_relay_page.dart';


import 'package:flutter/services.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_discovery/enum/visible_type.dart';
import 'package:ox_discovery/page/moments/visibility_selection_page.dart';
import 'package:ox_discovery/page/widgets/send_progress_widget.dart';
import 'package:ox_discovery/utils/discovery_utils.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_module_service/ox_module_service.dart';

import '../../enum/moment_enum.dart';
import '../../manager/moment_draft_manager.dart';
import '../../model/moment_extension_model.dart';
import '../../model/moment_ui_model.dart';
import '../../utils/album_utils.dart';
import '../../utils/moment_content_analyze_utils.dart';
import '../../utils/moment_widgets_utils.dart';
import '../widgets/Intelligent_input_box_widget.dart';
import '../widgets/moment_quote_widget.dart';
import '../widgets/nine_palace_grid_picture_widget.dart';

import 'package:nostr_core_dart/nostr.dart';

// Relay selection type for sending posts
enum RelaySelectionType {
  outbox,
  general,
  all,
}

extension RelaySelectionTypeEx on RelaySelectionType {
  String get displayName {
    switch (this) {
      case RelaySelectionType.outbox:
        return 'Outbox Relays';
      case RelaySelectionType.general:
        return 'General Relays';
      case RelaySelectionType.all:
        return 'All';
    }
  }
  
  List<RelayKind> get relayKinds {
    switch (this) {
      case RelaySelectionType.outbox:
        return [RelayKind.outbox];
      case RelaySelectionType.general:
        return [RelayKind.general];
      case RelaySelectionType.all:
        return [RelayKind.general, RelayKind.outbox];
    }
  }
}

class CreateMomentsPage extends StatefulWidget {
  final String? groupId;
  final EOptionMomentsType sendMomentsType;
  final EMomentType? type;
  final List<String>? imageList;
  final String? videoPath;
  final String? videoImagePath;
  final NotedUIModel? notedUIModel;
  const CreateMomentsPage(
      {Key? key,
      this.type = EMomentType.picture,
      this.sendMomentsType = EOptionMomentsType.personal,
      this.groupId,
      this.imageList,
      this.videoPath,
      this.videoImagePath,
      this.notedUIModel})
      : super(key: key);

  @override
  State<CreateMomentsPage> createState() => _CreateMomentsPageState();
}

class _CreateMomentsPageState extends State<CreateMomentsPage> with WidgetsBindingObserver {
  String _chatRelay = 'wss://relay.0xchat.com';
  Map<String,UserDBISAR> draftCueUserMap = {};

  List<String> addImageList = [];
  List<String>? preImageList;


  String? videoPath;
  String? videoImagePath;

  bool _isInputFocused = false;

  bool _postMomentTag = false;

  final TextEditingController _textController = TextEditingController();

  final ProcessController _processController = ProcessController();
  final Completer<void> _completer = Completer<void>();
  Completer<String>? _uploadCompleter;

  int get totalCount => _visibleType == VisibleType.allContact
      ? Contacts.sharedInstance.allContacts.length
      : _selectedContacts?.length ?? 0;

  VisibleType _visibleType = VisibleType.everyone;
  List<UserDBISAR>? _selectedContacts;

  EMomentType? currentPageType;
  
  // Relay selection for sending posts
  RelaySelectionType _relaySelectionType = RelaySelectionType.outbox;

  // Auto-save timers
  Timer? _debounceTimer;
  Timer? _periodicSaveTimer;


  @override
  void initState() {
    // if(widget.imageList != null || widget.videoPath != null) {
    //   _uploadCompleter = Completer<String>();
    //   _getUploadMediaContent();
    // }
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initDraft();
    _setupAutoSave();
  }

  @override
  void dispose() {
    // Save draft before disposing
    _saveDraftImmediately();
    _debounceTimer?.cancel();
    _periodicSaveTimer?.cancel();
    _textController.removeListener(_onTextChanged);
    WidgetsBinding.instance.removeObserver(this);
    _processController.process.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // Save draft when app goes to background
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _saveDraftImmediately();
    }
  }

  void _initDraft() async {
    // Initialize draft manager and load drafts from persistent storage
    await MomentDraftManager.shared.setup();

    // Set currentPageType first from widget, then check for drafts
    currentPageType = widget.type;
    preImageList = widget.imageList;
    videoPath = widget.videoPath;
    videoImagePath = widget.videoImagePath;

    // Load draft if available and clear immediately after loading (show once only)
    final isGroup = widget.groupId != null;
    final cacheManager = OXMomentCacheManager.sharedInstance;
    final loadedDraft = isGroup 
        ? cacheManager.createGroupMomentMediaDraft
        : cacheManager.createMomentMediaDraft;
    
    if(loadedDraft != null){
      _textController.text = loadedDraft.content;
      _visibleType = loadedDraft.visibleType;
      _selectedContacts = loadedDraft.selectedContacts;
      draftCueUserMap = loadedDraft.draftCueUserMap ?? {};

      // Override with draft type if draft has media
      if(loadedDraft.type != EMomentType.content) {
        currentPageType = loadedDraft.type;
      }

      if(currentPageType == EMomentType.video){
        videoPath = loadedDraft.videoPath ?? videoPath;
        videoImagePath = loadedDraft.videoImagePath ?? videoImagePath;
      }

      if(currentPageType == EMomentType.picture){
        addImageList = loadedDraft.imageList ?? [];
      }
      
      // Clear draft immediately after loading (unified draft)
      MomentDraftManager.shared.saveDraft(
        isGroup: isGroup,
        draft: null,
      );
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        decoration: BoxDecoration(
          color: ThemeColor.color190,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(Adapt.px(20)),
            topLeft: Radius.circular(Adapt.px(20)),
          ),
        ),
        child: Stack(
          children: [
            Column(
                children: [
                  _buildAppBar(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.only(
                          left: 24.px,
                          right: 24.px,
                          bottom: currentPageType == EMomentType.content ? 100.px : 500.px,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _showEditImageWidget(),
                            _videoWidget(),
                            _pictureWidget(),
                            _quoteWidget(),
                            _captionWidget(),
                            _visibleContactsWidget(),
                            _selectRelayTypeWidget(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
            ),
            Align(
              child: SendProgressWidget(
                controller: _processController,
                totalCount: totalCount,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _labelWidget({
    required String title,
    required String content,
    required GestureTapCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: Adapt.px(52),
        decoration: BoxDecoration(
          color: ThemeColor.color180,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: Adapt.px(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: Adapt.px(16),
                fontWeight: FontWeight.w400,
                color: ThemeColor.color0,
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    _ellipsisText(content),
                    style: TextStyle(
                      fontSize: Adapt.px(16),
                      fontWeight: FontWeight.w400,
                      color: ThemeColor.color100,
                    ),
                  ),
                  CommonImage(
                    iconName: 'icon_arrow_more.png',
                    width: Adapt.px(24),
                    height: Adapt.px(24),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _ellipsisText(String text) {
    if (text.length > 30) {
      return text.substring(0, 10) +
          '...' +
          text.substring(text.length - 10, text.length);
    }
    return text;
  }

  Widget _showEditImageWidget() {
    if(currentPageType != null) return const SizedBox();
    return GestureDetector(
      onTap: () => {
        showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => _buildCreateMomentBottomDialog())
      },
      child: MomentWidgetsUtils.clipImage(
        borderRadius: 8.px,
        child: CommonImage(
          iconName: 'add_moment.png',
          fit: BoxFit.cover,
          package: 'ox_discovery',
          size: 104,
          useTheme: true,
        ),
      ),
    );
  }

  Widget _buildCreateMomentBottomDialog() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Adapt.px(12)),
        color: ThemeColor.color180,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildItem(
            Localized.text('ox_discovery.choose_camera_option'),
            index: -1,
            onTap: () {
              OXNavigator.pop(context);
              AlbumUtils.openCamera(context, (List<String> imageList) {
                currentPageType = EMomentType.picture;
                addImageList = [...addImageList,...imageList];
                setState(() {});
                _triggerDebounceSave();
              });
            },
          ),
          Divider(
            color: ThemeColor.color170,
            height: Adapt.px(0.5),
          ),
          _buildItem(
            Localized.text('ox_discovery.choose_image_option'),
            index: -1,
            onTap: () {
              OXNavigator.pop(context);
              AlbumUtils.openAlbum(context, type: 1,
                  callback: (List<String> imageList) {
                    currentPageType = EMomentType.picture;
                    addImageList = [...addImageList,...imageList];
                    setState(() {});
                    _triggerDebounceSave();
                  });
            },
          ),
          Divider(
            color: ThemeColor.color170,
            height: Adapt.px(0.5),
          ),
          _buildItem(
            Localized.text('ox_discovery.choose_video_option'),
            index: -1,
            onTap: () {
              OXNavigator.pop(context);
              AlbumUtils.openAlbum(
                  context,
                  type: 2,
                  selectCount: 1,
                  callback: (List<String> imageList) {
                    currentPageType = EMomentType.video;
                    videoPath = imageList[0];
                    videoImagePath = imageList[1];
                    setState(() {});
                    _triggerDebounceSave();

                    // OXNavigator.presentPage(
                    //   context,
                    //       (context) => CreateMomentsPage(
                    //     type: EMomentType.video,
                    //     videoPath: imageList[0],
                    //     videoImagePath: imageList[1],
                    //   ),
                    // );
                  });
            },
          ),
          Divider(
            color: ThemeColor.color170,
            height: Adapt.px(0.5),
          ),
          Container(
            height: Adapt.px(8),
            color: ThemeColor.color190,
          ),
          _buildItem(Localized.text('ox_common.cancel'), index: 3, onTap: () {
            OXNavigator.pop(context);
          }),
          SizedBox(
            height: Adapt.px(21),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(String title, {required int index, GestureTapCallback? onTap}) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: Adapt.px(56),
        child: Text(
          title,
          style: TextStyle(
            color: ThemeColor.color0,
            fontSize: Adapt.px(16),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildAppBar() {
    return Container(
      height: Adapt.px(57),
      margin: EdgeInsets.only(bottom: Adapt.px(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            child: CommonImage(
              iconName: "icon_back_left_arrow.png",
              width: Adapt.px(24),
              height: Adapt.px(24),
              useTheme: true,
            ),
            onTap: _checkSaveDraft,
          ),
          Text(
            Localized.text('ox_discovery.new_moments_title'),
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: Adapt.px(16),
                color: ThemeColor.color0),
          ),
          GestureDetector(
            onTap: _postMoment,
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  colors: [
                    ThemeColor.gradientMainEnd,
                    ThemeColor.gradientMainStart,
                  ],
                ).createShader(Offset.zero & bounds.size);
              },
              child: Text(
                Localized.text('ox_discovery.post'),
                style: TextStyle(
                  fontSize: Adapt.px(16),
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    ).setPadding(EdgeInsets.symmetric(
      horizontal: 24.px,
    ));
  }

  Widget _pictureWidget() {
    if (currentPageType != EMomentType.picture) return const SizedBox();
    return NinePalaceGridPictureWidget(
      isEdit: true,
      imageList: _getImageList(),
      delImageCallback:(int index) {
        if(preImageList != null &&  (preImageList!.length - 1 >= index )){
          preImageList!.removeAt(index);
        }else{
          addImageList.removeAt(index);
        }
        if(_getImageList().isEmpty){
          currentPageType = null;
        }
        setState(() {});
        _triggerDebounceSave();
      },
      addImageCallback: (List<String> newImageList) {
        addImageList = [...addImageList, ...newImageList];
        setState(() {});
        _triggerDebounceSave();
      },
    );
  }

  Widget _videoWidget() {
    if (currentPageType != EMomentType.video) return const SizedBox();
    return MomentWidgetsUtils.videoMoment(
        context,
        videoPath ?? '',
        videoImagePath ?? '',
        isEdit : true,
        delVideoCallback: (){
          videoPath = null;
          videoImagePath = null;
          currentPageType = null;
          setState(() {});
          _triggerDebounceSave();
        }
    );
  }

  Widget _quoteWidget() {
    NotedUIModel? notedUIModel = widget.notedUIModel;
    if (currentPageType != EMomentType.quote || notedUIModel == null) return const SizedBox();
    return MomentQuoteWidget(notedId: widget.notedUIModel!.noteDB.noteId);
  }

  Widget _captionWidget() {
    return Container(
      padding: EdgeInsets.only(
        top: 12.px,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(
              bottom: 12.px,
            ),
            child: Text(
              Localized.text('ox_discovery.caption'),
              style: TextStyle(
                  fontSize: 14.px,
                  fontWeight: FontWeight.w600,
                  color: ThemeColor.color0),
            ),
          ),
          IntelligentInputBoxWidget(
              textController: _textController,
              hintText: Localized.text('ox_discovery.caption_hint_text'),
              cueUserCallback: (List<UserDBISAR> userList){
                if(userList.isEmpty) return;
                for(UserDBISAR db in userList){
                  String? getName = db.name;
                  if(getName != null){
                    draftCueUserMap['@${getName}'] = db;
                    setState(() {});
                    _triggerDebounceSave();
                  }
                }
              },
              isFocusedCallback: (bool isFocus) {
                setState(() {
                  _isInputFocused = isFocus;
                });
              }),
        ],
      ),
    );
  }

  Widget _visibleContactsWidget() {
    if(currentPageType == EMomentType.quote) return const SizedBox();
    bool isGroup = EOptionMomentsType.group == widget.sendMomentsType;
    String content = _visibleType.name;
    if(isGroup){
      RelayGroupDBISAR? groupDB = RelayGroup.sharedInstance.myGroups[widget.groupId]?.value;
      content = 'Groups - ${groupDB?.name ?? ''}';
    }
    return Container(
      margin: EdgeInsets.only(
        top: 12.px,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(
              bottom: 12.px,
            ),
            child: Text(
              Localized.text('ox_discovery.visible_destination_title'),
              style: TextStyle(
                  fontSize: 14.px,
                  fontWeight: FontWeight.w600,
                  color: ThemeColor.color0),
            ),
          ),
          GestureDetector(
            onTap: (){
              if(isGroup) return;
              _visibleToUser();
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16.px,
              ),
              height: 48.px,
              decoration: BoxDecoration(
                color: ThemeColor.color180,
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    Adapt.px(12),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      width: 300.px,
                      child: Text(
                        content,
                        style: TextStyle(
                          fontSize: 16.px,
                          color: ThemeColor.color0,
                          fontWeight: FontWeight.w400,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                  if(!isGroup)
                  CommonImage(
                    iconName: 'moment_more_icon.png',
                    size: 24.px,
                    package: 'ox_discovery',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _visibleToUser() {
    OXNavigator.presentPage(
      context,
      (context) => VisibilitySelectionPage(
        visibleType: _visibleType,
        selectedContacts: _selectedContacts,
        onSubmitted: (type,items){
          setState(() {
            _visibleType = type;
            _selectedContacts = items;
          });
          _triggerDebounceSave();
        },
      ),
    );
  }

  Widget _selectRelayTypeWidget() {
    // Only show for public posts (everyone visibility)
    if (_visibleType != VisibleType.everyone || widget.sendMomentsType == EOptionMomentsType.group) {
      return const SizedBox();
    }
    
    return Container(
      margin: EdgeInsets.only(top: 12.px),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 12.px),
            child: Text(
              'Send to Server',
              style: TextStyle(
                fontSize: 14.px,
                fontWeight: FontWeight.w600,
                color: ThemeColor.color0,
              ),
            ),
          ),
          _labelWidget(
            title: 'Server',
            content: _relaySelectionType.displayName,
            onTap: () {
              _showRelaySelectionDialog();
            },
          ),
        ],
      ),
    );
  }

  void _showRelaySelectionDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Adapt.px(12)),
          color: ThemeColor.color180,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildRelaySelectionItem(
              RelaySelectionType.outbox,
              'Outbox Relays',
            ),
            Divider(
              color: ThemeColor.color170,
              height: Adapt.px(0.5),
            ),
            _buildRelaySelectionItem(
              RelaySelectionType.general,
              'General Relays',
            ),
            Divider(
              color: ThemeColor.color170,
              height: Adapt.px(0.5),
            ),
            _buildRelaySelectionItem(
              RelaySelectionType.all,
              'All',
            ),
            Divider(
              color: ThemeColor.color170,
              height: Adapt.px(0.5),
            ),
            Container(
              height: Adapt.px(8),
              color: ThemeColor.color190,
            ),
            _buildItem(
              Localized.text('ox_common.cancel'),
              index: -1,
              onTap: () {
                OXNavigator.pop(context);
              },
            ),
            SizedBox(height: Adapt.px(21)),
          ],
        ),
      ),
    );
  }

  Widget _buildRelaySelectionItem(RelaySelectionType type, String title) {
    final isSelected = _relaySelectionType == type;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        setState(() {
          _relaySelectionType = type;
        });
        OXNavigator.pop(context);
      },
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: Adapt.px(56),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16.px),
              child: Text(
                title,
                style: TextStyle(
                  color: ThemeColor.color0,
                  fontSize: Adapt.px(16),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (isSelected)
              Padding(
                padding: EdgeInsets.only(right: 16.px),
                child: Icon(
                  Icons.check,
                  color: ThemeColor.color0,
                  size: 24.px,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _selectRelayWidget(){
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: Adapt.px(12),
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              'Select relay',
              style: TextStyle(
                  fontSize: 14.px,
                  fontWeight: FontWeight.w600,
                  color: ThemeColor.color0,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            child: _labelWidget(
              title:  Localized.text('ox_chat.relay'),
              content: _chatRelay,
              onTap: () async {
                var result = await OXNavigator.presentPage(
                  context,
                      (context) => CommonSelectRelayPage(),
                );
                if (result != null) {
                  _chatRelay = result as String;
                  setState(() {});
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _checkSaveDraft() async {
    if(_textController.text.isEmpty && _getImageList().isEmpty && videoPath == null){
      OXNavigator.pop(context);
      return;
    }
   await OXCommonHintDialog.show(context,
        title: '',
        content: 'Whether to reserve this edit ?',
        actionList: [
          OXCommonHintAction(
            text: () => 'UnSave',
            style: OXHintActionStyle.gray,
            onTap: () {
              _optionDraft(null);
              OXNavigator.pop(context);
            },
          ),
          OXCommonHintAction.sure(
              text: 'Save',
              onTap: () async {
                _saveCreateMomentDraft();
                OXNavigator.pop(context);
              }),
        ],
        isRowAction: true,
    );
    OXNavigator.pop(context);

  }

  void _postMoment() async {

    // String getMediaStr = '';
    // if (_uploadCompleter != null) {
    //   getMediaStr = await _uploadCompleter!.future;
    // }
    if(_postMomentTag) return;
    
    // Check if outbox relays are available when outbox is selected
    if (_relaySelectionType == RelaySelectionType.outbox) {
      final outboxRelays = Connect.sharedInstance.relays(relayKinds: [RelayKind.outbox]);
      if (outboxRelays.isEmpty) {
        _postMomentTag = false;
        await _showNoOutboxRelaysDialog();
        return;
      }
    }
    
    _postMomentTag = true;
    OXLoading.show();

    String getMediaStr = await _getUploadMediaContent();
    OXLoading.dismiss();
    final inputText = _textController.text;
    String content = '${DiscoveryUtils.changeAtUserToNpub(draftCueUserMap, inputText)} $getMediaStr';
    OKEvent? event;

    NoteDBISAR? noteDB = widget.notedUIModel?.noteDB;

    List<String> hashTags = MomentContentAnalyzeUtils(content).getMomentHashTagList;
    List<String>? getHashTags = hashTags.isEmpty ? null : hashTags;
    List<String>? getReplyUser = DiscoveryUtils.getMentionReplyUserList(draftCueUserMap, inputText);

    if(content.trim().isEmpty){
      CommonToast.instance.show(context, Localized.text('ox_discovery.content_empty_tips'));
      _postMomentTag = false;
      return;
    }

    // Clear draft immediately when sending (before actual send)
    _optionDraft(null);

    if(widget.sendMomentsType == EOptionMomentsType.group) return _postMomentToGroup(content:content,mentions:getReplyUser,hashTags:hashTags);

    if(currentPageType == EMomentType.quote && noteDB != null){
      event = await Moment.sharedInstance.sendQuoteRepost(
        noteDB.noteId,
        content,
        hashTags: hashTags,
        mentions: getReplyUser,
        relayKinds: _relaySelectionType.relayKinds,
      );
    }else{
      switch (_visibleType) {
        case VisibleType.everyone:
          OXLoading.show();
          event = await Moment.sharedInstance.sendPublicNote(
            content,
            hashTags: getHashTags,
            mentions: getReplyUser,
            relayKinds: _relaySelectionType.relayKinds,
          );
          break;
        case VisibleType.allContact:
          _updateProgressStatus(0);
          Moment.sharedInstance
              .sendNoteContacts(content,
                  mentions: getReplyUser,
                  hashTags: getHashTags,
                  sendMessageProgressCallBack: (value) {
                    _updateProgressStatus(value);
                  })
              .then((value) => event = value);
          await _completer.future;
          break;
        case VisibleType.private:
          OXLoading.show();
          event = await Moment.sharedInstance.sendNoteJustMe(content,hashTags: getHashTags);
          break;
        case VisibleType.excludeContact:
          final pubkeys = _selectedContacts?.map((e) => e.pubKey).toList();
          _updateProgressStatus(0);
          Moment.sharedInstance
              .sendNoteCloseFriends(pubkeys ?? [], content,
                  mentions: getReplyUser,
                  hashTags: getHashTags,
                  sendMessageProgressCallBack: (value) => _updateProgressStatus(value))
              .then((value) => event = value);
          await _completer.future;
          break;
        default:
          break;
      }
    }

    await OXLoading.dismiss();
    if(event?.status ?? false){
      CommonToast.instance.show(context, Localized.text('ox_chat.sent_successfully'));
    }

    OXNavigator.pop(context);
  }

  Future<void> _showNoOutboxRelaysDialog() async {
    final result = await OXCommonHintDialog.show<int>(
      context,
      title: 'No Outbox Relays',
      content: 'No outbox relays are configured. Please configure outbox relays in settings, or select "General Relays" or "All" to send.',
      isRowAction: true,
      actionList: [
        OXCommonHintAction.cancel(onTap: () {
          OXNavigator.pop(context, 0);
        }),
        OXCommonHintAction(
          text: () => 'Configure',
          style: OXHintActionStyle.theme,
          onTap: () {
            OXNavigator.pop(context, 1);
          },
        ),
        OXCommonHintAction(
          text: () => 'Select General',
          style: OXHintActionStyle.gray,
          onTap: () {
            OXNavigator.pop(context, 2);
          },
        ),
        OXCommonHintAction(
          text: () => 'Select All',
          style: OXHintActionStyle.gray,
          onTap: () {
            OXNavigator.pop(context, 3);
          },
        ),
      ],
    );

    if (result == 1) {
      // Go to configure outbox relays
      OXNavigator.pop(context);
      OXModuleService.invoke('ox_usercenter', 'showRelayPage', [context]);
    } else if (result == 2) {
      // Select General Relays
      setState(() {
        _relaySelectionType = RelaySelectionType.general;
      });
    } else if (result == 3) {
      // Select All
      setState(() {
        _relaySelectionType = RelaySelectionType.all;
      });
    }
  }

  void _postMomentToGroup({required String content,required List<String>? mentions,required List<String>? hashTags}) async{
    String? groupId = widget.groupId;
    if(groupId == null) return CommonToast.instance.show(context, 'groupId is empty !');
    
    // Clear draft immediately when sending (before actual send)
    _optionDraft(null);
    
    List<String> previous = Nip29.getPrevious([[groupId]]);
    NoteDBISAR? noteDB = widget.notedUIModel?.noteDB;
    OKEvent result;
    OXLoading.show();
    if(currentPageType == EMomentType.quote && noteDB != null){
      result = await RelayGroup.sharedInstance.sendQuoteRepost(noteDB.noteId,content,hashTags:hashTags,mentions:mentions);
    }else{
      result = await RelayGroup.sharedInstance.sendGroupNotes(groupId,content,previous,mentions:mentions,hashTags:hashTags);
    }
    await OXLoading.dismiss();

    if(result.status){
      CommonToast.instance.show(context, Localized.text('ox_chat.sent_successfully'));
    }

    OXNavigator.pop(context);
  }

  Future<String> _getUploadMediaContent() async {
    List<String> imageList = _getImageList();
    if(imageList.isEmpty && videoPath == null) return '';

    if (imageList.isNotEmpty){
      List<String> imgUrlList = await AlbumUtils.uploadMultipleFiles(
        context,
        fileType: FileType.image,
        filePathList: _getImageList(),
        showLoading: false,
      );
      String getImageUrlToStr = imgUrlList.join(' ');
      // _uploadCompleter?.complete(getImageUrlToStr);
      return getImageUrlToStr;
    }

    if (videoPath != null){
      List<String> imgUrlList = await AlbumUtils.uploadMultipleFiles(
        context,
        fileType: FileType.video,
        filePathList: [videoPath!],
        showLoading: false
      );
      String getVideoUrlToStr = imgUrlList.join(' ');
      // _uploadCompleter?.complete(getVideoUrlToStr);
      return getVideoUrlToStr;
    }

    return '';
  }

  List<String> _getImageList() {
    List<String> containsImageList = [
      ...preImageList ?? [],
      ...addImageList
    ];
    return containsImageList;
  }

  void _updateProgressStatus(int value) {
    _processController.process.value = value;
    if (value > totalCount) {
      _completer.complete();
    }
  }

  void _saveCreateMomentDraft() {
    CreateMomentDraft draft = CreateMomentDraft(
      type: currentPageType ?? EMomentType.content,
      content: _textController.text,
      selectedContacts: _selectedContacts,
      draftCueUserMap: draftCueUserMap,
      visibleType : _visibleType,
      imageList: _getImageList(),
      videoPath: videoPath,
      videoImagePath: videoImagePath,
    );
    _optionDraft(draft);
  }

  void _optionDraft(CreateMomentDraft? draft){
    final sharedInstance = OXMomentCacheManager.sharedInstance;
    final isGroup = widget.groupId != null;

    // Update in-memory cache
    if(isGroup){
      sharedInstance.createGroupMomentMediaDraft = draft;
    } else {
      sharedInstance.createMomentMediaDraft = draft;
    }

    // Save to persistent storage
    MomentDraftManager.shared.saveDraft(
      isGroup: isGroup,
      draft: draft,
    );
  }

  // Setup auto-save mechanism
  void _setupAutoSave() {
    // Initialize draft manager
    MomentDraftManager.shared.setup();

    // Listen to text changes for debounce save
    _textController.addListener(_onTextChanged);

    // Setup periodic save (every 30 seconds as fallback)
    _periodicSaveTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (mounted) {
        _saveDraftImmediately();
      }
    });
  }

  // Handle text changes with debounce
  void _onTextChanged() {
    _triggerDebounceSave();
  }

  // Trigger debounce save (3 seconds after last change)
  void _triggerDebounceSave() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        _saveDraftImmediately();
      }
    });
  }

  // Save draft immediately
  void _saveDraftImmediately() {
    // Only save if there's content
    if (_textController.text.isEmpty && 
        _getImageList().isEmpty && 
        videoPath == null) {
      return;
    }

    _saveCreateMomentDraft();
  }
}

