//
//  ODBaseViewController.h
//  ODApp
//
//  Created by Odong-YG on 15/12/17.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ODClassMethod.h"
#import "MBProgressHUD.h"
@interface ODBaseViewController : UIViewController <MBProgressHUDDelegate>
@property (nonatomic,strong)    MBProgressHUD *HUD;
//导航的标题视图
- (void)addTitleViewWithName:(NSString *)name;

//增加左右按钮
- (void)addItemWithName:(NSString *)name
                 target:(id)target
                 action:(SEL)action
                 isLeft:(BOOL)isLeft;
- (void)createProgressHUDWithAlpha:(float)alpha withAfterDelay:(float)afterDelay title:(NSString *)title ;
@end
