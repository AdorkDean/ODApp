
//
//  ODBazaarDetailModel.m
//  ODApp
//
//  Created by Odong-YG on 15/12/23.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODBazaarDetailModel.h"

@implementation ODBazaarDetailApplysModel


@end


@implementation ODBazaarDetailModel

+ (void)initialize {
    [ODBazaarDetailModel mj_setupObjectClassInArray:^NSDictionary *{        
        return @{
                 @"applys" : [ODBazaarDetailApplysModel class]
                 };
    }];
}

@end
ODRequestResultIsDictionaryAll(ODBazaarDetailModel)