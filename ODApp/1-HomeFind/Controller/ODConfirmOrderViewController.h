//
//  ODConfirmOrderViewController.h
//  ODApp
//
//  Created by Odong-YG on 16/3/31.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODPayController.h"

@interface ODConfirmOrderViewController : ODPayController

@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, strong) NSString *takeOutID;
@property (nonatomic, copy) NSString *order_no;
@property (nonatomic, strong) NSMutableDictionary *dict;

@end
