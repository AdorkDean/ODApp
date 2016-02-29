//
//  ODMyApplyActivityController.h
//  ODApp
//
//  Created by Bracelet on 16/1/12.
//  Copyright © 2016年 Odong Bracelet. All rights reserved.
//

#import "ODBaseViewController.h"

#import "AFNetworking.h"
#import "MJRefresh.h"
#import "ODClassMethod.h"
#import "ODTabBarController.h"
#import "ODAPIManager.h"
#import "ONMyApplyActivityCell.h"
#import "ODMyApplyActivityModel.h"
#import "UIImageView+WebCache.h"
#import "ODActivityDetailController.h"
#import "ODCenterActivityViewController.h"

#import "ODNewActivityDetailViewController.h"

@interface ODMyApplyActivityController : ODBaseViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, copy) NSString *open_id;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@property (nonatomic, strong)NSMutableArray *dataArray;

@property (nonatomic, strong) UILabel *noReusltLabel;

@property (nonatomic, assign) int pageCount;

@property (nonatomic, assign) BOOL isRefresh;

@end
