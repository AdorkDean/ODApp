//
//  ODCommunityHeaderView.h
//  ODApp
//
//  Created by 王振航 on 16/4/15.
//  Copyright © 2016年 Odong Org. All rights reserved.
//  点击社区头像,  headerView

#import <UIKit/UIKit.h>
@class ODUserModel;

@interface ODCommunityHeaderView : UICollectionViewCell

/** 模型 */
@property (nonatomic, strong) ODUserModel *data;

@end
