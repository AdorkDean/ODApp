//
//  ODLocationController.h
//  ODApp
//
//  Created by Bracelet on 16/2/2.
//  Copyright © 2016年 Odong Bracelet. All rights reserved.
//

#import "ODBaseViewController.h"

#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

#import "AFNetworking.h"

#import "ODUserInformation.h"

#import "ODLocationCell.h"
#import "ODLocationModel.h"

@interface ODLocationController : ODBaseViewController <MAMapViewDelegate, AMapSearchDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>


@property(nonatomic, strong) NSMutableArray *cityListArray;
@property(nonatomic, strong) NSMutableArray *cityIdArray;

@property(nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property(nonatomic, strong) UICollectionView *collectionView;

@property(nonatomic, strong) AFHTTPRequestOperationManager *manager;


@end
