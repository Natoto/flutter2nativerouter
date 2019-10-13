import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter2nativerouter/flutter2nativerouter.dart';
import 'dart:math';
import 'package:flutter2nativerouter_example/Page1.dart';

class Page2 extends StatefulWidget {
  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  static Color randomColor() {
    return Color.fromARGB(255, Random().nextInt(256) + 0,
        Random().nextInt(256) + 0, Random().nextInt(256) + 0);
  }

  Color bgcolor = Color.fromARGB(255, Random().nextInt(256) + 0,
      Random().nextInt(256) + 0, Random().nextInt(256) + 0);
  int idx = Random().nextInt(256);

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print("页面更新。。$idx");
  }

  @override
  Widget build(BuildContext context) {
    print("build 页面。。$idx");
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
            Flutter2NativerouterWidget(context, 'page2'),
            Text('this is page twotwotwo'),
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
