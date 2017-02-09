//
//  TravelTool.h
//  Travel
//
//  Created by Alice on 16/4/6.
//  Copyright © 2016年 Alice. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AppDelegate.h"

//@class ICETutorialController;

@interface TravelTool : NSObject

//@property (strong, nonatomic) ICETutorialController *viewController;

//选择根控制器
+ (void)chooseRootController;

//创建登录界面
- (void)setupLogin;

@end
