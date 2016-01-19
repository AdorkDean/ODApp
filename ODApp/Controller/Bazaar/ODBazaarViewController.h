//
//  ODBazaarViewController.h
//  ODApp
//
//  Created by Odong-YG on 15/12/17.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODBaseViewController.h"
#import "ODClassMethod.h"
#import "ODAPIManager.h"
#import "AFNetworking.h"
#import "ODBazaarCollectionCell.h"
#import "ODBazaarHeaderView.h"
#import "ODBazaarReleaseTaskViewController.h"
#import "ODBazaarLabelSearchViewController.h"
#import "ODBazaarDetailViewController.h"
#import "MJRefresh.h"
#import "ODPersonalCenterViewController.h"

#import "ODOthersInformationController.h"

@interface ODBazaarViewController : ODBaseViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIPopoverPresentationControllerDelegate>

@property (nonatomic, copy) NSString *open_id;

@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)AFHTTPRequestOperationManager *manager;
@property(nonatomic,strong)UIView *headView;
@property(nonatomic,copy)NSString *status;
@property(nonatomic)NSInteger count;
@property(nonatomic,strong)UIButton *screeningButton;
@property(nonatomic,copy)NSString *refresh;


@end
