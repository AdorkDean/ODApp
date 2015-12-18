//
//  ODBazaarViewController.h
//  ODApp
//
//  Created by Odong-YG on 15/12/17.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODBaseViewController.h"
#import "ODClassMethod.h"
#import "ODColorConversion.h"
#import "ODAPIManager.h"
#import "AFNetworking.h"
#import "ODBazaarModel.h"
#import "ODBazaarViewCell.h"

@interface ODBazaarViewController : ODBaseViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)AFHTTPRequestOperationManager *manager;
@property(nonatomic,strong)UIView *headView;
@end
