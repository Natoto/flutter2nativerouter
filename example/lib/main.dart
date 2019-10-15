import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter2nativerouter/flutter2nativerouter.dart';
import 'package:flutter2nativerouter_example/Page2.dart';
import 'package:flutter2nativerouter_example/Page1.dart';


void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}


class _MyAppState extends State<MyApp>  with RouteAware{

  String _platformVersion = 'Unknown';
  int pageNum =0;
  BuildContext _curContext;
  @override
  void initState() {
    super.initState();
    initPlatformState();
    Flutter2nativerouter.startReceivingBroadcasts( (String broadcastName, Object broadcastData){
        //处理native过来的 push传参等
       print("main.dart 收到回调 ${broadcastName} ${broadcastData}");

       if(broadcastName == 'openuri')
       {
         if(broadcastData == 'page2'){

           Flutter2nativerouter.nativeOpenFlutterURI(_curContext, 'page2');
         }
         if(broadcastData == 'page1'){

           Flutter2nativerouter.nativeOpenFlutterURI(_curContext, 'page1');
         }
         else { //if(broadcastData == 'main'){
           Flutter2nativerouter.nativeOpenFlutterMainURI(_curContext);
         }
       }
    });
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await Flutter2nativerouter.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext contxt) {
    return
      MaterialApp(
      navigatorObservers: <NavigatorObserver>[routeObserver],
      routes: {
        'page1':(contxt) => new Page1(),
        'page2':(contxt) => new Page2()
      },
      home: Builder(
        builder: (BuildContext context1){
          _curContext = context1;
          return Scaffold(
            appBar: AppBar(
              title: const Text('Plugin example app'),
            ),
            body: Center(
              child:  Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flutter2NativerouterWidget(context1,'main'),
                  Text('this is page main'),
                  Text('Running on: $_platformVersion\n'),
                  RaisedButton(
                      child: Text("push native"),
                      onPressed: (){
                        print("click me");
                        Flutter2nativerouter.openNativeURI({"uri":"AViewController","animated":1});
                        setState(() {
                          pageNum++;
                        });
                      }),
                  RaisedButton(
                      child: Text("push flutter $pageNum"),
                      onPressed: (){
                        print("click me $pageNum");
                        Flutter2nativerouter.openFlutterURI(context1, 'page1',{"animated":0,"uri":'page1'});
                      }),
//              Page1(),
                ],
              ),
            ),

          );
        },
      )

    );
  }
}
