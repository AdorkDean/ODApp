//
//  ODReleaseModel.h
//  ODApp
//
//  Created by Bracelet on 16/2/18.
//  Copyright © 2016年 Odong Bracelet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ODReleaseModel : NSObject

@property(nonatomic, copy) NSString *swap_id;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *content;
@property(nonatomic, copy) NSString *price;
@property(nonatomic, copy) NSString *unit;
@property(nonatomic, copy) NSString *swap_type;
@property(nonatomic, copy) NSString *love_num;
@property(nonatomic, copy) NSString *share_num;
@property(nonatomic, copy) NSString *love_id;
@property(nonatomic, strong) NSArray *imgs_small;
@property(nonatomic, copy) NSString *open_id;
@property(nonatomic, strong) NSDictionary *user;
@property(nonatomic, copy) NSString *status;

@end

ODRequestResultIsArrayProperty(ODReleaseModel)

@interface ODReleaseLovesModel : NSObject

@property(nonatomic, copy) NSString *img_url;

@end
