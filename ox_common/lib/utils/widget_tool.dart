import 'package:flutter/material.dart';

///Title: widget_tool
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/4/25 15:12

extension YLCommonWidget on Widget {
  Widget setPadding(EdgeInsets padding) {
    return Padding(
      padding: padding,
      child: this,
    );
  }
}