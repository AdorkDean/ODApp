//
//  ODhomeViewCollectionReusableView.m
//  ODApp
//
//  Created by 代征钏 on 16/1/7.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODhomeViewCollectionReusableView.h"

@implementation ODhomeViewCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        
        self.cycleSecrollerView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height / 4.4 + 64)];
        
        [self addSubview:self.cycleSecrollerView];
        
        
        self.activityView = [ODClassMethod creatViewWithFrame:CGRectMake(0, 64 + kScreenSize.height / 4.4, kScreenSize.width, 195/2) tag:0 color:@"#ffffff"];
        [self addSubview:self.activityView];
        
        float spaceX = (kScreenSize.width - 40 * 2 - 40 * 4) / 3;

        self.lazyButton = [ODClassMethod creatButtonWithFrame:CGRectMake(40 - 20, 64 + kScreenSize.height / 4.4 + 20 - 10, 65, 80) target:self sel:nil tag:0 image:@"" title:nil font:0];
        
        UIImageView *lazyImageView = [ODClassMethod creatImageViewWithFrame:CGRectMake(40, 64 + kScreenSize.height / 4.4 + 20, 35, 21) imageName:@"首页-去偷懒icon" tag:0];
        
        [self addSubview:lazyImageView];
        [self addSubview:self.lazyButton];
        
        self.lazyLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(35, 64 + kScreenSize.height / 4.4 + 60, 40, 15) text:@"去偷懒" font:12 alignment:@"center" color:@"#484848" alpha:1 maskToBounds:NO];
        self.lazyLabel.userInteractionEnabled = NO;
        [self addSubview:self.lazyLabel];
        
        self.chatButton = [ODClassMethod creatButtonWithFrame:CGRectMake(40 + 40 + spaceX - 20, 64 + kScreenSize.height / 4.4 + 15 - 10, 65, 80) target:self sel:nil tag:0 image:@"" title:nil font:0];
        UIImageView *chatImageView = [ODClassMethod creatImageViewWithFrame:CGRectMake(40 + 40 + spaceX, 64 + kScreenSize.height / 4.4 + 15, 33.5f, 36) imageName:@"首页-去版聊icon" tag:0];
        [self addSubview:chatImageView];
        [self addSubview:self.chatButton];
        
        self.chatLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(35 + 40 + spaceX, 64 + kScreenSize.height / 4.4 + 60, 40, 15) text:@"去版聊" font:12 alignment:@"center" color:@"#484848" alpha:1 maskToBounds:NO];
        self.chatLabel.userInteractionEnabled = NO;
        [self addSubview:self.chatLabel];
        
        self.activityButton = [ODClassMethod creatButtonWithFrame:CGRectMake(40 + 40 * 2 + spaceX * 2 - 20, 64 + kScreenSize.height / 4.4 + 15 - 10, 65, 80) target:self sel:nil tag:0 image:@"" title:nil font:0];
        UIImageView *activityImageView = [ODClassMethod creatImageViewWithFrame:CGRectMake(40 + 40 * 2 + spaceX * 2, 64 + kScreenSize.height / 4.4 + 15, 27, 31.5f) imageName:@"首页-找活动icon" tag:0];
        [self addSubview:activityImageView];
        [self addSubview:self.activityButton];
        
        self.activityLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(35 + 40 * 2 + spaceX * 2, 64 + kScreenSize.height / 4.4 + 60, 40, 15) text:@"找活动" font:12 alignment:@"center" color:@"#484848" alpha:1 maskToBounds:NO];
        self.activityLabel.userInteractionEnabled = NO;
        [self addSubview:self.activityLabel];
        
        self.placeButton = [ODClassMethod creatButtonWithFrame:CGRectMake(40 + 40 * 3 + spaceX * 3 - 20, 64 + kScreenSize.height / 4.4 + 15 - 10, 65, 80) target:self sel:nil tag:0 image:@"" title:nil font:0];
        UIImageView *placeImageView = [ODClassMethod creatImageViewWithFrame:CGRectMake(40 + 40 * 3 + spaceX * 3, 64 + kScreenSize.height / 4.4 + 15, 30, 30) imageName:@"首页-约场地icon" tag:0];
        [self addSubview:placeImageView];
        [self addSubview:self.placeButton];
        
        self.placeLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(35 + 40 * 3 + spaceX * 3, 64 + kScreenSize.height / 4.4 + 60, 40, 15) text:@"约场地" font:12 alignment:@"center" color:@"#484848" alpha:1 maskToBounds:NO];
        self.placeLabel.userInteractionEnabled = NO;
        [self addSubview:self.placeLabel];

        self.themeView = [ODClassMethod creatViewWithFrame:CGRectMake(0, 64 + kScreenSize.height / 4.4 + 195 / 2, kScreenSize.width, 24) tag:0 color:@"#f3f3f3"];
        [self addSubview:self.themeView];

        self.themeImageView = [ODClassMethod creatImageViewWithFrame:CGRectMake(kScreenSize.width * 31/75, 64 + kScreenSize.height / 4.4 + 195 / 2 + 6, 13, 12) imageName:@"首页最新话题icon" tag:0];
        [self addSubview:self.themeImageView ];
        
        self.themeLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(kScreenSize.width * 31/75 + 13 + 4, 64 + kScreenSize.height / 4.4 + 195 / 2 + 6, 60, 12) text:@"最热话题" font:12 alignment:@"left" color:@"#484848" alpha:1 maskToBounds:NO];
        [self addSubview:self.themeLabel];
    }
    
    return self;
    
}


@end
