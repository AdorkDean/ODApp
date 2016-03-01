//
//  ODBazaarRequestHelpViewController.h
//  ODApp
//
//  Created by Odong-YG on 16/2/2.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODBaseViewController.h"
#import "ODClassMethod.h"
#import "ODAPIManager.h"
#import "AFNetworking.h"
#import "ODBazaarCollectionCell.h"
#import "ODBazaarReleaseTaskViewController.h"
#import "ODBazaarLabelSearchViewController.h"
#import "ODBazaarDetailViewController.h"
#import "MJRefresh.h"
#import "ODPersonalCenterViewController.h"
#import "ODOthersInformationController.h"
#import "ODLazyViewController.h"
#import "ODBazaaeExchangeSkillViewController.h"

@interface ODBazaarRequestHelpViewController : ODBaseViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIPopoverPresentationControllerDelegate>

@property(nonatomic, copy) NSString *open_id;
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, strong) AFHTTPRequestOperationManager *manager;
@property(nonatomic, strong) UIView *headView;
@property(nonatomic, copy) NSString *status;
@property(nonatomic) NSInteger count;
@property(nonatomic, strong) UIButton *screeningButton;
@property(nonatomic, copy) NSString *refresh;
@property(nonatomic) NSInteger indexPath;

@property (nonatomic, strong) UILabel *noResultLabel;

@end
