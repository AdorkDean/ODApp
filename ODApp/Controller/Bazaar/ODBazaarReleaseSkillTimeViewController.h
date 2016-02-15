//
//  ODBazaarReleaseSkillTimeViewController.h
//  ODApp
//
//  Created by Odong-YG on 16/2/5.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODBaseViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "ODAPIManager.h"
#import "ODBazaarReleaseSkillTimeModel.h"
#import "ODBazaarReleaseSkillTimeViewCell.h"

@interface ODBazaarReleaseSkillTimeViewController : ODBaseViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)AFHTTPRequestOperationManager *manager;

@end