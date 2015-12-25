//
//  ODCommunityDetailViewController.h
//  ODApp
//
//  Created by Odong-YG on 15/12/25.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODBaseViewController.h"
#import "ODTabBarController.h"
#import "ODAPIManager.h"
#import "ODClassMethod.h"
#import "ODColorConversion.h"
#import "AFNetworking.h"

@interface ODCommunityDetailViewController : ODBaseViewController

@property(nonatomic,strong)UIView *headView;
@property(nonatomic,copy)NSString *user_id;
@property(nonatomic,strong)AFHTTPRequestOperationManager *manager;

@end

