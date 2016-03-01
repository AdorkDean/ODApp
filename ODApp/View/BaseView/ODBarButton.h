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
            ODBarButtonTypeDefault = 0,
    /** 图左文右 */
            ODBarButtonTypeImageUp = 1,
    /** 图上文下 */
            ODBarButtonTypeImageLeft = 2,
    /** 文上图下 */
            ODBarButtonTypeTextUp = 3,
    /** 文左图右 */
            ODBarButtonTypeTextLeft = 4
};

@interface ODBarButton : UIButton

/**
 *  按钮类型
 */
@property(nonatomic, assign) ODBarButtonType barButtonType;

- (instancetype)initWithTarget:(id)target action:(SEL)action title:(NSString *)title;

+ (instancetype)barButtonWithTarget:(id)target action:(SEL)action title:(NSString *)title;

@end
