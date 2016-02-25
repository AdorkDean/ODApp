//
//  ODReleaseController.h
//  ODApp
//
//  Created by 代征钏 on 16/2/18.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODBaseViewController.h"
#import "ODReleaseCell.h"
#import "ODReleaseModel.h"
#import "AFNetworking.h"
#import "ODAPIManager.h"
#import "MJRefresh.h"
#import "ODBazaarReleaseSkillViewController.h"

@interface ODReleaseController : ODBaseViewController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>


@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@property (nonatomic, copy) NSString *swap_id;

@property (nonatomic, strong) ODReleaseModel *model;

@property (nonatomic, strong) ODReleaseCell *cell;

@property (nonatomic, assign) int pageCount;
@property (nonatomic, assign) int pageSelectedCount;



@end
