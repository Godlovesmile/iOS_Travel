//
//  NetworkManager.h
//  Travel
//
//  Created by Alice on 16/4/20.
//  Copyright © 2016年 Alice. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworking.h"

@interface NetworkManager : NSObject

// JSON Post请求
+ (void)POST:(NSString *)URL params:(NSDictionary * )params success:(void (^)(id response))success
     failure:(void (^)(AFHTTPSessionManager *operation,NSError *error))Error;

// JSON Get请求
+ (void)GET:(NSString *)URL
    success:(void (^)(id response))success
    failure:(void (^)(AFHTTPSessionManager *operation,NSError *error))Error;

+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure;

// 上传图片(post方法)
//+ (void)UPLOADIMAGE:(NSString *)URL
//             params:(NSDictionary *)params
//        uploadImage:(UIImage *)image
//            success:(void (^)(id response))success
//            failure:(void (^)(AFHTTPSessionManager *operation,NSError *error))Error;

//发送微博的请求
+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params formDataArray:(NSArray *)formDataArray success:(void (^)(id))success failure:(void (^)(NSError *))failure;

//不带图片微博
+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure;
@end


/**
 *  用来封装文件数据的模型
 */
@interface IWFormData : NSObject
/**
 *  文件数据
 */
@property (nonatomic, strong) NSData *data;

/**
 *  参数名
 */
@property (nonatomic, copy) NSString *name;

/**
 *  文件名
 */
@property (nonatomic, copy) NSString *filename;

/**
 *  文件类型
 */
@property (nonatomic, copy) NSString *mimeType;

@end

