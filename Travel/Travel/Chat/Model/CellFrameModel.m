//
//  CellFrameModel.m
//  WeChat
//
//  Created by Alice on 16/3/21.
//  Copyright © 2016年 Alice. All rights reserved.
//

#import "CellFrameModel.h"

#import "NSString+Extension.h"

#define timeH 40
#define padding 10
#define iconW 40
#define iconH 40
#define textW 150

@implementation CellFrameModel

//重写set方法
- (void)setMessage:(MessageModel *)message {
    
    _message = message;
    CGRect frame = [UIScreen mainScreen].bounds;
    
    //1.时间的frame
    if (message.showTime) {
        CGFloat timeFrameX = 0;
        CGFloat timeFrameY = 0;
        CGFloat timeFrameW = frame.size.width;
        CGFloat timeFrameH = timeH;
        _timeFrame = CGRectMake(timeFrameX, timeFrameY, timeFrameW, timeFrameH);
    }
    
    //2.头像的frame
    CGFloat iconFrameX = !message.type ? padding : (frame.size.width - padding - iconW);
    CGFloat iconFrameY = CGRectGetMaxY(_timeFrame);
    CGFloat iconFrameW = iconW;
    CGFloat iconFrameH = iconH;
    _iconFrame = CGRectMake(iconFrameX, iconFrameY, iconFrameW, iconFrameH);
    
    //3.针对不同的内容,设置内容的frame
    //文本
    if (message.text) {
        
        CGSize textMaxSize = CGSizeMake(textW, MAXFLOAT);
        CGSize textSize = [message.text sizeWithFont:[UIFont systemFontOfSize:14.0]
                                             maxSzie:textMaxSize];
        CGSize textRealSize = CGSizeMake(textSize.width + 15 * 2, textSize.height + 15 * 2);
        CGFloat textFrameY = iconFrameY;
        CGFloat textFrameX = !message.type ? (2 * padding + iconFrameW) : (frame.size.width - (padding * 2 + iconW + textRealSize.width));
        _textFrame = (CGRect){textFrameX,textFrameY,textRealSize};
        
        //4.cell的高度
        _cellHeight = MAX(CGRectGetMaxY(_iconFrame), CGRectGetMaxY(_textFrame) + padding);
    }
    
    //图片
    if (message.img) {
        
        CGSize textMaxSize = CGSizeMake(textW, MAXFLOAT);
        NSString *text = @"esdfghjdxcgvbhnjkfcgvhbsdfcgvhbxcgvhbxcgvbhxcfgvdxfcgvfcgvhbxfcgyvxcdxfgvhdxfcgvdxfgvxdfcgvhbjxfcgvhbjnkfcgvhbjnkmxcvbjnkmxrctybntxcvbjn";
        CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:14.0]
                                             maxSzie:textMaxSize];
        CGSize textRealSize = CGSizeMake(textSize.width + 15 * 2, textSize.height + 15 * 2);
        CGFloat textFrameY = iconFrameY;
        CGFloat textFrameX = !message.type ? (2 * padding + iconFrameW) : (frame.size.width - (padding * 2 + iconW + textRealSize.width));
        _textFrame = (CGRect){textFrameX,textFrameY,textRealSize};
        
        //4.cell的高度
        _cellHeight = MAX(CGRectGetMaxY(_iconFrame), CGRectGetMaxY(_textFrame) + padding);

    }
    
    //音频
    if (message.audio) {
        
        NSLog(@"我在这儿!");
        NSLog(@"message.audio = %@",message.audio);
        NSLog(@"message.type = %d",message.type);
        
        CGSize textMaxSize = CGSizeMake(textW, MAXFLOAT);
        CGSize textSize = [message.audio sizeWithFont:[UIFont systemFontOfSize:14.0]
                                             maxSzie:textMaxSize];
        CGSize textRealSize = CGSizeMake(textSize.width + 15 * 2, textSize.height + 15 * 2);
        CGFloat textFrameY = iconFrameY;
        CGFloat textFrameX = !message.type ? (2 * padding + iconFrameW) : (frame.size.width - (padding * 2 + iconW + textRealSize.width));
        _textFrame = (CGRect){textFrameX,textFrameY,textRealSize};
        
        //4.cell的高度
        _cellHeight = MAX(CGRectGetMaxY(_iconFrame), CGRectGetMaxY(_textFrame) + padding);
    }
}
@end
