//
//  ODBazaarReleaseRewardViewController.h
//  ODApp
//
//  Created by Odong-YG on 16/1/4.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODBaseViewController.h"
#import "ODTabBarController.h"
#import "ODAPIManager.h"
#import "AFNetworking.h"

@interface ODBazaarReleaseRewardViewController : ODBaseViewController

@property(nonatomic,strong)UIView *headView;
@property(nonatomic,strong)UILabel *taskRewardLabel;
@property(nonatomic,strong)AFHTTPRequestOperationManager *manager;
@property(nonatomic,strong)NSMutableArray *dataArray;

@end
