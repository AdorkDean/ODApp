//
//  ODUserInformation.m
//  ODApp
//
//  Created by zhz on 16/1/13.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODUserInformation.h"

@implementation ODUserInformation

+ (ODUserInformation *)getData
{
    static ODUserInformation *userInformation = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userInformation = [ODUserInformation new];
    });
    
    return userInformation;
}

@end
