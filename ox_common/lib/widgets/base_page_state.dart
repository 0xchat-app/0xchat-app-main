import 'package:flutter/material.dart';
//import 'package:yl_statistics/yl_statistics.dart';

/**
 * Title: base_page_state
 * Description: TODO(Fill in by oneself)
 * Copyright: Copyright (c) 2023
 *
 * @author john
 * @CheckItem Fill in by oneself
 */
abstract class BasePageState<T extends StatefulWidget> extends State<T> {
  @protected
  String get routeName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    if(routeName!=null&& routeName.isNotEmpty) {
//      YLStatistics.pageStart(routeName);
//    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
//    if(routeName!=null&& routeName.isNotEmpty) {
//      YLStatistics.pageEnd(routeName);
//    }
  }
}
