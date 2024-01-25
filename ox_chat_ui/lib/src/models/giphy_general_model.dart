import 'dart:async';

import 'package:ox_common/const/common_constant.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_network/network_manager.dart';

import 'giphy_image.dart';

enum GiphyCategory {
  /// System Emoji
  EMOJIS,

  /// Common expressions
  COLLECT,

  /// Giphy Gif Endpoint
  GIFS,

  /// Giphy Sticker Endpoint
  STICKERS,
}

extension GiphyCategoryPath on GiphyCategory{
  String get path {
    switch (this) {
      case GiphyCategory.GIFS:
        return 'gifs';
      case GiphyCategory.STICKERS:
        return 'stickers';
      case GiphyCategory.EMOJIS:
        return 'emoji';
      case GiphyCategory.COLLECT:
        return 'collect';
    }
  }
}

class GiphyService {

  static const host = GiphyConfig.host;

  Future<GiphyGeneralModel?> getTrendingEndpoint(GiphyCategory type,{String? queryString,int? offset}) async {

    var url = '';
    var params = {};

    final _isSearch = queryString != null;

    switch (type) {
      case GiphyCategory.GIFS:
        if(_isSearch){
          url = host + '/v1/gifs/search';
        }else{
          url = host + '/v1/gifs/trending';
        }
        break;
      case GiphyCategory.STICKERS:
        if(_isSearch){
          url = host + '/v1/stickers/search';
        }else{
          url = host + '/v1/stickers/trending';
        }
        break;
      case GiphyCategory.EMOJIS:
        url = host + '/v2/emoji';
        break;
    }

    params = <String, dynamic>{
      'api_key': CommonConstant.giphyApiKey,
      'limit': GiphyConfig.limit,
      'offset': offset ?? 0,
      // 'rating': 'g',
      // 'random_id': '',
      // 'bundle': 'messaging_non_clips'
    };

    if(_isSearch){
      params.addAll(<String, dynamic>{
        'q': queryString,
        'lang':'en',
        'rating': 'g',
        'bundle': 'messaging_non_clips'
      });
    }

    late NetworkResponse response;

    GiphyGeneralModel? giphyGeneralModel;

    final completer = Completer<GiphyGeneralModel>();

    void parseAndConvertResult({required NetworkResponse response}) {
      if (response.data['meta']['status'] == 200) {
        giphyGeneralModel = GiphyGeneralModel.fromJson(response.data);
        LogUtil.e('giphy response: ${giphyGeneralModel?.data.first.url}');
      }
    }

    try {
      response = await OXNetwork.instance.request(
        null,
        url: url,
        data: params,
        requestType: RequestType.GET,
        showLoading: false,
        useCache: true,
        useCacheCallback: (NetworkResponse cacheResponse) {
          parseAndConvertResult(response: cacheResponse);
        
          if (!completer.isCompleted) {
            completer.complete(giphyGeneralModel);
          }
        },
      );
    }catch(e,s){
      LogUtil.e('get ${type.path}  category request failed, used cache data : $e \r\n $s');

      try{
        giphyGeneralModel = await completer.future;
        return giphyGeneralModel;
      }catch(error){
        LogUtil.e('retrieving cache data from future failed + $e');
      }
    }

    parseAndConvertResult(response: response);
    return giphyGeneralModel;
  }
}

class GiphyConfig {
  static const host = 'https://api.giphy.com';
  static const int limit = 21;
}

class GiphyGeneralModel {
  final List<GiphyImage> data;
  final int? totalCount;
  final int? count;
  final int? offset;
  final String responseId;

  GiphyGeneralModel({required this.data, required this.totalCount, required this.count,required this.offset,required this.responseId});

  factory GiphyGeneralModel.fromJson(Map<String, dynamic> json) {
    final totalCount = json['pagination']['total_count'];
    final count = json['pagination']['total_count'];
    final offset = json['pagination']['total_count'];
    final responseId = json['meta']['response_id'];

    final giphyDataList = <GiphyImage>[];
    final gifs = json['data'];

    if (gifs != null) {
      for (var index = 0; index < gifs.length; index++) {
        final name = gifs[index]['title'];
        final url = gifs[index]['images']['fixed_width']['url'];
        final width = gifs[index]['images']['fixed_width']['width'] ?? '0';
        final height = gifs[index]['images']['fixed_width']['height'] ?? '0';
        final size = gifs[index]['images']['fixed_width']['size'] ?? '0';

        final giphyImage = GiphyImage(
            url: url,
            name: name,
            width: width,
            height: height,
            size: size,
        );

        giphyDataList.add(giphyImage);
      }
    }

    return GiphyGeneralModel(
      data: giphyDataList,
      totalCount: totalCount,
      count: count,
      offset: offset,
      responseId: responseId,
    );
  }
}
