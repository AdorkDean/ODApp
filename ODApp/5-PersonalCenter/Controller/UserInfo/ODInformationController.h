//
//  ODInformationController.h
//  ODApp
//
//  Created by zhz on 16/1/7.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODBaseViewController.h"
@class ODInformationController, ODUserModel;

@protocol ODInformationControllerDelegate <NSObject>

@optional

- (void)infoVc:(ODInformationController *)infoVc DidChangedUserImage:(ODUserModel *)userModel;

@end

@interface ODInformationController : ODBaseViewController

/** 代理 */
@property (nonatomic, weak) id <ODInformationControllerDelegate> delegate;

@end
