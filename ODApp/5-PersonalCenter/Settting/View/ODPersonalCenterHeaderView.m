//
//  ODPersonalCenterHeaderView.m
//  ODApp
//
//  Created by 王振航 on 16/3/17.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODPersonalCenterHeaderView.h"
#import "ODUserModel.h"

#import <UIImageView+WebCache.h>
#import "ODReleaseController.h"
#import "ODPersonalCenterCollectionController.h"
#import "ODInformationController.h"
#import "ODCustomButton.h"
#import "ODOrderAndSellController.h"

@interface ODPersonalCenterHeaderView() <ODInformationControllerDelegate>

/** 头像 */
@property(nonatomic, weak) IBOutlet UIImageView *avatarImageView;
/** 名字 */
@property(nonatomic, weak) IBOutlet UILabel *nameLabel;
/** 签名 */
@property(nonatomic, weak) IBOutlet UILabel *signLabel;
/** headerView */
@property (nonatomic, weak) IBOutlet UIView *showInformationView;
/** 按钮组 */
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *userInformation;

@end

@implementation ODPersonalCenterHeaderView

+ (instancetype)headerView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

#pragma mark - 初始化方法
- (void)awakeFromNib
{
    self.autoresizingMask = UIViewAutoresizingNone;
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMessage:)];
    [self.showInformationView addGestureRecognizer:ges];
}

- (void)setUser:(ODUserModel *)user
{
    _user = user;

    // 头像
    UIImage *placeholderImage = [UIImage OD_circleImageNamed:@"titlePlaceholderImage"];
    __weakSelf;
    [self.avatarImageView sd_setImageWithURL:[NSURL OD_URLWithString:user.avatar] placeholderImage:placeholderImage options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image == nil) return;
        // 设置圆角
        weakSelf.avatarImageView.image = [image OD_circleImage];
    }];

    self.nameLabel.text = user.nick.length ? user.nick : @"您还未设置昵称";
    self.signLabel.text = user.nick.length ? user.sign : @"您还未设置签名";
    
    for (ODCustomButton *button in self.userInformation)
    {
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - ODInformationController 代理方法
- (void)infoVc:(ODInformationController *)infoVc DidChangedUserImage:(ODUserModel *)userModel
{
    ODUserModel *newUser = [[ODUserInformation sharedODUserInformation] getUserCache];
    [self setUser:newUser];
    [self setNeedsDisplay];
}

#pragma mark - 事件方法
- (void)buttonClick:(UIButton *)btn
{
    NSUInteger index = btn.od_x / (self.od_width * 0.25);
    UINavigationController *navVc = [self findCurrentCNavVc];
    switch (index) {
        case 0: {
            ODOrderAndSellController *vc = [[ODOrderAndSellController alloc] init];
            [navVc pushViewController:vc animated:YES];
        } break;
        case 1: {
            ODOrderAndSellController *vc = [[ODOrderAndSellController alloc] init];
            vc.isSell = YES;
            [navVc pushViewController:vc animated:YES];
        } break;
        case 2: {
            ODReleaseController *vc = [[ODReleaseController alloc] init];
            [navVc pushViewController:vc animated:YES];
        } break;
        case 3: {
            ODPersonalCenterCollectionController *vc = [[ODPersonalCenterCollectionController alloc] init];
            [navVc pushViewController:vc animated:YES];
        } break;
    }
}

/**
 *  查找当前的导航控制器
 */
- (UINavigationController *)findCurrentCNavVc
{
    UITabBarController *tabBarControler = (id)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *navigationController = tabBarControler.selectedViewController;
    return navigationController;
}

/**
 *  跳转至个人详情
 */
- (void)showMessage:(UITapGestureRecognizer *)gesture
{
    ODInformationController *vc = [[ODInformationController alloc] init];
    // 设置代理
    vc.delegate = self;
    [[self findCurrentCNavVc] pushViewController:vc animated:YES];
}

@end
