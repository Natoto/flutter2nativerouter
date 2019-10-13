#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
  BOOL res = [super application:application didFinishLaunchingWithOptions:launchOptions];
  
  UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
  [button setTitle:@"push native" forState:UIControlStateNormal];
  button.center = self.window.center;
  [self.window addSubview:button];    
   
  return res;
}

@end
