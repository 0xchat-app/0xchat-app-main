import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/upload/uploader.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_button.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_usercenter/model/file_server_model.dart';
import 'package:ox_usercenter/page/set_up/file_server_add_page.dart';
import 'package:ox_usercenter/widget/bottom_sheet_dialog.dart';

class FileServerPage extends StatefulWidget {
  const FileServerPage({super.key});

  @override
  State<FileServerPage> createState() => _FileServerPageState();
}

class _FileServerPageState extends State<FileServerPage> {
  bool _isEditing = false;
  int _currentIndex = 0;
  final List<FileServerModel> _fileServerModelList = [];

  @override
  void initState() {
    super.initState();
    _fileServerModelList.addAll(
      FileServices.values
          .map((e) => FileServerModel(
                name: e.serviceName,
                canEdit: false,
                description: 'Free storage, expired in 7 days',
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.color190,
      appBar: CommonAppBar(
        useLargeTitle: false,
        centerTitle: true,
        title: 'Files Server',
        backgroundColor: ThemeColor.color190,
        actions: [
          Container(
            margin: EdgeInsets.only(
              right: 14.px,
            ),
            color: Colors.transparent,
            child: OXButton(
              highlightColor: Colors.transparent,
              color: Colors.transparent,
              minWidth: 44.px,
              height: 44.px,
              child: CommonImage(
                iconName: _isEditing ? 'icon_done.png' : 'icon_edit.png',
                width: 24.px,
                height: 24.px,
                useTheme: true,
              ),
              onPressed: () {
                setState(
                  () {
                    _isEditing = !_isEditing;
                  },
                );
              },
            ),
          )
        ],
      ),
      body: _buildBody().setPadding(EdgeInsets.symmetric(horizontal: Adapt.px(24), vertical: Adapt.px(12))),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => _buildFilesServerItem(_fileServerModelList[index],index),
          separatorBuilder: (context, index) => Container(height: 12.px,),
          itemCount: _fileServerModelList.length,
        ),
        _buildAddServerButton(),
      ],
    );
  }

  Widget _buildFilesServerItem(FileServerModel fileServer, int index) {
    bool canEdit = fileServer.canEdit && _currentIndex != index;
    final iconName = _isEditing && canEdit ? 'moment_more_icon.png' : _currentIndex == index ? 'icon_selected.png' : 'icon_unSelected.png';
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if(_isEditing) {
          if(canEdit) {
            OXNavigator.pushPage(context, (context) => const FileServerAddPage(fileServerType: FileServerType.nip96));
          }
        } else {
          setState(() {
            _currentIndex = index;
          });
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.px,vertical: 12.px),
        decoration: BoxDecoration(
          color: _isEditing && !canEdit ? ThemeColor.color180.withOpacity(0.2) : ThemeColor.color180,
          borderRadius: BorderRadius.circular(16.px),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fileServer.name,
                    style: TextStyle(
                      fontSize: 16.px,
                      fontWeight: FontWeight.w400,
                      color: _isEditing && !canEdit ? ThemeColor.white.withOpacity(0.2) : ThemeColor.white,
                    ),
                  ),
                  SizedBox(height: 4.px,),
                  Text(
                    fileServer.description ?? '',
                    style: TextStyle(
                      fontSize: 12.px,
                      fontWeight: FontWeight.w400,
                      color: _isEditing && !canEdit ? ThemeColor.color100.withOpacity(0.2) : ThemeColor.color100 ,
                    ),
                  ),
                ],
              ),
            ),
            Opacity(
              opacity: _isEditing && !canEdit ? 0.2 : 1,
              child: CommonImage(
                iconName: iconName,
                package: 'ox_discovery',
                useTheme: true,
                size: 24.px,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddServerButton() {
    return Opacity(
      opacity: _isEditing ? 0.24 : 1,
      child: CommonButton.themeButton(
        text: 'Add Server',
        onTap: () {
          if(_isEditing) return;
          final items = [
            BottomSheetItem(title: FileServerType.nip96.serverName,onTap: ()=> OXNavigator.pushPage(context, (context) => const FileServerAddPage(fileServerType: FileServerType.nip96))),
            BottomSheetItem(title: FileServerType.mini.serverName,onTap: ()=> OXNavigator.pushPage(context, (context) => const FileServerAddPage(fileServerType: FileServerType.mini))),
          ];
          BottomSheetDialog.showBottomSheet(context, items);
        },
      ).setPadding(
        EdgeInsets.only(top: 16.px),
      ),
    );
  }
}