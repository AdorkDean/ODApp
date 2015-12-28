//
//  ODBazaarLabelSearchViewController.h
//  ODApp
//
//  Created by Odong-YG on 15/12/21.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODBaseViewController.h"
#import "ODTabBarController.h"
#import "ODClassMethod.h"
#import "ODAPIManager.h"
#import "ODColorConversion.h"
#import "AFNetworking.h"


@interface ODBazaarLabelSearchViewController : ODBaseViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)AFHTTPRequestOperationManager *manager;
@property(nonatomic,strong)UIView *headView;
@property(nonatomic,strong)UITextField *searchTextField;

@end
