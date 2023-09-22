import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:scan/scan.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/common_color.dart';
import 'package:ox_common/utils/image_picker_utils.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/string_utils.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_common/ox_common.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_module_service/ox_module_service.dart';

import 'common_image.dart';

class CommonScanPage extends StatefulWidget {
  @override
  CommonScanPageState createState() => CommonScanPageState();
}

class CommonScanPageState extends State<CommonScanPage> {
  ScanController controller = ScanController();

  @override
  void initState() {
    super.initState();
    controller.resume();
  }

  @override
  void dispose() {
    controller.pause();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: ScanView(
              controller: controller,
              scanAreaScale: .7,
              scanLineColor: ThemeColor.gray2,
              onCapture: (data) {
                OXNavigator.pop(context, data);
              },
            ),
          ),
          Positioned(
              width: MediaQuery.of(context).size.width,
              top: MediaQueryData.fromWindow(window).padding.top,
              child: Container(
                height: Adapt.px(56),
                margin: EdgeInsets.only(left: Adapt.px(12), right: Adapt.px(12)),
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () => OXNavigator.pop(context),
                      behavior: HitTestBehavior.translucent,
                      child: Container(
                        height: double.infinity,
                        child: CommonImage(
                          iconName: "appbar_back.png",
                          width: Adapt.px(32),
                          height: Adapt.px(32),
                          color: CommonColor.white01,
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      alignment: Alignment.center,
                      child: Text(
                        'str_scan'.commonLocalized(),
                        style: TextStyle(
                          fontSize: Adapt.px(18),
                          color: ThemeColor.white,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          Positioned(
            width: MediaQuery.of(context).size.width,
            bottom: Adapt.px(56),
            child: Container(
              margin: EdgeInsets.only(left: Adapt.px(24), right: Adapt.px(24), top: Adapt.px(16)),
              height: Adapt.px(105),
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                      child: GestureDetector(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        children: [
                          SizedBox(
                            height: Adapt.px(20),
                          ),
                          CommonImage(
                            iconName: 'icon_business_card.png',
                            width: Adapt.px(54),
                            height: Adapt.px(54),
                            useTheme: true,
                          ),
                          SizedBox(
                            height: Adapt.px(7),
                          ),
                          Text(
                            'str_my_idcard'.commonLocalized(),
                            style: TextStyle(
                              color: ThemeColor.white,
                              fontSize: Adapt.px(12),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      OXModuleService.invoke('ox_chat', 'showMyIdCardDialog', [context]);
                    },
                  )),
                  Container(
                    width: Adapt.px(0.5),
                    height: Adapt.px(79),
                    color: ThemeColor.gray5,
                  ),
                  Expanded(
                      child: GestureDetector(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        children: [
                          SizedBox(
                            height: Adapt.px(20),
                          ),
                          CommonImage(
                            iconName: 'icon_scan_qr.png',
                            width: Adapt.px(54),
                            height: Adapt.px(54),
                            useTheme: true,
                          ),
                          SizedBox(
                            height: Adapt.px(7),
                          ),
                          Text(
                            'str_album'.commonLocalized(),
                            style: TextStyle(
                              color: ThemeColor.white,
                              fontSize: Adapt.px(12),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () async {
                      File? file = await ImagePickerUtils.getImageFromGallery();
                      if (file != null) {
                        String? qrcode = await Scan.parse(file.path);
                        if (qrcode != null) {
                          OXNavigator.pop(context, qrcode);
                        } else {
                          CommonToast.instance.show(context, "str_invalid_qr_code".commonLocalized());
                        }
                      }
                    },
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
