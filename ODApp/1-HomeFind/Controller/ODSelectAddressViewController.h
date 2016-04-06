//
//  ODSelectAddressViewController.h
//  ODApp
//
//  Created by Odong-YG on 16/4/1.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODBaseViewController.h"
#import <AMapSearchKit/AMapSearchKit.h>

@interface ODSelectAddressViewController : ODBaseViewController

@property(nonatomic, copy) void(^myBlock)(NSString *address,NSString *addressTitle,AMapGeoPoint *location);

@end
