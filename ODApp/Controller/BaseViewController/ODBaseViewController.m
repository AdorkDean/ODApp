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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
}

#pragma mark - 创建提示信息
- (void)createProgressHUDWithAlpha:(float)alpha withAfterDelay:(float)afterDelay title:(NSString *)title
{
    
    self.HUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];

    self.HUD.delegate  = self;
    
    self.HUD.color = [UIColor colorWithHexString:@"#000000" alpha:alpha];
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
