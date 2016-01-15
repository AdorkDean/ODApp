//
//  ODUserInformation.h
//  ODApp
//
//  Created by zhz on 16/1/13.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface ODUserInformation : NSObject

@property(nonatomic ,copy) NSString *openID;


+ (ODUserInformation *)getData;



@end
