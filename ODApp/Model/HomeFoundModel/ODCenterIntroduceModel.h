//
//  ODCenterIntroduceModel.h
//  ODApp
//
//  Created by Bracelet on 16/1/6.
//  Copyright © 2016年 Odong Bracelet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ODCenterIntroduceModel : NSObject

- (instancetype)initWithDict:(NSDictionary *)dict;

@property (nonatomic, copy) NSString *banner_url;
@property (nonatomic, copy) NSString *img_url;
@property (nonatomic, copy) NSString *title;

@end
