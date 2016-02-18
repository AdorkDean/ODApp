//
//  ODUserInformation.h
//  ODApp
//
//  Created by zhz on 16/1/13.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//
#import "Singleton.h"
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface ODUserInformation : NSObject

Single_Interface(ODUserInformation)
@property(nonatomic ,copy) NSString *openID;

@property (nonatomic, copy) NSString *locationCity;

@property (nonatomic, assign) NSInteger cityID;

@end
