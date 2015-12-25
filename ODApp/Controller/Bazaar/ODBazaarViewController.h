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
#import "ODBazaarCollectionCell.h"
#import "ODBazaarHeaderView.h"
#import "ODBazaarReleaseTaskViewController.h"
#import "ODBazaarLabelSearchViewController.h"
#import "ODBazaarDetailViewController.h"

@interface ODBazaarViewController : ODBaseViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIPopoverPresentationControllerDelegate>

@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)AFHTTPRequestOperationManager *manager;
@property(nonatomic,strong)UIView *headView;
@property(nonatomic,copy)NSString *status;
@end
