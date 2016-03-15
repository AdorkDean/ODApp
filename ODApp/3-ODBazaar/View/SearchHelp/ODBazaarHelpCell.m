//
//  ODBazaarHelpCell.m
//  ODApp
//
//  Created by 王振航 on 16/3/15.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODBazaarHelpCell.h"
#import "ODBazaarRequestHelpModel.h"
#import "ODOthersInformationController.h"

#import <UIButton+WebCache.h>

@interface ODBazaarHelpCell()

@property(weak, nonatomic) IBOutlet UIButton *avatarButton;
@property(weak, nonatomic) IBOutlet UILabel *titleLabel;
@property(weak, nonatomic) IBOutlet UILabel *contentLabel;
@property(weak, nonatomic) IBOutlet UILabel *nameLabel;
@property(weak, nonatomic) IBOutlet UILabel *timeLabel;
@property(weak, nonatomic) IBOutlet UILabel *statusLabel;
@end

@implementation ODBazaarHelpCell

#pragma mark - 初始化方法
- (void)awakeFromNib {
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#484848" alpha:1];
    self.contentLabel.textColor = [UIColor colorWithHexString:@"#8e8e8e" alpha:1];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"#000000" alpha:1];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"#ff6666" alpha:1];
    self.statusLabel.layer.masksToBounds = YES;
    self.statusLabel.layer.cornerRadius = 5;
    self.statusLabel.textColor = [UIColor colorWithHexString:@"#484848" alpha:1];
    self.statusLabel.backgroundColor = [UIColor colorWithHexString:@"#ffd701" alpha:1];
}

/**
 *  设置数据
 */
- (void)setModel:(ODBazaarRequestHelpTasksModel *)model
{
    _model = model;
    
    // 设置数据
    UIImage *placeholderImage = [UIImage OD_circleImageNamed:@"titlePlaceholderImage"];
    __weakSelf;
    // 头像
    [self.avatarButton sd_setBackgroundImageWithURL: [NSURL OD_URLWithString:model.avatar] forState:UIControlStateNormal placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image == nil) return;
        // 设置圆角
        [weakSelf.avatarButton setBackgroundImage:[image OD_circleImage] forState:UIControlStateNormal];
    }];
    // 监听点击
    [self.avatarButton addTarget:self action:@selector(clickavatarButton) forControlEvents:UIControlEventTouchUpInside];
    
    self.titleLabel.text = model.title;
    self.contentLabel.text = model.content;
    self.nameLabel.text = model.user_nick;
    //设置Label显示不同大小的字体
    NSString *time = [[[model.task_start_date substringFromIndex:5] stringByReplacingOccurrencesOfString:@"/" withString:@"."] stringByReplacingOccurrencesOfString:@" " withString:@"."];
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc]initWithString:time];
    [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, 5)];
    self.timeLabel.attributedText = noteStr;
    self.statusLabel.text = @"任务开始";
    
//    NSString *content = model.content;
//    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:11]};
//    CGSize size = [content boundingRectWithSize:CGSizeMake(kScreenSize.width-83, 30) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine) attributes:dict context:nil].size;
//    self.contentLabelConstraint.constant = size.height;

}

#pragma mark - 事件方法
/**
 *  点击头像按钮
 */
- (void)clickavatarButton
{
    ODOthersInformationController *vc = [[ODOthersInformationController alloc] init];
    
    NSString *open_id = self.model.open_id;
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
