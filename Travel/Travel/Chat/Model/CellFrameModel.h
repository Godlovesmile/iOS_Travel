//
//  CellFrameModel.h
//  WeChat
//
//  Created by Alice on 16/3/21.
//  Copyright © 2016年 Alice. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MessageModel.h"

@interface CellFrameModel : NSObject

@property(nonatomic,strong)MessageModel *message;

@property(nonatomic,assign)CGRect timeFrame;
@property(nonatomic,assign)CGRect iconFrame;
@property(nonatomic,assign)CGRect textFrame;

@property(nonatomic,assign)CGFloat cellHeight;

@end
