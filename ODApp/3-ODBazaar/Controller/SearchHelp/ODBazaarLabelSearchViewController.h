//
//  ODBazaarLabelSearchViewController.h
//  ODApp
//
//  Created by Odong-YG on 15/12/21.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODBaseViewController.h"
#import "ODBazaarCollectionCell.h"
#import "MJRefresh.h"
#import "ODBazaarModel.h"
#import "ODBazaarDetailViewController.h"
#import "ODBazaarRequestHelpModel.h"


@interface ODBazaarLabelSearchViewController : ODBaseViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UITextFieldDelegate>

@property(nonatomic, strong) UISearchBar *searchBar;
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic) NSInteger count;
@property(nonatomic, strong) UILabel *noReusltLabel;

@end
