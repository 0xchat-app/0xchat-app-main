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

enum OperationType { create, edit }

class FileServerOperationPage extends StatefulWidget {
  final FileStorageProtocol fileStorageProtocol;
  final OperationType operationType;

  const FileServerOperationPage({
    super.key,
    required this.fileStorageProtocol,
    OperationType? operationType,
  }) : operationType = operationType ?? OperationType.create;

  @override
  State<FileServerOperationPage> createState() => _FileServerOperationPageState();
}

class _FileServerOperationPageState extends State<FileServerOperationPage> {

  final _UrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _UrlController.text = 'wss://some.relay.com';
  }

  @override
  Widget build(BuildContext context) {
    final title = '${widget.operationType.name} ${widget.fileStorageProtocol.serverName}';
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
            // _buildItem('URL', _buildTextField()),
            if(widget.fileStorageProtocol == FileStorageProtocol.minio)
              _buildMinioTypeView(),
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

  Widget _buildTextField() {
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

  Widget _buildMinioTypeView() {
    List<String> labels = ['name','endPoint','secretKey','useSSL','description'];
    return ListView.separated(
      shrinkWrap: true,
      itemBuilder: (context, index) => _buildItem(labels[index], _buildTextField()),
      separatorBuilder: (context, index) => SizedBox(height: 12.px,),
      itemCount: labels.length,
    );
  }
}
