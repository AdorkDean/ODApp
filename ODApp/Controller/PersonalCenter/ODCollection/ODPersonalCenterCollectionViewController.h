//
//  ODPersonalCenterCollectionViewController.h
//  ODApp
//
//  Created by Odong-YG on 16/2/18.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODBaseViewController.h"
#import "ODBazaarExchangeSkillDetailViewController.h"
#import "ODBazaarExchangeSkillModel.h"
#import "ODBazaarExchangeSkillCollectionCell.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "ODAPIManager.h"
#import "ODHelp.h"
#import "ODCommunityShowPicViewController.h"
#import "MJRefresh.h"

@interface ODPersonalCenterCollectionViewController : ODBaseViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>


@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSArray *dataArray;
@property(nonatomic) NSInteger page;

@end
