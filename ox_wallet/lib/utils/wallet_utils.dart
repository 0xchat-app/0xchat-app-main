class WalletUtils {

  static double satoshiToBitcoin(double satoshiAmount) {
    return satoshiAmount / 100000000;
  }

  static double bitcoinToUSD(double amount){
    double currentPrice = 2228.81;
    return amount * currentPrice;
  }

  static String satoshiToUSD(double satoshiAmount,{int decimal = 2}) {
    return bitcoinToUSD(satoshiToBitcoin(satoshiAmount)).toStringAsFixed(decimal);
  }
}
