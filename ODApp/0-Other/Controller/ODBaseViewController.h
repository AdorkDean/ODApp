//
//  ODBaseViewController.h
//  ODApp
//
//  Created by Odong-YG on 15/12/17.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ODClassMethod.h"
#import "ODProgressHUD.h"
#import "ODHttpTool.h"
#import "ODUserInformation.h"

#import "ODNoResultLabel.h"

@interface ODBaseViewController : UIViewController

@property (nonatomic, strong) ODNoResultLabel *noResultLabel;


@end
