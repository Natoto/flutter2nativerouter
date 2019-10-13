#import <Flutter/Flutter.h>

@interface Flutter2NativeEventChannelHandel : NSObject<FlutterStreamHandler>

@property (nonatomic, copy) FlutterEventSink eventsBlock;

@end

@interface Flutter2nativerouterPlugin : NSObject<FlutterPlugin>

//+(void)pushPageWithName:(NSString *)routeName;

+(Flutter2NativeEventChannelHandel  *)routerPluginEventHandel;

@end
