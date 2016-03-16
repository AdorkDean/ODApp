//
//  ODIndentDetailTopView.h
//  ODApp
//
//  Created by Bracelet on 16/3/15.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ODOrderDetailModel.h"

@interface ODIndentDetailTopView : UIView

@property (weak, nonatomic) IBOutlet UILabel *orderStateLabel;

@property (nonatomic, strong) ODOrderDetailModel *model;

+ (instancetype)detailTopView;

@end
