import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter2nativerouter/flutter2nativerouter.dart';
import 'dart:math';

class Page1 extends StatefulWidget {
  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  static Color randomColor() {
    return Color.fromARGB(255, Random().nextInt(256) + 0,
        Random().nextInt(256) + 0, Random().nextInt(256) + 0);
  }

  Color bgcolor = Color.fromARGB(255, Random().nextInt(256) + 0,
      Random().nextInt(256) + 0, Random().nextInt(256) + 0);
  int idx = Random().nextInt(256);
  int isobserver = 0;
   @override
  void initState() {
    // TODO: implement initState
    super.initState();
   }

   @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
//    routeObserver.unsubscribe(routeware);
   }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
//    routeObserver.subscribe(routeware, ModalRoute.of(context));
    print("页面更新。。$idx");
  }

  @override
  Widget build(BuildContext context) {
//    print("build 页面。。$idx");

    return Scaffold(
      appBar: AppBar(
          title: const Text('Plugin example app'),
          leading: CupertinoNavigationBarBackButton(
            color: Colors.white,
            onPressed: () {
              Flutter2nativerouter.closeFlutterURI(context);
            },
          )),
      backgroundColor: bgcolor,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flutter2NativerouterWidget(context, 'page1'),
            Text('this is page one'),
            Text('当前序号 $idx'),
            RaisedButton(
                child: Text("open native"),
                onPressed: () {
                  print("click me");
                  Flutter2nativerouter.openNativeURI({});
                }),
            RaisedButton(
                child: Text("close native"),
                onPressed: () {
                  print("click me");
                  Flutter2nativerouter.closeNativeURI({});
                }),
            RaisedButton(
                child: Text("open flutter"),
                onPressed: () {
                  print("click me");
                  Flutter2nativerouter.openFlutterURI(context, 'page1',{'uri':'page1'});
                }),
            RaisedButton(
                child: Text("close flutter"),
                onPressed: () {
                  print("click me");
                  Flutter2nativerouter.closeFlutterURI(context);
                })
          ],
        ),
      ),
    );
  }
}
