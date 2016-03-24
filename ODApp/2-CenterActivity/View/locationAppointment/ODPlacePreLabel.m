//
//  ODPlacePreLabel.m
//  ODApp
//
//  Created by 刘培壮 on 16/3/3.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODPlacePreLabel.h"

@implementation ODPlacePreLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setUp];
}

- (void)setUp
{
    self.textColor = [UIColor colorWithRGBString:@"#8e8e8e" alpha:1];
    self.font = [UIFont systemFontOfSize:10.5];
}
@end

