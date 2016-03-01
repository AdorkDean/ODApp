//
//  ODUserResponse.h
//  ODApp
//
//  Created by william on 16/3/1.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ODUserResponse : NSObject

@property (copy, nonatomic) NSString *status;
@property (strong, nonatomic) ODUser *result;

@end
