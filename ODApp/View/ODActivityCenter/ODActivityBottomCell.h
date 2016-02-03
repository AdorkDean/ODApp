//
//  ODActivityBottomCell.h
//  ODApp
//
//  Created by 刘培壮 on 16/2/3.
//  Copyright © 2016年 Odong Org. All rights reserved.
//
#import "ODActivityDetailBtn.h"
#import <UIKit/UIKit.h>

@interface ODActivityBottomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet ODActivityDetailBtn *shareBtn;
@property (weak, nonatomic) IBOutlet ODActivityDetailBtn *goodBtn;

@end
