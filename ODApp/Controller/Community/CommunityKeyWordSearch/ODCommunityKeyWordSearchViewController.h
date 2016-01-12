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
#import "ODCommunityModel.h"
#import "ODCommunityCollectionCell.h"
#import "ODCommunityDetailViewController.h"
#import "MJRefresh.h"

@interface ODCommunityKeyWordSearchViewController : ODBaseViewController<UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate>

@property(nonatomic,strong)UIView *headView;
@property(nonatomic,strong)AFHTTPRequestOperationManager * manager;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *userArray;
@property(nonatomic,strong)UISearchBar *searchBar;
@property(nonatomic)NSInteger count;
@property(nonatomic,copy)NSString *keyText;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic)NSInteger currentTime;
@property(nonatomic,strong)UILabel *promptLabel;

@end
