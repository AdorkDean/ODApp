//
//  DataButton.m
//  ODApp
//
//  Created by zhz on 16/2/1.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "DataButton.h"

@implementation DataButton

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self addViews];
    }
    return self;

}

- (void)addViews{
    
    
    
    self.backgroundColor = [UIColor whiteColor];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 0;
    self.layer.borderWidth = 1;

    
    
    self.dataLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, self.frame.size.width - 20, 20)];
    self.dataLabel.textAlignment = NSTextAlignmentCenter;
    self.dataLabel.font = [UIFont systemFontOfSize:12];
    self.dataLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:self.dataLabel];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, self.frame.size.width - 20, 10)];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.font = [UIFont systemFontOfSize:10];
    self.timeLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:self.timeLabel];

    
    
    
}

@end
