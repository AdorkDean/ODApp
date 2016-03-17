//
//  ODBaseSettingController.m
//  ODApp
//
//  Created by 王振航 on 16/3/17.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODBaseSettingController.h"

@interface ODBaseSettingController ()

@end

@implementation ODBaseSettingController

/** 懒加载 */
- (NSMutableArray *)groups {
    if (!_groups) {
        _groups = [NSMutableArray array];
    }
    return _groups;
}

- (instancetype)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ODGroupItem *group = self.groups[section];
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ODSettingCell *cell = [ODSettingCell cellWithTableView:tableView cellStyle:UITableViewCellStyleDefault];
    
    ODGroupItem *group = self.groups[indexPath.section];
    ODSettingItem *item = group.items[indexPath.row];
    
    cell.item = item;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    ODGroupItem *group = self.groups[section];
    return group.header;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    ODGroupItem *group = self.groups[section];
    return group.footer;
}

#pragma mark - <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 点击后取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ODGroupItem *group = self.groups[indexPath.section];
    ODSettingItem *item = group.items[indexPath.row];
    
    if (item.oprtionBlock) {
        item.oprtionBlock(indexPath);
        return;
    }
    
    if (![item isKindOfClass:[ODArrowItem class]]) return;
    
    ODArrowItem *arrowItem = (ODArrowItem *)item;
    if (arrowItem.destVc) {
        UIViewController *vc = [[arrowItem.destVc alloc] init];
        // 设置标题
        vc.title = item.name;
        [self.navigationController pushViewController:vc  animated:YES];
    }
}

@end