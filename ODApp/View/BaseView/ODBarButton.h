//
//  ODBarButton.h
//  ODApp
//
//  Created by 刘培壮 on 16/1/31.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ODBarButtonType) {
    /** 默认 */
    ODBarButtonDefault = 0,
    /** 图左文右 */
    ODBarButtonImageUp = 1,
    /** 图上文下 */
    ODBarButtonImageLeft = 2,
    /** 文上图下 */
    ODBarButtonTextUp = 3,
    /** 文左图右 */
    ODBarButtonTextLeft = 4
};
@interface ODBarButton : UIButton

/**
 *  按钮类型
 */
@property(nonatomic, assign) ODBarButtonType barButtonType;

@end
