//
//  ODDeliveryNoteViewController.h
//  ODApp
//
//  Created by Odong-YG on 16/4/1.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODBaseViewController.h"

@interface ODDeliveryNoteViewController : ODBaseViewController

@property(nonatomic, copy) void(^myBlock)(NSString *str);

@end
