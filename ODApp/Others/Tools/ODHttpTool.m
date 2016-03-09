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

#pragma mark - 数据请求

+ (void)getWithURL:(NSString *)URL parameters:(NSDictionary *)parameters modelClass:(__unsafe_unretained Class)modeleClass success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    URL = [ODBaseURL stringByAppendingString:URL];
    NSMutableDictionary *parameter = [self getRequestParameter:parameters];
    [manager GET:URL parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        [self requestSuccessResult:responseObject modelClass:modeleClass successBlock:success failBlock:failure];
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self requestFailError:error requestOperation:operation failBlock:failure];
    }];
}

+ (void)postWithURL:(NSString *)URL parameters:(NSDictionary *)parameters modelClass:(__unsafe_unretained Class)modeleClass success:(void (^)(id))success failure:(void (^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    URL = [ODBaseURL stringByAppendingString:URL];
    NSMutableDictionary *parameter = [self getRequestParameter:parameters];
    [manager POST:URL parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        [self requestSuccessResult:responseObject modelClass:modeleClass successBlock:success failBlock:failure];
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
         [self requestFailError:error requestOperation:operation failBlock:failure];
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
         [self requestSuccessResult:responseObject modelClass:modeleClass successBlock:success failBlock:failure];
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        [self requestFailError:error requestOperation:operation failBlock:failure];
    }];
}

#pragma mark - 请求结果统一处理

+ (void)requestSuccessResult:(id)responseObject modelClass:(__unsafe_unretained Class)modeleClass successBlock:(void (^)(id))successBlock failBlock:(void (^)(id))failBlock
{
    NSLog(@"responseObject === %@",responseObject);
    if (successBlock && [responseObject[requestStatus]isEqualToString:requestSuccessStatus])
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
            successBlock(resultDic);
        }
        else
        {
            successBlock([ODRequestClassName(modeleClass) mj_objectWithKeyValues:responseObject]);
        }
    }
    else
    {
        [ODProgressHUD showErrorWithStatus:responseObject[requsetMessage]];
        failBlock(responseObject[requestStatus]);
    }
}

+ (void)requestFailError:(NSError *)error requestOperation:(AFHTTPRequestOperation *)manager failBlock:(void (^)(id))failBlock
{
    NSLog(@"error === %@ ,manager = %@",error.description,manager);
    if (error)
    {
        failBlock(error);
    }
}
@end
