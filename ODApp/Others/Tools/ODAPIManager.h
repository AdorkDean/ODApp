//
//  ODAPIManager.h
//  ODApp
//
//  Created by Odong-YG on 15/12/17.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ODAPIManager : NSObject


/**
 *  签名
 *
 *  @param parameters 参数
 *
 *  @return 签名之后的参数
 */
+ (NSMutableDictionary *)signParameters:(NSDictionary *)parameters;

+ (NSString *)getUrl:(NSString *)uri;

@end
