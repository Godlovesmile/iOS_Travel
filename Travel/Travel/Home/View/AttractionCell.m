//
//  AttractionCell.m
//  TravelApp
//
//  Created by SZT on 15/12/24.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import "AttractionCell.h"
//#import "MainScreenBound.h"

#define knameLabelW  kScreenWidth
#define knameLabelH  30
#define knameLabelX   0
#define knameLabelY  30

#define kRecommandW   kScreenHeight
#define kRecommandH   40
#define kRecommandX   0
#define kRecommandY   knameLabelY+knameLabelH+20

@implementation AttractionCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(knameLabelX, knameLabelY, knameLabelW, knameLabelH)];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.nameLabel];
        
        self.recommandLabel = [[UILabel alloc]initWithFrame:CGRectMake(kRecommandX, kRecommandY, kRecommandW, kRecommandH)];
        //self.recommandLabel.textAlignment = NSTextAlignmentCenter;
        //Font *font = [Font shareWithFont];
        //self.recommandLabel.font = [UIFont fontWithName:font.fontName size:12];
        [self.contentView addSubview:self.recommandLabel];
    }
    return self;
}
@end
