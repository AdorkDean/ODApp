//
//  LunBoModel.h
//  ODApp
//
//  Created by zhz on 15/12/23.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LunBoModel : NSObject

@property (nonatomic , copy) NSString *banner_url;
@property (nonatomic , copy) NSString *img_url;
@property (nonatomic , copy) NSString *title;

-(instancetype)initWithDict:(NSDictionary *)dict;

@end
