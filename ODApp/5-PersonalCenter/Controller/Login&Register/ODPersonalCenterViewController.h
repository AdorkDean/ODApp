//
//  ODPersonalCenterViewController.h
//  ODApp
//
//  Created by Odong-YG on 15/12/17.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//


#import "ODBaseViewController.h"

#import "ODHomeFindViewController.h"

@protocol ODPersonalCenterVCDelegate <NSObject>

- (void)personalHasLoginSuccess;

@end

@interface ODPersonalCenterViewController : ODBaseViewController

/**
 *  代理
 */
@property(nonatomic, weak) id <ODPersonalCenterVCDelegate> delegate;


@end
