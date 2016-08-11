//
//  MyNavigationController.m
//  ChangYouChangShou
//
//  Created by Myth on 16/7/1.
//  Copyright © 2016年 Myth. All rights reserved.
//

#import "MyNavigationController.h"
// 判断是否为iOS7
#define iOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

@interface MyNavigationController ()

@end

@implementation MyNavigationController

#pragma mark 一个类只会调用一次
+ (void)initialize {
  // 1.取出设置主题的对象
  UINavigationBar *navBar = [UINavigationBar
      appearanceWhenContainedIn:[MyNavigationController class], nil];

  // 2.设置导航栏的背景图片
  NSString *navBarBg = nil;
  if (iOS7) { // iOS7
    navBarBg = @"NavBar64";
    navBar.tintColor = [UIColor whiteColor];
  } else { // 非iOS7
    navBarBg = @"NavBar";
  }
  //    [navBar setBackgroundImage:[UIImage imageNamed:navBarBg]
  //    forBarMetrics:UIBarMetricsDefault];
  navBar.barTintColor =
      [UIColor colorWithRed:1.000 green:0.243 blue:0.263 alpha:1.000];
  navBar.translucent = NO;

// 3.标题
#ifdef __IPHONE_7_0
  [navBar setTitleTextAttributes:@{
    NSForegroundColorAttributeName : [UIColor whiteColor]
  }];
#else
  [navBar setTitleTextAttributes:@{
    UITextAttributeTextColor : [UIColor whiteColor]
  }];
#endif
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.interactivePopGestureRecognizer.delegate = (id)self; //左侧手势返回
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  NSLog(@"*****");
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
