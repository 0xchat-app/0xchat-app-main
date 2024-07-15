import 'package:ox_common/utils/num_utils.dart';
import 'package:ox_localizable/ox_localizable.dart';

String noDataShow = '--';

extension StringUtil on String {

  bool get isNum => num.tryParse(this) != null;

  bool get isNotNum => !isNum;

  bool get isZero {
    final aNum = num.tryParse(this);
    return aNum == null || aNum == 0;
  }

  String filterNum(num? value, {int fractionDigits = 2}) {
    if (value == null) return noDataShow;
    if (value < 0.01) {
      //4 bit
      return value.toString();
    } else {
      //2 bit
      return value.toStringAsFixed(fractionDigits);
    }
  }

  String filterString(String? value, {int fractionDigits = 2}) {
    if (value == null) return noDataShow;
    num _myValue = num.tryParse(value)!;
    if (_myValue < 0.01) {
      //4 bit
      return _myValue.toString();
    } else {
      //2 bit
      return _myValue.toStringAsFixed(fractionDigits);
    }
  }

  /// The data (including scientific notation) is transformed into the original data form
  String convertAsOrigin({fractionDigits}) {
    if(this.isEmpty) return this;
    var v2 = this.toLowerCase();
    if (v2.contains("+") && v2.contains("e") && !v2.contains("e+")) {
      var array = v2.split("+");
      var n1 = num.tryParse(array[0]);
      var n2 = num.tryParse(array[1]);
      return (n1! + n2!).toString().convertAsOrigin();
    } else if (v2.contains("e-")) {
      String data = v2.split("e-")[1];
      int d = int.tryParse(data) ?? 2;
      var ss = num.tryParse(v2)?.toStringAsFixed(fractionDigits ?? d) ?? v2;
      return ss;
    } else if (v2.contains("e")) {
      return num.tryParse(v2)?.toStringAsFixed(0) ?? v2;
    } else {
      return v2;
    }
  }

  /// Remove the 0 at the end of the decimal point
  String get filterZero {
    return this.splitMapJoin(
      RegExp(r'(?:\.0*|(\.\d+?)0+)$'),
      onMatch: (Match match) {
        return match[1] ?? '';
      },
    );
  }

  /// Precision processing
  String withDecimal(int decimal, {filterZero = false}) {
    if (this.isNotNum) return '';
    String result = Decimal.parse(this).formatNum(decimal);
    if (filterZero) {
      result = result.filterZero;
    }
    return result;
  }

  /// add
  String addDecStr(String value) {
    String a = this;
    String b = value;
    if (a.isNotNum) a = '0';
    if (b.isNotNum) b = '0';
    return NumUtil.addDecStr(a, b).toString().convertAsOrigin();
  }

  /// subtract
  String subtractDecStr(String value) {
    String a = this;
    String b = value;
    if (a.isNotNum) a = '0';
    if (b.isNotNum) b = '0';
    return NumUtil.subtractDecStr(a, b).toString().convertAsOrigin();
  }

  /// multiply
  String multiplyDecStr(String value) {
    String a = this;
    String b = value;
    if (a.isNotNum) a = '0';
    if (b.isNotNum) b = '0';
    return NumUtil.multiplyDecStr(this, value).toString().convertAsOrigin();
  }

  /// divide
  String divideDecStr(String value) {
    String a = this;
    String b = value;
    if (a.isNotNum) a = '0';
    if (b.isNotNum || b.isZero) return a;
    return NumUtil.divideDecStr(this, value).toString().convertAsOrigin();
  }

  /// Greater than
  bool greaterThanDecStr(String value) {
    String a = this;
    String b = value;
    if (a.isNotNum) a = '0';
    if (b.isNotNum) b = '0';
    return NumUtil.greaterThanDecStr(a, b);
  }

  /// Greater than or equal to
  bool greaterOrEqualDecStr(String value) {
    String a = this;
    String b = value;
    if (a.isNotNum) a = '0';
    if (b.isNotNum) b = '0';
    return NumUtil.greaterOrEqualDecStr(a, b);
  }

  /// Less than
  bool lessThanDecStr(String value) {
    String a = this;
    String b = value;
    if (a.isNotNum) a = '0';
    if (b.isNotNum) b = '0';
    return NumUtil.lessThanDecStr(a, b);
  }

  String commonLocalized([Map<String, String>? replaceArg]) {
    String text = Localized.text('ox_common.$this');
    if (replaceArg != null) {
      replaceArg.keys.forEach((key) {
        text = text.replaceAll(key, replaceArg[key] ?? '');
      });
    }
    return text;
  }

  /// Examples:
  /// ```dart
  /// String longString = "This is a very long string that needs truncation";
  /// longString.truncate(20); // Returns: "This is a...cation"
  /// longString.truncate(15); // Returns: "This...ation"
  /// longString.truncate(10); // Returns: "Thi...ion"
  /// longString.truncate(5);  // Returns: "T..."
  /// longString.truncate(5, dots: 1); // Returns: "T.i"
  /// ```
  String truncate(int maxLength, {int dots = 3}) {
    if (maxLength <= 0) return '';
    if (this.length <= maxLength) return this;

    int charsToShow = maxLength - dots;
    if (charsToShow <= 0) return '.' * dots;

    int frontChars = charsToShow ~/ 2;
    int backChars = charsToShow - frontChars;

    return '${this.substring(0, frontChars)}${'.' * dots}${this.substring(this.length - backChars)}';
  }

  String orDefault(String defaultValue) {
    return this.isEmpty ? defaultValue : this;
  }

  String capitalize() {
    if (this.isEmpty) {
      return this;
    }
    return this[0].toUpperCase() + this.substring(1);
  }

  bool get isRemoteURL => RegExp(r'https?:\/\/').hasMatch(this);
  bool get isFileURL => RegExp(r'file:\/\/').hasMatch(this.toLowerCase());
}

