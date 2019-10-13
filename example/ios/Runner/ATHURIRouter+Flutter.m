//
//  ATHURIRouter+UDB.m
//  GirGir
//
//  Created by zhouzhenhua on 2019/9/24.
//  Copyright © 2019 gokoo. All rights reserved.
//

#import "ATHURIRouter+Flutter.h"
#import "AViewController.h"
#import <flutter2nativerouter/F2NFlutterViewController.h>
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
@implementation ATHURIRouter (flutter)

//static int flutterpageidx = 0;

URIRegisterAction(UDBLoginAction2, @[@"native_openflutter"]) {
    NSDictionary *param = userInfo;
    UINavigationController *topViewController =  (UINavigationController *)[[UIApplication sharedApplication]delegate].window.rootViewController;
    //param[@"uri"]
    UIViewController *ctr = [MOSFlutterEngine.sharedInstance createFlutterContainer:@""];
    [topViewController pushViewController:ctr animated:YES];
//    topViewController.fd_interactivePopDisabled = YES;
//    flutterpageidx = 0;
}

URIRegisterAction(UDBLoginAction, @[@"flutter_opennative"]) {
    NSDictionary *param = userInfo;
    NSNumber *animatevalue = param[@"animated"];
    NSString *uri = param[@"AViewController"];
    BOOL animate = animatevalue ? animatevalue.boolValue : YES;
    UINavigationController *topViewController =  (UINavigationController *)[[UIApplication sharedApplication]delegate].window.rootViewController;
    [topViewController pushViewController:[AViewController new] animated:animate];
//    topViewController.topViewController.fd_interactivePopDisabled = YES;
    callback(YES, nil, nil);
}
URIRegisterAction(UDBLoginAction3, @[@"flutter_openflutter"]) {
    NSDictionary *param = userInfo;
    UINavigationController *topViewController =  (UINavigationController *)[[UIApplication sharedApplication]delegate].window.rootViewController;
//    topViewController.topViewController.fd_interactivePopDisabled = YES;

    NSString *url = param[@"uri"];
    if ([url isEqualToString:@"AViewController"]) {
        [topViewController pushViewController:[AViewController new] animated:YES];
//        topViewController.topViewController.fd_interactivePopDisabled = NO;
        return;
    }
    UIViewController *ctr = [MOSFlutterEngine.sharedInstance createFlutterContainer:param[@"uri"]];
//    ctr.fd_interactivePopDisabled = YES;
    [topViewController pushViewController:ctr animated:YES];
}

URIRegisterAction(UDBLoginAction4, @[@"flutter_closenative"]) {
    UINavigationController *topViewController =  (UINavigationController *)[[UIApplication sharedApplication]delegate].window.rootViewController;
    if ([topViewController.topViewController isKindOfClass:YYFlutterViewContainer.class]) {
        YYFlutterViewContainer *ctr = (YYFlutterViewContainer *)topViewController.topViewController;
        ctr.isForceClose = userInfo[@"isForceClose"];
    }
    [topViewController popViewControllerAnimated:YES];
}

URIRegisterAction(UDBLoginAction5, @[@"flutter_closeflutter"]) {
//    flutterpageidx --;
    NSLog(@"===> flutter_closeflutter flutterpageidx");
    NSNumber *flutterpageidx = userInfo[@"pageidx"];
    UINavigationController *topViewController =  (UINavigationController *)[[UIApplication sharedApplication]delegate].window.rootViewController;
    if (flutterpageidx.intValue == 0) {
//        topViewController.topViewController.fd_interactivePopDisabled = NO;
    }
//    [topViewController popViewControllerAnimated:YES];
}

@end
