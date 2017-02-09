//
//  RootTabBarController.m
//  Movie
//
//  Created by ylz on 15/12/26.
//  Copyright © 2015年 ylz. All rights reserved.
//

#import "RootTabBarController.h"

#import "ShareViewController.h"

#import "BaseNavigationController.h"

@interface RootTabBarController ()

@property(nonatomic,strong)UIImageView *selectItem;  //设置选中的图片
@property(nonatomic,strong)UIControl *selectedButton; //选中的按钮

@end

@implementation RootTabBarController

//+ (void)initialize {
//    
//    //获取所有的tabBarItem外观标识
//    UITabBarItem *item = [UITabBarItem appearance];
//    NSDictionary *dic = @{
//                          NSForegroundColorAttributeName : [UIColor orangeColor]
//                          };
//    [item setTitleTextAttributes:dic forState:UIControlStateSelected];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建tabBar所管理的视图控制器
    [self createCtrls];
    
    //自定义UITabBar
    [self createTabBar];
    
    //接受通知隐藏状态栏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenTabBarAction) name:@"hiddenTabBar" object:nil];
    
    //接受通知显示底部状态栏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTabBarAction) name:@"showTabBar" object:nil];


}

//隐藏tabbar事件
- (void)hiddenTabBarAction {
    
    self.tabBar.hidden = YES;
}

//显示tabbar事件
- (void)showTabBarAction {
    
    self.tabBar.hidden = NO;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //移除系统tabBar自带的item
    [self removeUITabBarButton];
    
    
}

//创建子控制器
- (void)createCtrls
{
    //通过storyboard加载视图控制器
    UIViewController *homeCtrl = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateInitialViewController];
    UIViewController *newsCtrl = [[ShareViewController alloc] init];
    BaseNavigationController *navigationCtrl = [[BaseNavigationController alloc] initWithRootViewController:newsCtrl];
    UIViewController *topCtrl = [[UIStoryboard storyboardWithName:@"Chat" bundle:nil] instantiateInitialViewController];
    UIViewController *cinemaCtrl = [[UIStoryboard storyboardWithName:@"Profile" bundle:nil] instantiateInitialViewController];
    
    //将视图控制器交由tabBar管理
    self.viewControllers = @[homeCtrl,navigationCtrl,topCtrl,cinemaCtrl];
}

//创建自定义tabbar
- (void)createTabBar
{
    //设置tabbar的背景颜色
    //self.tabBar.backgroundImage = [UIImage imageNamed:@"bg_tab_bar_shadow@2x"];
    
    //设置tabbar上面子控件
    //图片
    NSArray *imageArr = @[@"dd_home_tab1@2x",@"dd_home_tab2@2x",@"dd_home_tab3@2x",@"dd_home_tab4@2x"];
    NSArray *selectedImageArr = @[@"dd_home_tab1_selected@2x",@"dd_home_tab2_selected@2x",@"dd_home_tab3_selected@2x",@"dd_home_tab4_selected@2x"];
    //标题
    NSArray *nameArr = @[@"首页",@"分享",@"交流",@"我"];
    CGFloat itemWidth = [UIScreen mainScreen].bounds.size.width/4;
    
//    //选中的样式
//    self.selectItem = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selectTabbar_bg_all1@2x"]];
//    self.selectItem.frame = CGRectMake(0, 0, itemWidth-20, 49);
//    [self.tabBar addSubview:self.selectItem];

    
    for(int i = 0;i < imageArr.count;i++)
    {
        NSString *imageStr = imageArr[i];
        NSString *selectedImageStr = selectedImageArr[i];
        NSString *nameStr = nameArr[i];
        
        UIControl *itemControl = [[UIControl alloc] initWithFrame:CGRectMake(itemWidth*i, 0, itemWidth, 49)];
        itemControl.tag = i + 100;
        [itemControl addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabBar addSubview:itemControl];
        
        //图片,标题
        UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        imageBtn.frame = CGRectMake((itemWidth-20)/2, 8, 20, 20);
        [imageBtn setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
        [imageBtn setImage:[UIImage imageNamed:selectedImageStr] forState:UIControlStateSelected];
        imageBtn.userInteractionEnabled = NO;
        imageBtn.tag = 200;
        [itemControl addSubview:imageBtn];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 49-20, itemWidth, 20)];
        label.text = nameStr;
        label.textColor = [UIColor blackColor];
        label.tag = 300;
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        [itemControl addSubview:label];
        
        if (i == 0) {
            imageBtn.selected = YES;
            label.textColor = [UIColor colorWithRed:88/255.0 green:148/255.0 blue:66/255.0 alpha:1];
            _selectedButton = itemControl;
        }
    }
}

//子控件点击事件
- (void)clickItem:(UIControl *)control
{
    UIButton *btn0 = (UIButton *)[control viewWithTag:200];
    UIButton *btn1 = (UIButton *)[_selectedButton viewWithTag:200];
    UILabel *label0 = (UILabel *)[control viewWithTag:300];
    UILabel *label1 = (UILabel *)[_selectedButton viewWithTag:300];
    //切换按钮,把之前的按钮不选中,选中当前点击的按钮
    if (_selectedButton != control) {
        btn1.selected = NO;
        btn0.selected = YES;
        label1.textColor = [UIColor blackColor];
        label0.textColor = [UIColor colorWithRed:88/255.0 green:148/255.0 blue:66/255.0 alpha:1];
        _selectedButton = control;
    }
    self.selectedIndex = control.tag - 100;
}

//移除系统tabBar自带的item
- (void)removeUITabBarButton
{
    for(UIView *view in self.tabBar.subviews)
    {
        //NSLog(@"%@",view);
        //移除系统tabBar上的控件UITabBarButton类型
        
        if ([view isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [view removeFromSuperview];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
@end
