//
//  ODUserBlackListCell.h
//  ODApp
//
//  Created by Odong-YG on 16/4/15.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ODBlacklistModel, ODUserBlackListCell;

@protocol ODUserBlackListCellDelegate <NSObject>

@optional

- (void)userBlackListCellDidClickBlackListButton:(ODUserBlackListCell *)cell;

@end

@interface ODUserBlackListCell : UITableViewCell

@property (nonatomic, strong) ODBlacklistModel *data;

@property (nonatomic, weak) id<ODUserBlackListCellDelegate> delegate;

@end
