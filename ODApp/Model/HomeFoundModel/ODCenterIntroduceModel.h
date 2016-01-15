//
//  ODCenterIntroduceModel.h
//  ODApp
//
//  Created by 代征钏 on 16/1/6.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ODCenterIntroduceModel : NSObject

- (instancetype)initWithDict:(NSDictionary *)dict;

@property (nonatomic, copy) NSString *banner_url;
@property (nonatomic, copy) NSString *img_url;
@property (nonatomic, copy) NSString *title;

@end
