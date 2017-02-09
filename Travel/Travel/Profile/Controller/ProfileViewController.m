//
//  ProfileViewController.m
//  Travel
//
//  Created by Alice on 16/2/27.
//  Copyright © 2016年 Alice. All rights reserved.
//

#import "ProfileViewController.h"

#import "TravelTool.h"

#define headerViewHeight 200  //头视图图片的高度

@interface ProfileViewController ()<UITableViewDataSource,UITableViewDelegate> {
    
    UIImageView *_headerImageView;  //头视图图片
    
    NSArray *imageArr;
    
    NSArray *textArr;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)UILabel *label;  //显示缓存的文本

@end

@implementation ProfileViewController

//懒加载
- (UILabel *)label {
    
    if (_label == nil) {
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 100, 25, 100, 20)];
    }
    return _label;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self readCacheSize];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //  去除多余单元格的线条
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //保存图片的数组
    imageArr = @[@"friendsRecommentIcon-click",@"mine-setting-icon-click",@"MainTagSubIconClick",@"",@"mine_icon_nearby"];
    
    //保存文字的数组
    textArr = @[@"我",@"注销",@"清理缓存",@"",@"定位"];
    
    [self createUI];
}

//2.创建UI
- (void)createUI {
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    //注册NewsCell.xib文件

    //self.navigationController.navigationBar.translucent = NO;
    
    //–––––––––––––––––––––––––––––头视图缩放效果–––––-–––––––––––––––––––
    //方式一
    /*
     步步演示:1>.首先思路将图片直接添加到tableview的头视图上(发现下拉时,头部y改变)
     2>.在tableView上面加上一个UIView,发现不行(uiview无法下拉,uiview与tableview拉动不匹配)
     解决思路:在tableView的头视图,添加一个透明视图,在透明视图下面放上可以改变的头视图图片(通过拉动tableView时改变头视图图片的frame)
     
     */
    _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, headerViewHeight)];
    _headerImageView.image = [UIImage imageNamed:@"profile"];
    [self.view insertSubview:_headerImageView belowSubview:_tableView];
    
    
    //关键步骤
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, headerViewHeight)];
    view.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = view;
    
    //添加个文字
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 140, 150, 30)];
    //imageView.backgroundColor = [UIColor redColor];
    imageView.image = [UIImage imageNamed:@"app_slogan"];
    [view addSubview:imageView];
    
    //方式二
    //直接将tableView第一个cell作为透视图,可以进行同样处理
}

#pragma mark UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return imageArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    //缓存大小,显示在文本
    if (indexPath.row == 2) {
        
        self.label.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:self.label];
        
    }
    
    cell.imageView.image = [UIImage imageNamed:imageArr[indexPath.row]];
    
    cell.textLabel.text = textArr[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //选中注销的单元格
    if (indexPath.row == 1) {
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"注销"
                                                                       message:@"尼确定要删除?"
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                           
                                                                  //注销
                                                                  [[XMPPManager shareManager] logoutAction:^{
                                                                   
                                                                      [TravelTool chooseRootController];
                                                                  }];
                                                                  
                                                              }];
        
        UIAlertAction* defaultAction0 = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action) {
                                                                   
                                                                   //点击NO之后调用的方法
                                                                   
                                                               }];
        
        
        [alert addAction:defaultAction];
        [alert addAction:defaultAction0];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    if (indexPath.row == 2) {
        //弹出警告界面是否要删除
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"清除缓存"
                                                                       message:@"尼确定要删除"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  
                                                                  //点击OK之后调用的方法
                                                                  //清除缓存
                                                                  [[SDImageCache sharedImageCache] clearDisk];
                                                                  self.label.text = @"";
                                                                  
                                                              }];
        
        //NSLog(@"label = %@",_label);
        
        UIAlertAction* defaultAction0 = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action) {
                                                                   
                                                                   //点击OK之后调用的方法
                                                                   
                                                               }];
        
        
        [alert addAction:defaultAction];
        [alert addAction:defaultAction0];
        [self presentViewController:alert animated:YES completion:nil];
    }

    if (indexPath.row == 4) {
        
        UIViewController *viewCtrl = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
        //viewCtrl.hidesBottomBarWhenPushed = YES;
        [self presentViewController:viewCtrl animated:YES completion:nil];
        
    }
}

#pragma mark 滚动视图滚动实时调用的方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //NSLog(@"contenOffset = %f",scrollView.contentOffset.y);
    CGFloat y = scrollView.contentOffset.y;
    if(y >= 0) {   //往上滚动
        _headerImageView.frame = CGRectMake(0, -y, kScreenWidth, headerViewHeight);
        
    }else {   //往下滚动
        
        //改变_headerImageView的frame实现,放大缩小的效果;通过改变transform无法实现
        //通过_headerImageView高度的改变计算宽度(等比计算)
        /*
         kScreenWidth  200
         改变后的宽度x    200-y
         */
        CGFloat newWidth = kScreenWidth * (headerViewHeight - y) / headerViewHeight;
        _headerImageView.frame = CGRectMake( (kScreenWidth - newWidth) / 2, 0,newWidth, headerViewHeight-y);
    }
}

#pragma mark - 帮助方法
//计算缓存的大小
- (void)readCacheSize {
    
    //使用第三方框架能够直接计算
    CGFloat fileSize = [[SDImageCache sharedImageCache] getSize];
    _label.text = [NSString stringWithFormat:@"%.2f MB", fileSize / 1024 / 1024.0];
}

@end
