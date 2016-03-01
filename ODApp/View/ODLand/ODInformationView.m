//
//  ODInformationView.m
//  ODApp
//
//  Created by zhz on 16/1/7.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODInformationView.h"

@implementation ODInformationView

- (void)awakeFromNib
{

    self.lineHeight.constant = 0.5;
    self.lineOneHeight.constant = 0.5;
    self.lineTwoHeight.constant = 0.5;
    self.lineThreeHeight.constant = 0.5;
}

+(instancetype)getView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"ODInformationView" owner:nil options:nil] firstObject];

    
}

@end
