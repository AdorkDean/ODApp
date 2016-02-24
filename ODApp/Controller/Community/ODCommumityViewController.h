//
//  ODCommumityViewController.h
//  ODApp
//
//  Created by Odong-YG on 15/12/17.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODBaseViewController.h"
#import "ODAPIManager.h"
#import "ODClassMethod.h"
#import "AFNetworking.h"
#import "ODCommunityModel.h"
#import "ODCommunityCollectionCell.h"
#import "ODCommunityReleaseTopicViewController.h"
#import "ODCommunityDetailViewController.h"
#import "ODCommunityKeyWordSearchViewController.h"
#import "MJRefresh.h"
#import "ODPersonalCenterViewController.h"
#import "ODOthersInformationController.h"
#import "ODCommunityShowPicViewController.h"
#import "odbarbutton.h"

@interface ODCommumityViewController : ODBaseViewController<UICollectionViewDelegate,UICollectionViewDataSource,UIPopoverPresentationControllerDelegate>

@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)AFHTTPRequestOperationManager *manager;
@property(nonatomic,strong)ODBarButton *button;
@property(nonatomic,strong)UIView *classView;
@property(nonatomic)NSInteger count;
@property(nonatomic,assign) BOOL refresh;
@property (nonatomic, copy) NSString *bbsMark;
@property (nonatomic, assign) int bbsType;
- (void)joiningTogetherParmeters;

@end
