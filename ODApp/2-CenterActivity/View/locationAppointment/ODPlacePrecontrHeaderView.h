//
//  ODPlacePrecontrHeaderView.h
//  ODApp
//
//  Created by 刘培壮 on 16/3/2.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ODPrecontrBtn.h"

@interface ODPlacePrecontrHeaderView : UIView
@property (weak, nonatomic) IBOutlet ODPrecontrBtn *startTimeBtn;
@property (weak, nonatomic) IBOutlet ODPrecontrBtn *endTimeBtn;
@property (weak, nonatomic) IBOutlet ODPrecontrBtn *placeBtn;

/** 视图高度 */
@property (nonatomic,assign) CGFloat viewHeight;
/**
 *  回复初始状态
 */
- (void)reback;
@end
