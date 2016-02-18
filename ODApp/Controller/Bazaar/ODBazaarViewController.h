//
//  ODBazaarViewController.h
//  ODApp
//
//  Created by Odong-YG on 16/2/2.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODBaseViewController.h"
#import "ODBazaaeExchangeSkillViewController.h"
#import "ODBazaarRequestHelpViewController.h"
#import "ODBazaarReleaseSkillViewController.h"

@interface ODBazaarViewController : ODBaseViewController<UIScrollViewDelegate>

@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIView *lineView;
@property(nonatomic)NSInteger index;

@end
