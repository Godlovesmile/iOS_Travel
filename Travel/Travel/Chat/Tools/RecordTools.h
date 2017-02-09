//
//  RecordTools.h
//  Travel
//
//  Created by Alice on 16/5/9.
//  Copyright © 2016年 Alice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecordTools : NSObject

+ (instancetype)sharedRecorder;

/** 开始录音 */
- (void)startRecord;

/** 停止录音 */
- (void)stopRecordSuccess:(void (^)(NSURL *url,NSTimeInterval time))success andFailed:(void (^)())failed;

/** 播放声音数据 */
- (void)playData:(NSData *)data completion:(void(^)())completion;

/** 播放声音文件 */
- (void)playPath:(NSString *)path completion:(void(^)())completion;

@end
