//
//  ODBazaarExchangeSkillDetailViewController.h
//  ODApp
//
//  Created by Odong-YG on 16/2/1.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODBaseViewController.h"
#import "AFNetworking.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "ODAPIManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "ODBazaarExchangeSkillModel.h"
#import "ODHelp.h"
#import "UMSocial.h"
#import "ODOthersInformationController.h"
#import "ODOrderController.h"
#import "ODCollectionController.h"
#import "ODPersonalCenterViewController.h"
#import "ODThirdOrderController.h"

@interface ODBazaarExchangeSkillDetailViewController : ODBaseViewController<UMSocialUIDelegate,UMSocialDataDelegate>

@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)AFHTTPRequestOperationManager *manager;
@property(nonatomic,copy)NSString *swap_id;
@property(nonatomic,strong)ODBazaarExchangeSkillModel *model;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)UILabel *loveLabel;
@property(nonatomic,strong)UIImageView *loveImageView;
@property(nonatomic,strong)UIView *detailView;
@property(nonatomic,copy)NSString *nick;
@property(nonatomic,copy)NSString *love_id;
@property(nonatomic,copy)NSString *love;
@property(nonatomic)NSInteger sharedTimes;
@end
