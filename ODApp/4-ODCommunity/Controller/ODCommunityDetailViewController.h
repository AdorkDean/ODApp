//
//  ODCommunityDetailViewController.h
//  ODApp
//
//  Created by Odong-YG on 15/12/25.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODBaseViewController.h"
#import "ODTabBarController.h"
#import "ODClassMethod.h"
#import "ODCommunityDetailModel.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "ODHelp.h"
#import "ODCommunityDetailReplyViewController.h"
#import "ODCommunityDetailCell.h"
#import "MJRefresh.h"
#import "ODPersonalCenterViewController.h"
#import "ODOthersInformationController.h"
#import "ODCommunityDetailInfoModel.h"
#import "ODPublicTool.h"

@interface ODCommunityDetailViewController : ODBaseViewController <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, copy) NSString *bbs_id;
@property(nonatomic, strong) NSMutableArray *resultArray;
@property(nonatomic, strong) NSMutableArray *userArray;
@property(nonatomic, strong) NSArray *bbs_imgArray;
@property(nonatomic, strong) UIView *userView;
@property(nonatomic, strong) UIView *bbsView;
@property(nonatomic, strong) UIView *lineView;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, strong) NSMutableArray *imageArray;
@property(nonatomic, strong) UIView *tabelHeaderView;
@property(nonatomic, copy) NSString *open_id;
@property(nonatomic) CGFloat height;
@property(nonatomic) NSInteger count;
@property(nonatomic, copy) void(^myBlock)(NSString *refresh);
@property(nonatomic, copy) NSString *refresh;

@end

