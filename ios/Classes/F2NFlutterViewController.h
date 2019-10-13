//
//  MOSFlutterViewController.h
//  MosChat
//
//  Created by boob on 2019/1/3.
//  Copyright © 2019年 YY.INC. All rights reserved.
//

#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN
@class F2NFlutterViewController;
@class YYFlutterViewContainer;

@interface MOSFlutterEngine:NSObject 
+ (instancetype)sharedInstance;
- (FlutterEngine *)myEngine;

-(YYFlutterViewContainer *)createFlutterContainer:(NSString *)routeName;

@end

@interface YYFlutterViewContainer : UIViewController 
@property (nonatomic, assign) BOOL isForceClose;
@end

@interface F2NFlutterViewController : FlutterViewController

@end

NS_ASSUME_NONNULL_END
