//
//  MessageCell.h
//  WeChat
//
//  Created by Alice on 16/3/22.
//  Copyright © 2016年 Alice. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CellFrameModel.h"

@interface MessageCell : UITableViewCell

@property(nonatomic,strong)CellFrameModel *cellFrame;

@property(nonatomic,strong)NSDictionary *friendDic;

@end
