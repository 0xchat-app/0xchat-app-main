import 'package:ox_chat/model/option_model.dart';
import 'package:ox_localizable/ox_localizable.dart';

class CommunityMenuOptionModel {
  OptionModel optionModel;
  String content;
  String iconName;

  CommunityMenuOptionModel({
    this.optionModel = OptionModel.AddFriend,
    this.content = '',
    this.iconName = '',
  });

  static List<CommunityMenuOptionModel> getOptionModelList({String whitelistLevel = '0'}) {
    List<CommunityMenuOptionModel> list = [];
    list.add(
      CommunityMenuOptionModel(
        content: Localized.text('ox_common.str_add_friend'),
        iconName: 'icon_add_friend.png',
        optionModel: OptionModel.AddFriend,
      ),
    );
    list.add(
      CommunityMenuOptionModel(
        content: Localized.text('ox_chat.str_new_group'),
        iconName: 'icon_new_group.png',
        optionModel: OptionModel.AddGroup,
      ),
    );
    list.add(
      CommunityMenuOptionModel(
        content: Localized.text('ox_common.str_new_channel'),
        iconName: 'icon_new_channel.png',
        optionModel: OptionModel.NewChannel,
      ),
    );
    list.add(
      CommunityMenuOptionModel(
        content: Localized.text('ox_common.str_scan'),
        iconName: 'icon_scan_qr.png',
        optionModel: OptionModel.ScanQCode,
      ),
    );
    return list;
  }
}
