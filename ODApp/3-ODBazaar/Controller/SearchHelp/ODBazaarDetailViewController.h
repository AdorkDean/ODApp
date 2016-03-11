//
//  ODBazaarDetailViewController.h
//  ODApp
//
//  Created by Odong-YG on 15/12/29.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODBaseViewController.h"
#import "ODTabBarController.h"
#import "ODClassMethod.h"
#import "ODHelp.h"
#import "UIButton+WebCache.h"
#import "ODBazaarDetailModel.h"
#import "ODBazaarDetailLayout.h"
#import "ODBazaarDetailCollectionCell.h"
#import "UIImageView+WebCache.h"
#import "ODPersonalCenterViewController.h"
#import "ODOthersInformationController.h"

@interface ODBazaarDetailViewController : ODBaseViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextViewDelegate,UMSocialUIDelegate>

@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, strong) NSMutableArray *picArray;
@property(nonatomic, strong) NSArray *applys;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIView *userView;
@property(nonatomic, strong) UIView *taskTopView;
@property(nonatomic, strong) UIView *taskBottomView;
@property(nonatomic, strong) UILabel *taskContentLabel;
@property(nonatomic, strong) UILabel *allLabel;
@property(nonatomic, strong) UIImageView *allImageView;
@property(nonatomic, strong) UIView *allView;
@property(nonatomic, strong) NSString *task_status_name;
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) UIButton *taskButton;
@property(nonatomic, strong) UIButton *shareButton;
@property(nonatomic, copy) NSString *open_id;
@property(nonatomic, copy) NSString *task_id;
@property(nonatomic) NSInteger num;
@property(nonatomic, copy) void(^myBlock)(NSString *del);
@property(nonatomic, strong) UIView *evaluationView;
@property(nonatomic, strong) UITextView *evaluationTextView;
@property(nonatomic, strong) UILabel *placeholderLabel;
@end
