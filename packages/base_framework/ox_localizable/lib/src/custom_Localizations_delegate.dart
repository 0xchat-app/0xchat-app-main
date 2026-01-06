
import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/cupertino.dart';

import './localized.dart';

class CupertinoLocalizationsDelegate extends LocalizationsDelegate<CupertinoLocalizations> {
  const CupertinoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  SynchronousFuture<_DefaultCupertinoLocalizations> load(Locale locale) {
    return SynchronousFuture<_DefaultCupertinoLocalizations>(
      _DefaultCupertinoLocalizations()
    );
  }

  @override
  bool shouldReload(CupertinoLocalizationsDelegate old) => false;
}

class _DefaultCupertinoLocalizations extends CupertinoLocalizations {
  _DefaultCupertinoLocalizations();

  final DefaultCupertinoLocalizations _en = const DefaultCupertinoLocalizations();

  @override
  String get alertDialogLabel => Localized.text('ox_common.alertDialogLabel');

  @override
  String get todayLabel => Localized.text('ox_common.todayLabel');

  @override
  String get anteMeridiemAbbreviation => _en.anteMeridiemAbbreviation;

  @override
  String get postMeridiemAbbreviation => _en.postMeridiemAbbreviation;

  @override
  String get copyButtonLabel => Localized.text('ox_common.copyButtonLabel');

  @override
  String get cutButtonLabel => Localized.text('ox_common.cutButtonLabel');

  @override
  String get pasteButtonLabel => Localized.text('ox_common.pasteButtonLabel');

  @override
  String get selectAllButtonLabel => Localized.text('ox_common.selectAllButtonLabel');

  @override
  String get modalBarrierDismissLabel => _en.modalBarrierDismissLabel;

  @override
  DatePickerDateOrder get datePickerDateOrder => _en.datePickerDateOrder;

  @override
  DatePickerDateTimeOrder get datePickerDateTimeOrder => _en.datePickerDateTimeOrder;

  @override
  String datePickerDayOfMonth(int dayIndex, [int? weekDay]) => _en.datePickerDayOfMonth(dayIndex, weekDay);

  @override
  String datePickerHour(int hour) => _en.datePickerHour(hour);

  @override
  String datePickerHourSemanticsLabel(int hour) => _en.datePickerHourSemanticsLabel(hour);

  @override
  String datePickerMediumDate(DateTime date) => _en.datePickerMediumDate(date);

  @override
  String datePickerMinute(int minute) => _en.datePickerMinute(minute);

  @override
  String datePickerMinuteSemanticsLabel(int minute) => _en.datePickerMinuteSemanticsLabel(minute);

  @override
  String datePickerMonth(int monthIndex) => _en.datePickerMonth(monthIndex);

  @override
  String datePickerYear(int yearIndex) => _en.datePickerYear(yearIndex);

  @override
  String tabSemanticsLabel({required int tabIndex, required int tabCount}) => _en.tabSemanticsLabel(tabIndex: tabIndex, tabCount: tabCount);

  @override
  String timerPickerHour(int hour) => _en.timerPickerHour(hour);

  @override
  String timerPickerHourLabel(int hour) => _en.timerPickerHourLabel(hour);

  @override
  String timerPickerMinute(int minute) => _en.timerPickerMinute(minute);

  @override
  String timerPickerMinuteLabel(int minute) => _en.timerPickerMinuteLabel(minute);

  @override
  String timerPickerSecond(int second) => _en.timerPickerSecond(second);

  @override
  String timerPickerSecondLabel(int second) => _en.timerPickerSecondLabel(second);

  @override
  // TODO: implement searchTextFieldPlaceholderLabel
  String get searchTextFieldPlaceholderLabel => _en.searchTextFieldPlaceholderLabel;

  @override
  // TODO: implement timerPickerHourLabels
  List<String> get timerPickerHourLabels => _en.timerPickerHourLabels;

  @override
  // TODO: implement timerPickerMinuteLabels
  List<String> get timerPickerMinuteLabels => _en.timerPickerMinuteLabels;

  @override
  // TODO: implement timerPickerSecondLabels
  List<String> get timerPickerSecondLabels => _en.timerPickerSecondLabels;

  @override
  // TODO: implement noSpellCheckReplacementsLabel
  String get noSpellCheckReplacementsLabel => _en.noSpellCheckReplacementsLabel;

  @override
  String get clearButtonLabel => _en.clearButtonLabel;

  @override
  String datePickerStandaloneMonth(int monthIndex) => _en.datePickerStandaloneMonth(monthIndex);

  @override
  String get lookUpButtonLabel => _en.lookUpButtonLabel;

  @override
  String get menuDismissLabel => _en.menuDismissLabel;

  @override
  String get searchWebButtonLabel => _en.searchWebButtonLabel;

  @override
  String get shareButtonLabel => _en.shareButtonLabel;
}