//
//  ODCommunityShowPicViewController.h
//  ODApp
//
//  Created by Odong-YG on 16/2/2.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODBaseViewController.h"
#import "UIImageView+WebCache.h"
#import "ODBazaarPicCollectionViewCell.h"

@interface ODCommunityShowPicViewController : ODBaseViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property(nonatomic, strong) NSArray *photos;
@property(nonatomic, assign) NSUInteger selectedIndex;
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) UILabel *label;
@property(nonatomic, copy) NSString *skill;
@end
