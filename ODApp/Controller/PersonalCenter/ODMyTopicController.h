//
//  ODMyTopicController.h
//  ODApp
//
//  Created by zhz on 16/1/11.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODBaseViewController.h"

@interface ODMyTopicController : ODBaseViewController



@property (nonatomic , copy) NSString *refresh;

@property (nonatomic, copy) NSString *open_id;

@property (nonatomic, strong) UILabel *noResultLeftLabel;

@property (nonatomic, strong) UILabel *noReusltRightLabel;

@end
