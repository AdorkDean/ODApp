//
//  ODLazyViewController.h
//  ODApp
//
//  Created by Bracelet on 16/1/4.
//  Copyright © 2016年 Odong Bracelet. All rights reserved.
//

#import "ODBaseViewController.h"

#import "ODTabBarController.h"
#import "ODBazaarViewController.h"
#import "ODBazaarReleaseTaskViewController.h"
#import "ODUserInformation.h"

#import "ODPersonalCenterViewController.h"

@interface ODLazyViewController : ODBaseViewController<UIScrollViewDelegate>

@property (nonatomic, strong)UIScrollView *scrollView;

@property (nonatomic)BOOL isJob;



@end
