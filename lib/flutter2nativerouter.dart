import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


final Map<String,Flutter2NativePageContext> contextMap = {};

final MyRouteObserver routeObserver = MyRouteObserver();
//final MyRouteObserver<PageRoute> routeObserver = new MyRouteObserver<PageRoute>();
//final Flutter2nativerouterWare routeware = Flutter2nativerouterWare();

class Flutter2NativePageContext
{
   BuildContext context;
   String routeName;
   int pageIdx;
   int groupIdx;
   Flutter2NativePageContext(this.context,this.routeName,this.pageIdx,this.groupIdx);

}

class MyRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  void _sendScreenView(PageRoute<dynamic> route) {
    var screenName = route.settings.name;
    print('screenName ---> $screenName');
    // do something with it, ie. send it to your analytics service collector
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    super.didPush(route, previousRoute);
    print('didPush ---> ');
    if (route is PageRoute) {
      _sendScreenView(route);
    }

  }

  @override
  void didReplace({Route<dynamic> newRoute, Route<dynamic> oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    print('didReplace ---> ');
    if (newRoute is PageRoute) {
      _sendScreenView(newRoute);
    }
  }


  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {

//    if(Flutter2nativerouter.groupCanPop()){
      super.didPop(route, previousRoute);
      print('didPop ---> ');
      if (previousRoute is PageRoute && route is PageRoute) {
        _sendScreenView(previousRoute);
      }
  }
}


class NoAnimationMaterialPageRoute<T> extends MaterialPageRoute<T> {
  NoAnimationMaterialPageRoute({
    @required WidgetBuilder builder,
    RouteSettings settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(
      builder: builder,
      maintainState: maintainState,
      settings: settings,
      fullscreenDialog: fullscreenDialog);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}

class Flutter2NativerouterWidget extends StatelessWidget
{
   Flutter2NativerouterWidget(BuildContext context,String routename)
   {
     Flutter2nativerouter.updateContext(context,routename);
   }
   @override
  Widget build(BuildContext context) {
    return Container();
  }
}

/*
class Flutter2nativerouterWare  with RouteAware
{

//  @override
//  void dispose() {
//    routeObserver.unsubscribe(this);
//    super.dispose();
//  }
  void didPopNext() {
    debugPrint("didPopNext --- ${runtimeType}");
  }

  // Called when the current route has been pushed.
  void didPush() {
    debugPrint("didPush xxxx --- ${runtimeType}");
  }

  // Called when the current route has been popped off.
  void didPop() {
    debugPrint("didPop ${runtimeType}");
  }

  // Called when a new route has been pushed, and the current route is no longer visible.
  void didPushNext() {
    debugPrint("didPushNext ${runtimeType}");
  }

}
*/

class Flutter2nativerouter{

  static List<int> pageidxgroups = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
  //总共有多少组flutter页面,最多100个页面

  static int curgroupidx = 0;     //当前是第几组页面

  static const MethodChannel _channel =
      const MethodChannel('flutter2nativerouter');

//  static BuildContext _context;

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }


  static const EventChannel _eventChannel = const EventChannel("flutter2nativerouter_event");
  static Function(String, Object) _broadcastCallback;
  static StreamSubscription _streamSubscription;

  /*接受系统事件*/
  static void startReceivingBroadcasts(
      Function(String broadcastName, Object broadcastData) onReceiveBroadcast) {
    _broadcastCallback = onReceiveBroadcast;
    _streamSubscription = _eventChannel
        .receiveBroadcastStream("flutter2nativerouter_event")
        .listen(_onRcvBroadcast, onError: _onRcvBroadcastError);

  }

  static String getcontextkey(int pageidx, int groupidx){

    return "${groupidx}_${pageidx}";
  }
  static void _onRcvBroadcast(Object obj) {

    Map msg = obj;
    String type = msg['type'];
    String value = msg['value'];
    print("收到原生的方法调用 $type $value");
    if(type == "closeuri")
    {
      BuildContext _context = contextMap[getcontextkey(pageidxgroups[curgroupidx], curgroupidx)].context;
      _poppage(_context,true);
//      if(pageidxgroups[curgroupidx]>0){
//
//        BuildContext _context = contextMap[getcontextkey(pageidxgroups[curgroupidx], curgroupidx)].context;
//        _poppage(_context,true);
//      }else{
//        int idx = pageidxgroups[curgroupidx];
//        print("当前的idx $idx groupcuridx $curgroupidx");
//        if(pageidxgroups[curgroupidx]>=0) {
//          pop(_context, true);
//        }
//        closeNativeURI({"isForceClose":1});
//      }
    }
    else if(type == "dealloccloseuri")
    {
//      BuildContext _context = contextMap[getcontextkey(pageidxgroups[curgroupidx], curgroupidx)].context;
//      _poppage(_context,true);
    }
    else if( type == 'openuri'){
      _broadcastCallback('openuri',value);
    }

  }

  static void _onRcvBroadcastError(Object error) {
    print("On receive service error $error");
  }

  /*更新context*/
  static Future<bool> updateContext(BuildContext context, String routename){
    print("更新context $routename");
    Flutter2NativePageContext con = Flutter2NativePageContext(context, routename, pageidxgroups[curgroupidx] , curgroupidx);
    contextMap[getcontextkey(pageidxgroups[curgroupidx], curgroupidx)] = con;
  }

  static Future<bool> nativeOpenFlutterURI(BuildContext context, String pagename,[dynamic params]) async {

    Navigator.pushNamed(context, pagename);
    curgroupidx ++;
    pageidxgroups[curgroupidx] = 0;
    print("nativeOpenFlutterURI curgroupidx: $curgroupidx ${pageidxgroups[curgroupidx]}");
  }


  static Future<bool> nativeOpenFlutterMainURI(BuildContext context) async {

    pageidxgroups[curgroupidx] = 0;
    Navigator.of(context).popUntil((r) => r.isFirst);
    print("nativeOpenFlutterMainURI curgroupidx: $curgroupidx ${pageidxgroups[curgroupidx]}");
  }

/*打开原生页面
*
*  Flutter2nativerouter.openNativeURI({"uri":"AViewController","animated":1});
* */
  static Future<bool> openNativeURI(dynamic params) async {
    final bool res = await _channel.invokeMethod('flutter_opennative',params);
    return res;
  }
  /*打开flutter页面*/
  static Future<bool> openFlutterURI(BuildContext context, String pagename,[dynamic params]) async {

    pageidxgroups[curgroupidx] = pageidxgroups[curgroupidx] + 1;
    print('flutter push flutter page $params ');
    if(params == null) params = {'animated':0};
//    params["animated"] = 0;
    final bool res = await _channel.invokeMethod('flutter_openflutter',params);

    return res;
  }
  /*关闭原生页面*/
  static Future<bool> closeNativeURI([dynamic params]) async {
    curgroupidx --;
    if(curgroupidx<=0) curgroupidx = 0;
    final bool res = await _channel.invokeMethod('flutter_closenative',params);
    return res;
  }

 /*关闭flutter页面*/
  static Future<bool> startcloseFlutterURI(BuildContext context,[dynamic params]) async {

      closeNativeURI(params);
  }


  static groupCanPop() {

    int pageidx = pageidxgroups[curgroupidx];

    return pageidx>0;

  }

  // 出栈
  static bool _poppage<T extends Object>(BuildContext context,[T result]) {

    if(context == null) return false;
    if(canPop(context)){
      print("context 设置为空 ..... ");
      contextMap.remove(getcontextkey(pageidxgroups[curgroupidx], curgroupidx));
      bool res =  Navigator.pop(context, result);
      return res;
    }else{
      //做一次错误校验
      pageidxgroups[curgroupidx] = 0;
    }
    return false;
  }

  // 返回路由是否可以后退
  static canPop(BuildContext context) {
    return Navigator.canPop(context);
  }

}
