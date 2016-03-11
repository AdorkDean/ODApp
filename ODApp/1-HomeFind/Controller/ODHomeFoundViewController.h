//
//  ODHomeFoundViewController.h
//  ODApp
//
//  Created by Odong-YG on 15/12/17.
//  Copyright © 2015年 Odong Bracelet. All rights reserved.
//

#import "ODBaseViewController.h"

#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "UIImageView+WebCache.h"

#import "ODClassMethod.h"
#import "ODCommumityViewController.h"
#import "ODPrecontractViewController.h"
#import "ODTabBarController.h"
#import "ODcommunityCollectionCell.h"
#import "ODhomeViewCollectionReusableView.h"
#import "ODOthersInformationController.h"
#import "ODPersonalCenterViewController.h"
#import "ODHomeFoundFooterView.h"
#import "ODLocationController.h"
#import "ODFindJobController.h"
#import "ODNewActivityDetailViewController.h"
#import "ODFindFavorableController.h"
#import "ODUserInformation.h"

#import "ODDrawbackBuyerOneController.h"

@interface ODHomeFoundViewController : ODBaseViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, MAMapViewDelegate, AMapSearchDelegate>

@property(nonatomic, strong) UIButton *locationButton;

@property(nonatomic, strong) UICollectionView *collectionView;

@property(nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property(nonatomic, strong) ODhomeViewCollectionReusableView *rsusableView;
@property(nonatomic, strong) ODHomeFoundFooterView *footerView;

@property(nonatomic, strong) ODCommunityBbsModel *model;

//滚动窗口数组
@property(nonatomic, strong) NSMutableArray *pictureArray;
@property(nonatomic, strong) NSMutableArray *pictureIdArray;

//技能交换
@property(nonatomic, strong) NSMutableArray *dataArray;

@property(nonatomic, strong) NSArray *cityListArray;

@property(nonatomic, copy) NSString *centerName;
@property(nonatomic, copy) NSString *storeId;
@property(nonatomic, copy) NSString *centerTel;


@end
