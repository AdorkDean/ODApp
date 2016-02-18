//
//  ODLandThirdCell.m
//  ODApp
//
//  Created by zhz on 16/2/18.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODLandThirdCell.h"

@implementation ODLandThirdCell

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self addViews];
    }
    return self;
}


- (void)addViews
{
   
    
    self.buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buyButton.frame = CGRectMake((self.frame.size.width - 150) / 4, 0, 50, 50);
    [self.buyButton setImage:[UIImage imageNamed:@"buy_icon"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.buyButton];
    
    
    self.releaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.releaseButton.frame = CGRectMake(((self.frame.size.width - 150) / 4)*2 + 50, 0, 50, 50);
    [self.releaseButton setImage:[UIImage imageNamed:@"yifabu_icon"] forState:UIControlStateNormal];

   [self.contentView addSubview:self.releaseButton];

    
    self.collectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.collectionButton.frame = CGRectMake(((self.frame.size.width - 150) / 4)*3 + 100, 0, 50, 50);
    [self.collectionButton setImage:[UIImage imageNamed:@"shoucang_icon"] forState:UIControlStateNormal];

    [self.contentView addSubview:self.collectionButton];

    
    
    UILabel *buyLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.buyButton.frame.origin.x, 45, 50, 20)];
    buyLabel.textAlignment = NSTextAlignmentCenter;
    buyLabel.font = [UIFont systemFontOfSize:13];
    buyLabel.text = @"已购买";
    [self.contentView addSubview:buyLabel];
    
    UILabel *releaseLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.releaseButton.frame.origin.x, 45, 50, 20)];
    releaseLabel.textAlignment = NSTextAlignmentCenter;
    releaseLabel.font = [UIFont systemFontOfSize:13];
    releaseLabel.text = @"已发布";
    [self.contentView addSubview:releaseLabel];

    UILabel *collectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.collectionButton.frame.origin.x, 45, 50, 20)];
    collectionLabel.textAlignment = NSTextAlignmentCenter;
    collectionLabel.font = [UIFont systemFontOfSize:13];
    collectionLabel.text = @"收藏";
    [self.contentView addSubview:collectionLabel];
    
    
    
    
}





@end
