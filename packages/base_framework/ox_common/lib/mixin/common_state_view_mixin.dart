import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_status_view.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_module_service/ox_module_service.dart';

enum CommonStateView {
  CommonStateView_None,
  CommonStateView_NetworkError,
  CommonStateView_NoData,
  CommonStateView_NotLogin,
}

mixin CommonStateViewMixin {
  var _stateViewMixin = CommonStateView.CommonStateView_None;

  Widget commonStateViewWidget(BuildContext context, Widget noneWidget, {String? errorTip}) {
    switch (_stateViewMixin) {
      case CommonStateView.CommonStateView_None:
        return noneWidget;
      case CommonStateView.CommonStateView_NetworkError:
        return OXNetworkErrorView(refreshOnPress: () => stateViewCallBack(_stateViewMixin));
      case CommonStateView.CommonStateView_NoData:
        return renderNoDataView(context,errorTip: errorTip);
      case CommonStateView.CommonStateView_NotLogin:
        return _renderNoLoginView(context);
    }
  }

  // Subclass rewriting to implement callbacks
  stateViewCallBack(CommonStateView commonStateView) {}

  void updateStateView(CommonStateView commonStateView) {
    _stateViewMixin = commonStateView;
  }

  _renderNoLoginView(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: Adapt.px(80.0)),
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          CommonImage(
            iconName: 'icon_no_login.png',
            width: Adapt.px(90),
            height: Adapt.px(90),
            package: 'ox_common',
          ),
          GestureDetector(
            onTap: () => _goToLogin(context),
            child: Container(
              margin: EdgeInsets.only(top: Adapt.px(24)),
              child: RichText(
                text: TextSpan(
                    text: Localized.text('ox_common.please_login_hint'),
                    style: TextStyle(
                      color: ThemeColor.color100,
                      fontSize: Adapt.px(16),
                      fontWeight: FontWeight.w400
                    ),
                    children: [
                      TextSpan(
                        text: Localized.text('ox_common.please_login'),
                        style: TextStyle(
                          color: ThemeColor.color0,
                          fontSize: Adapt.px(14),
                        ),
                      ),
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  renderNoDataView(BuildContext context,{String? errorTip}){
    return CommonStatusView(pageStatus: PageStatus.noData, errorTip: errorTip,);
  }

  _goToLogin(BuildContext context) {
    OXModuleService.pushPage(context, "ox_login", "LoginPage", {});
  }
}
