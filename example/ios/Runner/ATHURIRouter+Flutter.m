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

URIRegisterAction(UDBLoginAction2, @[@"native_openflutter"]) { //OK
    
    NSLog(@"%s",__func__);
    NSDictionary *param = userInfo;
    UINavigationController *topViewController =  (UINavigationController *)[[UIApplication sharedApplication]delegate].window.rootViewController;
    NSString * url = param[@"uri"];
    UIViewController *ctr = [MOSFlutterEngine.sharedInstance createFlutterContainer:url];
    [topViewController pushViewController:ctr animated:YES]; 
}

#pragma mark - 以下为flutter调用的

URIRegisterAction(UDBLoginAction, @[@"flutter_opennative"]) { //OK
    
    NSLog(@"%s",__func__);
    NSDictionary *param = userInfo;
    NSNumber *animatevalue = param[@"animated"];
    NSString *uri = param[@"AViewController"];
    BOOL animate = animatevalue ? animatevalue.boolValue : YES;
    UINavigationController *topViewController =  (UINavigationController *)[[UIApplication sharedApplication]delegate].window.rootViewController;
    [topViewController pushViewController:[AViewController new] animated:animate]; 
    callback(YES, nil, nil);
}

URIRegisterAction(UDBLoginAction3, @[@"flutter_openflutter"]) { //OK
    
    NSLog(@"%s",__func__);
    NSDictionary *param = userInfo;
    UINavigationController *topViewController =  (UINavigationController *)[[UIApplication sharedApplication]delegate].window.rootViewController; 
    NSString *url = param[@"uri"];
    if ([url isEqualToString:@"AViewController"]) {
        [topViewController pushViewController:[AViewController new] animated:YES]; 
        return;
    }
    UIViewController *ctr = [MOSFlutterEngine.sharedInstance createFlutterContainer:param[@"uri"]]; 
    [topViewController pushViewController:ctr animated:YES];
}

URIRegisterAction(UDBLoginAction4, @[@"flutter_closenative"]) { //OK
    
    NSLog(@"%s",__func__);
    UINavigationController *topViewController =  (UINavigationController *)[[UIApplication sharedApplication]delegate].window.rootViewController;
    if ([topViewController.topViewController isKindOfClass:YYFlutterViewContainer.class]) {
        YYFlutterViewContainer *ctr = (YYFlutterViewContainer *)topViewController.topViewController;
        ctr.isForceClose = userInfo[@"isForceClose"];
    }
    [topViewController popViewControllerAnimated:YES];
}
 
@end
