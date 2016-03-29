//
//  ODHttpTool.h
//  ODApp
//
//  Created by 刘培壮 on 16/1/19.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface ODHttpTool : NSObject


+ (NSMutableDictionary *)getRequestParameter:(NSDictionary *)parameter;

/**
 *  签名
 *
 *  @param parameters 参数
 *
 *  @return 签名之后的参数
 */
+ (NSMutableDictionary *)signParameters:(NSDictionary *)parameters;


/**
 *  封装get请求
 *
 *  @param URL        请求地址
 *  @param parameters 请求参数
 *  @param success    成功回调
 *  @param failure    失败回调
 */

+ (void)getWithURL:(NSString *)URL parameters:(NSDictionary *)parameters modelClass:(Class)modeleClass success:(void (^)(id model))success failure:(void (^)(NSError *error))failure;

/**
 *  封装post请求
 *
 *  @param URL        请求地址
 *  @param parameters 请求参数
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)postWithURL:(NSString *)URL parameters:(NSDictionary *)parameters modelClass:(Class)modeleClass success:(void (^)(id model))success failure:(void (^)(NSError *error))failure;

/**
 *  封装带文件的POST请求
 *
 *  @param URL        请求地址
 *  @param parameters 请求参数
 *  @param dataArray  上传内容数组
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)postWithURL:(NSString *)URL parameters:(NSDictionary *)parameters fromDataArray:(NSArray *)dataArray modelClass:(Class)modeleClass success:(void (^)(id model))success failure:(void (^)(NSError *))failure;

+ (NSMutableDictionary *)getRequestParameter:(NSDictionary *)parameter;

// 刷新数据
+ (void)od_endRefreshWith:(UIScrollView *)scrollView array:(NSArray *)array;


@end
