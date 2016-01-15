//
//  ODMyApplyActivityController.h
//  ODApp
//
//  Created by 代征钏 on 16/1/12.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODBaseViewController.h"

#import "AFNetworking.h"
#import "MJRefresh.h"

#import "ODClassMethod.h"
#import "ODColorConversion.h"
#import "ODTabBarController.h"
#import "ODAPIManager.h"
#import "ONMyApplyActivityCell.h"
#import "ODMyApplyActivityModel.h"
#import "UIImageView+WebCache.h"
#import "ODActivityDetailController.h"
#import "ODCenterActivityViewController.h"



@interface ODMyApplyActivityController : ODBaseViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>



@property (nonatomic, strong) UIView *headView;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@property (nonatomic, strong)NSMutableArray *dataArray;

@end
