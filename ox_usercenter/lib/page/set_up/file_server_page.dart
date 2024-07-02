import 'package:flutter/material.dart';
import 'package:ox_common/model/file_storage_server_model.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_server_manager.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_button.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_usercenter/page/set_up/file_server_operation_page.dart';
import 'package:ox_usercenter/widget/bottom_sheet_dialog.dart';

class FileServerPage extends StatefulWidget {
  const FileServerPage({super.key});

  @override
  State<FileServerPage> createState() => _FileServerPageState();
}

class _FileServerPageState extends State<FileServerPage> with OXServerObserver {
  bool _isEditing = false;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = OXServerManager.sharedInstance.selectedFileStorageIndex;
    OXServerManager.sharedInstance.addObserver(this);
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
    final fileStorageServers = OXServerManager.sharedInstance.fileStorageServers;
    return Column(
      children: [
        ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => _buildFilesServerItem(fileStorageServers[index],index),
          separatorBuilder: (context, index) => Container(height: 12.px,),
          itemCount: fileStorageServers.length,
        ),
        _buildAddServerButton(),
      ],
    );
  }

  Widget _buildFilesServerItem(FileStorageServer fileServer, int index) {
    bool canEdit = fileServer.canEdit && _currentIndex != index;
    final iconName = _isEditing && canEdit ? 'icon_more.png' : _currentIndex == index ? 'icon_selected.png' : 'icon_unSelected.png';
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        if(_isEditing) {
          if(canEdit) {
            OXNavigator.pushPage(context, (context) => const FileServerOperationPage(fileStorageProtocol: FileStorageProtocol.nip96));
          }
        } else {
          await OXServerManager.sharedInstance.updateSelectedFileStorageServer(index);
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
                package: 'ox_usercenter',
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
            BottomSheetItem(title: FileStorageProtocol.nip96.serverName,onTap: ()=> OXNavigator.pushPage(context, (context) => const FileServerOperationPage(fileStorageProtocol: FileStorageProtocol.nip96))),
            BottomSheetItem(title: FileStorageProtocol.minio.serverName,onTap: ()=> OXNavigator.pushPage(context, (context) => const FileServerOperationPage(fileStorageProtocol: FileStorageProtocol.minio))),
          ];
          BottomSheetDialog.showBottomSheet(context, items);
        },
      ).setPadding(
        EdgeInsets.only(top: 16.px),
      ),
    );
  }

  @override
  void didAddFileStorageServer(FileStorageServer fileStorageServer) {
    setState(() {});
  }

  @override
  void dispose() {
    OXServerManager.sharedInstance.removeObserver(this);
    super.dispose();
  }
}