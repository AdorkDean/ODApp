//
//  ODHomeFoundViewController.h
//  ODApp
//
//  Created by Odong-YG on 15/12/17.
//  Copyright © 2015年 Odong Bracelet. All rights reserved.
//

#import "ODBaseViewController.h"

#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "UIImageView+WebCache.h"
#import "ODClassMethod.h"
#import "ODCommumityViewController.h"
#import "ODPrecontractViewController.h"
#import "ODTabBarController.h"
#import "ODcommunityCollectionCell.h"
#import "ODhomeViewCollectionReusableView.h"
#import "ODOthersInformationController.h"
#import "ODPersonalCenterViewController.h"
#import "ODHomeFoundFooterView.h"
#import "ODLocationController.h"
#import "ODFindJobController.h"
#import "ODNewActivityDetailViewController.h"
#import "ODFindFavorableController.h"
#import "ODUserInformation.h"
#import "ODDrawbackController.h"
#import "ODBazaarExchangeSkillCell.h"

@interface ODHomeFoundViewController : ODBaseViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, MAMapViewDelegate, AMapSearchDelegate>

/**
 *  体验中心ID
 */
@property(nonatomic, copy) NSString *storeId;


@end
