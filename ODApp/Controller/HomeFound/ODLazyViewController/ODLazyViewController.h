//
//  ODLazyViewController.h
//  ODApp
//
//  Created by 代征钏 on 16/1/4.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODBaseViewController.h"

#import "ODTabBarController.h"
#import "ODBazaarViewController.h"
#import "ODBazaarReleaseTaskViewController.h"
#import "ODUserInformation.h"

@interface ODLazyViewController : ODBaseViewController<UIScrollViewDelegate>

@property (nonatomic, strong)UIView *headView;

@property (nonatomic, strong)UIScrollView *scrollView;

@property (nonatomic)BOOL isJob;


@end
