//
//  AViewController.m
//  Runner
//
//  Created by boob on 2019/10/10.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import "AViewController.h"
#import <ATHRouter/ATHRouter.h>

@interface AViewController ()

@end

@implementation AViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)gotoFlutter:(id)sender { 
    
    [[ATHURIRouter sharedInstance] openURI:@"native_openflutter" parameters:@{@"uri":@"page1"}];
        
}

- (IBAction)button2Tap:(id)sender {
    [[ATHURIRouter sharedInstance] openURI:@"native_openflutter" parameters:@{@"uri":@"page2"}];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
