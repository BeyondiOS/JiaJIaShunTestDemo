//
//  ParentViewController.m
//  ChangYouChangShou
//
//  Created by Myth on 16/7/4.
//  Copyright © 2016年 Myth. All rights reserved.
//

#import "ParentViewController.h"

@interface ParentViewController ()

@end

@implementation ParentViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  // ------返回按钮
  UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
  [btnLeft setBackgroundImage:[UIImage imageNamed:@"left_back_button_n"]
                     forState:UIControlStateNormal];
  //        [btnLeft setBackgroundImage:[UIImage imageNamed:@"20"]
  //        forState:UIControlStateHighlighted];
  btnLeft.frame = CGRectMake(0, 0, 35, 35);
  [btnLeft addTarget:self
                action:@selector(barBtnILeftClick:)
      forControlEvents:UIControlEventTouchUpInside];

  UIBarButtonItem *barBtnLeft =
      [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
  [self.navigationItem setLeftBarButtonItem:barBtnLeft animated:YES];
}

- (void)barBtnILeftClick:(UITabBarItem *)tabBarI {
  //  self.navigationController.navigationBarHidden = YES;
  [self.navigationController popViewControllerAnimated:YES];
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
