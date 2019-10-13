//
//  NativeViewController.m
//  Runner
//
//  Created by boob on 2019/10/10.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//
#import <ATHRouter/ATHRouter.h>
#import "NativeViewController.h"

@interface NativeViewController ()

@end

@implementation NativeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)buttonTap:(id)sender {
    [[ATHURIRouter sharedInstance] openURI:@"native_openflutter" parameters:@{@"uri":@"main"}];
}

- (IBAction)button2Tap:(id)sender {
    [[ATHURIRouter sharedInstance] openURI:@"native_openflutter" parameters:@{@"uri":@"page2"}];
}

@end
