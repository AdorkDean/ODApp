//
//  ODOthersTaskController.h
//  ODApp
//
//  Created by 代征钏 on 16/1/18.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODBaseViewController.h"

#import "AFHTTPRequestOperationManager.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"


#import "ODAPIManager.h"
#import "ODBazaarModel.h"
#import "ODTaskCell.h"
#import "ODBazaarDetailViewController.h"



@interface ODOthersTaskController : ODBaseViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, copy) NSString *open_id;

@property (nonatomic, strong) UIView *headView;

@property (nonatomic, strong) UICollectionView *firstCollectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@property (nonatomic, strong) NSMutableArray *FirstDataArray;

@property (nonatomic , copy) NSString *type;

@property (nonatomic , assign) NSInteger firstPage; 

@end
