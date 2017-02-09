//
//  NetworkManager.m
//  Travel
//
//  Created by Alice on 16/4/20.
//  Copyright © 2016年 Alice. All rights reserved.
//

#import "NetworkManager.h"

#define serverUrl @"http://192.168.1.1:8080/jiekou"

@implementation NetworkManager

+ (void)POST:(NSString *)URL params:(NSDictionary * )params success:(void (^)(id response))success
     failure:(void (^)(AFHTTPSessionManager *operation,NSError *error))Error {
    // 创建请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 请求超时时间
    
    manager.requestSerializer.timeoutInterval = 30;
    NSString *postStr = URL;
    if (![URL hasPrefix:@"http"]) {
        
        postStr = [NSString stringWithFormat:@"%@%@", serverUrl,URL] ;
    }
    NSMutableDictionary *dict = [params mutableCopy];
    
    
    //发送post请求
    [manager POST:postStr parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // 请求成功
        NSDictionary *responseDict = (NSDictionary *)responseObject;
        success(responseDict);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

+ (void)GET:(NSString *)URL
    success:(void (^)(id response))success
    failure:(void (^)(AFHTTPSessionManager *operation,NSError *error))Error {
    // 获得请求管理者
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setHTTPShouldHandleCookies:NO];
    manager.requestSerializer.timeoutInterval = 30;
    NSString *getStr = URL;
    
    if (![URL hasPrefix:@"http"]) {
        
        getStr = [NSString stringWithFormat:@"%@%@", serverUrl,URL] ;
    }
    
    //发送GET请求
    [manager GET:getStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //        NSLog(@"getStr------------%@",getStr);
        //NSDictionary *responseDict = (NSDictionary *)responseObject;
        if (success) {
            
            success(responseObject);
        }
        

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
    }];
    
}

+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    // 1.创建请求管理对象
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    // 2.发送请求
    [mgr GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
        }
    }];
}

//发送带图片微博的请求
+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params formDataArray:(NSArray *)formDataArray success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    
    // 1.创建请求管理对象
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    //2.发送请求
    [mgr POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull totalFormData) {
        
        for (IWFormData *formData in formDataArray) {
            [totalFormData appendPartWithFileData:formData.data name:formData.name fileName:formData.filename mimeType:formData.mimeType];
        }

    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            success(responseObject);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
        }

    }];
}

//不带图片微博
+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    // 1.创建请求管理对象
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
        
    //2.发送请求
    [mgr POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            success(responseObject);
            
            NSLog(@"responseObject = %@",responseObject);
            
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
        }

    }];
}


@end

/**
 *  用来封装文件数据的模型
 */
@implementation IWFormData

@end

