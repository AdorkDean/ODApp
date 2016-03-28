//
//  ODSettingCell.m
//  ODApp
//
//  Created by 王振航 on 16/3/17.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODSettingCell.h"
#import "ODSettingItem.h"

#import "ODArrowItem.h"
#import "ODSwitchItem.h"
#import "ODCheckItem.h"

@interface ODSettingCell()

/** 辅助视图 */
@property (nonatomic, strong) UIImageView *arrowIndicator;

/** 开关 */
@property (nonatomic, strong) UISwitch *switchView;

@end

@implementation ODSettingCell

#pragma mark - 懒加载
- (UIImageView *)arrowIndicator
{
    if (_arrowIndicator == nil) {
        _arrowIndicator = [[UIImageView alloc] initWithImage:
                                         [UIImage imageNamed:@"rightjiantou"]];
    }
    return _arrowIndicator;
}
- (UISwitch *)switchView
{
    if (_switchView == nil) {
        _switchView = [[UISwitch alloc] init];
    }
    return _switchView;
}

#pragma mark - 初始化方法
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.textLabel.font = [UIFont systemFontOfSize:12.5f];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView cellStyle:(UITableViewCellStyle)style
{
    static NSString *ID = nil;
    if (!ID) {
        ID = [NSString stringWithFormat:@"%@Id", NSStringFromClass(self)];
    }
    ODSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[self alloc] initWithStyle:style reuseIdentifier:ID];
    }
    return cell;
}

- (void)setFrame:(CGRect)frame
{
    frame.size.height -= 4;
    [super setFrame:frame];
}

/**
 *  重新布局子控件
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.textLabel.od_x = 12.5;
    self.textLabel.od_centerY = self.detailTextLabel.od_centerY = self.imageView.od_centerY = self.contentView.od_centerY;
    
    if (self.imageView.image) {
        self.textLabel.od_x= CGRectGetMaxY(self.imageView.frame) + 10;
    }
    
    self.detailTextLabel.od_x = KScreenWidth - self.detailTextLabel.od_width - 17.5
                                - self.accessoryView.od_width;
}

#pragma mark - 设置数据
- (void)setItem:(ODSettingItem *)item
{
    _item = item;
    
    // 设置数据
    [self setupData];
    
    // 设置指示器样式
    [self setupAccessoryView];
}

/**
 *  设置数据
 */
- (void)setupData
{
    if (self.item.icon.length) self.imageView.image = [UIImage imageNamed:self.item.icon];
    self.textLabel.text = self.item.name;
    self.detailTextLabel.text = self.item.subTitle;
    
    if (self.item.colorType == ODSettingCellColorTypeWhite) {
        self.backgroundColor = [UIColor whiteColor];
    } else {
        self.backgroundColor = [UIColor colorWithRGBString:@"#ffd802" alpha:1];
    }
    self.accessoryView.od_x = KScreenWidth - 10 - self.accessoryView.od_width;
}

/**
 *  设置指示器样式
 */
- (void)setupAccessoryView
{
    if ([self.item isKindOfClass:[ODArrowItem class]]) {
        self.accessoryView = self.arrowIndicator;
    } else if ([self.item isKindOfClass:[ODSwitchItem class]]) {
        self.accessoryView = self.switchView;
    } else if ([self.item isKindOfClass:[ODCheckItem class]]) {
        self.accessoryView = nil;
    } else {
        self.accessoryView = nil;
    }
}

@end
