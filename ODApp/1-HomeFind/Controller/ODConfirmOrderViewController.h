//
//  ODConfirmOrderViewController.h
//  ODApp
//
//  Created by Odong-YG on 16/3/31.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODBaseViewController.h"

@interface ODConfirmOrderViewController : ODBaseViewController

@property (nonatomic, strong) NSArray *datas;
/** 商品的ids */
@property (nonatomic,copy) NSString *shopcart_ids;


@end
