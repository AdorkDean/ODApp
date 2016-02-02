//
//  ODHttpTool.m
//  ODApp
//
//  Created by 刘培壮 on 16/1/19.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//
#import <AFNetworking.h>
#import "ODHttpTool.h"
#import "ODAPIManager.h"
#import "NSObject+Log.h"

NSString * const requestStatus = @"status";
NSString * const requsetResult = @"result";
NSString * const requestSuccessStatus = @"success";

@implementation ODHttpTool

+ (void)getWithURL:(NSString *)URL parameters:(NSDictionary *)parameters modelClass:(__unsafe_unretained Class)modeleClass success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 1.创建请求管理对象
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    URL = [ODBaseURL stringByAppendingString:URL];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [parameter setValuesForKeysWithDictionary:[ODAPIManager signParameters:parameter]];
    
    // 2.发送请求
    [manager GET:URL parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSLog(@"responseObject === %@",responseObject);
        if (success && [responseObject[requestStatus]isEqualToString:requestSuccessStatus])
        {
            id resultDic = responseObject[requsetResult];
            if ([resultDic isKindOfClass:[NSArray class]] && [resultDic count] > 0)
            {
                resultDic = [resultDic lastObject];
            }
            [NSObject resolveDict:resultDic];
            NSObject *model = [modeleClass mj_objectWithKeyValues:responseObject];
            success(model);
        }
        else
        {
            failure(responseObject[requestStatus]);
        }
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
        NSLog(@"error === %@",error.description);
        if (error)
        {
            failure(error);
        }
    }];
}

+ (void)postWithURL:(NSString *)URL parameters:(NSDictionary *)parameters modelClass:(__unsafe_unretained Class)modeleClass success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
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

    URL = [ODBaseURL stringByAppendingString:URL];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [parameter setValuesForKeysWithDictionary:[ODAPIManager signParameters:parameter]];
    
    // 2.发送请求
    [manager POST:URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        if (success && [responseObject[requestStatus]isEqualToString:requestSuccessStatus])
        {
            id resultDic = responseObject[requsetResult];
            if ([resultDic isKindOfClass:[NSArray class]] && [resultDic count] > 0)
            {
                resultDic = [resultDic lastObject];
            }
            [NSObject resolveDict:resultDic];
            NSObject *model = [modeleClass mj_objectWithKeyValues:responseObject];
            success(model);
        }
        else
        {
            failure(responseObject[requestStatus]);
        }
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
        if (error)
        {
            failure(error);
        }
    }];
    
}

+ (void)postWithURL:(NSString *)URL parameters:(NSDictionary *)parameters fromDataArray:(NSArray *)dataArray modelClass:(__unsafe_unretained Class)modeleClass success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 1.创建请求管理对象
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    URL = [ODBaseURL stringByAppendingString:URL];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [parameter setValuesForKeysWithDictionary:[ODAPIManager signParameters:parameter]];

    // 2.发送请求
    [manager POST:URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
    {
//        for (PCFromData *formDatas in dataArray) {
//            [formData appendPartWithFileData:formDatas.data name:formDatas.name fileName:formDatas.filename mimeType:formDatas.mimeType];
//        }
    }
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
        if (success && [responseObject[requestStatus]isEqualToString:requestSuccessStatus])
        {
            id resultDic = responseObject[requsetResult];
            if ([resultDic isKindOfClass:[NSArray class]] && [resultDic count] > 0)
            {
                resultDic = [resultDic lastObject];
            }
            [NSObject resolveDict:resultDic];
            NSObject *model = [modeleClass mj_objectWithKeyValues:responseObject];
            success(model);
        }
        else
        {
            failure(responseObject[requestStatus]);
        }
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        if (error)
        {
            failure(error);
        }
    }];
}

#pragma mark - 数据转换


@end
