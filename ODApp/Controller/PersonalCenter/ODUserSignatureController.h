//
//  ODUserSignatureController.h
//  ODApp
//
//  Created by zhz on 16/1/5.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODBaseViewController.h"

@interface ODUserSignatureController : ODBaseViewController


@property(nonatomic,copy)void(^getTextBlock)(NSString *text);

@property (nonatomic , copy) NSString *signature;



@end
