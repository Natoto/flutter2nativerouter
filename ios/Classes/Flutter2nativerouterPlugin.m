#import "Flutter2nativerouterPlugin.h"
#import <ATHRouter/ATHRouter.h>
#import <objc/runtime.h>
#import "F2NFlutterViewController.h"

@implementation Flutter2NativeEventChannelHandel

- (FlutterError *_Nullable)onListenWithArguments:(id _Nullable)arguments
                                       eventSink:(FlutterEventSink)events
{
    // 回调给flutter， 建议使用实例指向，因为该block可以使用多次
    if (events) {
        self.eventsBlock = [events copy];
    }
    return nil;
}

/// flutter不再接收
- (FlutterError *_Nullable)onCancelWithArguments:(id _Nullable)arguments
{
    // arguments flutter给native的参数
    return nil;
}

@end

@interface Flutter2nativerouterPlugin ()

@property (nonatomic, strong) Flutter2NativeEventChannelHandel *eventHandel;
@end

__weak static Flutter2nativerouterPlugin *_routerplugin;

@implementation Flutter2nativerouterPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel
                                     methodChannelWithName:@"flutter2nativerouter"
                                           binaryMessenger:[registrar messenger]];
    Flutter2nativerouterPlugin *instance = [[Flutter2nativerouterPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
    _routerplugin = instance;
    FlutterEventChannel *evenChannal =  [FlutterEventChannel eventChannelWithName:@"flutter2nativerouter_event" binaryMessenger:[registrar messenger]];
    Flutter2NativeEventChannelHandel *handle = [Flutter2NativeEventChannelHandel new];
    instance.eventHandel = handle;
    [evenChannal setStreamHandler:handle];
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([@"getPlatformVersion" isEqualToString:call.method]) {
        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    } else if ([@"flutter_opennative" isEqualToString:call.method]) {
        NSDictionary *parameters = call.arguments;
        [[ATHURIRouter sharedInstance] openURI:@"flutter_opennative" parameters:parameters callback:^(BOOL success, id receiver, id assignment) {
            result(@(success));
        }];
    } else if ([@"flutter_openflutter" isEqualToString:call.method]) {
        NSDictionary *parameters = call.arguments;
        [[ATHURIRouter sharedInstance] openURI:@"flutter_openflutter" parameters:parameters callback:^(BOOL success, id receiver, id assignment) {
            result(@(success));
        }];
    } else if ([@"flutter_closenative" isEqualToString:call.method]) {
        NSDictionary *parameters = call.arguments;
        [[ATHURIRouter sharedInstance] openURI:@"flutter_closenative" parameters:parameters callback:^(BOOL success, id receiver, id assignment) {
            result(@(success));
        }];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

+ (Flutter2NativeEventChannelHandel *)routerPluginEventHandel {
    return _routerplugin.eventHandel;
}

@end
