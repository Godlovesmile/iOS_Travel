//
//  MapViewController.m
//  Travel
//  BGwxhl123@
//  Created by Alice on 16/4/27.
//  Copyright © 2016年 Alice. All rights reserved.
//

#import "MapViewController.h"

#import <MapKit/MapKit.h>

#import <CoreLocation/CoreLocation.h>

@interface MapViewController ()<CLLocationManagerDelegate,MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *label;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;   //地图

@property (weak, nonatomic) IBOutlet UILabel *textLabel;   //具体位置

@property(nonatomic,strong)CLLocationManager *manager;     //定位

@end

@implementation MapViewController

- (void)viewDidLoad {
    
    /*
     39.9206315476,116.1830857695
     */
    
    [super viewDidLoad];
    
    //–––––––––––––––––––––––定位–––––––––––––––––––––––––––
    //创建manager
    _manager = [[CLLocationManager alloc] init];
    //设置代理
    _manager.delegate = self;
    //设置精度
    _manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    
    //如果iOS8以后需要授权
    //if ([[UIDevice currentDevice].systemVersion floatValue] > 8.0) {
    //[_manager requestWhenInUseAuthorization];
    //}
    // 通过检查是否存在这个方法就可以判断是ios7还是ios8
//    if ([self.manager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
//        [self.manager requestAlwaysAuthorization];
//    }
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
        [self.manager requestWhenInUseAuthorization];
    }else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse){
        //设置代理
        self.manager.delegate=self;
        //设置定位精度
        self.manager.desiredAccuracy=kCLLocationAccuracyBest;
        //定位频率,每隔多少米定位一次
        CLLocationDistance distance=10.0;//十米定位一次
        self.manager.distanceFilter=distance;
        //启动跟踪定位
        [self.manager startUpdatingLocation];
    }
    //开始定位
    [_manager startUpdatingLocation];

    
    //–––––––––––––––––––––地图––––––––––––––––––––––––
    //显示当前用户所在的位置
    _mapView.showsUserLocation = YES;
    //设置地图的样式
    /*
     MKMapTypeStandard  标准地图
     MKMapTypeSatellite 卫星地图
     MKMapTypeHybrid   混合地图
     */
    _mapView.mapType = MKMapTypeStandard;
    _mapView.delegate = self;

    
    //返回按钮
    //创建返回的按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"leftArrow@2x.jpg"] forState:UIControlStateNormal];
    //[backBtn sizeToFit];
    backBtn.frame = CGRectMake(0, 15, 50, 50);
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    //[self.view insertSubview:backBtn atIndex:0];
    [self.view addSubview:backBtn];
}

//按钮点击事件
- (void)backAction:(UIBarButtonItem *)button {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - CLLocationManagerDelegate
//实时定位
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    
    //关闭定位
    [manager stopUpdatingLocation];
    
    //获取经纬度
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    
    CLLocationDegrees longitude = coordinate.longitude;
    CLLocationDegrees latitude = coordinate.latitude;
    
    //将浮点型的经纬度转换成字符串
    NSString *longStr = [NSString stringWithFormat:@"%f",longitude];
    NSString *latitudeStr = [NSString stringWithFormat:@"%f",latitude];
    NSLog(@"longStr = %@ latitudeStr = %@",longStr,latitudeStr);
    //加载数据
    //[self loadDataWithLongitude:longStr withLatitude:latitudeStr];
    
    //设置地图的显示区域
    CLLocationCoordinate2D center = coordinate;
    //数值越小，放大的倍数越大
    MKCoordinateSpan span = {0.1,0.1};
    MKCoordinateRegion region = {center,span};
    [_mapView setRegion:region animated:YES];
}

#pragma mark - MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    // 反地理编码；根据经纬度查找地名
    [geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count == 0 || error) {
            NSLog(@"找不到该位置");
            return;
        }
        
        // 当前地标
        CLPlacemark *pm = [placemarks firstObject];
        
        // 区域名称
        userLocation.title = pm.locality;
        // 详细名称
        userLocation.subtitle = pm.name;
        NSLog(@"%@  %@",pm.locality,pm.name);
        
        NSString *str = [NSString stringWithFormat:@"%@ %@",pm.locality,pm.name];
        self.label.text = str;
    
    }];
}
@end
