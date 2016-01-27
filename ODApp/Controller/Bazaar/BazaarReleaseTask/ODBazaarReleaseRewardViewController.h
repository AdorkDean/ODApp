//
//  ODBazaarReleaseRewardViewController.h
//  ODApp
//
//  Created by Odong-YG on 16/1/4.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODBaseViewController.h"
#import "ODTabBarController.h"
#import "ODAPIManager.h"
#import "AFNetworking.h"
#import "ODBazaarRewardCollectionCell.h"

@interface ODBazaarReleaseRewardViewController : ODBaseViewController<UICollectionViewDataSource,UICollectionViewDelegate,UITextFieldDelegate>

@property(nonatomic,strong)UIView *headView;
@property(nonatomic,strong)UILabel *taskRewardLabel;
@property(nonatomic,strong)AFHTTPRequestOperationManager *manager;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *idArray;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UITextField *textField;
@property(nonatomic)NSInteger count;
@property(nonatomic,copy)void(^taskRewardBlock)(NSString *name);
@end
