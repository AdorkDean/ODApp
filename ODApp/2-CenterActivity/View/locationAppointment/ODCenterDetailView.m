//
//  ODCenterDetailView.m
//  ODApp
//
//  Created by Bracelet on 16/3/17.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODCenterDetailView.h"

@implementation ODCenterDetailView

+ (instancetype)centerDetailView {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

- (void)awakeFromNib {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 5;
    self.layer.borderColor = [UIColor lineColor].CGColor;
    self.layer.borderWidth = 0.5f;
}

- (void)setModel:(ODStoreDetailModel *)model {
    self.centerNameLabel.text = model.name;
    self.centerTelLabel.text = model.tel;
    self.centerAddressLabel.text = model.address;
    self.centerTimeLabel.text = model.business_hours;
}


@end
