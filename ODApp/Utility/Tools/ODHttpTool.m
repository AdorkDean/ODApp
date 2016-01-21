//
//  ODHttpTool.m
//  ODApp
//
//  Created by 刘培壮 on 16/1/19.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//
#import <AFNetworking.h>
#import "ODHttpTool.h"

@implementation ODHttpTool

+ (void)getWithURL:(NSString *)URL parameters:(NSDictionary *)parameters success:(void (^)(id json))success failure:(void (^)(NSError *))failure{
    // 1.创建请求管理对象
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // 2.发送请求
    [manager GET:URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

+ (void)postWithURL:(NSString *)URL parameters:(NSDictionary *)parameters success:(void (^)(id json))success failure:(void (^)(NSError *))failure{
    // 1.创建请求管理对象
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //如果报接受类型不一致请替换一致text/html或别的
    
    //    NSSet *set = manager.responseSerializer.acceptableContentTypes;
    //    NSMutableSet *setM = [NSMutableSet setWithSet:set];
    //    [setM addObject:@"text/plain"];
    //    AFHTTPResponseSerializer *responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    //    responseSerializer.acceptableContentTypes = setM;
    //    manager.responseSerializer = responseSerializer;
    
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",@"text/plain", nil];
    
    // 2.发送请求
    [manager POST:URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error) {
            failure(error);
        }
    }];
    
}

+ (void)postWithURL:(NSString *)URL parameters:(NSDictionary *)parameters fromDataArray:(NSArray *)dataArray success:(void (^)(id json))success failure:(void (^)(NSError *))failure{
    // 1.创建请求管理对象
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 2.发送请求
    [manager POST:URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        for (PCFromData *formDatas in dataArray) {
//            [formData appendPartWithFileData:formDatas.data name:formDatas.name fileName:formDatas.filename mimeType:formDatas.mimeType];
//        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error) {
            failure(error);
        }
    }];
    
    
}


@end