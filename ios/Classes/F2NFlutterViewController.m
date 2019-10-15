//
//  MOSFlutterViewController.m
//  MosChat
//
//  Created by boob on 2019/1/3.
//  Copyright © 2019年 YY.INC. All rights reserved.
//
//#import <FlutterPluginRegistrant/GeneratedPluginRegistrant.h>

#import "F2NFlutterViewController.h"
#import "Flutter2nativerouterPlugin.h"
#import <objc/runtime.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
//#import "YynativehelperPlugin.h"

static int kGroupPageIdx = 0;
static __weak YYFlutterViewContainer *lastFlutterCtr = nil;

@interface Flutter2nativerouterPlugin (helper)
+ (void)pushPageWithName:(NSString *)routeName uniqidx:(int)idx;
+ (NSDictionary *)createHandleMap:(NSString *)type value:(NSString *)value groupidx:(int)groupidx;
@end

@interface YYFlutterViewContainer ()<UINavigationControllerDelegate>
@property (nonatomic, strong) F2NFlutterViewController *fluttervc;
@property (nonatomic, strong) UIImageView *snapImageView;
@property (nonatomic, strong) NSString *routeName;
//@property (nonatomic, assign) BOOL isloadflutter;
@property (nonatomic, assign) int groupidx;
//@property (nonatomic, assign) BOOL needUpdateScreenShot;
@property (nonatomic, assign) BOOL haveloadflutter;
@end

@implementation UIViewController (snap)

+ (UIImage *)takeSnapshot {
    GLint bufferWidth = 0;
    GLint bufferHeight = 0;

    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &bufferWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &bufferHeight);

    int width = bufferWidth;
    int height = bufferHeight;
    int length = width * height * 4;
    void *data = (void *)malloc(length * sizeof(GLubyte));

    glPixelStorei(GL_PACK_ALIGNMENT, 4);
    glReadPixels(0, 0, bufferWidth, bufferHeight, GL_RGBA, GL_UNSIGNED_BYTE, data);

    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(nil, data, length, nil);
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGImageRef image = CGImageCreate(width, height, 8, 32, width * 4, colorspace, kCGBitmapByteOrderDefault, dataProvider, nil, YES, kCGRenderingIntentDefault);

    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), false, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), image);
    UIImage *renderedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    free(data);
    return renderedImage;
}

- (UIImage *)f2n_screenShots:(UIView *)view1
{
    //截取整个backview
    UIView *view = view1;
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0);
    [view.layer performSelectorOnMainThread:@selector(renderInContext:) withObject:(id)UIGraphicsGetCurrentContext() waitUntilDone:YES];
    UIImage *sourceImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return sourceImage;
//    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
//    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return image;
}

@end

#pragma mark - flutter engine

@interface MOSFlutterEngine ()
@property (nonatomic, strong, readonly) F2NFlutterViewController *flutterViewController;
@property (nonatomic, strong) FlutterEngine *engine;
@property (nonatomic, copy) FlutterEventSink eventsBlock;
@end

@implementation MOSFlutterEngine
@synthesize flutterViewController = _flutterViewController;

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (YYFlutterViewContainer *)createFlutterContainer:(NSString *)routeName
{
    YYFlutterViewContainer *ctr = [YYFlutterViewContainer new];
    ctr.routeName = routeName;
    ctr.groupidx = kGroupPageIdx++;
    if (lastFlutterCtr) {
         UIImage *image =  [lastFlutterCtr f2n_screenShots:lastFlutterCtr.view];
         lastFlutterCtr.snapImageView.image = image;
    }
    lastFlutterCtr = ctr;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      [Flutter2nativerouterPlugin pushPageWithName:ctr.routeName uniqidx:ctr.groupidx];
//    });
    return ctr;
}

- (F2NFlutterViewController *)flutterViewController
{
    if (!_flutterViewController) {
        [_engine runWithEntrypoint:nil];
        F2NFlutterViewController *flutterViewController = [[F2NFlutterViewController alloc] initWithEngine:MOSFlutterEngine.sharedInstance.engine nibName:nil bundle:nil];
        [MOSFlutterEngine.sharedInstance registerPlugins:flutterViewController];
        _flutterViewController = flutterViewController;
//        NSString *channelName = @"com.girgir.app/native_post";
//        FlutterEventChannel *evenChannal = [FlutterEventChannel eventChannelWithName:channelName binaryMessenger:self];
        // 代理
//        [evenChannal setStreamHandler:MOSFlutterEngine.sharedInstance];
    }
    return _flutterViewController;
}

- (FlutterEngine *)myEngine
{
    return self.engine;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        if (!_engine) {
            FlutterEngine *engine = [[FlutterEngine alloc] initWithName:@"flutter.io" project:nil];
            _engine = engine;
//            [_engine runWithEntrypoint:nil];
        }
    }
    return self;
}

- (void)registerPlugins:(FlutterViewController *)flutterViewController
{
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class clazz = NSClassFromString(@"GeneratedPluginRegistrant");
        if (clazz) {
            if ([clazz respondsToSelector:NSSelectorFromString(@"registerWithRegistry:")]) {
                [clazz performSelector:NSSelectorFromString(@"registerWithRegistry:")
                            withObject:flutterViewController];
            }
        }
    });
    #pragma clang diagnostic pop
}

@end

#pragma mark - YYFlutterViewContainer
static UINavigationController *curnavigationctr;
@implementation YYFlutterViewContainer

- (F2NFlutterViewController *)fluttervc
{
    if (!_fluttervc) {
        [MOSFlutterEngine.sharedInstance.myEngine runWithEntrypoint:nil];
        _fluttervc = [[ F2NFlutterViewController alloc] initWithEngine:MOSFlutterEngine.sharedInstance.myEngine nibName:nil bundle:nil];
        [MOSFlutterEngine.sharedInstance registerPlugins:_fluttervc];
    }
    return _fluttervc;
}

- (void)detachFlutterView
{
//    [self.view bringSubviewToFront:self.snapImageView];
    MOSFlutterEngine.sharedInstance.myEngine.viewController = nil;
}

- (void)attachFlutterView
{
    F2NFlutterViewController *ctr = self.fluttervc;
    MOSFlutterEngine.sharedInstance.myEngine.viewController = ctr; 
//    [ctr surfaceUpdated:YES];     
    if (![self.childViewControllers containsObject:ctr]) {
        [self addChildViewController:ctr];
        ctr.view.frame = self.view.bounds;
        [self.view addSubview:ctr.view];
    }
}

- (void)viewDidLoad
{
    curnavigationctr = self.navigationController;
    [self snapImageView];
    self.view.backgroundColor = [UIColor colorWithRed:0x16 / 255.0 green:0x17 / 255.0  blue:0x18 / 255.0  alpha:0];
#if DEBUG
    self.view.backgroundColor = [UIColor redColor];
#endif
}

- (void)dealloc
{
    NSLog(@"%s 已经释放", __func__);
    kGroupPageIdx--;

    if (kGroupPageIdx > 0 && [Flutter2nativerouterPlugin routerPluginEventHandel].eventsBlock) {
//        [MOSFlutterEngine.sharedInstance.myEngine.lifecycleChannel  sendMessage:@"AppLifecycleState.resumed"];
        [Flutter2nativerouterPlugin routerPluginEventHandel].eventsBlock([Flutter2nativerouterPlugin createHandleMap:@"closeuri" value:self.routeName groupidx:self.groupidx]);
         #pragma clang diagnostic push
         #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        if ([curnavigationctr.topViewController isKindOfClass:YYFlutterViewContainer.class]) {
            [MOSFlutterEngine.sharedInstance.myEngine.viewController performSelector:@selector(surfaceUpdated:) withObject:@1];
            NSLog(@"%s 还有堆栈 执行 surfaceUpdated", __func__);
        }
        #pragma clang diagnostic pop
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self attachFlutterView];
//    self.snapImageView.frame = CGRectMake(100, 100, 100, 100);
//    if (self.haveloadflutter) {
        [self.view bringSubviewToFront:self.snapImageView];             
//        self.haveloadflutter = YES;
//    } 
    NSLog(@"%s", __func__); 
}

- (void)viewDidAppear:(BOOL)animated
{ 
    [super viewDidAppear:animated]; 
    NSLog(@"%s", __func__);
    [Flutter2nativerouterPlugin routerPluginEventHandel].eventsBlock([Flutter2nativerouterPlugin createHandleMap:@"updategroupidx" value:self.routeName groupidx:self.groupidx]);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.view sendSubviewToBack:self.snapImageView];     
    });

}

- (void)viewWillDisappear:(BOOL)animated
{ 
  [self detachFlutterView];
  [super viewWillDisappear:animated];
    NSLog(@"%s", __func__);
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"%s", __func__);
}

- (UIImageView *)snapImageView
{
    if (!_snapImageView) {
        _snapImageView = [UIImageView new];
        [self.view addSubview:_snapImageView];
        [self.view sendSubviewToBack:_snapImageView];
        _snapImageView.frame = self.view.bounds;
        #if DEBUG
//        _snapImageView.backgroundColor = [UIColor yellowColor];
        #endif
    }
    return _snapImageView;
}

@end

#pragma mark - mosfluttervc

@interface F2NFlutterViewController ()
@end

@implementation F2NFlutterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%s", __func__);
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
//    LogInfo(NSStringFromClass(self.class), @"%s",__func__);
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"%s", __func__);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    NSLog(@"%@ %s", NSStringFromClass(self.class), __func__);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"%s", __func__);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"%@ %s", NSStringFromClass(self.class), __func__);
}

- (void)setInitialRoute:(NSString *)route
{
    [super setInitialRoute:route]; 
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)loadDefaultSplashScreenView
{
    return YES;
}

@end

@implementation Flutter2nativerouterPlugin (helper)

+ (void)pushPageWithName:(NSString *)routeName uniqidx:(int)idx
{
    if ([Flutter2nativerouterPlugin routerPluginEventHandel].eventsBlock) {
        [Flutter2nativerouterPlugin routerPluginEventHandel].eventsBlock([Flutter2nativerouterPlugin createHandleMap:@"openuri" value:routeName groupidx:idx]);
    }
}

+ (NSDictionary *)createHandleMap:(NSString *)type value:(NSString *)value groupidx:(int)groupidx
{
    type = type ? type : @"unknow";
    value = value ? value : @"";
    return @{
        @"value": value,
        @"type": type,
        @"groupidx": @(groupidx)
    };
}

@end

/*
#pragma mark - pop dismiss

@implementation UINavigationController (flutter2native)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        [self swizzleSelector:@selector(popViewControllerAnimated:) withAnotherSelector:@selector(f2n_popViewControllerAnimated:)];
//        [self swizzleSelector:@selector(pushViewController:animated:) withAnotherSelector:@selector(f2n_pushViewController:animated:)];
    });
}

+ (void)swizzleSelector:(SEL)originalSelector withAnotherSelector:(SEL)swizzledSelector
{
    Class aClass = [self class];

    Method originalMethod = class_getInstanceMethod(aClass, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(aClass, swizzledSelector);

    BOOL didAddMethod =
        class_addMethod(aClass,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));

    if (didAddMethod) {
        class_replaceMethod(aClass,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

#pragma mark - Method Swizzling
- (void)f2n_pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    BOOL isflutterview = NO;
    if ([viewController isKindOfClass:[YYFlutterViewContainer class]]) {
        YYFlutterViewContainer *ctr = (YYFlutterViewContainer *)viewController;
        if ([Flutter2nativerouterPlugin routerPluginEventHandel].eventsBlock) {
//            animated = NO;
            isflutterview = YES;
        }
    }
    [self f2n_pushViewController:viewController animated:animated];
}

- (UIViewController *)f2n_popViewControllerAnimated:(BOOL)animated
{
    BOOL isflutterview = NO;
    if ([self.topViewController isKindOfClass:[YYFlutterViewContainer class]]) {
        YYFlutterViewContainer *ctr = (YYFlutterViewContainer *)self.topViewController;
        BOOL isForceClose = ctr.isForceClose;
        if (!isForceClose && [Flutter2nativerouterPlugin routerPluginEventHandel].eventsBlock) {
//            animated = NO;
            isflutterview = YES;
        }
    }
    if (isflutterview) {
        if ([Flutter2nativerouterPlugin routerPluginEventHandel].eventsBlock) {
//            [Flutter2nativerouterPlugin routerPluginEventHandel].eventsBlock([Flutter2nativerouterPlugin createHandleMap:@"closeuri" value:@"popflutter"]);
        }
        return nil;
    } else {
        UIViewController *ctr = [self f2n_popViewControllerAnimated:animated];
        return ctr;
    }
}

@end

@implementation UIViewController (flutter2native)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [UINavigationController swizzleSelector:@selector(dismissViewControllerAnimated:completion:) withAnotherSelector:@selector(f2n_dismissViewControllerAnimated:completion:)];
    });
}

- (void)f2n_dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    BOOL isflutterview = NO;
    if ([self isKindOfClass:[YYFlutterViewContainer class]]) {
        if ([Flutter2nativerouterPlugin routerPluginEventHandel].eventsBlock) {
            isflutterview = YES;
        }
    }
    [self f2n_dismissViewControllerAnimated:flag completion:^{
        if (isflutterview) {
//            [Flutter2nativerouterPlugin routerPluginEventHandel].eventsBlock([Flutter2nativerouterPlugin createHandleMap:@"closeuri" value:@"dismissflutter"]);
        }
        completion();
    }];
}

@end
*/
