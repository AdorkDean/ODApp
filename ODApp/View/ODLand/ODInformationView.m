//
//  ODInformationView.m
//  ODApp
//
//  Created by zhz on 16/1/7.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODInformationView.h"

@implementation ODInformationView

+ (instancetype)getView {
    return [[[NSBundle mainBundle] loadNibNamed:@"ODInformationView" owner:nil options:nil] firstObject];

}

@end
