
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_search_textfield.dart';
import 'package:ox_localizable/ox_localizable.dart';

abstract class CommonSearchPage extends StatefulWidget{

  final String searchHint;


  CommonSearchPage({Key? key,this.searchHint = ""}) : super(key: key);


}

abstract class CommonSearchPageState<T extends StatefulWidget> extends State<T> {


  List<String> searchHistoryLists = [];

  ///Whether to display search results
  bool showResultArea  = false;

  late TextEditingController controller;

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    controller = new TextEditingController();
  }




  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @mustCallSuper
  onInputCallBack(String value){

    setState(() {
      showResultArea = value.isNotEmpty;
    });

  }


  onSearchSubmitted(String value){}

  @mustCallSuper
  onClearHistory(){

    setState(() {
      searchHistoryLists = [];
    });

  }

  ///called click a single history text
  void onHistoryItemClick(int index,String result){}

  ///The view for which the search was not started
  Widget buildContent();

  ///Search results view
  Widget buildResultContent();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: ThemeColor.dark02,
        appBar: _appBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              searchHistoryLists.length > 0 && !showResultArea ?
                   _renderHistorySearchArea() : Container(),
              showResultArea ? buildResultContent() : buildContent()
            ],
          ),
        )
    );
  }

  _appBar(){

    return PreferredSize(
        preferredSize: Size.fromHeight(Adapt.px(50)),
        child: Container(
          margin: EdgeInsets.only(top: MediaQueryData.fromWindow(window).padding.top + Adapt.px(4),bottom: Adapt.px(12)),
          child: CommonSearchTextField(
            controller: controller,
            inputCallBack: onInputCallBack,
            frameWidth: Adapt.px(50),
            hintText: (widget as CommonSearchPage).searchHint,
            isShowDeleteBtn: true,
            rightWidget: GestureDetector(
              onTap: ()=>OXNavigator.pop(context),
              child: Container(
                  margin: EdgeInsets.symmetric(horizontal: Adapt.px(15)),
                  child: Text(Localized.text('ox_common.cancel'),style: TextStyle(
                      fontSize: Adapt.px(14),
                      fontWeight: FontWeight.w500,
                      // fontWeight: Platform.isAndroid ? FontWeight.w600 : FontWeight.w500,
                      color: ThemeColor.main
                  ),)
              ),
            ),
            onSubmitted: onSearchSubmitted,
          ),
        )
    );

  }

  Widget _renderHistorySearchArea(){

    return Container(
      padding: EdgeInsets.only(left: Adapt.px(15),right: Adapt.px(15)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: Adapt.px(8)),
                child: Text(
                    Localized.text('ox_common.history_search_title'),style: TextStyle(
                    fontSize: Adapt.px(16),
                    fontWeight:FontWeight.w500,
                    // fontWeight: Platform.isAndroid ? FontWeight.w600 : FontWeight.w500,
                    color: ThemeColor.gray02,
                ),
                ),
              ),
              GestureDetector(
                onTap: onClearHistory,
                child: CommonImage(
                  iconName: "icon_delete.png",
                  width: Adapt.px(16),
                  height: Adapt.px(16),
                ),
              )
            ],
          ),
          Divider(
            color: ThemeColor.dark04,
            height: 1,
          ),

          Container(
            padding: EdgeInsets.only(top: Adapt.px(19),bottom: Adapt.px(22)),
            child: GridView.builder(
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: searchHistoryLists.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: Adapt.px(8),
                    childAspectRatio: 110/32,
                    mainAxisSpacing: Adapt.px(12)
                ),
                itemBuilder: (BuildContext context, int index) {
                  //Widget Function(BuildContext context, int index)
                  return GestureDetector(
                    onTap: ()=>onHistoryItemClick(index, searchHistoryLists[index]),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: ThemeColor.dark04,
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      child: Text(searchHistoryLists[index],style: TextStyle(
                          fontSize: Adapt.px(14),
                          fontWeight:FontWeight.w500,
                          // fontWeight: Platform.isAndroid ? FontWeight.w600 : FontWeight.w500,
                          color: ThemeColor.white01
                      ),),
                    ),
                  );
                }
            ),
          ),


        ],
      ),
    );


  }

}


