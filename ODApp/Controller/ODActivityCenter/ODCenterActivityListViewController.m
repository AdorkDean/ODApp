//
//  ODCenterActivityListViewController.m
//  ODApp
//
//  Created by 刘培壮 on 16/2/1.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODNewActivityCell.h"
#import "ODCenterActivityListViewController.h"
#import "ODActivityDetailViewController.h"

@interface ODCenterActivityListViewController ()

@end

@implementation ODCenterActivityListViewController

NSString *cellId = @"newActivityCell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor redColor];
//    self.tableView.tableHeaderView = [[UIView alloc]init];
//    self.tableView.tableFooterView = [[UIView alloc]init];
}



#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ODNewActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ODActivityDetailViewController *detailViewController = [[ODActivityDetailViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *naviController = [UIApplication sharedApplication].keyWindow.rootViewController.navigationController;
    [naviController pushViewController:detailViewController animated:YES];
}

@end
