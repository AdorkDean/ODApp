//
//  ODOtherTopicViewController.h
//  ODApp
//
//  Created by Odong-YG on 16/1/18.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ODAPIManager.h"
#import "ODClassMethod.h"
#import "ODColorConversion.h"
#import "AFNetworking.h"
#import "ODCommunityModel.h"
#import "ODCommunityCollectionCell.h"
#import "ODCommunityHeaderView.h"
#import "ODCommunityDetailViewController.h"
#import "MJRefresh.h"


@interface ODOtherTopicViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *userArray;
@property(nonatomic,strong)AFHTTPRequestOperationManager *manager;
@property(nonatomic,strong)UIView *headView;
@property(nonatomic)NSInteger count;
@property(nonatomic,copy)NSString *refresh;
@property(nonatomic,copy)NSString *open_id;

@end
