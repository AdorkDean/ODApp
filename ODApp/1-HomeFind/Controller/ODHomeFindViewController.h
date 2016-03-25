//
//  ODHomeFindViewController.h
//  ODApp
//
//  Created by Odong-YG on 15/12/17.
//  Copyright © 2015年 Odong Bracelet. All rights reserved.
//

#import "ODBaseViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "UIImageView+WebCache.h"
#import "ODCommumityViewController.h"
#import "ODPrecontractViewController.h"
#import "ODTabBarController.h"
#import "ODOthersInformationController.h"
#import "ODPersonalCenterViewController.h"
#import "ODLocationController.h"
#import "ODNewActivityDetailViewController.h"
#import "ODPublicWebViewController.h"
#import "ODUserInformation.h"
#import "ODDrawbackController.h"
#import "ODBazaarExchangeSkillCell.h"
#import "ODBazaarExchangeSkillModel.h"

@interface ODHomeFindViewController : ODBaseViewController <UIScrollViewDelegate, MAMapViewDelegate, AMapSearchDelegate>

/**
 *  体验中心ID
 */
@property(nonatomic, copy) NSString *storeId;


@end
