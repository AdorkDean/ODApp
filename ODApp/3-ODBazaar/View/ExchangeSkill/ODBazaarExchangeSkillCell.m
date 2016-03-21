//
//  ODBazaarExchangeSkillCell.m
//  ODApp
//
//  Created by 王振航 on 16/3/14.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODBazaarExchangeSkillCell.h"
#import "ODBazaarExchangeSkillModel.h"
#import "ODHomeInfoModel.h"
#import "UIButton+WebCache.h"
#import "ODBazaarPhotosView.h"
#import "ODOthersInformationController.h"
#import "ODUserInformation.h"

@interface ODBazaarExchangeSkillCell()

@property (nonatomic, weak) IBOutlet UIButton *avatarButton;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *nickLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (nonatomic, weak) IBOutlet UILabel *contentLabel;
@property (nonatomic, weak) IBOutlet UILabel *loveLabel;
@property (nonatomic, weak) IBOutlet UILabel *shareLabel;
@property (nonatomic, weak) IBOutlet UIImageView *genderImageView;
/** 配图 */
@property (nonatomic, weak) ODBazaarPhotosView *photosView;

@end

@implementation ODBazaarExchangeSkillCell

#pragma mark - 懒加载
- (ODBazaarPhotosView *)photosView
{
    if (_photosView == nil) {
        ODBazaarPhotosView *photosView = [[ODBazaarPhotosView alloc] init];
        [self.contentView addSubview:photosView];
        _photosView = photosView;
    }
    return _photosView;
}

#pragma mark - 初始化方法
/**
 *  初始化控件
 */
- (void)awakeFromNib
{
    // 取消选中样式
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.genderImageView.contentMode = UIViewContentModeCenter;
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#484848" alpha:1];
    self.priceLabel.textColor = [UIColor colorWithHexString:@"#ff6666" alpha:1];
    self.nickLabel.textColor = [UIColor colorWithHexString:@"#8e8e8e" alpha:1];
    self.contentLabel.textColor = [UIColor colorWithHexString:@"#484848" alpha:1];
    self.loveLabel.textColor = [UIColor colorWithHexString:@"#8e8e8e" alpha:1];
    self.shareLabel.textColor = [UIColor colorWithHexString:@"#8e8e8e" alpha:1];
}

/**
 *  设置数据
 */
- (void)setModel:(ODBazaarExchangeSkillModel *)model
{
    _model = model;
    
    // 设置数据
    UIImage *placeholderImage = [UIImage OD_circleImageNamed:@"titlePlaceholderImage"];
    __weakSelf;
    // 头像
    [self.avatarButton sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:model.user.avatar] forState:UIControlStateNormal placeholderImage:placeholderImage options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image == nil) return;
        // 设置圆角
        [weakSelf.avatarButton setBackgroundImage:[image OD_circleImage] forState:UIControlStateNormal];
    }];
    // 监听点击
    [self.avatarButton addTarget:self action:@selector(clickavatarButton) forControlEvents:UIControlEventTouchUpInside];
    
    self.titleLabel.text = model.title;
    self.priceLabel.text = [[[[NSString stringWithFormat:@"%.2f",model.price] stringByAppendingString:@"元"] stringByAppendingString:@"/"]stringByAppendingString:model.unit];
    self.nickLabel.text = model.user.nick;
    self.contentLabel.text = model.content;
    
    self.loveLabel.text = [NSString stringWithFormat:@"%d",model.love_num];
    self.shareLabel.text = [NSString stringWithFormat:@"%d",model.share_num];
    if (model.user.gender == ODBazaarUserGenderTypeWoman) {
        self.genderImageView.image = [UIImage imageNamed:@"icon_woman"];
    }else{
        self.genderImageView.image = [UIImage imageNamed:@"icon_man"];
    }
    
    // 设置配图
    if (model.imgs_small.count) {
        self.photosView.hidden = NO;
        self.photosView.frame = model.photosFrame;
        self.photosView.skillModel = model;
    } else {
        self.photosView.hidden = YES;
    }
}

/**
 *  设置cell间隙
 */
- (void)setFrame:(CGRect)frame
{
    frame.size.height -= ODBazaaeExchangeCellMargin;
    [super setFrame:frame];
}   

#pragma mark - 事件方法
/**
 *  点击头像按钮
 */
- (void)clickavatarButton
{
    ODOthersInformationController *vc = [[ODOthersInformationController alloc] init];
    // 取出open_id
    NSString *open_id = self.model.user.open_id;
    vc.open_id = open_id;
    // 如果不是自己, 可以跳转
    if (![[ODUserInformation sharedODUserInformation].openID isEqualToString:open_id])
    {
        UITabBarController *tabBarControler = (id)[UIApplication sharedApplication].keyWindow.rootViewController;
        UINavigationController *navigationController = tabBarControler.selectedViewController;
        [navigationController pushViewController:vc animated:YES];
    }
}

@end
