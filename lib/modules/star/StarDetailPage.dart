import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_treasure_box/modules/global/model/star_model.dart';
import 'package:flutter_app_treasure_box/modules/global/util/Util.dart';
import 'package:flutter_app_treasure_box/modules/global/widget/ProgressDialog.dart';

class StarDetailPage extends StatefulWidget {
  String consName;


  StarDetailPage(this.consName);

  @override
  State<StatefulWidget> createState() {
    return new StarDetailState(this.consName);
  }

}

class StarDetailState extends State<StarDetailPage> {

  StarDetail mStarDetail;
  String consName;

  bool _loading = false;    // 是否loading

  final String _url = 'http://web.juhe.cn:8080/constellation/getAll?';
  final String _key = 'e9c93b5f97574e261f60bf19e446c6e0';
  final String _type = 'today';

  StarDetailState(this.consName);

  @override
  void initState() {
    super.initState();
    Future<StarDetail> starDetail = _onQuery(consName, _type);
    starDetail.then((StarDetail result) {
      setState(() {
        mStarDetail = result;
        _loading = !_loading;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text("星座运势详情"),
      ),
      body: _buildPageView(context),
    );
  }

  Widget _buildPageView(BuildContext context) {
    return new ProgressDialog (
        loading: _loading,
        msg: '正在加载...',
        child: new Padding(
          padding: new EdgeInsets.all(16.0),
          child: new Column(
            children: <Widget>[
              this.mStarDetail == null ? new Text("123") : new Text(mStarDetail.datetime)
            ],
          ),
        )
    );
  }

  //HTTP请求的函数返回值为异步控件Future
  Future<StarDetail> _onQuery(String consName, String type) async {
    setState(() {
      _loading = !_loading;
    });

    Response response;
    Dio dio = new Dio();
    response = await dio.get(_url, queryParameters: {"consName": consName, "type": type, "key": _key});
    print(response.data.toString());

    Map<String, dynamic> reMap = json.decode(response.data);

    var starDetail = new StarDetail.fromJson(reMap);
    return starDetail;
  }

}