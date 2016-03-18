//
//  ODMyTaskController.h
//  ODApp
//
//  Created by zhz on 16/1/11.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODBaseViewController.h"
@class ODMyTaskController;

@protocol ODMyTaskControllerDelegate <NSObject>

@optional
- (void)taskVc:(ODMyTaskController *)vc didClickedPopMenu:(NSString *)type;

@end


@interface ODMyTaskController : ODBaseViewController

@property(nonatomic, copy) NSString *open_id;
@property(nonatomic, copy) NSString *isFirstRefresh;
@property(nonatomic, copy) NSString *isSecondRefresh;
@property(nonatomic, copy)void(^myBlock)(NSString *type);

@property (nonatomic, weak) id<ODMyTaskControllerDelegate> taskDelegate;

@end
