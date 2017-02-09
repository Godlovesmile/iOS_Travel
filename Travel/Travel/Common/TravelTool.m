//
//  TravelTool.m
//  Travel
//
//  Created by Alice on 16/4/6.
//  Copyright © 2016年 Alice. All rights reserved.
//

#import "TravelTool.h"

#import "RootTabBarController.h"

#import "NewFeatureControllerCollectionViewController.h"

#import "ICETutorialController.h"

@implementation TravelTool

//选择根控制器
+ (void)chooseRootController {
    
    NSString *key = @"CFBundleVersion";
    // 取出沙盒中存储的上次使用软件的版本号
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastVersion = [defaults stringForKey:@"ylz"];
    
    // NSLog(@"%@",[UIApplication sharedApplication].keyWindow);
    
    //获取当前软件的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    if ([currentVersion isEqualToString:lastVersion]) {
        //显示状态栏
//        [UIApplication sharedApplication].statusBarHidden = NO;
//        [UIApplication sharedApplication].keyWindow.rootViewController = [[RootTabBarController alloc] init];
        
        [[[TravelTool alloc] init] setupLogin];

    }else{
        
        [UIApplication sharedApplication].keyWindow.rootViewController = [[NewFeatureControllerCollectionViewController alloc] init];
        //存储新版本
        [defaults setObject:currentVersion forKey:@"ylz"];
        [defaults synchronize];
    }
}

//创建登录界面
- (void)setupLogin {
    
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    
    //登录界面
    ICETutorialPage *layer1 = [[ICETutorialPage alloc] initWithSubTitle:nil
                                                            description:nil
                                                            pictureName:@"tutorial_background_00@2x.jpg"];
    ICETutorialPage *layer2 = [[ICETutorialPage alloc] initWithSubTitle:nil
                                                            description:nil
                                                            pictureName:@"tutorial_background_01@2x.jpg"];
    ICETutorialPage *layer3 = [[ICETutorialPage alloc] initWithSubTitle:nil
                                                            description:nil
                                                            pictureName:@"tutorial_background_02@2x.jpg"];
    ICETutorialPage *layer4 = [[ICETutorialPage alloc] initWithSubTitle:nil
                                                            description:nil
                                                            pictureName:@"tutorial_background_03@2x.jpg"];
    ICETutorialPage *layer5 = [[ICETutorialPage alloc] initWithSubTitle:nil
                                                            description:nil
                                                            pictureName:@"tutorial_background_04@2x.jpg"];
    ICETutorialLabelStyle *subStyle = [[ICETutorialLabelStyle alloc] init];
    [subStyle setFont:TUTORIAL_SUB_TITLE_FONT];
    [subStyle setTextColor:TUTORIAL_LABEL_TEXT_COLOR];
    [subStyle setLinesNumber:TUTORIAL_SUB_TITLE_LINES_NUMBER];
    [subStyle setOffset:TUTORIAL_SUB_TITLE_OFFSET];
    
    ICETutorialLabelStyle *descStyle = [[ICETutorialLabelStyle alloc] init];
    [descStyle setFont:TUTORIAL_DESC_FONT];
    [descStyle setTextColor:TUTORIAL_LABEL_TEXT_COLOR];
    [descStyle setLinesNumber:TUTORIAL_DESC_LINES_NUMBER];
    [descStyle setOffset:TUTORIAL_DESC_OFFSET];
    
    // Load into an array.
    NSArray *tutorialLayers = @[layer1,layer2,layer3,layer4,layer5];
    
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        delegate.viewController = [[ICETutorialController alloc] initWithNibName:@"ICETutorialController_iPhone"
                                                                          bundle:nil
                                                                        andPages:tutorialLayers];
    } else {
        delegate.viewController = [[ICETutorialController alloc] initWithNibName:@"ICETutorialController_iPad"
                                                                          bundle:nil
                                                                        andPages:tutorialLayers];
    }
    
    // Set the common styles, and start scrolling (auto scroll, and looping enabled by default)
    [delegate.viewController setCommonPageSubTitleStyle:subStyle];
    [delegate.viewController setCommonPageDescriptionStyle:descStyle];
    
    // Set button 1 action.
    [delegate.viewController setButton1Block:^(UIButton *button){
        //NSLog(@"Button 1 pressed.");
        //显示状态栏
//        [UIView animateWithDuration:10 animations:^{
//            
//            [UIApplication sharedApplication].statusBarHidden = NO;
//            [UIApplication sharedApplication].keyWindow.rootViewController = [[RootTabBarController alloc] init];
//            
//        } completion:nil];
        
        

    }];
    
    // Set button 2 action, stop the scrolling.
    __weak AppDelegate *weakSelf = delegate;
    [weakSelf.viewController setButton2Block:^(UIButton *button){
        NSLog(@"Button 2 pressed.");
        //NSLog(@"Auto-scrolling stopped.");
        
        [weakSelf.viewController stopScrolling];
    }];
    
    // Run it.
    [delegate.viewController startScrolling];
    
    [UIApplication sharedApplication].keyWindow.rootViewController = delegate.viewController;
}
@end
