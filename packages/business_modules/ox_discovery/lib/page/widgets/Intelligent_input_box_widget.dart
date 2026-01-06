import 'package:chatcore/chat-core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_network_image.dart';

import '../../utils/discovery_utils.dart';
import '../../utils/moment_widgets_utils.dart';
import '../moments/select_mention_page.dart';

class IntelligentInputBoxWidget extends StatefulWidget {
  final String hintText;
  final Function(bool isFocused)? isFocusedCallback;
  final Function(List<UserDBISAR> userList)? cueUserCallback;
  final TextEditingController textController;
  final List<String>? imageUrlList;
  const IntelligentInputBoxWidget({
    super.key,
    this.hintText = '---',
    this.isFocusedCallback,
    this.cueUserCallback,
    this.imageUrlList,
    required this.textController,
  });

  @override
  _IntelligentInputBoxWidgetState createState() =>
      _IntelligentInputBoxWidgetState();
}

class _IntelligentInputBoxWidgetState extends State<IntelligentInputBoxWidget> {
  final _mentionPrefix = '@';
  final FocusNode _replyFocusNode = FocusNode();

  bool isShowUserList = false;

  List<UserDBISAR> contactsList = [];

  List<UserDBISAR> showContactsList = [];

  int? saveCursorPosition;

  bool isShowModalBottomSheet = false;

  @override
  void initState() {
    super.initState();
    // widget.textController.addListener(() {
    //   if (widget.textController.selection.isValid) {
    //     _inputChangeOption(widget.textController.text);
    //   }
    // });

    _replyFocusNode.addListener(() {
      widget.isFocusedCallback?.call(_replyFocusNode.hasFocus);
    });
    _getContactsList();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(
            left: 16.px,
            right: 16.px,
            bottom: 50.px,
          ),
          // height: 134.px,
          decoration: BoxDecoration(
            color: ThemeColor.color180,
            borderRadius: BorderRadius.all(
              Radius.circular(
                Adapt.px(12),
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _showImageWidget(),
              TextField(
                onChanged: _inputChangeOption,
                focusNode: _replyFocusNode,
                controller: widget.textController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintText: widget.hintText,
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
            ],
          ),
        ),
        // _selectListWidget(),
      ],
    );
  }

  Widget _showImageWidget() {
    List<String>? imageList = widget.imageUrlList;
    if (imageList == null || imageList.isEmpty) return const SizedBox();
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: imageList.map((String image) {
            return MomentWidgetsUtils.clipImage(
              borderRadius: 8.px,
              child: Image.asset(
                image,
                width: 100.px,
                fit: BoxFit.fill,
                height: 100.px,
              ),
            ).setPaddingOnly(right: 12.px);
          }).toList(),
        ),
      ),
    ).setPaddingOnly(top: 12.px);
  }

  Widget _selectListWidget() {
    if (!isShowUserList) return const SizedBox();

    return Container(
      margin: EdgeInsets.only(
        top: 12.px,
      ),
      decoration: BoxDecoration(
        color: ThemeColor.color180,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.px),
          topRight: Radius.circular(12.px),
        ),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () async {
              setState(() {
                saveCursorPosition = widget.textController.selection.start;
              });
              final result = await OXNavigator.presentPage(
                  context, (context) => const SelectMentionPage());
              if(isShowModalBottomSheet){
                OXNavigator.pop(context);
                FocusScope.of(context).requestFocus(_replyFocusNode);
              }

              if (result is List<UserDBISAR>) {
                widget.cueUserCallback?.call(result);
                String atContent = '';
                for (UserDBISAR db in result) {
                  String name = db.name ?? db.pubKey;
                  atContent = atContent + '@$name ';
                }
                _insertText(atContent,saveCursorPosition);

              }
              // _insertText(user.name ?? user.pubKey);
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 12.px,
                vertical: 10.px,
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: ThemeColor.color160,
                    width: 1.px,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Find other friends',
                    style: TextStyle(
                      color: ThemeColor.color100,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.px,
                    ),
                  ),
                  CommonImage(
                    iconName: 'icon_chat_search.png',
                    size: 24.px,
                    package: 'ox_chat',
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 300.px,
            child: SingleChildScrollView(child: _captionToUserListWidget()),
          ),
        ],
      ),
    );
  }

  Widget _captionToUserListWidget() {
    if (!isShowUserList) return const SizedBox();
    return ListView.builder(
      primary: false,
      controller: null,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: showContactsList.length,
      itemBuilder: (context, index) {
        return _captionToUserWidget(index);
      },
    );
  }

  Widget _captionToUserWidget(int index) {
    UserDBISAR user = showContactsList[index];
    return GestureDetector(
      onTap: () {
        if(isShowModalBottomSheet){
          OXNavigator.pop(context);
          FocusScope.of(context).requestFocus(_replyFocusNode);
        }
        widget.cueUserCallback?.call([user]);
        final name = '@${user.name ?? user.pubKey} ';
        _insertText(name, null);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: ThemeColor.color160,
              width: 1.px,
            ),
          ),
        ),
        padding: EdgeInsets.symmetric(
          vertical: 10.px,
          horizontal: 12.px,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MomentWidgetsUtils.clipImage(
              borderRadius: 24.px,
              imageSize: 24.px,
              child: OXCachedNetworkImage(
                imageUrl: user.picture ?? '',
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    MomentWidgetsUtils.badgePlaceholderImage(),
                errorWidget: (context, url, error) =>
                    MomentWidgetsUtils.badgePlaceholderImage(),
                width: 24.px,
                height: 24.px,
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                left: 12.px,
              ),
              child: Row(
                children: [
                  Text(
                    user.name ?? '--',
                    style: TextStyle(
                      color: ThemeColor.color0,
                      fontWeight: FontWeight.w400,
                      fontSize: 14.px,
                    ),
                  ).setPaddingOnly(
                    right: 8.px,
                  ),
                  Text(
                    DiscoveryUtils.getUserMomentInfo(user, '0')[1],
                    style: TextStyle(
                      color: ThemeColor.color100,
                      fontWeight: FontWeight.w400,
                      fontSize: 14.px,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _inputChangeOption(String text)async{
    final cursorPosition = widget.textController.selection.start;

    if (text.isEmpty || !text.contains(_mentionPrefix) || !widget.textController.selection.isCollapsed) {
      _hideUserList();
      return;
    }

    if (cursorPosition > 0 && text[cursorPosition - 1] == '@') {
      setState(() {
        showContactsList = contactsList;
        isShowUserList = true;
      });

        isShowModalBottomSheet = true;
        await showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) {
            return Container(
              height: 400.px,
              child: _selectListWidget(),
            );
          },
        );
        isShowModalBottomSheet = false;

      return;
    }

    final prefixStart = text.lastIndexOf(_mentionPrefix, cursorPosition - 1);
    if (prefixStart < 0) {
      _hideUserList();
      return;
    }

    final searchText = text.substring(prefixStart + 1, cursorPosition).toLowerCase();
    List<UserDBISAR> filteredUserList = _checkAtList(searchText);
    setState(() {
      showContactsList = filteredUserList;
      isShowUserList = filteredUserList.isNotEmpty;
    });
  }

  void _hideUserList() {
    if (isShowUserList) {
      setState(() {
        showContactsList = [];
        isShowUserList = false;
      });
    }
  }

  void _getContactsList() {
    List<UserDBISAR> tempList = Contacts.sharedInstance.allContacts.values.toList();
    contactsList = tempList;
    setState(() {});
  }

  List<UserDBISAR> _checkAtList(String text) {
    if (text.isEmpty) return contactsList;
    List<UserDBISAR> userDB = contactsList.where((UserDBISAR user) {
      if (user.name != null && user.name!.toLowerCase().contains(text)) {
        return true;
      }
      return false;
    }).toList();
    return userDB;
  }

  void _insertText(String textToInsert,int? saveCursorPosition) {
    final preText = widget.textController.text;
    final cursorPosition = saveCursorPosition ?? widget.textController.selection.start;
    final prefixStart = preText.lastIndexOf(_mentionPrefix, cursorPosition);

    final atWhoStr = '$textToInsert ';
    final newText = preText.replaceRange(prefixStart, cursorPosition, '$textToInsert ');

    final newSelectionStart = prefixStart + atWhoStr.length;
    final newTextLength = newText.length;
    final setSelectionStart = newSelectionStart > newTextLength ? newTextLength : newSelectionStart;
    widget.textController.value = widget.textController.value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: setSelectionStart),
    );


    setState(() {
      isShowUserList = false;
    });
  }
}
