//
//  ODTakeOutCell.h
//  ODApp
//
//  Created by 王振航 on 16/3/22.
//  Copyright © 2016年 Odong Org. All rights reserved.
//  定外卖cell

#import <UIKit/UIKit.h>
@class ODTakeOutModel, ODTakeOutCell;

@protocol ODTakeOutCellDelegate <NSObject>

@optional
- (void)takeOutCell:(ODTakeOutCell *)cell didClickedButton:(ODTakeOutModel *)takeOut userInfo:(NSDictionary *)dict;

@end

@interface ODTakeOutCell : UITableViewCell

/** 模型数据 */
@property (nonatomic, strong) ODTakeOutModel *datas;

/** 代理 */
@property (nonatomic, weak) id<ODTakeOutCellDelegate> delegate;

@end
