//
//  ODAPIManager.m
//  ODApp
//
//  Created by Odong-YG on 15/12/17.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODAPIManager.h"
#import "ODAPPInfoTool.h"
#import <CommonCrypto/CommonDigest.h>

static NSString *const privateKey = @"@#$%T-90KJ(3;lkm54)(YUr41mkl09hk";



@interface NSString (ODAPIManager)

@property(nonatomic, strong, readonly) NSString *md5;

@end



@implementation NSString (LingQianHelper)

- (NSString *)md5 {
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG) strlen(cStr), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++) {
        [hash appendFormat:@"%02X", result[i]];
    }

    return [hash uppercaseString];
}

@end

@implementation ODAPIManager


#pragma mark - 添加 sign 字段之后的参数

+ (NSMutableDictionary *)signParameters:(NSDictionary *)parameters {
    NSMutableDictionary *sigParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    sigParameters[@"sign"] = [[self class] signStringWithParameters:sigParameters];

    return sigParameters;
}

+ (NSString *)getUrl:(NSString *)uri {
    return [ODURL stringByAppendingString:uri];
}

#pragma mark - 私有函数


/**
 *  参数签名
 *
 *  @param parameters 参数
 *
 *  @return sign
 */
+ (NSString *)signStringWithParameters:(NSDictionary *)parameters {
    NSArray *allValues = [[parameters allValues] arrayByAddingObject:privateKey];
    allValues = [allValues sortedArrayUsingSelector:@selector(compare:)];
    NSString *signData = [allValues componentsJoinedByString:@"|"];

    return [[[[signData.md5 lowercaseString] md5] lowercaseString] substringWithRange:NSMakeRange(9, 6)];
}



@end
