import 'package:flutter/material.dart';
import 'package:ox_common/model/file_storage_server_model.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/upload/minio_uploader.dart';
import 'package:ox_common/upload/nip96_info_loader.dart';
import 'package:ox_common/upload/nip96_server_adaptation.dart';
import 'package:ox_common/upload/upload_utils.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_server_manager.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_button.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_usercenter/widget/bottom_sheet_dialog.dart';

enum OperationType { create, edit }

class FileServerOperationPage extends StatefulWidget {
  final FileStorageProtocol fileStorageProtocol;
  final OperationType operationType;
  final FileStorageServer? fileStorageServer;

  const FileServerOperationPage({
    super.key,
    required this.fileStorageProtocol,
    this.fileStorageServer,
    OperationType? operationType,
  }) : operationType = operationType ?? OperationType.create;

  @override
  State<FileServerOperationPage> createState() => _FileServerOperationPageState();
}

class _FileServerOperationPageState extends State<FileServerOperationPage> {

  final List<String> _minioInputOptions = ['URL', 'Access Key', 'Secret Key', 'Bucket Name', 'Custom Name'];
  late final List<TextEditingController> _minioInputOptionControllers;
  final _urlController = TextEditingController();
  final _serverNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initMinioData();
    _initNip96Data();
  }

  _initMinioData() {
    if (widget.fileStorageProtocol == FileStorageProtocol.minio) {
      _minioInputOptionControllers = List.generate(_minioInputOptions.length, (index) => TextEditingController());
      if (widget.operationType == OperationType.edit) {
        MinioServer? minioServer = widget.fileStorageServer as MinioServer;
        _minioInputOptionControllers[0].text = minioServer.url;
        _minioInputOptionControllers[1].text = minioServer.accessKey;
        _minioInputOptionControllers[2].text = minioServer.secretKey;
        _minioInputOptionControllers[3].text = minioServer.bucketName;
        _minioInputOptionControllers[4].text = minioServer.name;
      }
    }
  }

  _initNip96Data() {
    if (widget.fileStorageProtocol == FileStorageProtocol.nip96) {
      if (widget.operationType == OperationType.edit) {
        Nip96Server? nip96server = widget.fileStorageServer as Nip96Server;
        _urlController.text = nip96server.url;
        _serverNameController.text = nip96server.name;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final operation = widget.operationType == OperationType.create ? 'Add' : 'Edit';
    final title = '$operation ${widget.fileStorageProtocol.serverName}';
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
            if(widget.fileStorageProtocol == FileStorageProtocol.blossom)
              _buildBlossomTypeView(),
            CommonButton.themeButton(
              text: Localized.text('ox_common.complete'),
              onTap: _handleComplete,
            ).setPadding(EdgeInsets.only(top: 12.px)),
            if(widget.operationType == OperationType.edit)
              _buildDeleteButton(),
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
    ValueChanged<String>? onChanged,
    validator,
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
        validator: validator,
        // onChanged: (value) {
        //   setState(() {});
        // },
      ),
    );
  }

  Widget _buildNip96TypeView() {
    return Column(
      children: [
        _buildItem(
          'URL',
          _buildTextField(hintText: 'Enter URL(http or https)', controller: _urlController),
        ),
        _buildItem(
          'Custom Name',
          _buildTextField(hintText: 'Custom Server Name(Optional)',controller: _serverNameController),
        ).setPaddingOnly(top: 12.px),
      ],
    );
  }

  Widget _buildBlossomTypeView() {
    return Column(
      children: [
        _buildItem('URL', _buildTextField(hintText: 'Enter URL(http or https)'),),
        _buildItem('Custom Name', _buildTextField(hintText: 'Custom Server Name(Optional)'),).setPaddingOnly(top: 12.px),
      ],
    );
  }

  Widget _buildMinioTypeView() {
    Map<String,String> hintText = {
      _minioInputOptions[0]:'Enter URL(http or https)',
      _minioInputOptions[1]:'Enter Secret Key',
      _minioInputOptions[2]:'Enter Access Key',
      _minioInputOptions[3]:'Enter Bucket Name',
      _minioInputOptions[4]:'Custom Server Name(optional)',
    };
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return _buildItem(
          _minioInputOptions[index],
          _buildTextField(
            controller: _minioInputOptionControllers[index],
            hintText: hintText[_minioInputOptions[index]],
          ),
        );
      },
      separatorBuilder: (context, index) => SizedBox(height: 12.px,),
      itemCount: _minioInputOptions.length,
    );
  }

  Widget _buildDeleteButton() {
    return GestureDetector(
      onTap: () {
        BottomSheetDialog.showBottomSheet(
            context, [BottomSheetItem(title: 'Delete',onTap: _deletedFileServer)],
            title: 'Delete ${widget.fileStorageProtocol.serverName}?',
            color: ThemeColor.red1,
        );
      },
      child: Container(
        alignment: Alignment.center,
        height: 48.px,
        decoration: BoxDecoration(
            color: ThemeColor.color180,
            borderRadius: BorderRadius.circular(12.px),),
        child: Text(
          'Delete',
          style: TextStyle(
            fontSize: 16.px,
            fontWeight: FontWeight.w600,
            color: ThemeColor.red1,
          ),
        ),
      ).setPadding(EdgeInsets.symmetric(vertical: 12.px)),
    );
  }

  _deletedFileServer() async {
    if (widget.fileStorageServer != null) {
      await OXServerManager.sharedInstance.deleteFileStorageServer(widget.fileStorageServer!);
      OXNavigator.pop(context);
    }
  }

  _handleComplete() {
    switch(widget.fileStorageProtocol) {
      case FileStorageProtocol.nip96:
        _createNip96Server();
        break;
      case FileStorageProtocol.blossom:
        break;
      case FileStorageProtocol.minio:
        _createMinioServer();
        break;
      case FileStorageProtocol.oss:
        break;
    }
  }

  String _verifyMinioOption() {
    String errorMsg = '';
    final tips = _minioInputOptions.map((item) => 'Please Enter $item').toList();
    for (int index = 0; index < _minioInputOptionControllers.length; index++) {
      if (index == 4) return errorMsg;
      if (_minioInputOptionControllers[index].text.isEmpty) {
        errorMsg = tips[index];
        break;
      }
    }
    return errorMsg;
  }

  Future<void> _createMinioServer() async {
    final errorMsg = _verifyMinioOption();
    if(errorMsg.isNotEmpty){
      CommonToast.instance.show(context, errorMsg);
      return;
    }
    String url = _minioInputOptionControllers[0].text;
    String accessKey = _minioInputOptionControllers[1].text;
    String secretKey = _minioInputOptionControllers[2].text;
    String bucketName = _minioInputOptionControllers[3].text;
    final name = _minioInputOptionControllers[4].text;

    if(!_urlValidator(url)) {
      CommonToast.instance.show(context, 'Please enter a valid URL');
      return;
    }

    MinioUploader.init(
      url: url,
      accessKey: accessKey,
      secretKey: secretKey,
      bucketName: bucketName,
    );

    OXLoading.show();
    try {
      bool result = await MinioUploader.instance.bucketExists();
      OXLoading.dismiss();
      MinioServer minioServer = MinioServer(
        url: url,
        accessKey: accessKey,
        secretKey: secretKey,
        name: name,
        bucketName: bucketName,
      );
      if(!result) {
        CommonToast.instance.show(context, 'Bucket Name is not exist!');
        return;
      }
      if(widget.operationType == OperationType.create) {
        await OXServerManager.sharedInstance.addFileStorageServer(minioServer);
      }else {
        await OXServerManager.sharedInstance.updateFileStorageServer(minioServer);
      }
      OXNavigator.pop(context);
    } catch (e) {
      OXLoading.dismiss();
      UploadResult result = UploadExceptionHandler.handleException(e);
      CommonToast.instance.show(context, result.errorMsg ?? 'Minio Error');
    }
  }

  _createNip96Server() async {
    final url = _urlController.text;
    final name = _serverNameController.text;
    if(!_urlValidator(url)) {
      CommonToast.instance.show(context, 'Please enter a valid URL');
      return;
    }
    OXLoading.show();
    Nip96ServerAdaptation? nip96serverAdaptation = await NIP96InfoLoader.getInstance().pullServerAdaptation(url);
    OXLoading.dismiss();
    if(nip96serverAdaptation == null || nip96serverAdaptation.apiUrl == null) {
      CommonToast.instance.show(context, 'The file server does not support NIP-96');
      return;
    }
    Nip96Server nip96server = Nip96Server(url: url, name: name.isNotEmpty ? name : url);
    if(widget.operationType == OperationType.create) {
      await OXServerManager.sharedInstance.addFileStorageServer(nip96server);
    }else {
      await OXServerManager.sharedInstance.updateFileStorageServer(nip96server);
    }
    OXNavigator.pop(context);
  }

  bool _urlValidator(String value) {
    const urlPattern = r'^(https?):\/\/([^\s$.?#].[^\s]*)?(:\d{1,5})?(\/[^\s]*)?$';
    return RegExp(urlPattern, caseSensitive: false).hasMatch(value);
  }

  @override
  void dispose() {
    if(widget.fileStorageProtocol == FileStorageProtocol.minio) {
      for (var controller in _minioInputOptionControllers) {
        controller.dispose();
      }
    }
    _urlController.dispose();
    _serverNameController.dispose();
    super.dispose();
  }
}
