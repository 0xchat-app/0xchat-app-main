import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_common/widgets/contact_choose_page.dart';
import 'package:ox_discovery/enum/visible_type.dart';
import 'package:ox_discovery/page/widgets/flexible_selector.dart';
import 'package:chatcore/chat-core.dart';

class VisibilitySelectionPage extends StatefulWidget {
  final VisibleType? visibleType;
  final List<UserDB>? selectedContacts;
  final Function(VisibleType type, List<UserDB>)? onSubmitted;

  const VisibilitySelectionPage({super.key, this.onSubmitted, this.visibleType, required this.selectedContacts});

  @override
  State<VisibilitySelectionPage> createState() => _VisibilitySelectionPageState();
}

class _VisibilitySelectionPageState extends State<VisibilitySelectionPage> {

  final List<VisibleType> _visibleItems = List.of([...VisibleType.values]);
  late VisibleType _currentVisibleType;

  // List<UserDB> _includeContacts = [];
  List<UserDB> _excludeContacts = [];

  @override
  void initState() {
    _currentVisibleType = widget.visibleType ?? VisibleType.everyone;
    _excludeContacts = widget.selectedContacts ?? [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
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
        child: Container(
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        _buildAppBar(),
        _buildViewPermission(),
      ],
    ).setPadding(EdgeInsets.symmetric(horizontal: 24.px));
  }

  Widget _buildAppBar(){
    return SizedBox(
      height: 56.px,
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
            onTap: () {
              OXNavigator.pop(context);
            },
          ),
          Text(
            'Visible to',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16.px,
              color: ThemeColor.color0,
            ),
          ),
          IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            icon: CommonImage(
              iconName: 'icon_done.png',
              width: 24.px,
              height: 24.px,
              useTheme: true,
            ),
            onPressed: _onSubmitted,
          )
        ],
      ),
    );
  }

  Widget _buildViewPermission(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "WHO CAN VIEW AND REPLY",
          style: TextStyle(
            fontSize: 16.px,
            fontWeight: FontWeight.w600,
            color: ThemeColor.color0,
          ),
        ),
        SizedBox(height: 12.px),
        _buildVisibleList()
      ],
    ).setPaddingOnly(top: 12.px);
  }

  Widget _buildVisibleList(){
    return Container(
      // height: 326.px,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.px),
        color: ThemeColor.color180,
      ),
      child: ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: _buildListItem,
        separatorBuilder: (context, index) => Container(
          height: 0.5.px,
          color: ThemeColor.color160,
        ),
        itemCount: _visibleItems.length,
      ),
    );
  }

  Widget _buildListItem(BuildContext context, int index) {
    final bool isSpecial = index == VisibleType.excludeContact.index;
        // || index == VisibleType.includeContact.index;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10.px, horizontal: 16.px),
      child: FlexibleSelector(
        title: _visibleItems[index].name,
        subTitle: _visibleItems[index].illustrate,
        isSelected: !isSpecial && _currentVisibleType.index == index,
        type: isSpecial ? SelectionType.multiple : null,
        content: isSpecial ? _selectedUserName(VisibleType.values[index]) : null,
        onChanged: () {
          setState(() {
            _currentVisibleType = VisibleType.values[index];
          });
          if (isSpecial) {
            OXNavigator.presentPage(
              context,
              (context) => ContactChoosePage<UserDB>(
                title: 'Close Friends',
                contactType: ContactType.contact,
                onSubmitted: _selectedOnChanged,
                selectedContactList: _excludeContacts,
              ),
            );
          }
        },
      ),
    );
  }

  void _selectedOnChanged(List<UserDB> userList) {
    if (userList.isEmpty) {
      CommonToast.instance.show(context, 'Please select at least one user');
      return;
    }
    setState(() {
      // if (_currentVisibleType == VisibleType.includeContact) {
      //   _includeContacts = userList;
      // }
      if (_currentVisibleType == VisibleType.excludeContact) {
        _excludeContacts = userList;
      }
    });
    OXNavigator.pop(context);
  }

  String _selectedUserName(VisibleType type) {
    // List<UserDB> userList = type == VisibleType.includeContact
    //     ? _includeContacts
    //     : _excludeContacts;
    List<UserDB> userList = _excludeContacts;
    return userList
        .where((user) => user.name != null)
        .map((user) => user.name)
        .join(', ');
  }

  void _onSubmitted() {
    if (_currentVisibleType == VisibleType.excludeContact) {
      widget.onSubmitted?.call(_currentVisibleType, _excludeContacts);
    } else {
      widget.onSubmitted?.call(_currentVisibleType, []);
    }
    OXNavigator.pop(context);
  }
}
