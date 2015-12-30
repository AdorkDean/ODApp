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
#import "ODCommunityDetailModel.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "ODHelp.h"
#import "ODCommunityDetailReplyViewController.h"
#import "ODCommunityDetailCell.h"

@interface ODCommunityDetailViewController : ODBaseViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIView *headView;
@property(nonatomic,copy)NSString *bbs_id;
@property(nonatomic,strong)AFHTTPRequestOperationManager *manager;
@property(nonatomic,strong)NSMutableArray *resultArray;
@property(nonatomic,strong)NSMutableArray *userArray;
@property(nonatomic,strong)NSArray *bbs_imgArray;
@property(nonatomic,strong)UIView *userView;
@property(nonatomic,strong)UIView *bbsView;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;

@end

