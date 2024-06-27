import 'package:flutter/material.dart';
import 'package:ox_common/model/file_storage_server_model.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_server_manager.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_button.dart';
import 'package:ox_localizable/ox_localizable.dart';

enum OperationType { add, edit }

class FileServerAddPage extends StatefulWidget {
  final FileStorageProtocol fileServerType;
  final OperationType operationType;

  const FileServerAddPage({
    super.key,
    required this.fileServerType,
    OperationType? operationType,
  }) : operationType = operationType ?? OperationType.add;

  @override
  State<FileServerAddPage> createState() => _FileServerAddPageState();
}

class _FileServerAddPageState extends State<FileServerAddPage> {

  final _UrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _UrlController.text = 'wss://some.relay.com';
  }

  @override
  Widget build(BuildContext context) {
    final title = '${widget.operationType.name} ${widget.fileServerType.serverName}';
    return Scaffold(
      backgroundColor: ThemeColor.color190,
      appBar: CommonAppBar(
        useLargeTitle: false,
        centerTitle: true,
        title: title,
        backgroundColor: ThemeColor.color190,
      ),
      body: _buildBody().setPadding(EdgeInsets.symmetric(
          horizontal: Adapt.px(24), vertical: Adapt.px(12))),
    );
  }

  Widget _buildBody() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildItem('URL', _buildURLTextField()),
            if(widget.fileServerType == FileStorageProtocol.minio)
              _buildItem('Secret Key', _buildURLTextField()).setPaddingOnly(top: 12.px),
            CommonButton.themeButton(
              text: Localized.text('ox_common.complete'),
              onTap: () {
                Nip96Server nip96Server = Nip96Server(name: '新添加的');
                OXServerManager.sharedInstance.addFileStorageServer(nip96Server);
                OXNavigator.pop(context);
              },
            ).setPadding(EdgeInsets.only(top: 12.px)),
            if(widget.operationType == OperationType.edit)
              CommonButton.themeButton(
                text: Localized.text('ox_common.delete'),
                onTap: () {},
              ).setPadding(EdgeInsets.only(top: 12.px)),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(String? itemTitle, Widget? itemBody) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: Adapt.px(46),
          alignment: Alignment.centerLeft,
          child: Text(
            itemTitle ?? "",
            style: TextStyle(
              color: ThemeColor.color0,
              fontSize: 14.px,
              fontWeight: FontWeight.w600
            ),
          ),
        ),
        itemBody ?? Container(),
      ],
    );
  }

  Widget _buildURLTextField() {
    return Container(
      width: double.infinity,
      height: 48.px,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.px),
        color: ThemeColor.color180,
      ),
      alignment: Alignment.center,
      child: TextField(
        controller: _UrlController,
        decoration: InputDecoration(
          hintStyle: TextStyle(
            color: ThemeColor.color0,
            fontSize: 16.px,
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (value) {
          setState(() {});
        },
      ),
    );
  }
}
