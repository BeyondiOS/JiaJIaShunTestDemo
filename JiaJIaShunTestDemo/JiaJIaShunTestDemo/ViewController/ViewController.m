//
//  ViewController.m
//  JiaJIaShunTestDemo
//
//  Created by Myth on 16/8/5.
//  Copyright © 2016年 Myth. All rights reserved.
//

#import "ViewController.h"

#import "AFNetworking.h"
#import "MJExtension.h"
#import "Sorround.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *array;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];

    
  self.tableView = [[UITableView alloc]
      initWithFrame:CGRectMake(0, 200, CGRectGetWidth(self.view.frame),
                               CGRectGetHeight(self.view.frame) - 200)
              style:UITableViewStylePlain];
  self.tableView.backgroundColor = [UIColor whiteColor];
  self.tableView.dataSource = self;
  self.tableView.delegate = self;
  [self.view addSubview:self.tableView];

  NSString *url = @"http://api.steward.jjshome.com/ste/shop/getNearShops?lng=114.105&lat=22.570";
//    NSDictionary *parameters = @{ @"lng": @"113°46", @"lat" :@"22°27" };
    
  AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
  [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
  [manager GET:url
      parameters:nil
      progress:^(NSProgress *_Nonnull downloadProgress) {

      }
      success:^(NSURLSessionDataTask *_Nonnull task,
                id _Nullable responseObject) {
        NSDictionary *dic = (NSDictionary *)responseObject;

        self.array = [Sorround
            mj_objectArrayWithKeyValuesArray:[dic objectForKey:@"data"]];

        [self.tableView reloadData];

      }
      failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        NSLog(@"Error: %@", error);

      }];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  static NSString *CellIdentifier = @"Cell";

  UITableViewCell *cell = (UITableViewCell *)[tableView
      dequeueReusableCellWithIdentifier:CellIdentifier];

  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                  reuseIdentifier:CellIdentifier];
  }

  Sorround *s = self.array[indexPath.row];
  cell.textLabel.text = s.deptName;
  cell.detailTextLabel.text = s.rootDept;

  return cell;
}

@end
