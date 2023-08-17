import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:ox_common/widgets/common_button.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_module_service/ox_module_service.dart';

enum PageStatus {
  normal,
  networkError,
  noData,
  noLogin,
}

class CommonStatusView extends StatelessWidget {
  CommonStatusView(
      {required this.pageStatus,
      this.padding,
      this.refreshOnPress,
      this.errorTip,
      this.emptyIconView});

  final PageStatus pageStatus;
  final EdgeInsets? padding;
  final Function? refreshOnPress;
  final String? errorTip;
  final Widget? emptyIconView;

  @override
  Widget build(BuildContext context) {
    Widget content() {
      switch (pageStatus) {
        case PageStatus.networkError:
          return OXNetworkErrorView(
              refreshOnPress: refreshOnPress ?? () {}, padding: padding);
        case PageStatus.noData:
          return _renderNoDataView();
        case PageStatus.noLogin:
          return _renderNoLoginView(context);
        case PageStatus.normal:
          return Container();
      }
    }

    return Container(
      width: double.infinity,
      child: content(),
    );
  }

  _renderNoDataView() {
    return Container(
      padding: padding ??
          EdgeInsets.only(
            top: Adapt.px(80.0),
          ),
      child: Column(
        children: <Widget>[
          emptyIconView ??
              CommonImage(
                iconName: 'icon_no_data.png',
                width: Adapt.px(90),
                height: Adapt.px(90),
              ),
          Container(
            margin: EdgeInsets.only(top: Adapt.px(24.0)),
            child: Text(
              errorTip ?? Localized.text('ox_common.status_empty'),
              style: TextStyle(
                  color: ThemeColor.color100,
                  fontSize: Adapt.px(16),
                  fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }

  _renderNoLoginView(BuildContext context) {
  
    return Center(
      child: OXButton(
        minWidth: Adapt.px(96.0),
        height: Adapt.px(36.0),
        color: ThemeColor.dark04,
        radius: Adapt.px(4),
        child: Text(
          Localized.text('ox_common.sign_in'),
          style: TextStyle(
            fontSize: Adapt.px(14.0),
            fontWeight: FontWeight.w500,
            color: ThemeColor.white01,
          ),
        ),
        onPressed: () =>
            OXModuleService.pushPage(context, "ox_login", "LoginPage", {}),
      ),
    );
  }
}

class OXNetworkErrorView extends StatelessWidget {
  OXNetworkErrorView({required this.refreshOnPress, this.padding}) : super();

  final Function refreshOnPress;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: this.padding ?? EdgeInsets.only(top: Adapt.px(80.0)),
      child: Column(
        children: <Widget>[
          CommonImage(
            iconName: 'icon_status_network_error.png',
            width: Adapt.px(80),
            height: Adapt.px(80),
          ),
          Padding(
            padding: EdgeInsets.only(top: Adapt.px(20.0)),
            child: Text(
              Localized.text('ox_common.status_network_error'),
              style: TextStyle(
                  fontSize: Adapt.px(16.0),
                  fontWeight: FontWeight.w400,
                  color: ThemeColor.gray02),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: Adapt.px(36.0)),
            child: OXButton(
                minWidth: Adapt.px(96.0),
                height: Adapt.px(36.0),
                color: ThemeColor.dark04,
                radius: Adapt.px(4),
                child: Text(
                  Localized.text('ox_common.status_network_refresh'),
                  style: TextStyle(
                    fontSize: Adapt.px(14.0),
                    fontWeight: FontWeight.w500,
                    color: ThemeColor.white01,
                  ),
                ),
                onPressed: () => refreshOnPress()),
          ),
        ],
      ),
    );
  }
}
