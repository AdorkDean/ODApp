//
//  ODActiveDeviceBtn.h
//  ODApp
//
//  Created by 刘培壮 on 16/3/2.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ODActiveDeviceBtn;
@protocol ODActiveDeviceBtnDelegate <NSObject>

@optional
- (void)activeDeviceBtnClicked:(ODActiveDeviceBtn *)activeDeviceBtn;

@end

@interface ODActiveDeviceBtn : UIButton

/** deviceId */
@property (nonatomic,assign) NSInteger deviceId;

/** 设置代理 */
@property (nonatomic,weak) id <ODActiveDeviceBtnDelegate> delegate;

@end
