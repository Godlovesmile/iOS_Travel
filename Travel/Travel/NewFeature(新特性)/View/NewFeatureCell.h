//
//  NewFeatureCell.h
//  微博
//
//  Created by mac527 on 15/10/20.
//  Copyright © 2015年 mac527. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewFeatureCell : UICollectionViewCell

@property(nonatomic,strong)UIImage *image;

//判断是否是最后一页
- (void)setIndexPath:(NSIndexPath *)indexPath Count:(int)count;
@end
