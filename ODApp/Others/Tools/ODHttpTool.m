//
//  ODHttpTool.m
//  ODApp
//
//  Created by 刘培壮 on 16/1/19.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

/** 拼接模型类名 */
#define ODRequestClassName(className)       NSClassFromString([NSStringFromClass(className)stringByAppendingString:@"Response"])

#import <AFNetworking.h>
#import "ODHttpTool.h"
#import "ODProgressHUD.h"
#import "ODAPIManager.h"
#import "ODAPPInfoTool.h"
#import "ODUserInformation.h"

NSString * const requestStatus = @"status";
NSString * const requsetResult = @"result";
NSString * const requsetMessage = @"message";
NSString * const requestSuccessStatus = @"success";

@implementation ODHttpTool

+ (NSMutableDictionary *)getRequestParameter:(NSDictionary *)parameter
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"city_id"] = [NSString stringWithFormat:@"%@",[ODUserInformation sharedODUserInformation].cityID];
    dic[@"device_id"] = @"";
    dic[@"platform"] = @"iphone";
    dic[@"platform_version"] = @"";
    dic[@"channel"] = @"appstore";
    dic[@"app_version"] = [ODAPPInfoTool APPVersion];
    dic[@"network_type"] = @"";
    dic[@"latitude"] = @"";
    dic[@"longitude"] = @"";
    if (dic[@"open_id"] == nil)
    {
        dic[@"open_id"] = [ODUserInformation sharedODUserInformation].openID;
    }
    [dic setValuesForKeysWithDictionary:parameter];
    return [ODAPIManager signParameters:dic];
}


+ (void)getWithURL:(NSString *)URL parameters:(NSDictionary *)parameters modelClass:(__unsafe_unretained Class)modeleClass success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 1.创建请求管理对象
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    URL = [ODBaseURL stringByAppendingString:URL];
    NSMutableDictionary *parameter = [self getRequestParameter:parameters];
    
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
            if ([resultDic isKindOfClass:[NSDictionary class]])
            {
                [resultDic NSLogProperty];
            }
            if (modeleClass == [NSObject class] && ![resultDic isKindOfClass:[NSArray class]])
            {
                success(resultDic);
            }
            else
            {
                success([ODRequestClassName(modeleClass) mj_objectWithKeyValues:responseObject]);
            }
        }
        else
        {
            [ODProgressHUD showErrorWithStatus:responseObject[requsetMessage]];
            failure(responseObject[requestStatus]);
        }
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
        NSLog(@"error === %@ ,manager = %@",error.description,manager);
        if (error)
        {
            failure(error);
        }
    }];
}

+ (void)postWithURL:(NSString *)URL parameters:(NSDictionary *)parameters modelClass:(__unsafe_unretained Class)modeleClass success:(void (^)(id))success failure:(void (^)(NSError *error))failure
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
    
    
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",@"text/plain", nil];

    URL = [ODBaseURL stringByAppendingString:URL];
    NSMutableDictionary *parameter = [self getRequestParameter:parameters];
    
    // 2.发送请求
    [manager POST:URL parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSLog(@"responseObject === %@",responseObject);
        if (success && [responseObject[requestStatus]isEqualToString:requestSuccessStatus])
        {
            id resultDic = responseObject[requsetResult];
            if ([resultDic isKindOfClass:[NSArray class]] && [resultDic count] > 0)
            {
                resultDic = [resultDic lastObject];
            }
            if ([resultDic isKindOfClass:[NSDictionary class]])
            {
                [resultDic NSLogProperty];
            }
            if (modeleClass == [NSObject class] && ![resultDic isKindOfClass:[NSArray class]])
            {
                success(resultDic);
            }
            else
            {
                NSObject *model = [ODRequestClassName(modeleClass) mj_objectWithKeyValues:responseObject];
                success(model);
            }
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
    NSMutableDictionary *parameter = [self getRequestParameter:parameters];

    // 2.发送请求
    [manager POST:URL parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
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
            if ([resultDic isKindOfClass:[NSDictionary class]])
            {
                [resultDic NSLogProperty];
            }
            NSObject *model = [ODRequestClassName(modeleClass) mj_objectWithKeyValues:responseObject];
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
