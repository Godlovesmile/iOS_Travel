//
//  MessageCell.m
//  WeChat
//
//  Created by Alice on 16/3/22.
//  Copyright © 2016年 Alice. All rights reserved.
//

#import "MessageCell.h"

#import "UIImage+ResizeImage.h"

#import "XMPPMessage+Tools.h"

#import "UIImage+Scale.h"

@implementation MessageCell {
    
    UILabel *_timeLable;
    UIImageView *_iconView;
    UIButton *_textView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _timeLable = [[UILabel alloc] init];
        _timeLable.textAlignment = NSTextAlignmentCenter;
        _timeLable.textColor = [UIColor grayColor];
        _timeLable.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_timeLable];
        
        _iconView = [[UIImageView alloc] init];
        [self.contentView addSubview:_iconView];
        
        _textView = [UIButton buttonWithType:UIButtonTypeCustom];
        //_textView.enabled = NO;
        _textView.userInteractionEnabled = NO;
        _textView.titleLabel.numberOfLines = 0;
        _textView.titleLabel.font = [UIFont systemFontOfSize:13];
        _textView.contentEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15);
        [self.contentView addSubview:_textView];
    }
    return self;
}

- (void)setCellFrame:(CellFrameModel *)cellFrame {
    
    _cellFrame = cellFrame;
    MessageModel *message = cellFrame.message;
    
    _timeLable.frame = cellFrame.timeFrame;
    _timeLable.text = message.time;
    
    _iconView.frame = cellFrame.iconFrame;
    NSString *iconStr = !message.type ? @"logo" : @"me";
    _iconView.image = [UIImage imageNamed:iconStr];

    _textView.frame = cellFrame.textFrame;
    NSString *textBg = !message.type ? @"chat_recive_nor" : @"chat_send_nor";
    UIColor *textColor = !message.type ? [UIColor redColor] : [UIColor blackColor];
    [_textView setTitleColor:textColor forState:UIControlStateNormal];
    [_textView setBackgroundImage:[UIImage resizeImage:textBg] forState:UIControlStateNormal];

    [_textView setTitle:message.text forState:UIControlStateNormal];
    
    if (message.img != nil) {
        
        [_textView setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [_textView setBackgroundImage:message.img forState:UIControlStateNormal];
    }
    
    if (message.audio != nil) {
        
        [_textView setTitle:message.audio forState:UIControlStateNormal];
    }
}
@end
