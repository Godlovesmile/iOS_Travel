//
//  BaseNavigationController.m
//  Movie
//
//  Created by ylz on 15/12/26.
//  Copyright © 2015年 ylz. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏的背景颜色
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg_all-64@2x"] forBarMetrics:UIBarMetricsDefault];
    
    //设置标题文字的属性
    /*富文本*/
    NSDictionary *titleDic = @{
                               NSFontAttributeName : [UIFont boldSystemFontOfSize:20],
                               NSForegroundColorAttributeName : [UIColor whiteColor]
                               };
    [self.navigationBar setTitleTextAttributes:titleDic];
    
    //设置导航栏按钮的颜色
    self.navigationBar.tintColor = [UIColor orangeColor];

}

//设置 UIStatusBar的首选样式
- (UIStatusBarStyle)preferredStatusBarStyle {
    //return UIStatusBarStyleLightContent;   //黑底白字
    return UIStatusBarStyleDefault;          //白底黑字
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
@end
