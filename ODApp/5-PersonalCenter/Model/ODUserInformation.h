//
//  ODUserInformation.h
//  ODApp
//
//  Created by zhz on 16/1/13.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//
#import "ODSingleton.h"
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "ODUserModel.h"
#import <CoreLocation/CoreLocation.h>

@interface ODUserInformation : NSObject

Single_Interface(ODUserInformation)

@property(nonatomic, copy) NSString *openID;
@property(nonatomic, copy) NSString *locationCity;
@property(nonatomic, copy) NSString *cityID;
@property(nonatomic, copy) NSString *avatar;
@property(nonatomic, copy) NSString *mobile;
@property(nonatomic, assign) CLLocationCoordinate2D userCoordinate;

- (void)updateUserCache:(ODUserModel *)user;
- (ODUserModel *)getUserCache;

@end
