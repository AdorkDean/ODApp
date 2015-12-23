//
//  ODBaseViewController.h
//  ODApp
//
//  Created by Odong-YG on 15/12/17.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ODClassMethod.h"
#import "ODColorConversion.h"

@interface ODBaseViewController : UIViewController

//导航的标题视图
- (void)addTitleViewWithName:(NSString *)name;

//增加左右按钮
- (void)addItemWithName:(NSString *)name
                 target:(id)target
                 action:(SEL)action
                 isLeft:(BOOL)isLeft;
@end
