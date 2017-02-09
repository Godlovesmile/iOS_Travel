//
//  NewFeatureCell.m
//  微博
//
//  Created by mac527 on 15/10/20.
//  Copyright © 2015年 mac527. All rights reserved.
//

#import "NewFeatureCell.h"

#import "RootTabBarController.h"

#import "TravelTool.h"

@interface NewFeatureCell()

@property(nonatomic,weak)UIImageView *imageView;

@property(nonatomic,weak)UIButton *shareButton;

@property(nonatomic,weak)UIButton *startButton;

@end

@implementation NewFeatureCell

- (UIButton *)startButton
{
    if (_startButton == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"开始我们的旅行" forState:UIControlStateNormal];
        //[btn setImage:[UIImage imageNamed:@"new_feature_finish_button"] forState:UIControlStateNormal];
        //[btn setImage:[UIImage imageNamed:@"new_feature_finish_button_highlighted"] forState:UIControlStateHighlighted];
        [btn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button_highlighted"] forState:UIControlStateHighlighted];
        [btn sizeToFit];
        [btn addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        _startButton = btn;
    }
    return _startButton;
}
//点击开始微博按钮事件
- (void)start
{
//    RootTabBarController *tabBar = [[RootTabBarController alloc] init];
    //切换视图控制器
//    KeyWindow.rootViewController = tabBar;
    
    [[[TravelTool alloc] init] setupLogin];
}

- (UIButton *)shareButton
{
    if (_shareButton == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"分享微博" forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"new_feature_share_false"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"new_feature_share_true"] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        [btn sizeToFit];
        [btn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        _shareButton = btn;
    }
    return _shareButton;
}

//点击分享按钮事件
- (void)share
{
    
}

- (UIImageView *)imageView
{
    if (_imageView == nil) {
        UIImageView *imgView = [[UIImageView alloc] init];
        //注意:一定要加载contentView
        [self.contentView addSubview:imgView];
         _imageView = imgView;
    }
    return _imageView;
}

//布局子控件的frame
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
    
    //分享按钮
    self.shareButton.center = CGPointMake(kScreenWidth/2, self.height*0.8);
    
    //开始按钮
    self.startButton.center = CGPointMake(kScreenWidth/2, self.height*0.9);
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    self.imageView.image = image;
}

//判断是否是最后一页
- (void)setIndexPath:(NSIndexPath *)indexPath Count:(int)count
{
    if (indexPath.row == count-1) {
        self.shareButton.hidden = NO;
        self.startButton.hidden = NO;
    }else{
        self.shareButton.hidden = YES;
        self.startButton.hidden = YES;
    }
    
}

@end
