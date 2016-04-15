//
//  ODCommunityHeaderView.m
//  ODApp
//
//  Created by 王振航 on 16/4/15.
//  Copyright © 2016年 Odong Org. All rights reserved.
//  点击社区头像,  headerView
#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS

#import "ODCommunityHeaderView.h"
#import "ODUserModel.h"
#import "ODHttpTool.h"
#import "ODProgressHUD.h"

#import <UIImageView+WebCache.h>
#import <Masonry.h>

@interface ODCommunityHeaderView()

/** 头像 */
@property (nonatomic, weak) UIImageView *avatarView;
/** 昵称 */
@property (nonatomic, weak) UILabel *nickLabel;
/** 签名 */
@property (nonatomic, weak) UILabel *signLabel;
/** 黑名单 */
@property (nonatomic, weak) UIButton *blackListButton;

@end

static CGFloat const margin = 10.0;
static CGFloat const padding = 17.5;
static CGFloat nickfontSize = 12.0f;
static CGFloat signfontSize = 10.0f;

@implementation ODCommunityHeaderView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        // 头像
        UIImageView *avatarView = [[UIImageView alloc] init];
        [self.contentView addSubview:avatarView];
        self.avatarView = avatarView;
        [avatarView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(margin);
            make.left.equalTo(self).offset(2 * margin);
            make.size.offset(CGSizeMake(60, 60));
        }];
        // 黑名单按钮
        UIButton *blackListButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [blackListButton setTitle:@"加入黑名单" forState:UIControlStateNormal];
        blackListButton.titleLabel.font = [UIFont systemFontOfSize:nickfontSize];
        [blackListButton setTitleColor:[UIColor colorGreyColor] forState:UIControlStateNormal];
        [self.contentView addSubview:blackListButton];
        self.blackListButton = blackListButton;
        [blackListButton makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-margin);
            make.size.equalTo(CGSizeMake(80, 30));
        }];
        // 拉黑功能
        [blackListButton addTarget:self action:@selector(addBlackList) forControlEvents:UIControlEventTouchUpInside];
        
        // 昵称
        UILabel *nickLabel = [[UILabel alloc] init];
        nickLabel.textColor = [UIColor blackColor];
        nickLabel.font = [UIFont systemFontOfSize:nickfontSize];
        [self.contentView addSubview:nickLabel];
        self.nickLabel = nickLabel;
        [nickLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(padding);
            make.left.equalTo(avatarView.right).offset(padding);
            make.right.equalTo(blackListButton.left).offset(-margin);
        }];
        // 签名
        UILabel *signLabel = [[UILabel alloc] init];
        signLabel.textColor = [UIColor colorGreyColor];
        signLabel.font = [UIFont systemFontOfSize:signfontSize];
        [self.contentView addSubview:signLabel];
        signLabel.numberOfLines = 2;
        self.signLabel = signLabel;
        [signLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nickLabel.bottom).offset(margin);
            make.left.equalTo(nickLabel);
            make.right.equalTo(blackListButton.left).offset(-margin);
        }];
    }
    return self;
}

- (void)setData:(ODUserModel *)data
{
    _data = data;
    
    __weakSelf;
    [self.avatarView sd_setImageWithURL:[NSURL OD_URLWithString:data.avatar] placeholderImage:[UIImage imageNamed:@"titlePlaceholderImage"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (!image) return;
        [weakSelf.avatarView setImage:[image OD_circleImage]];
    }];
    self.nickLabel.text = data.nick;
    self.signLabel.text = data.sign;
}

#pragma mark - IBActions
- (void)addBlackList
{
    // 拼接参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"reject_user_open_id"] = self.data.open_id;
    params[@"act"] = @"add";
    [ODHttpTool getWithURL:ODDocUserReject parameters:params modelClass:[NSObject class] success:^(id model) {
        [ODProgressHUD showSuccessWithStatus:@"拉黑成功"];
        
        UITabBarController *tabBarVc = (id)[UIApplication sharedApplication].keyWindow.rootViewController;
        UINavigationController *navVc = tabBarVc.selectedViewController;
        [navVc popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
    }];
    // 刷新社区
    [[NSNotificationCenter defaultCenter] postNotificationName:ODNotificationBlackListRefresh object:nil];
}

@end
