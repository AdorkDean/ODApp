//
//  ODOthersInformationController.h
//  ODApp
//
//  Created by Bracelet on 16/1/18.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODBaseViewController.h"

#import "UIImageView+WebCache.h"

#import "ODUserModel.h"
#import "ODTabBarController.h"
#import "ODAPIManager.h"
#import "ODClassMethod.h"
#import "ODMyOrderRecordController.h"
#import "ODOtherTaskController.h"
#import "ODOtherTopicViewController.h"

#import "ODLandFirstCell.h"
#import "ODLandSecondCell.h"


@interface ODOthersInformationController : ODBaseViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property(nonatomic, copy) NSString *open_id;

@property(nonatomic, copy) NSString *phoneNumber;
@property(nonatomic, copy) NSString *password;

@property(nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property(nonatomic, strong) UICollectionView *collectionView;


@property(nonatomic, strong) ODUserModel *model;

@property(nonatomic, assign) BOOL isOther;

@end
