//
//  NSObject+YYNet.m
//  pugongying
//
//  Created by wyy on 16/5/23.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "NSObject+YYNet.h"
#import "AFNetworking.h"

@implementation NSObject (YYNet)
+ (id)GET:(NSString *)urlStr parameters:(NSDictionary *)parameters progress:(void(^)(NSProgress * downloadProgress)) downLoadProgress completionHandler:(void(^)(id responseObject, NSError *error)) completionHandler{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"text/json", @"text/javascript", @"text/plain", nil];
    //修改超时时间
    manager.requestSerializer.timeoutInterval = 30;
    
    return [manager GET:urlStr parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        downLoadProgress(downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completionHandler(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completionHandler(nil,error);
    }];
}

+ (id)POST:(NSString *)urlStr parameters:(NSDictionary *)parameters progress:(void(^)(NSProgress * downloadProgress)) upLoadProgress completionHandler:(void(^)(id responseObject, NSError *error)) completionHandler{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 30;
    
    return [manager POST:urlStr parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        upLoadProgress(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completionHandler(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completionHandler(nil,error);
    }];
}

@end
