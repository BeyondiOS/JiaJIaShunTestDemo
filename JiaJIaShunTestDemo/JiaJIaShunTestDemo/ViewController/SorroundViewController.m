//
//  SorroundViewController.m
//  JiaJIaShunTestDemo
//
//  Created by Myth on 16/8/6.
//  Copyright © 2016年 Myth. All rights reserved.
//

#import "SorroundViewController.h"

// ------第三方库
#import "AFNetworking.h"
#import "MJExtension.h"
#import "Masonry.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>

#import "MyBMKPointAnnotation.h"
#import "Sorround.h"
#import "SorroundTableViewCell.h"

@interface SorroundViewController () <UITableViewDelegate,
                                      UITableViewDataSource, BMKMapViewDelegate,
                                      BMKLocationServiceDelegate> {
  IBOutlet BMKMapView *_mapView;
  BMKLocationService *_locService;
  AFHTTPSessionManager *_manager;
  int _lastPosition;
}

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *array;
@property(nonatomic, strong) BMKMapView *mapView;

@end

@implementation SorroundViewController

#pragma mark - **************** viewControl的生命周期
- (void)viewDidLoad {
  [super viewDidLoad];

  self.title = @"周边家家顺";
  self.navigationController.navigationBar.translucent = NO;
  NSLog(@"%@", NSStringFromCGRect(self.view.frame));

  //初始化BMKLocationService
  _locService = [[BMKLocationService alloc] init];
  _locService.delegate = self;
  //启动LocationService
  [_locService startUserLocationService];

  // 初始化BMKMapView
  self.mapView = [BMKMapView new];
  //切换为普通地图
  [self.mapView setMapType:BMKMapTypeStandard];
  //打开百度城市热力图图层（百度自有数据）
  //  [self.mapView setBaiduHeatMapEnabled:YES];
  self.mapView.delegate = self;
  _mapView.showsUserLocation = NO; //先关闭显示的定位图层
  _mapView.userTrackingMode = BMKUserTrackingModeFollow; //设置定位的状态
  _mapView.showsUserLocation = YES;                      //显示定位图层
  CLLocationCoordinate2D center =
      CLLocationCoordinate2DMake(39.924257, 116.403263);
  BMKCoordinateRegion region; //表示范围的结构体
  region.center = center;     //中心点
  region.span.latitudeDelta =
      0.0001; //经度范围（设置为0.1表示显示范围为0.2的纬度范围）
  region.span.longitudeDelta = 0.0001; //纬度范围
  [_mapView setRegion:region animated:YES];
  [self.view addSubview:self.mapView];

  [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
    // 添加左、上边距约束
    make.left.top.mas_equalTo(0);
    // 添加右边距约束
    make.right.mas_equalTo(0);
  }];

  // ------tableView
  //    self.tableView = [[UITableView alloc]
  //        initWithFrame:CGRectMake(0,
  //        CGRectGetHeight(self.view.frame)-64/2-64,
  //        CGRectGetWidth(self.view.frame),
  //                                 CGRectGetHeight(self.view.frame)/2)
  //   style:UITableViewStylePlain];
  self.tableView = [UITableView new];
  self.tableView.backgroundColor = [UIColor whiteColor];
  self.tableView.dataSource = self;
  self.tableView.delegate = self;
  self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  //注册TableView中用于复用的Cell
  [self.tableView registerNib:[UINib nibWithNibName:@"SorroundTableViewCell"
                                             bundle:nil]
       forCellReuseIdentifier:@"SorroundTableViewCell"];
  self.tableView.rowHeight = 85;
  [self.view addSubview:self.tableView];

  [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
    // 添加右、下边距约束
    make.bottom.left.right.mas_equalTo(0);

    make.top.mas_equalTo(self.mapView.mas_bottom).offset(0);

    make.height.mas_equalTo(self.mapView);

    // 添加左边距（左边距 = 父容器纵轴中心 + 偏移量0）
    //    make.left.mas_equalTo(self.view.mas_centerX).offset(0);
  }];

  // ------初始化AFHTTPSessionManager
  _manager = [AFHTTPSessionManager manager];
  //  [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (void)viewWillAppear:(BOOL)animated {
  [_mapView viewWillAppear];
  _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
  _locService.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
  [_mapView viewWillDisappear];
  _mapView.delegate = nil; // 不用时，置nil
  _locService.delegate = nil;
}

// ------设置tableViewcell的分割线从左边0位置开始
- (void)viewDidLayoutSubviews {
  if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
    [_tableView setSeparatorInset:UIEdgeInsetsZero];
  }
  if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
    [_tableView setLayoutMargins:UIEdgeInsetsZero];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - **************** 网络请求
- (void)reloadSorround:(BMKUserLocation *)userLocation {
  // ------请求数据
  NSString *url = [NSString
      stringWithFormat:
          @"http://api.steward.jjshome.com/ste/shop/getNearShops?lng=%f&lat=%f",
          userLocation.location.coordinate.longitude,
          userLocation.location.coordinate.latitude];
  //    NSDictionary *parameters = @{ @"lng": @"113°46", @"lat" :@"22°27" };
  NSLog(@"lng:%f,lat:%f", userLocation.location.coordinate.longitude,
        userLocation.location.coordinate.latitude);

  [_manager GET:url
      parameters:nil
      progress:^(NSProgress *_Nonnull downloadProgress) {

      }
      success:^(NSURLSessionDataTask *_Nonnull task,
                id _Nullable responseObject) {
        NSDictionary *dic = (NSDictionary *)responseObject;

        self.array = [Sorround
            mj_objectArrayWithKeyValuesArray:[dic objectForKey:@"data"]];

        [self.mapView removeAnnotations:self.mapView.annotations];

        unichar ch = 65;
        for (Sorround *sorrund in self.array) {
          sorrund.letter = [NSString stringWithUTF8String:(char *)&ch];
          ch++;

          // 添加一个PointAnnotation
          MyBMKPointAnnotation *annotation =
              [[MyBMKPointAnnotation alloc] init];
          CLLocationCoordinate2D coor;
          coor.latitude = [sorrund.lat doubleValue];
          coor.longitude = [sorrund.lng doubleValue];
          annotation.coordinate = coor;
          annotation.title = sorrund.deptName;
          annotation.pinText = sorrund.letter;
          [_mapView addAnnotation:annotation];
        }
        [self.tableView reloadData];

      }
      failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        NSLog(@"Error: %@", error);
      }];
}

#pragma mark - **************** BMKLocationServiceDelegate
//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation {
  //    NSLog(@"heading is %@",userLocation.heading);
  [self.mapView updateLocationData:userLocation];
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
  //    NSLog(@"didUpdateUserLocation lat %f,long
  //    %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
  [self.mapView updateLocationData:userLocation];
  [self reloadSorround:userLocation];
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error {
  NSLog(@"location error");
}

#pragma mark - **************** BMKMapViewDelegate
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView
             viewForAnnotation:(id<BMKAnnotation>)annotation {
  if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
    BMKPinAnnotationView *newAnnotationView =
        [[BMKPinAnnotationView alloc] initWithAnnotation:annotation
                                         reuseIdentifier:@"myAnnotation"];
    newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    //      v.backgroundColor=[UIColor redColor];
    UIImageView *image = [[UIImageView alloc] initWithFrame:v.bounds];
    image.image = [UIImage imageNamed:@"ic_store_mark_default"];
    [v addSubview:image];

    UILabel *label = [[UILabel alloc] initWithFrame:v.bounds];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = ((MyBMKPointAnnotation *)annotation).pinText;
    [v addSubview:label];

    [newAnnotationView addSubview:v];
    //    newAnnotationView.image =
    //        [UIImage imageNamed:@"ic_store_mark_default"];
    //        //把大头针换成别的图片

    //    newAnnotationView.animatesDrop = YES; // 设置该标注点动画显示
    return newAnnotationView;
  }
  return nil;
}

#pragma mark - **************** UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  static NSString *identifier = @"SorroundTableViewCell";

  SorroundTableViewCell *cell = (SorroundTableViewCell *)[tableView
      dequeueReusableCellWithIdentifier:identifier
                           forIndexPath:indexPath];

  cell.model = self.array[indexPath.row];
  //  Sorround *s = self.array[indexPath.row];
  //  cell.textLabel.text = s.deptName;
  //  cell.detailTextLabel.text = s.rootDept;

  return cell;
}

- (void)tableView:(UITableView *)tableView
      willDisplayCell:(UITableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath {

  // ------设置tableViewcell的分割线从左边0位置开始
  if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
    [cell setLayoutMargins:UIEdgeInsetsZero];
  }
  if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
    [cell setSeparatorInset:UIEdgeInsetsZero];
  }
}

#pragma mark - ****************scrollView
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
  _lastPosition = scrollView.contentOffset.y;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
  if (_lastPosition < scrollView.contentOffset.y) {
    NSLog(@"向上滚动");

    [self.mapView mas_remakeConstraints:^(MASConstraintMaker *make) {
      // 添加左、上边距约束
      make.left.top.right.mas_equalTo(0);
    }];

    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
      // 添加右、下边距约束
      make.bottom.left.right.mas_equalTo(0);

      make.top.mas_equalTo(self.mapView.mas_bottom).offset(0);

      make.height.mas_equalTo(self.mapView);
    }];

    // 更新约束
    [UIView animateWithDuration:0.7
                     animations:^{
                       [self.view layoutIfNeeded];
                     }];
  } else {
    NSLog(@"向下滚动");

    [self.mapView mas_updateConstraints:^(MASConstraintMaker *make) {
      //        make.height.mas_equalTo(CGRectGetHeight(self.view.frame) -
      //                                                  self.tableView.rowHeight);
      make.bottom.mas_equalTo(-self.tableView.rowHeight);
    }];

    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
      make.top.mas_equalTo(CGRectGetMaxY(self.mapView.frame) +
                           CGRectGetHeight(self.mapView.frame) -
                           self.tableView.rowHeight);
      make.height.mas_equalTo(self.tableView.rowHeight);
    }];

    // 更新约束
    [UIView animateWithDuration:0.7
                     animations:^{
                       [self.view layoutIfNeeded];
                     }];
  }
}

// offset发生改变
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
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
