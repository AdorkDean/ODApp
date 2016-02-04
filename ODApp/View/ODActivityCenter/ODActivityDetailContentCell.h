//
//  ODActivityDetailContentCell.h
//  ODApp
//
//  Created by 刘培壮 on 16/2/2.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ODActivityDetailContentCell : UITableViewCell

/**
 *  mark
 */
@property (weak, nonatomic) UIWebView *contentWebView;

/**
 *  cell的高度
 */
@property(nonatomic, assign) CGFloat height;

@end
