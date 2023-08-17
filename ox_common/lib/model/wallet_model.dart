class WalletModel {
  String id;
  String appId;
  String title;
  String scheme;
  String appStoreUrl;
  String playStoreUrl;
  String image;

  WalletModel(
      {required this.id,
      required this.appId,
      required this.title,
      required this.scheme,
      required this.image})
      : this.appStoreUrl = 'itms-apps://itunes.apple.com/app/id$id',
        this.playStoreUrl = 'market://details?id=$appId';

  static List<WalletModel> get wallets => List.from([
        WalletModel(
            id: '1488724463',
            appId: 'zapsolutions.strike',
            title: 'Strike',
            scheme: 'strike://',
            image: 'icon_lighting_wallet_strike.png'),
        WalletModel(
            id: '711923939',
            appId: 'com.squareup.cash',
            title: 'Cash APP',
            scheme: 'cashapp://',
            image: 'icon_lighting_wallet_cash_app.png'),
        WalletModel(
            id: '1376878040',
            appId: 'io.bluewallet.bluewallet',
            title: 'Blue Wallet',
            scheme: 'bluewallet:lightning://',
            image: 'icon_lighting_wallet_blue_wallet.png'),
        WalletModel(
            id: '1456038895',
            appId: 'app.zeusln.zeus',
            title: 'Zeus LN',
            scheme: 'zeusln:lightning://',
            image: 'icon_lighting_wallet_zeus_ln.png'),
        WalletModel(
            id: '1544097028',
            appId: 'fr.acinq.phoenix.mainnet',
            title: 'Phoenix',
            scheme: 'phoenix://',
            image: 'icon_lighting_wallet_phoenix.png'),
        WalletModel(
            id: '1463604142',
            appId: 'com.breez.client',
            title: 'Breez',
            scheme: 'breez://',
            image: 'icon_lighting_wallet_breez.png'),
      ]);
}
