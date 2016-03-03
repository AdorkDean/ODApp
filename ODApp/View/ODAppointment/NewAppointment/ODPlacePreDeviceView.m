//
//  ODPlacePreDeviceView.m
//  ODApp
//
//  Created by 刘培壮 on 16/3/2.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODPlacePreDeviceView.h"
#import "ODActiveDeviceBtn.h"
#import "UIView+ODPlaceView.h"
#import "ODStoreDetailModel.h"

@implementation ODPlacePreDeviceView

- (void)setDevices:(NSArray *)devices
{
    if (_devices == devices)
    {
        return;
    }
    [self layoutIfNeeded];
    for (UIView *view in self.devicesView.subviews)
    {
        [view removeFromSuperview];
    }
    for (NSInteger i = 0; i < devices.count; i ++)
    {
        ODStoreDetailDeviceListModel *model = devices[i];
        ODActiveDeviceBtn *btn = [ODActiveDeviceBtn buttonWithType:UIButtonTypeCustom];
        [btn setTitle:model.name forState:UIControlStateNormal];
        btn.deviceId = model.id;
        btn.frame = CGRectMake((i % 4) * self.devicesView.od_width / 4, btn.od_height * (i / 4) , self.devicesView.od_width, btn.od_height);
        [self.devicesView addSubview:btn];
    }
    self.devicesViewHeightConstraint.constant = ((devices.count - 1) / 4 + 1) * 30;
    self.od_height = self.viewHeight;
    self.devicesView.od_height = self.devicesViewHeightConstraint.constant;
    [self.devicesView od_setBorder];
}

- (CGFloat)viewHeight
{
    [self layoutIfNeeded];
    return self.devicesViewHeightConstraint.constant + 28;
}

#pragma mark - ODActiveDeviceBtnDelegate

- (void)activeDeviceBtnClicked:(ODActiveDeviceBtn *)activeDeviceBtn
{
    if ([self.delegate respondsToSelector:@selector(placePreDeviceView:clickedActiveDeviceBtn:)])
    {
        [self.delegate placePreDeviceView:self clickedActiveDeviceBtn:activeDeviceBtn];
    }
}


@end
