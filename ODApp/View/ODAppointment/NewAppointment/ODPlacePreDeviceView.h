//
//  ODPlacePreDeviceView.h
//  ODApp
//
//  Created by 刘培壮 on 16/3/2.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ODActiveDeviceBtn.h"

@class ODPlacePreDeviceView;

@protocol ODPlacePreDeviceViewDelegate <NSObject>

@optional
- (void)placePreDeviceView:(ODPlacePreDeviceView *)view clickedActiveDeviceBtn:(ODActiveDeviceBtn *)ActiveDeviceBtn;

@end

@interface ODPlacePreDeviceView : UIView <ODActiveDeviceBtnDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *devicesViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *devicesView;
/** 设备信xi */
@property (nonatomic,strong) NSArray *devices;

/** 高度 */
@property (nonatomic,assign) CGFloat viewHeight;

/** daili */
@property (nonatomic,weak) id <ODPlacePreDeviceViewDelegate> delegate;

@end
