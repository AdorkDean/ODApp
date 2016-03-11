//
//  ODCommunityKeyWordSearchViewController.h
//  ODApp
//
//  Created by Odong-YG on 15/12/25.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODBaseViewController.h"
#import "ODCommunityBbsModel.h"
#import "ODCommunityCollectionCell.h"
#import "ODCommunityDetailViewController.h"
#import "ODCommunityShowPicViewController.h"
#import "MJRefresh.h"

@interface ODCommunityKeyWordSearchViewController : ODBaseViewController <UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate>

@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic ,strong) NSMutableDictionary *userInfoDic;
@property(nonatomic, strong) NSMutableArray *userArray;
@property(nonatomic, strong) UISearchBar *searchBar;
@property(nonatomic) NSInteger count;
@property(nonatomic, copy) NSString *keyText;
@property(nonatomic, strong) UILabel *noReusltLabel;

@end
