//
//  ODSkillDetailController.h
//  ODApp
//
//  Created by 代征钏 on 16/1/31.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODBaseViewController.h"

#import "AFNetworking.h"
#import "UIImageView+WebCache.h"

#import "ODSkillDetailReusableView.h"
#import "ODOrderController.h"
#import "ODAPIManager.h"
#import "ODSkillDetailModel.h"




@interface ODSkillDetailController : ODBaseViewController<UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, copy)NSString *personTitle;

@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *priceLabel;
@property (nonatomic, strong)UILabel *contentLabel;

@property (nonatomic, strong)UIScrollView *scrollView;

@property (nonatomic, assign)float *lastImageFrame;

@property (nonatomic, strong)AFHTTPRequestOperationManager *manager;
@property (nonatomic, strong)NSMutableArray *pictureArray;

@property (nonatomic, strong)ODSkillDetailModel *skillDetailModel;

@property (nonatomic, strong)UIView *payView;
@property (nonatomic, strong)UIButton *collectButton;
@property (nonatomic, strong)UIImageView *collectImageView;
@property (nonatomic, strong)UIButton *payButton;

@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)NSMutableArray *collectArray;



@end
