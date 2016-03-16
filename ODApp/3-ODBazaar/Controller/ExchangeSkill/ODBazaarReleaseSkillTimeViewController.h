//
//  ODBazaarReleaseSkillTimeViewController.h
//  ODApp
//
//  Created by Odong-YG on 16/2/5.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODBaseViewController.h"
#import "ODBazaarReleaseSkillTimeViewCell.h"

@interface ODBazaarReleaseSkillTimeViewController : ODBaseViewController <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, copy) NSString *status;
@property(nonatomic, copy) NSString *swap_id;
@property(nonatomic) NSInteger index1;
@property(nonatomic) NSInteger index2;
@property(nonatomic) NSInteger index3;
@property(nonatomic, copy) void(^myBlock)(NSMutableArray *array);
@end
