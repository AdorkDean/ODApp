//
//  ODBazaaeExchangeSkillViewController.h
//  ODApp
//
//  Created by Odong-YG on 16/2/1.
//  Copyright © 2016年 Odong-YG. All rights reserved.
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

@interface ODBazaaeExchangeSkillViewController : ODBaseViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)AFHTTPRequestOperationManager *manager;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic)NSInteger page;
@end
