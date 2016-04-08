//
//  ODCommunityCell.m
//  ODApp
//
//  Created by Odong-YG on 16/3/24.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODCommunityCell.h"
#import "ODInformViewController.h"

@implementation ODCommunityCell

/**
 *  初始化方法
 */
- (void)awakeFromNib {
    self.nickLabel.textColor = [UIColor colorGloomyColor];
    self.signLabel.textColor = [UIColor colorGraynessColor];
    self.timeLabel.textColor = [UIColor colorGraynessColor];
    self.contentLabel.textColor = [UIColor colorGloomyColor];
}

/**
 *  设置数据
 */
-(void)showDataWithModel:(ODCommunityBbsListModel *)model dict:(NSMutableDictionary *)dict index:(NSIndexPath *)index{
    self.model = model;
    self.indexPath = index;
    self.timeLabel.text = model.created_at;
    self.contentLabel.text = model.content;
    NSString *userId = [NSString stringWithFormat:@"%d",model.user_id];
    self.open_id = [dict[userId]open_id];
    [self.headButton sd_setBackgroundImageWithURL: [NSURL OD_URLWithString:[dict[userId]avatar_url]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"titlePlaceholderImage"]];
    // 设置数据
    UIImage *placeholderImage = [UIImage OD_circleImageNamed:@"titlePlaceholderImage"];
    __weakSelf;
    // 头像
    [self.headButton sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:[dict[userId]avatar_url]] forState:UIControlStateNormal placeholderImage:placeholderImage options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image == nil) return;
        // 设置圆角
        [weakSelf.headButton setBackgroundImage:[image OD_circleImage] forState:UIControlStateNormal];
    }];
    [self.informBtn addTarget:self action:@selector(tapInformBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.headButton addTarget:self action:@selector(otherInfoClick) forControlEvents:UIControlEventTouchUpInside];
    self.nickLabel.text = [dict[userId]nick];
    self.signLabel.text = [dict[userId]sign];
    CGFloat width = kScreenSize.width>320?90:70;
    if (model.imgs.count) {
        for (id vc in self.picView.subviews) {
            [vc removeFromSuperview];
        }
        
        NSInteger count;
        if (model.imgs.count>9) {
            count = 9;
        }else{
            count = model.imgs_big.count;
        }
        for (NSInteger i = 0; i < count; i++) {
            UIButton *imageButton = [[UIButton alloc] init];
            if (model.imgs.count == 4) {
                imageButton.frame = CGRectMake((width + 5) * (i % 2), (width + 5) * (i / 2), width, width);
                self.picConstraintHeight.constant = 2*width+5+6;
            }else{
                imageButton.frame = CGRectMake((width + 5) * (i % 3), (width + 5) * (i / 3), width, width);
                self.picConstraintHeight.constant = width+(width+5)*((count-1)/3)+6;
            }
            
            [imageButton sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:model.imgs[i]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholderImage"] options:SDWebImageRetryFailed];
            [imageButton addTarget:self action:@selector(imageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            imageButton.tag = 10 * index.row + i;
            [self.picView addSubview:imageButton];
        }
    }else{
        for (id vc in self.picView.subviews) {
            [vc removeFromSuperview];
        }
        self.picConstraintHeight.constant = 0.5;
    }
    
    CGFloat contentH = [self.model.content boundingRectWithSize:CGSizeMake(KScreenWidth - 20, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:10.5f]} context:nil].size.height;
    if (model.imgs.count==0) {
        self.spaceHeight.constant = 10 + contentH;
    }else{
        self.spaceHeight.constant = 10 + contentH + 10;
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
- (void)otherInfoClick{
    ODOthersInformationController *vc = [[ODOthersInformationController alloc] init];
    // 取出open_id
    NSString *open_id = self.open_id;
    vc.open_id = open_id;
    // 如果不是自己, 可以跳转
    if (![[ODUserInformation sharedODUserInformation].openID isEqualToString:open_id]){
        UITabBarController *tabBarControler = (id)[UIApplication sharedApplication].keyWindow.rootViewController;
        UINavigationController *navigationController = tabBarControler.selectedViewController;
        [navigationController pushViewController:vc animated:YES];
    }
}

// 举报
- (void)tapInformBtn {
    ODInformViewController *informVC = [[ODInformViewController alloc] init];
    informVC.objectId = [NSString stringWithFormat:@"%d", self.model.id];
    informVC.type = @"1";
    
    UITabBarController *tabBarControler = (id)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *navigationController = tabBarControler.selectedViewController;
    [navigationController pushViewController:informVC  animated:YES];
}

/**
 *   点击图片方法
 */
-(void)imageButtonClick:(UIButton *)button{
    ODCommunityShowPicViewController *picController = [[ODCommunityShowPicViewController alloc]init];
    picController.photos = self.model.imgs_big;
    picController.selectedIndex = button.tag-10*self.indexPath.row;
    UITabBarController *tabBarControler = (id)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *navigationController = tabBarControler.selectedViewController;
    [navigationController.topViewController presentViewController:picController animated:YES completion:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
