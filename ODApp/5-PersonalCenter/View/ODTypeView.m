//
//  ODTypeView.m
//  ODApp
//
//  Created by zhz on 16/1/12.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODTypeView.h"

@implementation ODTypeView

+ (instancetype)getView {
    return [[[NSBundle mainBundle] loadNibNamed:@"ODTypeView" owner:nil options:nil] firstObject];

}

@end
