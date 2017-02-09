//
//  UIImage+ResizeImage.m
//  WeChat
//
//  Created by Alice on 16/3/22.
//  Copyright © 2016年 Alice. All rights reserved.
//

#import "UIImage+ResizeImage.h"

@implementation UIImage (ResizeImage)

//拉伸图片
+ (UIImage *)resizeImage:(NSString *)imageName {
    
    UIImage *image = [UIImage imageNamed:imageName];
    CGFloat imageW = image.size.width * 0.5;
    CGFloat imageH = image.size.height * 0.5;
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(imageH, imageW, imageH, imageW)
                                 resizingMode:UIImageResizingModeTile];
}

@end
