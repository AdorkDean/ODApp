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

#import "ODMySellController.h"
#import "ODMyOrderController.h"
#import "ODReleaseController.h"
#import "ODPersonalCenterCollectionController.h"
#import "ODInformationController.h"

@interface ODPersonalCenterHeaderView() <ODInformationControllerDelegate>

@property(weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property(weak, nonatomic) IBOutlet UILabel *nameLabel;
@property(weak, nonatomic) IBOutlet UILabel *signLabel;

@property (weak, nonatomic) IBOutlet UIView *showInformationView;
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *userInformation;

@end

@implementation ODPersonalCenterHeaderView

+ (instancetype)headerView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

- (void)setUser:(ODUserModel *)user
{
    _user = user;
    
    if (_user != user) {
        _user = user;
    }
    
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMessage:)];
    [self.showInformationView addGestureRecognizer: ges];
    
    // 头像
    UIImage *placeholderImage = [UIImage OD_circleImageNamed:@"titlePlaceholderImage"];
    __weakSelf;
    [self.avatarImageView sd_setImageWithURL:[NSURL OD_URLWithString:user.avatar] placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image == nil) return;
        // 设置圆角
        weakSelf.avatarImageView.image = [image OD_circleImage];
    }];

    self.nameLabel.text = user.nick.length ? user.nick : @"您还未设置昵称";
    self.signLabel.text = user.nick.length ? user.sign : @"您还未设置签名";
    
    for (UIButton *button in self.userInformation)
    {
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)buttonClick:(UIButton *)btn
{
    NSUInteger index = btn.od_x / (self.od_width * 0.25);
    
    
    UINavigationController *navVc = [self findOwnNavVc];
    switch (index) {
        case 0: {
            ODMyOrderController *vc = [[ODMyOrderController alloc] init];
            [navVc pushViewController:vc animated:YES];
        }
        break;
        case 1: {
            ODMySellController *vc = [[ODMySellController alloc] init];
            [navVc pushViewController:vc animated:YES];
        }
        break;
        case 2: {
            ODReleaseController *vc = [[ODReleaseController alloc] init];
            [navVc pushViewController:vc animated:YES];
        }
        break;
        case 3: {
            ODPersonalCenterCollectionController *collection = [[ODPersonalCenterCollectionController alloc]init];
            [navVc pushViewController:collection animated:YES];
        }
        break;
        default:
        break;
    }
}

- (UINavigationController *)findOwnNavVc
{
    UITabBarController *tabBarControler = (id)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *navigationController = tabBarControler.selectedViewController;
    return navigationController;
}

- (void)showMessage:(UITapGestureRecognizer *)gesture
{
    ODInformationController *vc = [[ODInformationController alloc] init];
    // 设置代理
    vc.delegate = self;
    [[self findOwnNavVc] pushViewController:vc animated:YES];
}

- (void)infoVc:(ODInformationController *)infoVc DidChangedUserImage:(ODUserModel *)userModel
{
    ODUserModel *newUser = [[ODUserInformation sharedODUserInformation] getUserCache];
    
    [self setUser:newUser];
    [self setNeedsDisplay];
}

@end
