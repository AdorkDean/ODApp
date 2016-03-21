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

@end

@implementation ODSettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.textLabel.font = [UIFont systemFontOfSize:12.5f];
    }
    return self;
}

#pragma mark - 初始化方法
+ (instancetype)cellWithTableView:(UITableView *)tableView cellStyle:(UITableViewCellStyle)style
{
    static NSString *ID = nil;
    if (!ID) {
        ID = [NSString stringWithFormat:@"%@ID", NSStringFromClass(self)];
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
    
    self.accessoryView.od_x = KScreenWidth - 25;
}

#pragma mark - 设置数据
- (void)setItem:(ODSettingItem *)item
{
    _item = item;
    
    [self setupData];
    
    [self setupAccessoryView];
}

- (void)setupData
{
    self.imageView.image = self.item.icon;
    self.textLabel.text = self.item.name;
    
    if (self.item.colorType == ODSettingCellColorTypeWhite) {
        self.backgroundColor = [UIColor whiteColor];
    } else {
        self.backgroundColor = [UIColor colorWithHexString:@"#ffd802" alpha:1];
    }
    
    self.detailTextLabel.text = self.item.subTitle;
}

- (void)setupAccessoryView
{
    if ([self.item isKindOfClass:[ODArrowItem class]]) {
        UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rightjiantou"]];
        self.accessoryView = arrow;
    } else if ([self.item isKindOfClass:[ODSwitchItem class]]) {
        self.accessoryView = [[UISwitch alloc] init];
    } else if ([self.item isKindOfClass:[ODCheckItem class]]) {
        self.accessoryView = nil;
    } else {
        self.accessoryView = nil;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
}

@end
