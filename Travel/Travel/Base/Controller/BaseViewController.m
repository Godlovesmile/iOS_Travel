//
//  BaseViewController.m
//  Movie
//
//  Created by ylz on 15/12/26.
//  Copyright © 2015年 ylz. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //给视图添加背景图片
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_main@2x"]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
@end
