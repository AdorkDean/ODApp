//
//  ODBaseViewController.m
//  ODApp
//
//  Created by Odong-YG on 15/12/17.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODBaseViewController.h"

@interface ODBaseViewController ()

@end

@implementation ODBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)addTitleViewWithName:(NSString *)name {
    
    UILabel *titleLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(0, 0, 100, 30) text:name font:17 alignment:@"center" color:@"#000000" alpha:1];
    titleLabel.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = titleLabel;
}

- (void)addItemWithName:(NSString *)name target:(id)target action:(SEL)action isLeft:(BOOL)isLeft {
    
    UIButton *button = [ODClassMethod creatButtonWithFrame:CGRectMake(0, 0, 100, 30) target:target sel:action tag:0 image:nil title:name font:17];
    button.backgroundColor = [UIColor clearColor];
    [button setTitleColor:[UIColor colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    if (isLeft) {
        self.navigationItem.leftBarButtonItem = item;
    }else {
        self.navigationItem.rightBarButtonItem = item;
    }
}
#pragma mark - 创建提示信息
- (void)createProgressHUDWithAlpha:(float)alpha withAfterDelay:(float)afterDelay title:(NSString *)title
{
    
    self.HUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];

    self.HUD.delegate  = self;
    
    self.HUD.color = [UIColor colorWithHexString:@"#8e8e8e" alpha:alpha];
    self.HUD.mode = MBProgressHUDModeText;
    self.HUD.labelText = title;
    self.HUD.margin = 8.f;
    self.HUD.yOffset = 150.f;
    self.HUD.removeFromSuperViewOnHide = YES;
    [self.HUD hide:YES afterDelay:afterDelay];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
