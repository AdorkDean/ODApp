//
//  ODActivityDetailViewController.m
//  ODApp
//
//  Created by 刘培壮 on 16/2/2.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//
#import "ODHttpTool.h"
#import "ODActivityDetailModel.h"
#import "ODActivityDetailViewController.h"

@interface ODActivityDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)UITableView *tableView;

/**
 *  从服务器获取到的数据
 */
@property (nonatomic, strong) NSArray *resultLists;


@end

@implementation ODActivityDetailViewController

static NSString * const cellId = @"newActivityCell";

#pragma mark - lazyLoad
- (UITableView *)tableView
{
    if (!_tableView)
    {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, ODTopY, KScreenWidth, KControllerHeight - ODTabBarHeight) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableFooterView = [UIView new];
        tableView.rowHeight = 98;
        _tableView = tableView;
    }
    return _tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"活动详情";
    [self requestData];
}

-(void)requestData
{
    __weakSelf
    NSDictionary *parameter = @{@"activity_id":[@(self.acitityId)stringValue]};
    [ODHttpTool getWithURL:KActivityListUrl parameters:parameter modelClass:[ODActivityDetailModel class] success:^(id json)
     {
         [weakSelf.tableView reloadData];
     }
                   failure:^(NSError *error)
     {
         
     }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultLists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ODActivityDetailViewController *detailViewController = [[ODActivityDetailViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:detailViewController animated:YES];
}


@end
