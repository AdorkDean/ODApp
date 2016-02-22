//
//  ODRoundTimeDrawView.h
//  ODApp
//
//  Created by 刘培壮 on 16/2/22.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ODRoundTimeDrawView : UIView

/**
 *  选中状态的数组
 */
@property (nonatomic, strong) NSMutableArray *selectedArr;

/**
 *  第1个时间段是否空闲
 */
@property(nonatomic, assign) BOOL firstTimeIsFree;

/**
 *  第2个时间段是否空闲
 */
@property(nonatomic, assign) BOOL secondTimeIsFree;

/**
 *  第3个时间段是否空闲
 */
@property(nonatomic, assign) BOOL thirdTimeIsFree;

@end
