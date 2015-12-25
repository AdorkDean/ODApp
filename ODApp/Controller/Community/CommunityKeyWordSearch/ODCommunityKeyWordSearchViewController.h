//
//  ODCommunityKeyWordSearchViewController.h
//  ODApp
//
//  Created by Odong-YG on 15/12/25.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODBaseViewController.h"
#import "ODTabBarController.h"
#import "AFNetworking.h"
#import "ODAPIManager.h"

@interface ODCommunityKeyWordSearchViewController : ODBaseViewController<UISearchBarDelegate>

@property(nonatomic,strong)UIView *headView;
@property(nonatomic,strong)AFHTTPRequestOperationManager * manager;

@end
