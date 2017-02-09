//
//  SearchCell.m
//  Travel
//
//  Created by Alice on 16/5/13.
//  Copyright © 2016年 Alice. All rights reserved.
//

#import "SearchCell.h"

@implementation SearchCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat width = self.frame.size.width;
        CGFloat height = self.frame.size.height;
        
        self.itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        self.itemLabel.font = [UIFont systemFontOfSize:16];
        self.itemLabel.backgroundColor = [UIColor clearColor];
        self.itemLabel.textColor = [UIColor blackColor];
        self.itemLabel.textAlignment = NSTextAlignmentCenter;
        [self getCicleLabel:self.itemLabel];
        [self.contentView addSubview:self.itemLabel];
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)getCicleLabel:(UILabel *)label {
    
    label.layer.masksToBounds = YES;
    label.layer.borderColor = [UIColor whiteColor].CGColor;
    label.layer.borderWidth = 2;
    label.layer.cornerRadius = self.itemLabel.frame.size.height / 2;
}

@end
