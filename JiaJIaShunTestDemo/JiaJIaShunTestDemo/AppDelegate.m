//
//  AppDelegate.m
//  JiaJIaShunTestDemo
//
//  Created by Myth on 16/8/5.
//  Copyright © 2016年 Myth. All rights reserved.
//

#import "AppDelegate.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>

@interface AppDelegate (){
    BMKMapManager* _mapManager;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

  //    // 1.创建队列
  //    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
  //
  //    // 2.添加操作到队列中
  //    [queue addOperationWithBlock:^{
  //        NSLog(@"download1 --- %@", [NSThread currentThread]);
  //    }];
  //    [queue addOperationWithBlock:^{
  //        NSLog(@"download2 --- %@", [NSThread currentThread]);
  //    }];

  __block NSInteger i = 0;
  for (int j = 0; j < 15; j++) {
    dispatch_async(
        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
          i = i + 3;
        });

    dispatch_async(
        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
          i = i - 1;
        });
  }
  NSLog(@"i=%ld", i);

    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"yzYHubvYsmxfGlS49htLWIG8GuSvlPEK"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
  //设置状态栏颜色
  [[UIApplication sharedApplication]
      setStatusBarStyle:UIStatusBarStyleLightContent];

  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state.
  // This can occur for certain types of temporary interruptions (such as an
  // incoming phone call or SMS message) or when the user quits the application
  // and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down
  // OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate
  // timers, and store enough application state information to restore your
  // application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called
  // instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state;
  // here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the
  // application was inactive. If the application was previously in the
  // background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if
  // appropriate. See also applicationDidEnterBackground:.
}

@end
