//
//  ODCenterDetailView.h
//  ODApp
//
//  Created by Bracelet on 16/3/17.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ODStoreDetailModel.h"

@interface ODCenterDetailView : UIView


@property (weak, nonatomic) IBOutlet UILabel *centerNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *centerTelLabel;

@property (weak, nonatomic) IBOutlet UIButton *centerTelButton;

@property (weak, nonatomic) IBOutlet UIButton *centerAddressButton;

@property (weak, nonatomic) IBOutlet UILabel *centerAddressLabel;

@property (weak, nonatomic) IBOutlet UILabel *centerTimeLabel;

@property (nonatomic, strong) ODStoreDetailModel *model;


+ (instancetype)centerDetailView;

@end
