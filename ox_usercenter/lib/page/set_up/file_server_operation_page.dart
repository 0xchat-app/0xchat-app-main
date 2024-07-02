import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ox_common/model/file_storage_server_model.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_server_manager.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_button.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:minio/minio.dart';
import 'package:http/http.dart';

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

  final List<String> _minioOptionTextField = ['EndPoint', 'Access Key', 'Secret Key','Custom Name'];
  Map<String, String> _minioOptionTextFieldData = {};
  late final List<TextEditingController> _minioOptionControllers ;

  @override
  void initState() {
    super.initState();
    _minioOptionControllers = List.generate(_minioOptionTextField.length, (index) => TextEditingController());
    if(widget.operationType == OperationType.edit) {
      _minioOptionTextFieldData[_minioOptionTextField[0]] = '';
    } else {
      _minioOptionTextFieldData = {for (var item in _minioOptionTextField) item: ''};
    }
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
            if(widget.fileStorageProtocol == FileStorageProtocol.minio)
              _buildMinioTypeView(),
            if(widget.fileStorageProtocol == FileStorageProtocol.nip96)
              _buildNip96TypeView(),
            CommonButton.themeButton(
              text: Localized.text('ox_common.complete'),
              onTap: () {
                final errorMsg = _verifyMinioOption();
                if(errorMsg.isNotEmpty){
                  CommonToast.instance.show(context, errorMsg);
                  return;
                }
                _createMinioServer();
              },
            ).setPadding(EdgeInsets.only(top: 12.px)),
            if(widget.operationType == OperationType.edit)
              CommonButton.themeButton(
                text: Localized.text('ox_common.delete'),
                onTap: () {
                  print('---- result: $_minioOptionTextFieldData');
                },
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

  Widget _buildTextField({
    TextEditingController? controller,
    String? hintText,
    ValueChanged<String>? onChanged
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.px),
        color: ThemeColor.color180,
      ),
      alignment: Alignment.center,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: ThemeColor.color100,
            fontSize: 16.px,
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: onChanged,
        // onChanged: (value) {
        //   setState(() {});
        // },
      ),
    );
  }

  Widget _buildNip96TypeView() {
    return _buildItem('URL', _buildTextField(hintText: 'Enter URL(http or https)'));
  }

  Widget _buildMinioTypeView() {
    Map<String,String> hintText = {
      _minioOptionTextField[0]:'Enter URL(http or https)',
      _minioOptionTextField[1]:'Enter Secret Key',
      _minioOptionTextField[2]:'Enter Access Key',
      _minioOptionTextField[3]:'Custom Server Name(optional)',
    };
    return ListView.separated(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return _buildItem(
          _minioOptionTextField[index],
          _buildTextField(
            controller: _minioOptionControllers[index],
            hintText: hintText[_minioOptionTextField[index]],
            onChanged: (value) {
              _minioOptionTextFieldData[_minioOptionTextField[index]] = value;
            }
          ),
        );
      },
      separatorBuilder: (context, index) => SizedBox(height: 12.px,),
      itemCount: _minioOptionTextField.length,
    );
  }

  String _verifyMinioOption() {
    String errorMsg = '';
    _minioOptionTextFieldData.forEach((key, value) {
      if(key == _minioOptionTextField[3]) return;
      if (value.isEmpty) {
        errorMsg = 'Please Enter $key';
      }
    });
    return errorMsg;
  }

  Future<void> _createMinioServer() async {
    String url = _minioOptionControllers[0].text;
    String accessKey = _minioOptionControllers[1].text;
    String secretKey = _minioOptionControllers[2].text;
    final uri = Uri.parse(url);
    String endPoint = uri.hasScheme ? url.replaceFirst('${uri.scheme}://', '') : url ;
    final name = _minioOptionControllers[3].text.isNotEmpty ? _minioOptionControllers[3].text : endPoint;
    final useSSL = uri.scheme == 'https';
    final port = uri.port == 0 ? null : uri.port;

    final minio = Minio(
      endPoint: endPoint,
      accessKey: accessKey,
      secretKey: secretKey,
      useSSL: useSSL,
      port: port,
    );

    OXLoading.show();
    try {
      await minio.listBuckets();
      OXLoading.dismiss();
      MinioServer minioServer = MinioServer(endPoint: endPoint, accessKey: accessKey, secretKey: secretKey, name: name);
      OXServerManager.sharedInstance.addFileStorageServer(minioServer);
      OXNavigator.pop(context);
    } on ClientException catch (e) {
      final error = e.toString().substring(e.toString().indexOf(':') + 2,e.toString().length);
      CommonToast.instance.show(context, error);
    } catch (e) {
      OXLoading.dismiss();
      CommonToast.instance.show(context, e.toString());
    }
  }

  @override
  void dispose() {
    for (var controller in _minioOptionControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
